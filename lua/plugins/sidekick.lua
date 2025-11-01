return {
  "folke/sidekick.nvim",
  opts = {
    -- add any options here
    cli = {
      mux = {
        backend = "tmux",
        enabled = true,
      },
      win = { layout = "float" },
    },
  },
  keys = {
    -- {
    --   "<c-.>",
    --   function()
    --     require("sidekick.cli").focus()
    --   end,
    --   mode = { "n", "x", "i", "t" },
    --   desc = "Sidekick Switch Focus",
    -- },
    {
      "<leader>ac",
      function()
        require("sidekick.cli").toggle({ name = "crush", focus = true })
      end,
      desc = "Sidekick Toggle Crush",
    },
  },
}
