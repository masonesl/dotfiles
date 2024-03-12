local mappings = {}

local k = vim.keymap

mappings.set_basic = function()
  -- Remap the leader to space
  vim.g.mapleader = ' '

  -- @TEMP memorble binding for netrw
  k.set('n', '<leader>pv', vim.cmd.Ex)

  -- Allow for moving selection in visual mode
  k.set('v', 'J', ':m \'>+1<CR>gv=gv')
  k.set('v', 'K', ':m \'<-2<CR>gv=gv')

  -- Center cursor when half page jumping
  k.set('n', '<C-d>', '<C-d>zz')
  k.set('n', '<C-u>', '<C-u>zz')

  -- Place search results in the middle of the screen
  k.set('n', 'n', 'nzz')
  k.set('n', 'N', 'Nzz')

end

mappings.set_telescope = function()
  local telescope = require('telescope.builtin')

  k.set('n', '<leader>ff', telescope.find_files, {})
  k.set('n', '<leader>gf', telescope.git_files, {})
end

mappings.set_harpoon = function()
  local harpoon = require('harpoon')

  -- Add current file to harpoon
  k.set('n', '<leader>ha', function()
    harpoon:list():append()
  end)
  -- Remove current file from harpoon
  k.set('n', '<leader>hr', function()
    harpoon:list():remove()
  end)
  -- Clear harpoon
  k.set('n', '<leader>hc', function()
    harpoon:list():clear()
  end)
  -- View the harpoon list with telescope
  k.set('n', '<leader>hm', function()
    require('config.harpoon').use_telescope(harpoon:list())
  end)
  for i = 1, 4, 1 do
    k.set('n', '<leader>h' .. i, function()
      harpoon:list():select(i)
    end)
  end
end

mappings.set_lsp = function()
  local lbuf = vim.lsp.buf
  local diag = vim.diagnostic

  k.set('n', '<leader>e', diag.open_float)
  k.set('n', '[d', diag.goto_prev)
  k.set('n', '[d', diag.goto_next)
  k.set('n', '<leader>q', diag.setloclist)

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
      vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

      local opts = { buffer = ev.buf }
      k.set('n', 'gD', lbuf.declaration, opts)
      k.set('n', 'gd', lbuf.definition, opts)
      k.set('n', 'K', lbuf.hover, opts)
      k.set('n', 'gi', lbuf.implementation, opts)
      k.set('n', '<C-k>', lbuf.signature_help, opts)
      k.set('n', '<leader>wa', lbuf.add_workspace_folder, opts)
      k.set('n', '<leader>wr', lbuf.remove_workspace_folder, opts)
      k.set('n', '<leader>wl', function()
        print(vim.inspect(lbuf.list_workspace_folders()))
      end, opts)
      k.set('n', '<leader>D', lbuf.type_definition, opts)
      k.set('n', '<leader>rn', lbuf.rename, opts)
      k.set('n', '<leader>ca', lbuf.code_action, opts)
      k.set('n', 'gr', lbuf.references, opts)
      k.set('n', '<leader>fo', function()
        lbuf.format { async = true }
      end, opts)
    end,
  })
end

mappings.get_cmp = function()
  local cmp = require('cmp')
  return {
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
  }
end



return mappings
