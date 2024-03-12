local t = {}

t.plugin = {
	'folke/tokyonight.nvim',
	lazy = false,
	priority = 1000,
	opts = {},
}

t.config = function()
	require('tokyonight').setup({
		style = 'night',
		on_highlights = function(h, c)
      -- Custom Telescope colors
			h.TelescopeNormal = {
				bg = c.bg_dark,
				fg = c.fg_dark,
			}
			h.TelescopeBorder = {
				bg = c.bg_dark,
				fg = c.bg_dark,
			}
			h.TelescopePromptNormal = {
				bg = c.bg_dark,
			}
			h.TelescopePromptBorder = {
				bg = c.bg_dark,
				fg = c.bg_dark,
			}
			h.TelescopePromptTitle = {
				bg = c.bg_dark,
				fg = c.fg_dark,
			}
			h.TelescopePreviewTitle = {
				bg = c.bg_dark,
				fg = c.fg_dark,
			}
			h.TelescopeResultsTitle = {
				bg = c.bg_dark,
				fg = c.fg_dark,
			}

      -- Custom CMP colors
      h.CmpSel = {
        bg = c.blue,
        fg = c.bg_dark,
      }
      h.CmpItemAbbrMatch = {
        bold = true,
        fg = c.blue,
      }
      h.CmpItemAbbrMatchFuzzy = {
        link = 'CmpItemKindVariable',
      }
      h.CmpItemKindVariable = {
        bg = 'NONE',
        fg = c.cyan,
      }
      h.CmpItemKindInterface = {
        link = 'CmpItemKindVariable',
      }
      h.CmpItemKindText = {
        link = 'CmpItemKindVariable',
      }
      h.CmpItemKindFunction = {
        bg = 'NONE',
        fg = c.magenta,
      }
      h.CmpItemKindMethod = {
        link = 'CmpItemKindFunction',
      }
      h.CmpItemKindKeyword = {
        bg = 'NONE',
        fg = c.fg_dark,
      }
      h.CmpItemKindProperty = {
        link = 'CmpItemKindKeyword',
      }
      h.CmpItemKindUnit = {
        link = 'CmpItemKindKeyword',
      }
      h.CmpDocBorder = {
        fg = c.terminal_black,
      }
      h.CmpBorder = {
        fg = c.terminal_black,
      }

      h.NormalFloat =  {
        bg = 'NONE',
      }
      h.FloatBorder = {
        fg = c.terminal_black
      }

      -- Line numbers
      h.LineNrAbove = {
        fg = c.blue,
      }
      h.LineNrBelow = {
        fg = c.blue0,
      }
		end,
	})

end

t.load = function()
	vim.cmd[[colorscheme tokyonight]]
end

return t
