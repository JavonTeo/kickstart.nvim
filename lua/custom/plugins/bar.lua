return {
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 
			{
				'kiennt63/harpoon-files.nvim',
				dependencies = { {'ThePrimeagen/harpoon', branch='harpoon2' } },
				opts = {
					icon = '',
                    max_length = 7,
                    separator_left = ' ',
                    separator_right = '',
                    reverse_order = true
				},
			},
			'nvim-tree/nvim-web-devicons' },
		config = function()
			local mode = {
				'mode',
				fmt = function(str)
					return ' ' .. str
					-- return ' ' .. str:sub(1, 1) -- displays only the first character of the mode
				end,
			}
			local harpoon_files = require 'harpoon_files'
			require('lualine').setup {
				options = {
					icons_enabled = true,
					-- theme = 'gruvbox_dark',
					component_separators = { left = '', right = '' },
					section_separators = { left = '', right = '' },
					disabled_filetypes = {
						statusline = {},
						winbar = {},
						'alpha',
						'neo-tree',
					},
					ignore_focus = {},
					always_divide_middle = true,
					always_show_tabline = true,
					globalstatus = false,
					refresh = {
						statusline = 1000,
						tabline = 1000,
						winbar = 1000,
						refresh_time = 16, -- ~60fps
						events = {
							'WinEnter',
							'BufEnter',
							'BufWritePost',
							'SessionLoadPost',
							'FileChangedShellPost',
							'VimResized',
							'Filetype',
							'CursorMoved',
							'CursorMovedI',
							'ModeChanged',
						},
					},
				},
				sections = {
					lualine_a = { mode },
					lualine_b = { 'branch', 'diff' },
					lualine_c = { 'filename' },
					lualine_x = { harpoon_files.lualine_component },
					lualine_y = { },
					lualine_z = { 'progress' },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { 'filename' },
					lualine_x = { 'location' },
					lualine_y = {},
					lualine_z = {},
				},
				tabline = {},
				winbar = {},
				inactive_winbar = {},
				extensions = { 'fugitive' },
			}
		end,
	},

	{
		'utilyre/barbecue.nvim',
		name = 'barbecue',
		version = '*',
		dependencies = {
			'SmiteshP/nvim-navic',
			'nvim-tree/nvim-web-devicons', -- optional dependency
		},
		config = function()
			-- triggers CursorHold event faster
			vim.opt.updatetime = 200

			require('barbecue').setup {
				theme = { normal = { bg = '#2e2e2e' } },
				create_autocmd = false, -- prevent barbecue from updating itself automatically
			}

			vim.api.nvim_create_autocmd({
				'WinScrolled', -- or WinResized on NVIM-v0.9 and higher
				'BufWinEnter',
				'CursorHold',
				'InsertLeave',

				-- include this if you have set `show_modified` to `true`
				'BufModifiedSet',
			}, {
				group = vim.api.nvim_create_augroup('barbecue.updater', {}),
				callback = function()
					require('barbecue.ui').update()
				end,
			})
		end,
	},
}
