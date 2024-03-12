local plugins = {
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.5',
		dependencies = {
			'nvim-lua/plenary.nvim'
		},
	},
	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
	},
	{
		'ThePrimeagen/harpoon',
		-- This branch will be merged into main soon
		branch = 'harpoon2',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-telescope/telescope.nvim',
		},
	},
	{
		'norcalli/nvim-colorizer.lua',
	},
	{
		'williamboman/mason.nvim',
		'williamboman/mason-lspconfig.nvim',
		'neovim/nvim-lspconfig',
	},
	{
		'hrsh7th/cmp-nvim-lsp',
		'hrsh7th/nvim-cmp',
		'L3MON4D3/LuaSnip',
	},
  {
    'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
    lazy = false,
    config = function ()
      require('lsp_lines').setup()
    end
  },
  {
    'numToStr/Comment.nvim',
    lazy = false,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
  },
}

return plugins
