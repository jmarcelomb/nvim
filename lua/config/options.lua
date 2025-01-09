-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.lazyvim_python_ruff = "ruff"

-- remove transparency
vim.opt.pumblend = 0 -- for cmp menu
vim.opt.winblend = 0 -- for documentation popup

-- enable spell check
-- vim.opt.spelllang = "en_us"
-- vim.opt.spell = true

vim.opt.listchars = {
  tab = "> ",
  trail = "·",
  nbsp = "+",
}

vim.opt.colorcolumn = "80"
vim.opt.scrolloff = 10

vim.o.clipboard = "unnamedplus"

-- Disable neovide animations
vim.g.neovide_position_animation_length = 0
vim.g.neovide_cursor_animation_length = 0.00
vim.g.neovide_cursor_trail_size = 0
vim.g.neovide_cursor_animate_in_insert_mode = false
vim.g.neovide_cursor_animate_command_line = false
vim.g.neovide_scroll_animation_far_lines = 0
vim.g.neovide_scroll_animation_length = 0.00
