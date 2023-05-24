require('plugins')

-- @TODO re-organize config directory structure

-- Enable line numbers
vim.wo.number = true

-- Set the line numbers to relative for easy vertical jumping
vim.wo.relativenumber = true

vim.g.mapleader = " "

-- Shortcut to get back to directory
vim.keymap.set("n", "<leader>pd", vim.cmd.Ex)

-- Set tab to 2 spaces
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

-- Use system clipboard when used with leader key
vim.keymap.set('n', '<leader>y', '"+yy')
vim.keymap.set('v', '<leader>y', '"+y')

-- Center cursor on vertical movement
vim.keymap.set("n", "k", "kzz")
vim.keymap.set("n", "j", "jzz")

require("tokyonight").setup({
		style = "night",
		transparent = true
	})	

vim.cmd[[colorscheme tokyonight]]

require("colorizer").setup()

local colors = require("tokyonight.colors").setup()

vim.api.nvim_set_hl(0, "LineNrAbove", {fg=colors.green})
vim.api.nvim_set_hl(0, "LineNr", {fg=colors.grey})
vim.api.nvim_set_hl(0, "LineNrBelow", {fg=colors.red})
