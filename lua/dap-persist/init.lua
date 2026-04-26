local M = {}

local data_path = vim.fn.stdpath("data") .. "/dap-helper.json"

local function read_json()
  if vim.fn.filereadable(data_path) ~= 1 then return {} end
  local ok, data = pcall(vim.fn.json_decode, vim.fn.readfile(data_path))
  return ok and data or {}
end

local function write_json(data)
  vim.fn.writefile({ vim.fn.json_encode(data) }, data_path)
end

function M.save_breakpoints(bufnr)
  if vim.bo[bufnr].modified then return end
  local ok, bp_mod = pcall(require, "dap.breakpoints")
  if not ok then return end
  local bps = bp_mod.get(bufnr)
  local data = read_json()
  local file = vim.api.nvim_buf_get_name(bufnr)
  if bps and bps[bufnr] and #bps[bufnr] > 0 then
    data[file] = data[file] or {}
    data[file]["breakpoints"] = bps[bufnr]
  elseif data[file] then
    data[file]["breakpoints"] = nil
    if not next(data[file]) then data[file] = nil end
  end
  write_json(data)
end

function M.load_breakpoints(bufnr)
  local ok, bp_mod = pcall(require, "dap.breakpoints")
  if not ok then return end
  local data = read_json()
  local file = vim.api.nvim_buf_get_name(bufnr)
  local entry = data[file] and data[file]["breakpoints"]
  if not entry then return end
  for _, bp in ipairs(entry) do
    bp_mod.set(bp, bufnr, bp.line)
  end
end

function M.setup()
  vim.api.nvim_create_autocmd("BufUnload", {
    group = vim.api.nvim_create_augroup("dap-persist-save", { clear = true }),
    callback = function(args) M.save_breakpoints(args.buf) end,
  })

  vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    group = vim.api.nvim_create_augroup("dap-persist-load", { clear = true }),
    callback = function(args) M.load_breakpoints(args.buf) end,
  })
end

return M
