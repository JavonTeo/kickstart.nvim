return {
	'yetone/avante.nvim',
	-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
	-- must add this setting
	build = vim.fn.has 'win32' ~= 0
		and 'powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false'
		or 'make',
	event = 'VeryLazy',
	version = false, -- Never set this value to "*"! Never!
	---@module 'avante'
	---@type avante.Config
	opts = {
		-- add any opts here
		-- this file can contain specific instructions for your project
		instructions_file = 'avante.md',
		provider = "gemini",
		providers = {
			gemini = {
				-- define API key via `export AVANTE_GEMINI_API_KEY=your-api-key`
				endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
				model = "gemini-2.0-flash",
				timeout = 30000, -- Timeout in milliseconds
				context_window = 1048576,
				use_ReAct_prompt = true,
				extra_request_body = {
					generationConfig = {
						temperature = 0.75,
					},
				},
			}
		},
		selector = {
			provider = "fzf_lua",
		}
	},
	dependencies = {
		'nvim-lua/plenary.nvim',
		'MunifTanjim/nui.nvim',
		--- The below dependencies are optional,
		'ibhagwan/fzf-lua', -- for file_selector provider fzf
		'nvim-tree/nvim-web-devicons',
		{
			-- support for image pasting
			'HakonHarnes/img-clip.nvim',
			event = 'VeryLazy',
			opts = {
				-- recommended settings
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = {
						insert_mode = true,
					},
					-- required for Windows users
					use_absolute_path = true,
				},
			},
		},
		{
			-- Make sure to set this up properly if you have lazy=true
			'MeanderingProgrammer/render-markdown.nvim',
			opts = {
				file_types = { 'markdown', 'Avante' },
			},
			ft = { 'markdown', 'Avante' },
		},
	},
}
