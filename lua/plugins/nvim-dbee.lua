return {
  "kndndrj/nvim-dbee",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  keys = {
    {
      "<leader>BB",
      function()
        require("dbee").open()
      end,
      desc = "Open DBee 🐝",
    },
  },
  build = function()
    -- Install tries to automatically detect the install method.
    -- if it fails, try calling it with one of these parameters:
    --    "curl", "wget", "bitsadmin", "go"
    require("dbee").install()
  end,
  config = function()
    require("dbee").setup(--[[optional config]])
  end,
}
