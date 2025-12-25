return {
	'ThePrimeagen/harpoon',
	branch = 'harpoon2',
	dependencies = { 'nvim-lua/plenary.nvim' },
	config = function()
		local harpoon = require 'harpoon'
		harpoon:setup {}

		vim.keymap.set('n', '<leader>m', function()
			harpoon:list():add()
		end, { desc = 'Add harpoon [M]ark' })
		vim.keymap.set('n', '<C-e>', function()
			-- toggle_telescope(harpoon:list()) -- add this if using telescope
			-- To delete mark from harpoon list, do dd then :wq to write the list
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = 'Open harpoon window' })

		vim.keymap.set('n', '<A-1>', function()
			harpoon:list():select(1)
		end)
		vim.keymap.set('n', '<A-2>', function()
			harpoon:list():select(2)
		end)
		vim.keymap.set('n', '<A-3>', function()
			harpoon:list():select(3)
		end)
		vim.keymap.set('n', '<A-4>', function()
			harpoon:list():select(4)
		end)
		vim.keymap.set('n', '<A-5>', function()
			harpoon:list():select(5)
		end)
		vim.keymap.set('n', '<A-6>', function()
			harpoon:list():select(6)
		end)

		-- -- Toggle previous & next buffers stored within Harpoon list
		-- vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
		-- vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)

		-- if you want to use telescope, include the below code
		-- basic telescope configuration
		-- local conf = require('telescope.config').values
		-- local function toggle_telescope(harpoon_files)
		-- 	local finder = function()
		-- 		local paths = {}
		-- 		for _, item in ipairs(harpoon_files.items) do
		-- 			table.insert(paths, item.value)
		-- 		end
		--
		-- 		return require('telescope.finders').new_table {
		-- 			results = paths,
		-- 		}
		-- 	end
		--
		-- 	require('telescope.pickers')
		-- 		.new({}, {
		-- 			prompt_title = 'Harpoon',
		-- 			finder = finder(),
		-- 			previewer = conf.file_previewer {},
		-- 			sorter = conf.generic_sorter {},
		-- 			layout_config = {
		-- 				height = 0.5,
		-- 				width = 0.8,
		-- 				prompt_position = 'top',
		-- 				preview_cutoff = 120,
		-- 			},
		-- 			attach_mappings = function(prompt_bufnr, map)
		-- 				map('n', 'dd', function()
		-- 					local state = require 'telescope.actions.state'
		-- 					local selected_entry = state.get_selected_entry()
		-- 					local current_picker = state.get_current_picker(prompt_bufnr)
		--
		-- 					table.remove(harpoon_files.items, selected_entry.index)
		-- 					current_picker:refresh(finder())
		-- 				end)
		-- 				return true
		-- 			end,
		-- 		})
		-- 		:find()
		-- end
	end,
}
