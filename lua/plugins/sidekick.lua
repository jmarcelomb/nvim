return {
  {
    "folke/sidekick.nvim",
    opts = {
      nes = { enabled = false },
      cli = {
        mux = {
          backend = "tmux",
          enabled = true,
        },
        win = { layout = "float" },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      if opts.servers then
        opts.servers.copilot = nil
      end
    end,
  },
}
