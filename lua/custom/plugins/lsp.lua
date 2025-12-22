return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
			{ "mason-org/mason.nvim", opts = {} },
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim",    opts = {} }, -- Useful status updates for LSP.
			"saghen/blink.cmp", -- Allows extra capabilities provided by blink.cmp
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						-- helper to easily define mappings for LSP items
						-- only sets mappings to Normal mode
						vim.keymap.set("n", keys, func,
							{ buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("ga", vim.lsp.buf.code_action, "[G]oto Code [A]ction")
					map("gr", require("fzf-lua").lsp_references, "[G]oto [R]eferences")
					map("gri", require("fzf-lua").lsp_implementations, "[G]oto [I]mplementation")
					map("gd", function() require("fzf-lua").lsp_definitions { jump1 = true } end, "[G]oto [D]efinition") --  To jump back, press <C-t>.
					map("gD", require("fzf-lua").lsp_declarations, "[G]oto [D]eclaration")
					-- Jump to the type of the word under your cursor.
					--  Useful when you're not sure what type a variable is and you want to see
					--  the definition of its *type*, not where it was *defined*.
					map("gt", require("fzf-lua").lsp_typedefs, "[G]oto [T]ype Definition")
					-- Manual formatting keymap
					map("<leader>ff", function()
						vim.lsp.buf.format({ async = true })
						vim.notify('File formatted.', vim.log.levels.INFO)
					end, "[F]ormat buffer")

					-- Toggle global diagnostics (linting)
					map("<leader>td", function()
						if vim.diagnostic.is_enabled() then
							vim.diagnostic.enable(false)
							vim.notify("Diagnostics disabled globally",
								vim.log.levels.INFO)
						else
							vim.diagnostic.enable(true)
							vim.notify("Diagnostics enabled globally",
								vim.log.levels.INFO)
						end
					end, "[T]oggle [D]iagnostics")

					-- The following code creates a keymap to toggle inlay hints in your
					-- code, if the language server you are using supports them
					--
					-- This may be unwanted, since they displace some of your code
					if
					    client
					    and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
					then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({
								bufnr =
								    event.buf
							}))
						end, "[T]oggle Inlay [H]ints")
					end

					-- <Experimental - not currently in use>
					-- Toggle diagnostics (cycling through different levels)
					-- map("<leader>td", function()
					-- 	local current_config = vim.diagnostic.config()
					--
					-- 	if not current_config.enabled then
					-- 		-- Currently disabled -> Show only errors
					-- 		vim.diagnostic.config({
					-- 			enabled = true,
					-- 			severity = { min = vim.diagnostic.severity.ERROR },
					-- 			virtual_text = { severity = { min = vim.diagnostic.severity.ERROR } },
					-- 			signs = { severity = { min = vim.diagnostic.severity.ERROR } },
					-- 		})
					-- 		vim.notify("Diagnostics: Errors only", vim.log.levels.INFO)
					-- 	elseif
					-- 		current_config.severity and current_config.severity.min == vim.diagnostic.severity.ERROR
					-- 	then
					-- 		-- Currently errors only -> Show all diagnostics
					-- 		vim.diagnostic.config({
					-- 			enabled = true,
					-- 			severity = nil, -- Show all levels
					-- 			virtual_text = { severity = nil },
					-- 			signs = { severity = nil },
					-- 		})
					-- 		vim.notify("Diagnostics: All levels enabled", vim.log.levels.INFO)
					-- 	else
					-- 		-- Currently all enabled -> Disable all
					-- 		vim.diagnostic.config({ enabled = false })
					-- 		vim.notify("Diagnostics: Disabled", vim.log.levels.INFO)
					-- 	end
					-- end, "[T]oggle [D]iagnostics (Cycle: Errors → All → Off)")

					-- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
					---@param client vim.lsp.Client
					---@param method vim.lsp.protocol.Method
					---@param bufnr? integer some lsp support methods only in specific files
					---@return boolean
					local function client_supports_method(client, method, bufnr)
						if vim.fn.has("nvim-0.11") == 1 then
							return client:supports_method(method, bufnr)
						else
							return client.supports_method(method, { bufnr = bufnr })
						end
					end

					-- The following two autocommands are used to highlight references of the
					-- word under your cursor when your cursor rests there for a little while.
					--    See `:help CursorHold` for information about when this is executed
					--
					-- When you move your cursor, the highlights will be cleared (the second autocommand).
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if
					    client
					    and client_supports_method(
						    client,
						    vim.lsp.protocol.Methods.textDocument_documentHighlight,
						    event.buf
					    )
					then
						local highlight_augroup =
						    vim.api.nvim_create_augroup("kickstart-lsp-highlight",
							    { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach",
								{ clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({
									group = "kickstart-lsp-highlight",
									buffer = event2.buf,
								})
							end,
						})
					end

					-- -- AUTO-FORMATTING ON SAVE
					-- -- Comment out this entire block to disable auto-formatting
					-- if client and client_supports_method(client, "textDocument/formatting") then
					-- 	local format_augroup = vim.api.nvim_create_augroup("LspAutoFormat", { clear = false })
					-- 	vim.api.nvim_create_autocmd("BufWritePre", {
					-- 		buffer = event.buf,
					-- 		group = format_augroup,
					-- 		callback = function()
					-- 			vim.lsp.buf.format({ async = false })
					-- 		end,
					-- 	})
					-- end
				end,
			})

			-- Diagnostic Config
			-- See :help vim.diagnostic.Opts
			vim.diagnostic.config({
				severity_sort = true,
				-- OPTION 1: Show only ERRORS (current setting)
				-- Uncomment the line below to show ONLY errors
				-- severity = { min = vim.diagnostic.severity.ERROR },

				-- OPTION 2: Disable ALL diagnostics
				-- Uncomment the line below to disable ALL diagnostics (including errors)
				-- enabled = false,

				float = { border = "rounded", source = "if_many" },
				underline = { severity = vim.diagnostic.severity.ERROR },
				signs = vim.g.have_nerd_font
				    and {
					    text = {
						    [vim.diagnostic.severity.ERROR] = "󰅚 ",
						    [vim.diagnostic.severity.WARN] = "󰀪 ",
						    [vim.diagnostic.severity.INFO] = "󰋽 ",
						    [vim.diagnostic.severity.HINT] = "󰌶 ",
					    },
					    -- severity = { min = vim.diagnostic.severity.ERROR }, -- only show error signs
				    }
				    or {},

				-- Virtual text refers to the diagnostic messages displayed at the end of the line
				virtual_text = {
					source = "if_many",
					spacing = 2,
					-- uncomment the line below to show ALL virtual text
					severity = { vim.diagnostic.severity.ERROR }, -- only show virtual text for errors
					-- severity = { vim.diagnostic.severity.ERROR, vim.diagnostic.severity.WARN }, -- show virtual text for errors and warnings
					format = function(diagnostic)
						local diagnostic_message = {
							[vim.diagnostic.severity.ERROR] = diagnostic.message,
							[vim.diagnostic.severity.WARN] = diagnostic.message,
							[vim.diagnostic.severity.INFO] = diagnostic.message,
							[vim.diagnostic.severity.HINT] = diagnostic.message,
						}
						return diagnostic_message[diagnostic.severity]
					end,
				},
			})

			local capabilities = require("blink.cmp").get_lsp_capabilities()
			local vue_language_server_path = vim.fn.stdpath("data")
			    .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

			local servers = {
				-- clangd = {},
				-- gopls = {},
				basedpyright = {
					analysis = {
						autoSearchPaths = true,
						diagnosticMode = "openFilesOnly",
						useLibraryCodeForTypes = true,
						inlayHints = {
							callArgumentNames = true,
						},
						exclude = {
							"**/build", "**/build/**"
						}
					},
				},
				vue_ls = {},
				html = {},
				cssls = {},
				jsonls = {},
				quick_lint_js = {},
				-- rust_analyzer = {},
				-- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
				--
				-- Some languages (like typescript) have entire language plugins that can be useful:
				--    https://github.com/pmizio/typescript-tools.nvim
				--
				-- But for many setups, the LSP (`ts_ls`) will work just fine

				ts_ls = {
					init_options = {
						plugins = {
							{
								languages = { "vue" },
								location = vue_language_server_path,
								name = "@vue/typescript-plugin",
								configNamespace = "typescript",
							},
						},
					},
					filetypes = {
						"javascript",
						"javascriptreact",
						"typescript",
						"typescriptreact",
						"vue",
					},
				},

				ruff = {},
				emmet_language_server = {},
				lua_ls = {
					-- cmd = { ... },
					-- filetypes = { ... },
					-- capabilities = {},
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
							-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
							-- diagnostics = { disable = { 'missing-fields' } },
						},
					},
				},
			}

			-- Ensure the servers and tools above are installed
			--
			-- To check the current status of installed tools and/or manually install
			-- other tools, you can run
			--    :Mason
			--
			-- You can press `g?` for help in this menu.
			--
			-- `mason` had to be setup earlier: to configure its options see the
			-- `dependencies` table for `nvim-lspconfig` above.
			--
			-- You can add other tools here that you want Mason to install
			-- for you, so that they are available from within Neovim.
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua", -- Used to format Lua code
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				ensure_installed = {},
				automatic_installation = false,
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						-- This handles overriding only values explicitly passed
						-- by the server configuration above. Useful when disabling
						-- certain features of an LSP (for example, turning off formatting for ts_ls)
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities,
							server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})

			-- This sets the colors for the floating windows
			-- (e.g. LSP function signature when you hover and <Shift-k> over a function, or telescope window)
			vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#110147', fg = '#fffcea' })        -- floating window background color and font color
		end,
	},
	-- { -- formatters, linters
	--     'nvimtools/none-ls.nvim',
	--     dependencies = {
	--         'nvimtools/none-ls-extras.nvim',
	--         'jayp0521/mason-null-ls.nvim',
	--     },
	--     config = function()
	--         local null_ls = require 'null-ls'
	--         local formatting = null_ls.builtins.formatting -- to setup formatters
	--         local diagnostics = null_ls.builtins.diagnostics -- to setp linters
	--
	--         require('mason-null-ls').setup {
	--             ensure_installed = {
	--                 'prettier', --ts/js formatter
	--                 'stylua', -- lua formatter
	--                 'eslint_d', -- ts/js linter
	--                 'ruff', -- Python linter and formatter
	--             },
	--             automatic_installation = true,
	--         }
	--
	--         local sources = {
	--             formatting.prettier.with { filetypes = { 'html', 'json', 'yaml', 'markdown' } },
	--             formatting.stylua,
	--             require('none-ls.formatting.ruff').with { extra_args = { '--extend-select', 'I' } },
	--             require 'none-ls.formatting.ruff_format',
	--         }
	--
	--         this code sets up autoformatting on save
	--         local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
	--         null_ls.setup {
	--             debug = true, -- Enable debg mode. Inspect logs with :NullLsLog
	--             sources = sources,
	--             -- code that runs when null-ls attaches to a buffer
	--             on_attach = function(client, bufnr)
	--                 if client:supports_method 'textDocument/formatting' then
	--                     vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr } -- clear duplicate autocmds
	--                     -- buffer is formatted before file actually gets written to disk
	--                     vim.api.nvim_create_autocmd('BufWritePre', {
	--                         group = augroup,
	--                         buffer = bufnr,
	--                         callback = function()
	--                             vim.lsp.buf.format { async = false }
	--                         end,
	--                     })
	--                 end
	--             end,
	--         }
	--     end,
	-- },
	-- { -- code folding
	-- 	"kevinhwang91/nvim-ufo",
	-- 	dependencies = "kevinhwang91/promise-async",
	-- 	config = function()
	-- 		vim.o.foldcolumn = "1"
	-- 		vim.o.foldlevel = 99
	-- 		vim.o.foldlevelstart = 99
	-- 		vim.o.foldenable = true
	--
	-- 		vim.keymap.set("n", "zR", require("ufo").openAllFolds)
	-- 		vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
	--
	-- 		-- Treesitter as folding provider
	-- 		require("ufo").setup({
	-- 			provider_selector = function(_, _, _)
	-- 				return { "treesitter", "indent" }
	-- 			end,
	-- 		})
	-- 	end,
	-- },
}
