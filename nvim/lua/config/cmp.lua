local c = {}
local cmp_kinds = {
  Text = '  ',
  Method = '  ',
  Function = '󰊕  ',
  Constructor = '  ',
  Field = '  ',
  Variable = '  ',
  Class = '  ',
  Interface = '  ',
  Module = '󰕳  ',
  Property = '  ',
  Unit = '  ',
  Value = '  ',
  Enum = '  ',
  Keyword = '  ',
  Snippet = '  ',
  Color = '  ',
  File = '  ',
  Reference = '  ',
  Folder = '  ',
  EnumMember = '  ',
  Constant = '  ',
  Struct = '  ',
  Event = '  ',
  Operator = '  ',
  TypeParameter = '  ',
}

c.config = function(mappings)
	local cmp = require('cmp')
	cmp.setup({
		sources = {
			{name = 'nvim_lsp'},
      {name = 'luasnip'},
		},
    window = {
      completion = {
        winhighlight = 'Normal:CmpPmenu,Cursorline:CmpSel,Search:None',
        side_padding = 1,
        border = vim.g.border('CmpBorder'),
      },
      documentation = {
        winhighlight = 'Normal:CmdDoc',
        border = vim.g.border('CmpDocBorder'),
      },
    },
    completion = {
      completeopt = 'menu,menuone',
    },
    formatting = {
      format = function (_, vim_item)
        vim_item.kind = (cmp_kinds[vim_item.kind] or '') .. vim_item.kind
        return vim_item
      end
    },
		mapping = cmp.mapping.preset.insert(mappings),
		snippet = {
			expand = function(args)
				require('luasnip').lsp_expand(args.body)
			end,
		},
	})
end

return c
