local opt = vim.opt
local api = vim.api
local fn  = vim.fn
local g   = vim.g

-- Obtain a variable containing the colors of the current theme
local function get_colors()
  local lazy_path = fn.stdpath('data') .. '/lazy/base46'
  opt.rtp:prepend(lazy_path)
  return require('base46').get_theme_tb('base_30')
end

local colors = get_colors()

-- Set line number colors below and above relative line
api.nvim_set_hl(0, 'LineNrAbove', {
  fg = colors.cyan,
})
api.nvim_set_hl(0, 'LineNrBelow', {
  fg = colors.green,
})


opt.relativenumber = true

