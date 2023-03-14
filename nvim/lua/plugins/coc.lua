-- also need to install:
--          'https://github.com/rafamadriz/friendly-snippets@main',
--          'coc-webview',
--          'coc-lua',
--          'coc-markdown-preview-enhanced'

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
        }
    end
  }
}

