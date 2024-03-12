local c = {}

local function config()
  require('Comment').setup({
    opleader = { line = '<leader>/' },
    toggler = { line = '<leader>/' },
    mappings = {
      basic = true,
      extra = false,
    },
  })
end

c.setup = function ()
  config()
end

return c
