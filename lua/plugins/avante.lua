local avante_python_improve_code = [[
Act as a top-notch Python developer using Python 3.10 or newer. Write clean, maintainable, and production-quality code that follows best practices and modern design principles.
Use type annotations as much as possible. Prefer built-in types and modern constructs such as dataclass, Enum, match-case, and structural pattern matching.
Avoid using Any, object, or loose typing unless strictly necessary. Split logic into small, focused, and reusable functions or classes.
Follow a clean and readable coding style. Add clear, concise comments where non-trivial logic is involved.
If there’s ambiguity in the implementation or multiple good design choices, let me know so we can discuss the best path forward.
]]

local generate_commit_prompt = function()
  local diff = vim.fn.system("git diff --no-ext-diff --staged")
  if diff == "" then
    return "The diff is empty. Please stage changes before running."
  end

  local use_emoji = false -- Set to true if you want GitMoji convention
  local commit_preface = use_emoji
      and [[
Use GitMoji convention to preface the commit. Here are some help to choose the right emoji:
🐛, Fix a bug;
✨, Introduce new features;
📝, Add or update documentation;
🚀, Deploy stuff;
✅, Add, update, or pass tests;
♻️, Refactor code;
⬆️, Upgrade dependencies;
🔧, Add or update configuration files;
🌐, Internationalization and localization;
💡, Add or update comments in source code;
        ]]
    or [[
Do not preface the commit with anything, except for the conventional commit keywords (in lower case):
fix, feat, build, chore, ci, docs, style, refactor, perf, test.
        ]]

  return string.format(
    [[
You are to act as an author of a commit message in git. Your mission is to create clean and comprehensive commit messages as per the Conventional Commit Convention and explain WHAT were the changes and mainly WHY the changes were done.
I'll send you an output of 'git diff --staged' command, and you are to convert it into a commit message.
%s
Add a short description of WHY the changes are done after the commit message.
Don't start it with 'This commit', just describe the changes.
Use the present tense. Lines must not be longer than 74 characters. Use English for the commit message.

<diff>
%s
</diff>
        ]],
    commit_preface,
    diff
  )
end
require("which-key").add({
  { "<leader>a", group = "Avante" },
  {
    mode = { "n", "v" },
    {
      "<leader>ap",
      function()
        require("avante.api").ask({ question = avante_python_improve_code })
      end,
      desc = "Python improve code prompt",
    },
    {
      "<leader>amc",
      function()
        require("avante.api").ask({ question = generate_commit_prompt() })
      end,
      desc = "Generate Commit(ask)",
    },
  },
})

return {

  {
    "yetone/avante.nvim",
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    -- ⚠️ must add this setting! ! !
    build = vim.fn.has("win32") ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      or "make",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    ---@module 'avante'
    ---@type avante.Config
    input = {
      provider = "snacks",
      provider_opts = {
        -- Additional snacks.input options
        title = "Avante Input",
        icon = " ",
      },
    },
    opts = {
      provider = "copilot",
      disabled_tools = { "web_search" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "echasnovski/mini.pick", -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "stevearc/dressing.nvim", -- for input provider dressing
      "folke/snacks.nvim", -- for input provider snacks
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>a", group = "ai" },
      },
    },
  },
}
