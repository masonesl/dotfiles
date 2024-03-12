local lsp = require('lspconfig')
local lsp_cap = require('cmp_nvim_lsp').default_capabilities()

local border_handlers = {
  ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = vim.g.border('FloatBorder')
  }),
  ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = vim.g.border('FloatBorder')
  }),
}

local default_setup = function(server)
  lsp[server].setup({
    capabilities = lsp_cap,
    handlers = border_handlers,
  })
end

require('mason-lspconfig').setup({
  handlers = {
    default_setup,
    lua_ls = function()
      lsp.lua_ls.setup({
        handlers = border_handlers,
        capabilities = lsp_cap,
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
    asm_lsp = function ()
      lsp.asm_lsp.setup({
        handlers = border_handlers,
        capabilities = lsp_cap,
        settings = {
          filetypes = {'s', 'asm', 'S'},
        }
      })
    end,
  },
})

vim.diagnostic.config({
  virtual_text = false,
})
