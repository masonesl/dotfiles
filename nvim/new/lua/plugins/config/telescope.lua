local t = {}

local telescope = require('telescope.builtin')
local k = vim.keymap

local function mappings()
  k.set('n', '<leader>ff', telescope.find_files, {})
  k.set('n', '<leader>gf', telescope.git_files, {})
end

t.setup = function()
  mappings()
end

return t
