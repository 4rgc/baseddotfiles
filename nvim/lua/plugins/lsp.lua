return {
  { 'SmiteshP/nvim-navic', dependencies = {'neovim/nvim-lspconfig'} },
  {
    'neovim/nvim-lspconfig',
    config = function ()
      require('lspconfig').clangd.setup {
        on_attach = function(client, bufnr)
          navic.attach(client, bufnr)
        end
      }
    end
  },
  {
    'ray-x/lsp_signature.nvim',
    config = function ()
      require('lsp_signature').setup(lsp_signature_cfg)
    end
  }
}
