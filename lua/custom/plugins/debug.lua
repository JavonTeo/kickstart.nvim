return {
	{
		'mfussenegger/nvim-dap',
		dependencies = {
			'nvim-neotest/nvim-nio',
			'rcarriga/nvim-dap-ui',
			'mfussenegger/nvim-dap-python',
			'jbyuki/one-small-step-for-vimkind',
		},
		config = function()
			local dap = require 'dap'
			local dapui = require 'dapui'
			local dap_python = require 'dap-python'
			-- dap.configurations.lua = {
			-- 	{
			-- 		type = 'nlua',
			-- 		request = 'attach',
			-- 		name = 'Attach to running Neovim instance',
			-- 	},
			-- }
			--
			-- dap.adapters.nlua = function(callback, config)
			-- 	callback {
			-- 		type = 'server',
			-- 		host = config.host or '127.0.0.1',
			-- 		port = config.port or 8086,
			-- 	}
			-- end

			-- Setup --
			vim.fn.sign_define(
				'DapBreakpoint',
				{ text = '', texthl = 'DiagnosticSignError', linehl = '', numhl = '' }
			)
			vim.fn.sign_define(
				'DapBreakpointRejected',
				{ text = '❌', texthl = 'DiagnosticSignError', linehl = '', numhl = '' }
			)
			vim.fn.sign_define(
				'DapStopped',
				{
					text = '',
					texthl = 'DiagnosticSignWarn',
					linehl = 'Visual',
					numhl = 'DiagnosticSignWarn',
				}
			)
			dapui.setup {
				expand_lines = true,
				controls = { enabled = false },
				floating = { border = 'rounded' },
				render = {
					max_type_length = 60,
					max_value_lines = 200,
				},
				layouts = {
					{
						elements = {
							{ id = 'repl',   size = 0.75 },
							{ id = 'stacks', size = 0.25 },
						},
						position = 'bottom',
						size = 10,
					},
				},
			}
			dap_python.setup 'python3' -- pip install debugpy in global python3 first
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end

			-- Keymaps --
			local opts = { noremap = true, silent = true }
			vim.keymap.set(
				'n',
				'<leader>b',
				dap.toggle_breakpoint,
				{ desc = '[D]ap toggle [B]reakpoint', noremap = true, silent = true }
			)
			vim.keymap.set(
				'n',
				'<leader>dc',
				dap.continue,
				{ desc = '[D]ap [C]ontinue', noremap = true, silent = true }
			)
			vim.keymap.set(
				'n',
				'<leader>n',
				dap.step_over,
				{ desc = 'Dap [N]ext', noremap = true, silent = true }
			)
			vim.keymap.set(
				'n',
				'<leader>ds',
				dap.step_into,
				{ desc = '[D]ap [S]tep into', noremap = true, silent = true }
			)
			vim.keymap.set(
				'n',
				'<leader>dr',
				dap.step_out,
				{ desc = '[D]ap [R]eturn (step out)', noremap = true, silent = true }
			)
			vim.keymap.set(
				'n',
				'<leader>dq',
				function()
					dap.terminate()
					dapui.close()
				end,
				{ desc = '[D]ap [Q]uit', noremap = true, silent = true }
			)
			vim.keymap.set(
				'n',
				'<leader>du',
				dapui.toggle,
				{ desc = '[D]apUi toggle', noremap = true, silent = true }
			)
			-- vim.keymap.set(
			-- 	'n',
			-- 	'<leader>da',
			-- 	dap.attach,
			-- 	{ desc = '[D]apUi toggle', noremap = true, silent = true }
			-- )
			vim.keymap.set(
				'n',
				'<leader>dw',
				function()
					dapui.eval(nil, { enter = true })
				end,
				{
					desc = '[D]apUi floating Window for word under cursor',
					noremap = true,
					silent = true,
				}
			)
		end,
	},
}
