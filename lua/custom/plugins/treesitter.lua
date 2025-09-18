return { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
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
        auto_install = true,
        highlight = {
            enable = true,
            -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
            --  If you are experiencing weird indenting issues, add the language to
            --  the list of additional_vim_regex_highlighting and disabled languages for indent.
            additional_vim_regex_highlighting = { 'ruby' },
        },
        indent = { enable = true, disable = { 'ruby' } },
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
