-- prefil edit window with common scenarios to avoid repeating query and submit immediately
local prefill_edit_window = function(request)
  require("avante.api").edit()
  local code_bufnr = vim.api.nvim_get_current_buf()
  local code_winid = vim.api.nvim_get_current_win()
  if code_bufnr == nil or code_winid == nil then
    return
  end
  vim.api.nvim_buf_set_lines(code_bufnr, 0, -1, false, { request })
  -- Optionally set the cursor position to the end of the input
  vim.api.nvim_win_set_cursor(code_winid, { 1, #request + 1 })
  -- Simulate Ctrl+S keypress to submit
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-s>", true, true, true), "v", true)
end

-- NOTE: most templates are inspired from ChatGPT.nvim -> chatgpt-actions.json
local avante_grammar_correction = "Correct the text to standard English, but keep any code blocks inside intact."
local avante_keywords = "Extract the main keywords from the following text"
local avante_code_readability_analysis = [[
  You must identify any readability issues in the code snippet.
  Some readability issues to consider:
  - Unclear naming
  - Unclear purpose
  - Redundant or obvious comments
  - Lack of comments
  - Long or complex one liners
  - Too much nesting
  - Long variable names
  - Inconsistent naming and code style.
  - Code repetition
  You may identify additional problems. The user submits a small section of code from a larger file.
  Only list lines with readability issues, in the format <line_num>|<issue and proposed solution>
  If there's no issues with code respond with only: <OK>
]]
local avante_optimize_code = "Optimize the following code"
local avante_summarize = "Summarize the following text"
local avante_explain_code = "Explain the following code"
local avante_complete_code = "Complete the following codes written in " .. vim.bo.filetype
local avante_add_docstring = "Add docstring to the following codes"
local avante_fix_bugs = "Fix the bugs inside the following codes if any"
local avante_add_tests = "Implement tests for the following code"
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
      "<leader>ag",
      function()
        require("avante.api").ask({ question = avante_grammar_correction })
      end,
      desc = "Grammar Correction(ask)",
    },
    {
      "<leader>ak",
      function()
        require("avante.api").ask({ question = avante_keywords })
      end,
      desc = "Keywords(ask)",
    },
    {
      "<leader>al",
      function()
        require("avante.api").ask({ question = avante_code_readability_analysis })
      end,
      desc = "Code Readability Analysis(ask)",
    },
    {
      "<leader>ao",
      function()
        require("avante.api").ask({ question = avante_optimize_code })
      end,
      desc = "Optimize Code(ask)",
    },
    {
      "<leader>ams",
      function()
        require("avante.api").ask({ question = avante_summarize })
      end,
      desc = "Summarize text(ask)",
    },
    {
      "<leader>ax",
      function()
        require("avante.api").ask({ question = avante_explain_code })
      end,
      desc = "Explain Code(ask)",
    },
    {
      "<leader>ac",
      function()
        require("avante.api").ask({ question = avante_complete_code })
      end,
      desc = "Complete Code(ask)",
    },
    {
      "<leader>ad",
      function()
        require("avante.api").ask({ question = avante_add_docstring })
      end,
      desc = "Docstring(ask)",
    },
    {
      "<leader>ab",
      function()
        require("avante.api").ask({ question = avante_fix_bugs })
      end,
      desc = "Fix Bugs(ask)",
    },
    {
      "<leader>au",
      function()
        require("avante.api").ask({ question = avante_add_tests })
      end,
      desc = "Add Tests(ask)",
    },
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

require("which-key").add({
  { "<leader>a", group = "Avante" },
  {
    mode = { "v" },
    {
      "<leader>aG",
      function()
        prefill_edit_window(avante_grammar_correction)
      end,
      desc = "Grammar Correction",
    },
    {
      "<leader>aK",
      function()
        prefill_edit_window(avante_keywords)
      end,
      desc = "Keywords",
    },
    {
      "<leader>aO",
      function()
        prefill_edit_window(avante_optimize_code)
      end,
      desc = "Optimize Code(edit)",
    },
    {
      "<leader>aC",
      function()
        prefill_edit_window(avante_complete_code)
      end,
      desc = "Complete Code(edit)",
    },
    {
      "<leader>aD",
      function()
        prefill_edit_window(avante_add_docstring)
      end,
      desc = "Docstring(edit)",
    },
    {
      "<leader>aB",
      function()
        prefill_edit_window(avante_fix_bugs)
      end,
      desc = "Fix Bugs(edit)",
    },
    {
      "<leader>aU",
      function()
        prefill_edit_window(avante_add_tests)
      end,
      desc = "Add Tests(edit)",
    },
  },
})

return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    -- opts = {
    --   -- add any opts here
    --   -- for example
    --   provider = "openai",
    --   openai = {
    --     endpoint = "https://api.openai.com/v1",
    --     model = "gpt-4o", -- your desired model (or use gpt-4o, etc.)
    --     timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
    --     temperature = 0,
    --     max_completion_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
    --     --reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
    --   },
    -- },
    -- opts = {
    --   provider = "ollama",
    --   ollama = {
    --     endpoint = "http://127.0.0.1:11434",
    --     model = "qwq:32b",
    --   },
    -- },
    -- opts = { provider = "gemini" },
    opts = { provider = "copilot" },
    disabled_tools = { "web_search" },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "echasnovski/mini.pick", -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
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
