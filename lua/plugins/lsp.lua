return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- pyright will be automatically installed with mason and loaded with lspconfig
        pyright = {
          settings = {
            typos_lsp = {},
            pyright = {
              -- Using Ruff's import organizer
              disableOrganizeImports = true,
            },
            python = {
              analysis = {
                -- Ignore all files for analysis to exclusively use Ruff for linting
                ignore = { "*" },
              },
            },
          },
        },
        ruff = {
          trace = "messages",
          init_options = {
            settings = {
              logLevel = "debug",
            },
          },
        },
        clangd = {
          mason = false,
        },
      },
    },
  },
  {
    "maan2003/lsp_lines.nvim",
    event = "VeryLazy", -- Or `LspAttach`
    priority = 1000, -- needs to be loaded in first
    config = function()
      -- Disable virtual text explicitly before setting up lsp_lines
      vim.diagnostic.config({ virtual_lines = false })
      require("lsp_lines").setup()
    end,
    keys = {
      {
        "<leader>lt",
        function()
          local lsp_lines = require("lsp_lines")
          local state = lsp_lines.toggle()
          vim.diagnostic.config({ virtual_text = not state }) -- Toggle virtual text when disabling lsp_lines
        end,
        desc = "Toggle lsp_lines",
      },
    },
  },
}
