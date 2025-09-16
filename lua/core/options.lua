-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

vim.o.number = true -- Make line numbers default
vim.o.relativenumber = true

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

vim.o.wrap = false -- Display lines as one long line 
vim.o.linebreak = true -- Companion to wrap, don't split words

vim.o.mouse = 'a' -- Enable mouse mode

vim.o.autoindent = true -- Copy indent from current line when starting new one

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- TODO: when opening a new help, open to the right. Maybe use keymaps?
vim.o.splitright = true
vim.o.splitbelow = true

