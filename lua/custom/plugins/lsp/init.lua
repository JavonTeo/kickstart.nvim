return {
  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    event = "LazyFile",
    dependencies = {
      "mason.nvim",
      { "mason-org/mason-lspconfig.nvim", config = function() end },
      {
        'p00f/clangd_extensions.nvim',
        lazy = true,
        config = function()
          require('clangd_extensions').setup({
            inlay_hints = {
              inline = vim.fn.has 'nvim-0.10' == 1,
              only_current_line = false,
              only_current_line_autocmd = { 'CursorHold' },
              show_parameter_hints = true,
              parameter_hints_prefix = '<- ',
              other_hints_prefix = '=> ',
              max_len_align = false,
              max_len_align_padding = 1,
              right_align = false,
              right_align_padding = 7,
              highlight = 'Comment',
              priority = 100,
            },
            ast = {
              role_icons = {
                type = '',
                declaration = '',
                expression = '',
                specifier = '',
                statement = '',
                ['template argument'] = '',
              },
              kind_icons = {
                Compound = '',
                Recovery = '',
                TranslationUnit = '',
                PackExpansion = '',
                TemplateTypeParm = '',
                TemplateTemplateParm = '',
                TemplateParamObject = '',
              },
              highlights = {
                detail = 'Comment',
              },
            },
            memory_usage = { border = 'none' },
            symbol_info = { border = 'none' },
          })
        end,
      },
    },
    opts_extend = { "servers.*.keys" },
    opts = function()
      ---@class PluginLspOpts
      local ret = {
        -- options for vim.diagnostic.config()
        ---@type vim.diagnostic.Opts
        diagnostics = {
          underline = true,
          update_in_insert = false,
          virtual_text = {
            spacing = 4,
            source = "if_many",
            prefix = "●",
            -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
            -- prefix = "icons",
          },
          severity_sort = true,
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = LazyVim.config.icons.diagnostics.Error,
              [vim.diagnostic.severity.WARN] = LazyVim.config.icons.diagnostics.Warn,
              [vim.diagnostic.severity.HINT] = LazyVim.config.icons.diagnostics.Hint,
              [vim.diagnostic.severity.INFO] = LazyVim.config.icons.diagnostics.Info,
            },
          },
        },
        -- Enable this to enable the builtin LSP inlay hints on Neovim.
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the inlay hints.
        inlay_hints = {
          enabled = true,
          exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
        },
        -- Enable this to enable the builtin LSP code lenses on Neovim.
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the code lenses.
        codelens = {
          enabled = false,
        },
        -- Enable this to enable the builtin LSP folding on Neovim.
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the folds.
        folds = {
          enabled = true,
        },
        -- options for vim.lsp.buf.format
        -- `bufnr` and `filter` is handled by the LazyVim formatter,
        -- but can be also overridden when specified
        format = {
          formatting_options = nil,
          timeout_ms = nil,
        },
        -- LSP Server Settings
        -- Sets the default configuration for an LSP client (or all clients if the special name "*" is used).
        ---@alias lazyvim.lsp.Config vim.lsp.Config|{mason?:boolean, enabled?:boolean, keys?:LazyKeysLspSpec[]}
        ---@type table<string, lazyvim.lsp.Config|boolean>
        servers = {
          -- configuration for all lsp servers
          ["*"] = {
            capabilities = {
              workspace = {
                fileOperations = {
                  didRename = true,
                  willRename = true,
                },
              },
            },
            -- stylua: ignore
            keys = {
              { "<leader>cl", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
              { "<leader>rn", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
              { "ga", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "x" }, has = "codeAction" },
              { "gd", vim.lsp.buf.definition, desc = "Goto Definition", has = "definition" },
              { "gr", vim.lsp.buf.references, desc = "References", nowait = true },
              { "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
              -- { "gy", vim.lsp.buf.type_definition, desc = "Goto T[y]pe Definition" },
              { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
              -- { "gd", function() require("fzf-lua").lsp_definitions({ jump1 = true, ignore_current_line = true }) end, desc = "Goto Definition", has = "definition" },
              -- { "gr", function() require("fzf-lua").lsp_references({ jump1 = true, ignore_current_line = true }) end, desc = "References", nowait = true },
              -- { "gI", function() require("fzf-lua").lsp_implementations({ jump1 = true, ignore_current_line = true }) end, desc = "Goto Implementation" },
              -- { "gD", function() require("fzf-lua").lsp_declarations({ jump1 = true, ignore_current_line = true }) end, desc = "Goto Declaration" },
              -- { "gt", function() require("fzf-lua").lsp_typedefs({ jump1 = true, ignore_current_line = true }) end, desc = "Goto T[y]pe Definition" },
              { "<leader>st", function() require("fzf-lua").lsp_document_symbols() end, desc = "Search Treesitter symbols", has = "documentSymbol" },
              { "K", function() return vim.lsp.buf.hover() end, desc = "Hover" },
              { "gK", function() return vim.lsp.buf.signature_help() end, desc = "Signature Help", has = "signatureHelp" },
              { "<c-k>", function() return vim.lsp.buf.signature_help() end, mode = "i", desc = "Signature Help", has = "signatureHelp" },
              { "]]", function() Snacks.words.jump(vim.v.count1) end, has = "documentHighlight", desc = "Next Reference" },
              { "[[", function() Snacks.words.jump(-vim.v.count1) end, has = "documentHighlight", desc = "Prev Reference" },
            },
          },
          stylua = { enabled = false },
          clangd = {
            filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
            cmd = {
              'clangd',
              '--background-index',
              '--offset-encoding=utf-16',
              '--clang-tidy',
              '--header-insertion=iwyu',
              '--completion-style=detailed',
              '--function-arg-placeholders',
              '--fallback-style=llvm',
            },
            init_options = {
              usePlaceholders = true,
              completeUnimported = true,
              clangdFileStatus = true,
            },
          },
          ruff = {},
          basedpyright = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "openFilesOnly",
              useLibraryCodeForTypes = true,
              inlayHints = { callArgumentNames = true },
            },
          },
          vue_ls = {},
          html = {},
          cssls = {},
          jsonls = {},
          biome = {},
          ts_ls = {
            init_options = {
              plugins = {
                {
                  languages = { "vue" },
                  location = vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
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
          lua_ls = {
            -- mason = false, -- set to false if you don't want this server to be installed with mason
            -- Use this to add any additional keymaps
            -- for specific lsp servers
            -- ---@type LazyKeysSpec[]
            -- keys = {},
            settings = {
              Lua = {
                workspace = {
                  checkThirdParty = false,
                },
                codeLens = {
                  enable = true,
                },
                completion = {
                  callSnippet = "Replace",
                },
                doc = {
                  privateName = { "^_" },
                },
                hint = {
                  enable = true,
                  setType = false,
                  paramType = true,
                  paramName = "Disable",
                  semicolon = "Disable",
                  arrayIndex = "Disable",
                },
              },
            },
          },
        },
        -- you can do any additional lsp server setup here
        -- return true if you don't want this server to be setup with lspconfig
        ---@type table<string, fun(server:string, opts: vim.lsp.Config):boolean?>
        setup = {
          basedpyright = function(_, opts)
            opts.on_attach = function(client, bufnr)
              if client.name == 'basedpyright' then
                client.server_capabilities.semanticTokensProvider = nil
              end
            end
          end,
          ruff = function(_, opts)
            opts.on_attach = function(client, bufnr)
              if client.name == 'ruff' then
                client.server_capabilities.hoverProvider = false
                client.server_capabilities.documentFormattingProvider = false
                client.server_capabilities.documentRangeFormattingProvider = false
              end
            end
          end,
        },
      }
      return ret
    end,
    ---@param opts PluginLspOpts
    config = vim.schedule_wrap(function(_, opts)
      -- setup autoformat
      LazyVim.format.register(LazyVim.lsp.formatter())

      -- setup keymaps
      for server, server_opts in pairs(opts.servers) do
        if type(server_opts) == "table" and server_opts.keys then
          require("custom.plugins.lsp.keymaps").set({ name = server ~= "*" and server or nil }, server_opts.keys)
        end
      end

      -- inlay hints
      if opts.inlay_hints.enabled then
        Snacks.util.lsp.on({ method = "textDocument/inlayHint" }, function(buffer)
          if
            vim.api.nvim_buf_is_valid(buffer)
            and vim.bo[buffer].buftype == ""
            and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
          then
            vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
          end
        end)
      end

      -- folds
      if opts.folds.enabled then
        Snacks.util.lsp.on({ method = "textDocument/foldingRange" }, function()
          if LazyVim.set_default("foldmethod", "expr") then
            LazyVim.set_default("foldexpr", "v:lua.vim.lsp.foldexpr()")
          end
        end)
      end

      -- code lens
      if opts.codelens.enabled and vim.lsp.codelens then
        Snacks.util.lsp.on({ method = "textDocument/codeLens" }, function(buffer)
          vim.lsp.codelens.refresh()
          vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            buffer = buffer,
            callback = vim.lsp.codelens.refresh,
          })
        end)
      end

      -- diagnostics
      if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
        opts.diagnostics.virtual_text.prefix = function(diagnostic)
          local icons = LazyVim.config.icons.diagnostics
          for d, icon in pairs(icons) do
            if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
              return icon
            end
          end
          return "●"
        end
      end
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      if opts.capabilities then
        LazyVim.deprecate("lsp-config.opts.capabilities", "Use lsp-config.opts.servers['*'].capabilities instead")
        opts.servers["*"] = vim.tbl_deep_extend("force", opts.servers["*"] or {}, {
          capabilities = opts.capabilities,
        })
      end

      if opts.servers["*"] then
        vim.lsp.config("*", opts.servers["*"])
      end

      -- get all the servers that are available through mason-lspconfig
      local have_mason = LazyVim.has("mason-lspconfig.nvim")
      local mason_all = have_mason
          and vim.tbl_keys(require("mason-lspconfig.mappings").get_mason_map().lspconfig_to_package)
        or {} --[[ @as string[] ]]
      local mason_exclude = {} ---@type string[]

      ---@return boolean? exclude automatic setup
      local function configure(server)
        if server == "*" then
          return false
        end
        local sopts = opts.servers[server]
        sopts = sopts == true and {} or (not sopts) and { enabled = false } or sopts --[[@as lazyvim.lsp.Config]]

        if sopts.enabled == false then
          mason_exclude[#mason_exclude + 1] = server
          return
        end

        local use_mason = sopts.mason ~= false and vim.tbl_contains(mason_all, server)
        local setup = opts.setup[server] or opts.setup["*"]
        if setup and setup(server, sopts) then
          mason_exclude[#mason_exclude + 1] = server
        else
          vim.lsp.config(server, sopts) -- configure the server
          if not use_mason then
            vim.lsp.enable(server)
          end
        end
        return use_mason
      end

      local install = vim.tbl_filter(configure, vim.tbl_keys(opts.servers))
      if have_mason then
        require("mason-lspconfig").setup({
          ensure_installed = vim.list_extend(install, LazyVim.opts("mason-lspconfig.nvim").ensure_installed or {}),
          automatic_enable = { exclude = mason_exclude },
        })
      end
    end),
  },

  -- cmdline tools and lsp servers
  {

    "mason-org/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
      },
    },
    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          -- trigger FileType event to possibly load this newly installed LSP server
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)

      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },
}
