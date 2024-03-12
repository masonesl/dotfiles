local o = {}

local k = vim.keymap

local function config()
  require('oil').setup({
    columns = {
      'icon',
    },
  })
end

local function mappings()
  k.set('n', '-', ':Oil<CR>')
end

o.setup = function ()
  config()
  mappings()
end

return o
