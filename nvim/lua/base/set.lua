local o          = vim.opt
local g          = vim.g

-- Line numbers and relative line numbers
o.relativenumber = true
o.number         = true

-- Tab and indent related options
o.tabstop        = 2
o.softtabstop    = 2
o.shiftwidth     = 2
o.expandtab      = true
o.smartindent    = true

-- Do not continue highlighting searches and enable incremental search
o.hlsearch       = false
o.incsearch      = true
o.ignorecase     = true
o.smartcase      = true

o.termguicolors  = true

o.scrolloff      = 8

o.cursorline     = true

o.clipboard      = 'unnamedplus'

o.timeoutlen     = 300

o.formatoptions:remove({ 'c', 'r', 'o' })

g.border = function(hl)
  return {
    { '┌', hl },
    { '─', hl },
    { '┐', hl },
    { '│', hl },
    { '┘', hl },
    { '─', hl },
    { '└', hl },
    { '│', hl },
  }
end
