require('plugins')

-- Enable line numbers
vim.wo.number = true

-- Set the line numbers to relative for easy vertical jumping
vim.wo.relativenumber = true

vim.g.mapleader = " "

-- Shortcut to get back to directory
vim.keymap.set("n", "<leader>pd", vim.cmd.Ex)
