local plugins = {
  {
    'neovim/nvim-lspconfig',
    config = function()
      require('plugins.configs.lspconfig')
      require('custom.configs.lspconfig')
    end
  },
  {
    'elkowar/yuck.vim',
    lazy = false
  }
}

return plugins
