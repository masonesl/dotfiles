local m = {}

local function config()
  require('mason').setup({
    ui = {
      icons = {
        package_installed   = '󰦕',
        package_pending     = '󰦗',
        package_uninstalled = '󱄊',
      }
    }
  })
end

m.setup = function()
  config()
end

return m
