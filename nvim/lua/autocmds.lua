vim.api.nvim_create_autocmd('FileType', {
    pattern = 'markdown,snippets',
    command = 'set nowrap',
    desc = 'Don\'t wrap lines in markdown'
})

vim.api.nvim_create_autocmd('BufRead,BufNewFile', {
    pattern = '*.dbout',
    command = 'set filetype=dbout',
    desc = 'Set filetype to dbout'
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'dbout',
    command = 'normal zR',
    desc = 'Expand folds in db result files',
})
