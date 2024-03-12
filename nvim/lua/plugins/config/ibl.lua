local i = {}

local function config()
  require('ibl').setup({
    indent = {
      char = '┊',
    },
  })
end

i.setup = function ()
  config()
end

return i
