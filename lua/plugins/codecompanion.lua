return {
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        {
          mode = { "n", "v" },
          { "<leader>a", group = "ai" },
          { "<leader>aa", vim.cmd.CodeCompanionActions, desc = "Code Companion Actions" },
          {
            "<leader>ac",
            function()
              vim.cmd.CodeCompanionChat("Toggle")
            end,
            desc = "Code Companion Chat",
          },
          {
            "<leader>ad",
            function()
              require("codecompanion").prompt("lsp")
            end,
            desc = "Debug Diagnostics",
          },
          {
            "<leader>af",
            function()
              require("codecompanion").prompt("fix")
            end,
            desc = "Fix Code",
          },
          {
            "<leader>ao",
            function()
              require("codecompanion").prompt("optimize")
            end,
            desc = "Optimize",
          },
          {
            "<leader>ar",
            function()
              require("codecompanion").prompt("review")
            end,
            desc = "Review",
          },
        },
      },
    },
  },
  {
    "olimorris/codecompanion.nvim",
    config = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "echasnovski/mini.diff",
      "folke/snacks.nvim",
    },
    opts = {
      strategies = {
        chat = {
          adapter = "copilot",
        },
        inline = { adapter = "copilot" },
      },
      display = {
        diff = {
          provider = "mini_diff",
        },
      },
      prompt_library = {
        ["Review"] = {
          strategy = "chat",
          description = "Review code in a buffer",
          opts = {
            mapping = "<leader>ar",
            modes = { "v" },
            short_name = "review",
            auto_submit = true,
            stop_context_insertion = true,
            user_prompt = false,
          },
          prompts = {
            {
              role = "system",
              content = function(context)
                return "I want you to act as a senior "
                  .. context.filetype
                  .. " developer."
                  .. " You need to review the given code and provide concise summary of issues, unoptimal solutions, and possible risks in the code."
                  .. " I will ask you specific questions and I want you to return concise explanations and codeblock examples."
              end,
            },
            {
              role = "user",
              content = function(context)
                local text
                if context.is_visual then
                  text = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                else
                  local buf_utils = require("codecompanion.utils.buffers")
                  text = buf_utils.get_content(context.bufnr)
                end

                return "Review the following code:\n\n```" .. context.filetype .. "\n" .. text .. "\n```\n\n"
              end,
              opts = {
                contains_code = true,
              },
            },
          },
        },
        ["Optimize"] = {
          strategy = "inline",
          description = "Optimize given code",
          opts = {
            mapping = "<leader>ao",
            short_name = "optimize",
          },
          prompts = {
            {
              role = "system",
              content = function(context)
                return "I want you to act as a senior "
                  .. context.filetype
                  .. " developer."
                  .. " I will give code and I want you in response to return a code that can replace this code without any additional explanations or new comments. "
              end,
            },
            {
              role = "user",
              content = function(context)
                local text = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

                return "Please optimize following code:\n\n```" .. context.filetype .. "\n" .. text .. "\n```\n\n"
              end,
              opts = {
                contains_code = true,
              },
            },
          },
        },
        ["Generate a Commit Message"] = {
          strategy = "chat",
          description = "Generate a commit message",
          opts = {
            index = 10,
            is_default = true,
            is_slash_cmd = true,
            short_name = "commit",
            auto_submit = true,
          },
          prompts = {
            {
              role = "user",
              content = function()
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
              end,
              opts = {
                contains_code = true,
              },
            },
          },
        },
      },
    },
  },
}
