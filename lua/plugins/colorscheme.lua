return {
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
  },
  {
    "neanias/everforest-nvim",
    version = false,
    lazy = false,
    priority = 1000,
    config = function()
      require("everforest").setup({
        background = "hard",
        transparent_background_level = 0,
        italics = true,
        disable_italic_comments = false,
        on_highlights = function(hl, _)
          hl["@string.special.symbol.ruby"] = { link = "@field" }
        end,
        colours_override = function(palette)
          palette.bg0 = "#1e2326"
        end,
      })
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa",
    },
  },
}
