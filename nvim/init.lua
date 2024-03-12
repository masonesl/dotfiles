require('set')
local mappings = require('mappings')
local theme    = require('style')
local plugins  = require('plugins')

mappings.set_basic()

-- Setup the lazy plugin manager
local lazypath = vim.fn.stdpath('data') .. 'lazy/lazy.nvim'

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath
  })
end

vim.opt.rtp:prepend(lazypath)

local lazy = require('lazy')

-- Add the theme to the plugins array, then install our plugins
table.insert(plugins, theme.plugin)
lazy.setup(plugins)

-- Configure and load our theme
theme.config()
theme.load()

-- Load our harpoon config
require('config.harpoon').setup()
mappings.set_harpoon()

mappings.set_telescope()

-- Load our treesitter config
require('config.treesitter')

-- @TEMP load colorizer no config
require('colorizer').setup()

require('config.mason')

require('lsp')
mappings.set_lsp()

local cmp = require('config.cmp')
cmp.config(mappings.get_cmp())

require('Comment').setup({
  toggler = { line = '<leader>/' },
  mappings = { basic = true },
})

require('ibl').setup({
  indent = {
    char = '┊',
  },
})
