-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true
vim.o.termguicolors = true

vim.o.number = true -- Make line numbers default
vim.o.relativenumber = true

-- Settings for cursorline for displaying
vim.o.cursorline = true
vim.o.cursorlineopt = 'number'

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
vim.schedule(function()
	vim.o.clipboard = 'unnamedplus'
end)

vim.o.wrap = false         -- Display lines as one long line
vim.o.linebreak = true     -- Companion to wrap, don't split words

vim.o.mouse = 'a'          -- Enable mouse mode

vim.opt.tabstop = 4        -- number of spaces that <Tab> counts for
vim.opt.shiftwidth = 4     -- number of spaces for each indent level
vim.opt.smartindent = true -- smart autoindenting on new lines
vim.opt.autoindent = true  -- copy indent from current line when starting new one

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- TODO: when opening a new help, open to the right. Maybe use keymaps?
vim.o.splitright = true
vim.o.splitbelow = true

vim.o.updatetime = 500

vim.o.scrolloff = 20

vim.diagnostic.enable(false)
