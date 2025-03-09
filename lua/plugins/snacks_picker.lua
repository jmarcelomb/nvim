return {
  "folke/snacks.nvim",
  keys = {
    { "<leader><space>", LazyVim.pick("files", { hidden = true }), desc = "Find Files (Root Dir)" },
  },
  opts = {
    picker = {
      -- sources = {
      --   files = { hidden = false },
      -- },
    },
  },
}
