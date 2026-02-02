return {
	'ibhagwan/fzf-lua',
	-- optional for icon support
	dependencies = { 'nvim-tree/nvim-web-devicons' },
	config = function()
		-- calling `setup` is optional for customization
		require('fzf-lua').setup {
			fzf_opts = {
				['--cycle'] = true,
			},
			fzf_colors = true,
			file_icon_padding = ' ',
			winopts = {
				title_flags = false,
				border = 'single',
				on_create = function()
					vim.keymap.set(
						't',
						'<C-r>',
						[['<C-\><C-N>"'.nr2char(getchar()).'pi']],
						{ expr = true, buffer = true }
					)
				end,
				width = 0.9,
			},

			files = {
				formatter = 'path.filename_first',
				prompt = 'file ',
				title = false,
				cwd_prompt = false,
				header = false,
				git_icons = false,
				winopts = {
					title = false,
					height = 0.35,
					width = 0.35,
					preview = {
						hidden = 'hidden',
					},
				},
			},
			grep = {
				header = false,
				prompt = 'grep ',
				title = false,
				rg_glob = true,
				glob_flag = '--iglob',
				glob_separator = '%s%-%-',
				winopts = {
					title = false,
				},
			},

			keymap = {
				builtin = {
					['<c-d>'] = 'preview-page-down',
					['<c-u>'] = 'preview-page-up',
				},
			},
		}

		local builtin = require 'fzf-lua'
		vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
		vim.keymap.set('n', '<leader>sf', builtin.global, { desc = '[S]earch [F]iles' })
		-- vim.keymap.set('n', '<leader>st', builtin.treesitter, { desc = '[S]earch current [T]reesitter symbols' })
		vim.keymap.set('n', '<leader>sw', builtin.grep_cword, { desc = '[S]earch current [W]ord' })
		vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
		vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
		vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
	end,
}
