return {
	-- run :checkhealth treesitter to check:
	--   1. requirements are all OK
	--   2. expected languages are listed under installed
	'nvim-treesitter/nvim-treesitter',
	dependencies = {
		'nvim-treesitter/nvim-treesitter-textobjects',
	},
	lazy = false,
	build = ':TSUpdate',
	branch = 'main',
	pin = true,
	config = function()
		local parsers = {
			'lua',
			'python',
			'javascript',
			'css',
			'html',
			'typescript',
			'tsx',
			'vue',
			'vimdoc',
			'vim',
			'regex',
			'dockerfile',
			'json',
			'go',
			'yaml',
			'markdown',
			'markdown_inline',
			'bash',
			'c',
			'cpp'
		}
		require('nvim-treesitter').install(parsers)

		vim.api.nvim_create_autocmd('FileType', {
			pattern = parsers,
			callback = function () vim.treesitter.start() end,
		})
		-- require('nvim-treesitter').setup {
		-- 	ensure_installed = {
		-- 	},
		-- 	auto_install = true,
		-- 	highlight = {
		-- 		enable = true,
		-- 	},
		-- 	textobjects = {
		-- 		select = {
		-- 			enable = true,
		-- 			lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
		-- 			keymaps = {
		-- 				-- You can use the capture groups defined in textobjects.scm
		-- 				['aa'] = '@parameter.outer',
		-- 				['ia'] = '@parameter.inner',
		-- 				['af'] = '@function.outer',
		-- 				['if'] = '@function.inner',
		-- 				['ac'] = '@class.outer',
		-- 				['ic'] = '@class.inner',
		-- 			},
		-- 			selection_modes = {
		-- 				['@function.outer'] = 'V',
		-- 			},
		-- 		},
		-- 	},
		-- 	indent = { enable = true, disable = { 'ruby' } },
		-- 	incremental_selection = {
		-- 		enable = true,
		-- 		keymaps = {
		-- 			init_selection = '<a-s>',
		-- 			node_incremental = '<a-s>',
		-- 			node_decremental = '<a-S>',
		-- 			scope_incremental = '<c-space>',
		-- 		},
		-- 	},
		-- 	fold = { enable = true },
		-- }

		-- vim.api.nvim_create_autocmd("BufWinEnter", {
		-- 	callback = function ()
		-- 		vim.wo.foldmethod = "expr"
		-- 		vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		-- 	end
		-- })
		-- -- Treesitter folds
		-- vim.o.foldmethod = 'expr'
		-- vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
		-- vim.o.foldtext = 'v:lua.vim.treesitter.foldtext()'
		-- vim.o.foldlevel = 99
		-- vim.o.foldlevelstart = 99
	end
}
