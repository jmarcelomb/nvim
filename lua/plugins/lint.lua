return {
  "mfussenegger/nvim-lint",
  event = "LazyFile",
  opts = {
    events = { "BufWritePost", "BufReadPost", "InsertLeave" },
    linters_by_ft = {
      fish = { "fish" },
      python = { "mypy" },
    },
    linters = {
      mypy = {
        cmd = "uvx",
        args = {
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
