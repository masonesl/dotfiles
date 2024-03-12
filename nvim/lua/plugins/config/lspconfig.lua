local l = {}

local lsp = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local k = vim.keymap
local lbuf = vim.lsp.buf
local diag = vim.diagnostic

local border_handlers = {
  ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = vim.g.border('FloatBorder')
  }),
  ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = vim.g.border('FloatBorder')
  }),
}


local function default_lspconfig(server)
  lsp[server].setup({
    capabilities = capabilities,
    handlers = border_handlers,
  })
end

local function config()
  require('mason-lspconfig').setup({
    handlers = {
      default_lspconfig,
      lua_ls = function()
        lsp.lua_ls.setup({
          handlers = border_handlers,
          capabilities = capabilities,
          settings = {
            Lua = {
              runtime = {
                version = 'LuaJIT',
              },
              diagnostics = {
                globals = { 'vim' },
              },
              workspace = {
                library = {
                  vim.env.VIMRUNTIME,
                }
              }
            }
          }
        })
      end,
      asm_lsp = function()
        lsp.asm_lsp.setup({
          handlers = border_handlers,
          capabilities = capabilities,
          settings = {
            filetypes = { 's', 'asm', 'S' },
          }
        })
      end,
    },
  })
end

local function manual_config()
  lsp.gdscript.setup({
    capabilities = capabilities,
    handlers = border_handlers,
  })
end

local function mappings()
  k.set('n', '<leader>e', diag.open_float)
  k.set('n', '[d', diag.goto_prev)
  k.set('n', ']d', diag.goto_next)
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
      -- k.set('n', '<C-k>', lbuf.signature_help, opts)
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

local function define_signs()
  local signd = vim.fn.sign_define

  signd('DiagnosticSignError',{
    texthl = 'DiagnosticSignErrorText',
    numhl = 'DiagnosticSignErrorNum',
    linehl = 'DiagnosticSignErrorLine',
    text = ' ',
  })
  signd('DiagnosticSignWarn',{
    texthl = 'DiagnosticSignWarnText',
    numhl = 'DiagnosticSignWarnNum',
    linehl = 'DiagnosticSignWarnLine',
    text = ' ',
  })
  
end

local function config_virtualtext()
  vim.diagnostic.config({
    virtual_text = false,
    underline = true,
    severity_sort = true,
  })
end

l.setup = function()
  config()
  manual_config()
  mappings()
  config_virtualtext()
  define_signs()
end

return l
