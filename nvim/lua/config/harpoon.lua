local h       = {}
local harpoon = require('harpoon')

h.setup = function() harpoon:setup({}) end

-- Function to show harpoon list using telescope
h.use_telescope = function (harpoon_files)
	local tconfig = require('telescope.config').values

	local file_paths = {}
	for _, item in ipairs(harpoon_files.items) do
		table.insert(file_paths, item.value)
	end

	require('telescope.pickers').new({}, {
		prompt_title = 'Harpoon',
		finder = require('telescope.finders').new_table({
			results = file_paths,
		}),
		previewer = tconfig.file_previewer({}),
		sorter    = tconfig.generic_sorter({}),
	}):find()
end

return h
