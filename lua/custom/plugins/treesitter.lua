return { -- Highlight, edit, and navigate code
	'nvim-treesitter/nvim-treesitter',
	dependencies = {
		'nvim-treesitter/nvim-treesitter-textobjects',
	},
	build = ':TSUpdate',
	branch = 'main',
	lazy = true,
	pin = true,
	config = function()
		require('nvim-treesitter.configs').setup {
			ensure_installed = {
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
			},
			auto_install = false,
			highlight = {
				enable = true,
				-- disable = function(lang, buf)
				-- 	-- if loading big file, don't use treesitter highlighting
				-- 	local max_filesize = 100 * 1024 -- 100 KB files
				-- 	local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
				-- 	if ok and stats and stats.size > max_filesize then
				-- 		return true
				-- 	end
				-- end,
				-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
				--  If you are experiencing weird indenting issues, add the language to
				--  the list of additional_vim_regex_highlighting and disabled languages for indent.
				-- additional_vim_regex_highlighting = { 'ruby' },
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						['aa'] = '@parameter.outer',
						['ia'] = '@parameter.inner',
						['af'] = '@function.outer',
						['if'] = '@function.inner',
						['ac'] = '@class.outer',
						['ic'] = '@class.inner',
					},
					selection_modes = {
						['@function.outer'] = 'V',
					},
				},
			},
			indent = { enable = true, disable = { 'ruby' } },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = '<a-s>',
					node_incremental = '<a-s>',
					node_decremental = '<a-S>',
					scope_incremental = '<c-space>',
				},
			},
		}

		-- -- Treesitter folds
		-- vim.o.foldmethod = 'expr'
		-- vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
		-- vim.o.foldtext = 'v:lua.vim.treesitter.foldtext()'
		-- vim.o.foldlevel = 99
		-- vim.o.foldlevelstart = 99
	end
}
