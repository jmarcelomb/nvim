return {
  {
    {
      "mfussenegger/nvim-dap",
    -- stylua: ignore
    keys = {
      { "<leader>d", "", desc = "+debug", mode = {"n", "v"} },
    { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
    { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
    { "<leader>dr", function() require("dap").restart() end, desc = "Restart debug" },
    { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
    { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
    { "<leader>dj", function() require("dap").down() end, desc = "Down" },
    { "<leader>dk", function() require("dap").up() end, desc = "Up" },
    { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
    { "<F1>", function() require("dap").step_over() end, desc = "Step Over" },
    { "<F2>", function() require("dap").step_into() end, desc = "Step Into" },
    { "<F3>", function() require("dap").step_out() end, desc = "Step Out" },
    { "<F5>", function() require("dap").continue() end, desc = "Run/Continue" },
    { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
    { "<leader>dR", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
    { "<leader>ds", function() require("dap").session() end, desc = "Session" },
    { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
    { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
    { "<leader>de", function() require("dapui").eval(nill, { enter = true }) end, desc = "Eval", mode = {"n", "v"} },
    },
    },
  },
  {
    "daic0r/dap-helper.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-neotest/nvim-nio" },
  -- stylua: ignore
  keys = {
    { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
    { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
  },
    opts = {},
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        -- dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        -- dapui.close({})
      end
    end,
  },
  -- { "mfussenegger/nvim-dap-python", enabled = false },
}
