vim.o.termguicolors = true
-- Relative line numbers
vim.o.relativenumber = true
-- Show line numbers
vim.o.number = true
-- Default to 2 spaces for tabs
vim.o.tabstop = 2
vim.o.shiftwidth = 2
-- Expand tabs to spaces
vim.o.expandtab = true
-- Line wrap
vim.o.textwidth = 120

-- coc variables
-- Some servers have issues with backup files, see #649
vim.o.backup = false
vim.o.writebackup = false

-- Allow local config loading
vim.o.exrc = true

-- Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
-- delays and poor user experience
vim.o.updatetime = 300

-- Always show the signcolumn, otherwise it would shift the text each time
-- diagnostics appeared/became resolved
vim.o.signcolumn = "yes"

vim.o.timeout = true
vim.o.timeoutlen = 300

-- linewrap column
vim.o.colorcolumn = "120"

-- treesitter fold
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'

-- other setup
vim.filetype.add({ filename = { ['Jenkinsfile'] = 'groovy' } })
