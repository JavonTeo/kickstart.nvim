return {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
        require('toggleterm').setup {
            size = 15, -- height of terminal
            open_mapping = [[<c-\>]], -- Ctrl+` toggle, FIX this needs to override the default behavior of ctrl+`
            -- set to ctrl+\ for now
            direction = 'horizontal', -- bottom window
            shade_terminals = true,
            start_in_insert = true, -- enter insert when opening
            insert_mappings = true, -- allow <C-`> in insert mode
            terminal_mappings = true, -- allow <C-`> in terminal mode
            close_on_exit = false, -- keep terminal session alive
            persist_mode = false, -- auto switch cursor mode
            shell = vim.o.shell,
        }

        -- Map <Esc> to exit terminal mode
        vim.api.nvim_create_autocmd('TermOpen', {
            pattern = 'term://*',
            callback = function()
                vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { buffer = true })
            end,
        })
    end,
}
