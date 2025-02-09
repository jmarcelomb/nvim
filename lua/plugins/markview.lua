return {
  "OXY2DEV/markview.nvim",
  lazy = false,
  config = function()
    require("markview").setup({
      auto_start = false, -- Disable automatic preview
    })
  end,
  keys = {
    {
      "<leader>mp",
      ":Markview<CR>",
      desc = "Toggle markdown preview",
    },
  },
}
