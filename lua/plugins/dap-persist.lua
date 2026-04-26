return {
  {
    "jmarcelomb/dap-persist.nvim",
    dependencies = { "mfussenegger/nvim-dap" },
    opts = {},
    config = function(_, opts)
      require("dap-persist").setup(opts)
    end,
  },
}
