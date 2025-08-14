-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local g = vim.g
local o = vim.opt

g.lazyvim_python_ruff = "ruff"

-- auto format on save
-- vim.g.autoformat = false

-- remove transparency
o.pumblend = 0 -- for cmp menu
o.winblend = 0 -- for documentation popup

-- enable spell check
-- vim.opt.spelllang = "en_us"
-- vim.opt.spell = true

o.listchars = {
  tab = "> ",
  trail = "·",
  nbsp = "+",
}

o.colorcolumn = "80"
o.scrolloff = 10

o.clipboard = "unnamedplus"

-- Disable neovide animations
g.neovide_position_animation_length = 0
g.neovide_cursor_animation_length = 0.00
g.neovide_cursor_trail_size = 0
g.neovide_cursor_animate_in_insert_mode = false
g.neovide_cursor_animate_command_line = false
g.neovide_scroll_animation_far_lines = 0
g.neovide_scroll_animation_length = 0.00

-- Disable animations
-- vim.g.snacks_animate = false

-- Change diff algorithm
o.diffopt = "internal,filler,closeoff,indent-heuristic,linematch:60,algorithm:histogram"

-- [avante] views can only be fully collapsed with the global statusline
o.laststatus = 3
