vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown,snippets',
  command = 'set nowrap',
  desc = 'Don\'t wrap lines in markdown'
})
