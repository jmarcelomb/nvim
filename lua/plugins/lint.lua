return {
  "mfussenegger/nvim-lint",
  event = "LazyFile",
  opts = {
    -- Event to trigger linters
    events = { "BufWritePost", "BufReadPost", "InsertLeave" },
    linters_by_ft = {
      fish = { "fish" },
      python = { "mypy", "pylint", "ruff" },
      -- ["*"] = { "typos" },
    },
    linters = {
      -- Set pylint to work in virtualenv
      pylint = {
        cmd = "python",
        args = {
          "-m",
          "pylint",
          "-f",
          "json",
          "--from-stdin",
          function()
            return vim.api.nvim_buf_get_name(0)
          end,
        },
      },
      -- Set mypy to work in virtualenv
      mypy = {
        cmd = "python",
        args = {
          "-m",
          "mypy",
          "--show-column-numbers",
          "--show-error-end",
          "--hide-error-context",
          "--no-color-output",
          "--no-error-summary",
          "--no-pretty",
        },
      },
    },
  },
}
