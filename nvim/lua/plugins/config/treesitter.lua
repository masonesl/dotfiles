local t = {}

local function config()
  require('nvim-treesitter.configs').setup {
    ensure_installed = {
      'lua',
      'python',
      'rust',
      'c',
      'hyprlang',
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
