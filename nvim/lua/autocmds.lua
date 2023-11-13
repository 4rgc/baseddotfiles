local map = require('util').map

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'markdown,snippets',
    command = 'set nowrap',
    desc = 'Don\'t wrap lines in markdown'
})

vim.api.nvim_create_autocmd({'BufRead','BufNewFile'}, {
    pattern = '*.dbout',
    command = 'set filetype=dbout',
    desc = 'Set filetype to dbout'
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'dbout', '.zk.md' },
    command = 'normal zR',
    desc = 'Autoexpand folds',
})

vim.api.nvim_create_autocmd({'BufRead','BufNewFile'}, {
    pattern = '*/zk/zettels/*',
    callback =  function () map("i", "[[", "<cmd>Telekasten insert_link<cr>", 'Insert link') end,
    desc = 'Call insert link automatically when we start typing a link'
})
