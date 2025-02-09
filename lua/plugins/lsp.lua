return {
  {
    "maan2003/lsp_lines.nvim",
    event = "VeryLazy", -- Or `LspAttach`
    priority = 1000, -- needs to be loaded in first
    config = function()
      require("lsp_lines").setup()
      vim.diagnostic.config({ virtual_text = false }) -- Only if needed in your configuration, if you already have native LSP diagnostics
    end,
    keys = {
      {
        "<leader>lt",
        function()
          require("lsp_lines").toggle()
        end,
        desc = "Toggle lsp_lines",
      },
    },
  },
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
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          mason = false,
        },
      },
    },
  },
}
