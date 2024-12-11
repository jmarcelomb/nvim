return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- add tsx and treesitter
      vim.list_extend(opts.ensure_installed, {
        "c",
        "python",
        "rust",
        "bash",
        "diff",
        "html",
        "javascript",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "query",
        "regex",
        "vim",
        "vimdoc",
        "json",
        "yaml",
        "toml",
        "xml",
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      auto_install = true,
    },
  },
}
