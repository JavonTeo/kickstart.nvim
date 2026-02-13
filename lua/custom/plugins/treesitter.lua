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
			callback = function (args) 
				-- 1. Enables highlighting
				vim.treesitter.start()
				-- 2. Enables treesitter-based folding
				vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
				vim.wo[0][0].foldmethod = 'expr'
				-- 3. Enables treesitter-based indentation
				vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})

		-- Ensure all folds are open on file entry
		vim.opt.foldlevel = 99
	end
}
