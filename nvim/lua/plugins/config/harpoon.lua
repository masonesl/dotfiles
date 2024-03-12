local h = {}

local harpoon = require('harpoon')
local k = vim.keymap

local function config()
  harpoon:setup({})
end

local function telescope_harpoon_menu(harpoon_files)
  local tconfig = require('telescope.config').values

  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  require('telescope.pickers').new({}, {
    prompt_title = 'Harpoon',
    finder       = require('telescope.finders').new_table({
      results = file_paths,
    }),
    previewer    = tconfig.file_previewer({}),
    sorter       = tconfig.generic_sorter({}),
  }):find()
end

local function mappings()
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
    telescope_harpoon_menu(harpoon:list())
  end)
  for i = 1, 4, 1 do
    k.set('n', '<leader>h' .. i, function()
      harpoon:list():select(i)
    end)
  end
end

h.setup = function()
  config()
  mappings()
end

return h
