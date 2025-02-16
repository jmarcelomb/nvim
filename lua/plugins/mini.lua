return {
  "echasnovski/mini.trailspace",
  event = "VeryLazy",
  version = false,
  cmd = {
    "TrimWhitespace",
  },
  keys = {
    { "<leader>fw", "<cmd>TrimWhitespace<CR>", desc = "Erase Whitespace" },
  },
  opts = {},
  config = function()
    require("mini.trailspace").setup()
    -- Define the custom command
    vim.api.nvim_create_user_command("TrimWhitespace", function()
      require("mini.trailspace").trim()
    end, {})
  end,
}
