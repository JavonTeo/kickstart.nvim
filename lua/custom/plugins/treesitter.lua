return { -- Highlight, edit, and navigate code
	'nvim-treesitter/nvim-treesitter',
	dependencies = {
		'nvim-treesitter/nvim-treesitter-textobjects',
	},
	build = ':TSUpdate',
	branch = 'main',
	lazy = false,
	pin = true,
	opts = {
		ensure_installed = {
			'lua',
			'python',
			'javascript',
			'typescript',
			'vue',
			'vimdoc',
			'vim',
			'regex',
			'terraform',
			'sql',
			'dockerfile',
			'toml',
			'json',
			'java',
			'groovy',
			'go',
			'gitignore',
			'graphql',
			'yaml',
			'make',
			'cmake',
			'markdown',
			'markdown_inline',
			'bash',
			'tsx',
			'css',
			'html',
		},
		-- Autoinstall languages that are not installed
		auto_install = false,
		highlight = {
			enable = true,
			disable = function(lang, buf)
				-- if loading big file, don't use treesitter highlighting
				local max_filesize = 100 * 1024 -- 100 KB files
				local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
				if ok and stats and stats.size > max_filesize then
					return true
				end
			end,
			-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
			--  If you are experiencing weird indenting issues, add the language to
			--  the list of additional_vim_regex_highlighting and disabled languages for indent.
			additional_vim_regex_highlighting = { 'ruby' },
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
		-- indent = { enable = true, disable = { 'ruby' } },
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = '<a-s>',
				node_incremental = '<a-s>',
				node_decremental = '<a-S>',
				scope_incremental = '<c-space>',
			},
		},
	},
	config = function(_, opts)
		require('nvim-treesitter.configs').setup(opts)

		-- FIX "fn name not showing on fold"

		-- Treesitter folds
		vim.o.foldmethod = 'expr'
		vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
		vim.o.foldtext = 'v:lua.vim.treesitter.foldtext()'

		-- vim.o.foldcolumn = '1'
		-- local function get_fold_text()
		--     local line = vim.fn.getline(vim.v.foldstart)
		--     local char = vim.v.foldend > vim.v.foldstart and '▸' or '▾' -- Custom icons
		--     local num_lines = vim.v.foldend - vim.v.foldstart + 1
		--     return char
		--         .. ' '
		--         .. line:sub(1, vim.opt.columns:get() - 10)
		--         .. ' ('
		--         .. num_lines
		--         .. ' lines)'
		-- end

		-- vim.opt.foldtext = get_fold_text()

		vim.o.foldlevel = 99
		vim.o.foldlevelstart = 99
	end,
	-- There are additional nvim-treesitter modules that you can use to interact
	-- with nvim-treesitter. You should go explore a few and see what interests you:
	--
	--    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
	--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
	--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
}
