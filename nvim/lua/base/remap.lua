local k = vim.keymap

-- Remap the leader to space
vim.g.mapleader = ' '

-- Allow for moving selection in visual mode
k.set('v', 'J', ':m \'>+1<CR>gv=gv')
k.set('v', 'K', ':m \'<-2<CR>gv=gv')

-- Center cursor when half page jumping
k.set('n', '<C-d>', '<C-d>zz')
k.set('n', '<C-u>', '<C-u>zz')

-- Place search results in the middle of the screen
k.set('n', 'n', 'nzz')
k.set('n', 'N', 'Nzz')

k.set('n', '<C-h>', ':wincmd h<CR>');
k.set('n', '<C-j>', ':wincmd j<CR>');
k.set('n', '<C-k>', ':wincmd k<CR>');
k.set('n', '<C-l>', ':wincmd l<CR>');

k.set('n', '<leader>tr', function ()
  require('trouble').toggle()
end)

