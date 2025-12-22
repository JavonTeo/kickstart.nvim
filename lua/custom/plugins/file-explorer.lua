return {
	'mikavilpas/yazi.nvim',
	version = '*', -- use the latest stable version
	event = 'VeryLazy',
	dependencies = {
		{ 'nvim-lua/plenary.nvim', lazy = true },
	},
	keys = {
		-- 👇 in this section, choose your own keymappings!
		{
			'<leader>yy',
			mode = { 'n', 'v' },
			'<cmd>Yazi<cr>',
			desc = '[Y]azi',
		},
		{
			-- Open in the current working directory
			'<leader>ycd',
			'<cmd>Yazi cwd<cr>',
			desc = "[Y]azi current dir",
		},
		{
			'<leader>yr',
			'<cmd>Yazi toggle<cr>',
			desc = '[Y]azi [R]esume last session',
		},
	},
	---@type YaziConfig | {}
	opts = {
		-- if you want to open yazi instead of netrw, see below for more info
		open_for_directories = false,
		keymaps = {
			show_help = '<f1>',
		},
	},
	-- if you use `open_for_directories=true`, this is recommended
	init = function()
		-- mark netrw as loaded so it's not loaded at all.
		--
		-- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
		vim.g.loaded_netrwPlugin = 1
	end,
}
-- {
--     "nvim-neo-tree/neo-tree.nvim",
--     branch = "v3.x",
--     dependencies = {
--       "nvim-lua/plenary.nvim",
--       "MunifTanjim/nui.nvim",
--       "nvim-tree/nvim-web-devicons", -- optional, but recommended
--     },
--     lazy = false, -- neo-tree will lazily load itself
-- }
