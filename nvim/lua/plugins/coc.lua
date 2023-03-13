return {
  {
    'neoclide/coc.nvim',
    branch = 'release',
    init = function ()
        vim.g.coc_global_extensions = {
          'coc-tslint-plugin',
          'coc-tsserver',
          'coc-css',
          'coc-html',
          'coc-json',
          'coc-prettier',
          'friendly-snippets',
          'coc-webview',
          'coc-lua',
          'coc-markdown-preview-enhanced'
        }
    end
  }
}

