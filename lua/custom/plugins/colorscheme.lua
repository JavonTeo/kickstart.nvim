return

	-- {
	-- 	'catppuccin/nvim',
	-- 	name = 'catppuccin',
	-- 	priority = 1000,
	-- 	config = function()
	-- 		require('catppuccin').setup {
	-- 			flavour = 'frappe', -- latte, frappe, macchiato, mocha
	-- 			background = {      -- :h background
	-- 				light = 'latte',
	-- 				dark = 'mocha',
	-- 			},
	-- 			transparent_background = false, -- disables setting the background color.
	-- 			float = {
	-- 				transparent = false,        -- enable transparent floating windows
	-- 				solid = false,              -- use solid styling for floating windows, see |winborder|
	-- 			},
	-- 			show_end_of_buffer = true,      -- shows the '~' characters after the end of buffers
	-- 			term_colors = true,             -- sets terminal colors (e.g. `g:terminal_color_0`)
	-- 			dim_inactive = {
	-- 				enabled = true,             -- dims the background color of inactive window
	-- 				shade = 'dark',
	-- 				percentage = 0.15,          -- percentage of the shade to apply to the inactive window
	-- 			},
	-- 			no_italic = false,              -- Force no italic
	-- 			no_bold = false,                -- Force no bold
	-- 			no_underline = false,           -- Force no underline
	-- 			styles = {                      -- Handles the styles of general hi groups (see `:h highlight-args`):
	-- 				comments = { 'italic' },    -- Change the style of comments
	-- 				conditionals = { 'italic' },
	-- 				loops = {},
	-- 				functions = {},
	-- 				keywords = {},
	-- 				strings = {},
	-- 				variables = {},
	-- 				numbers = {},
	-- 				booleans = {},
	-- 				properties = {},
	-- 				types = {},
	-- 				operators = {},
	-- 				-- miscs = {}, -- Uncomment to turn off hard-coded styles
	-- 			},
	-- 			color_overrides = {},
	-- 			custom_highlights = {},
	-- 			default_integrations = true,
	-- 			auto_integrations = false,
	-- 			integrations = {
	-- 				cmp = true,
	-- 				gitsigns = true,
	-- 				nvimtree = true,
	-- 				treesitter = true,
	-- 				notify = false,
	-- 				mini = {
	-- 					enabled = true,
	-- 					indentscope_color = '',
	-- 				},
	-- 				-- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
	-- 			},
	-- 		}
	-- 		vim.cmd.colorscheme 'catppuccin'
	-- 	end,
	-- }

	-- {
	-- 	'junegunn/seoul256.vim',
	-- 	name = 'seoul256',
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function ()
	-- 		vim.g.seoul256_italic_comments = true
	-- 		vim.g.seoul256_contrast = true
	-- 		vim.cmd.colorscheme 'seoul256'
	-- 	end
	-- }

	{
		'rebelot/kanagawa.nvim',
		name = 'kanagawa',
		priority = 1000,
		config = function ()
			local cyan = "#94e2d5"
			local purple = "#cba6f7"
			local gray = "#6c7086"
			local yellow = "#f9e2af"
			local dark_vanilla = "#d4caa3"

			require("kanagawa").setup({
				-- compile = false,  -- enable compiling the colorscheme
				-- undercurl = true, -- enable undercurls
				-- commentStyle = { italic = true },
				-- functionStyle = {},
				-- keywordStyle = { italic = true },
				-- statementStyle = { bold = true },
				-- typeStyle = {},
				-- transparent = true,   -- true: set background color
				-- dimInactive = true,   -- dim inactive window `:h hl-NormalNC`
				-- terminalColors = true, -- define vim.g.terminal_color_{0,17}
				-- colors = {             -- add/modify theme and palette colors
				-- 	palette = {
				-- 		cyan = "#94e2d5",
				-- 		purple = "#cba6f7",
				-- 		gray = "#6c7086",
				-- 		yellow = "#f9e2af",
				-- 		dark_vanilla = "#d4caa3",
				-- 	},
				-- 	theme = {},
				-- },
			})
			vim.cmd.colorscheme 'kanagawa-wave' -- toggle between kanagawa-wave, kanagawa-dragon, kanagawa-lotus

			local colors = require('kanagawa.colors').setup()
			local palette_colors = colors.palette
			local set = vim.api.nvim_set_hl
			set(0, 'Visual', { bg = "#283b57" })

			-- This sets the colors for the floating windows
			-- (e.g. LSP function signature when you hover and <Shift-k> over a function, or telescope window)
			-- set(0, 'NormalFloat', { bg = '#110147', fg = '#fffcea' })        -- floating window background color and font color
			-- set(0, 'NormalFloat', { fg = palette_colors.dragonAqua, bg = palette_colors.sumiInk6 })
		end
	}

	-- {
	-- 	-- { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" }
	-- 	'scottmckendry/cyberdream.nvim',
	-- 	name = 'cyberdream',
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function ()
	-- 		vim.cmd.colorscheme 'cyberdream'
	-- 	end
	-- }
