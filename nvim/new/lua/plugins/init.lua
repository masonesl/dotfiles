return {
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('plugins.config.theme').setup()
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('plugins.config.telescope').setup()
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('plugins.config.treesitter').setup()
    end,
  },
  {
    'ThePrimeagen/harpoon',
    -- This branch will be merged into main soon
    branch = 'harpoon2',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      require('plugins.config.harpoon').setup()
    end,
  },
  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  },
  {
    'williamboman/mason.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()
      require('plugins.config.mason').setup()
      require('plugins.config.lspconfig').setup()
    end,
  },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'L3MON4D3/LuaSnip',
      'https://codeberg.org/FelipeLema/cmp-async-path',
    },
    config = function()
      require('plugins.config.cmp').setup()
    end,
  },
  {
    'numToStr/Comment.nvim',
    lazy = false,
    config = function()
      require('plugins.config.comment').setup()
    end,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    config = function()
      require('plugins.config.ibl').setup()
    end,
  },
  {
    'stevearc/oil.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('plugins.config.oil').setup()
    end,
  },
  {
    'folke/trouble.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
  },
}
