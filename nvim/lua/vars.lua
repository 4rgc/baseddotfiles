vim.opt.termguicolors = true
vim.o.relativenumber = true
vim.o.number = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.textwidth = 120

-- coc variables
-- Some servers have issues with backup files, see #649
vim.opt.backup = false
vim.opt.writebackup = false

-- Allow local config loading
vim.o.exrc = true

-- Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
-- delays and poor user experience
vim.opt.updatetime = 300

-- Always show the signcolumn, otherwise it would shift the text each time
-- diagnostics appeared/became resolved
vim.opt.signcolumn = "yes"

vim.o.timeout = true
vim.o.timeoutlen = 300

-- linewrap column
vim.o.colorcolumn = 120

-- treesitter fold
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'

-- other setup
vim.filetype.add({filename = {['Jenkinsfile'] = 'groovy'}})
