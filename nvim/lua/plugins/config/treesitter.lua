local t = {}

local function config()
  require('nvim-treesitter').setup {
    ensure_installed = {
      'lua',
      'python',
      'rust',
      'help',
      'c',
    },
    sync_install = false,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    }
  }
end

t.setup = function()
  config()
end

return t
