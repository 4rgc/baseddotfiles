return {
  { 'SmiteshP/nvim-navic', dependencies = {'neovim/nvim-lspconfig'} },
  {
    'neovim/nvim-lspconfig',
    config = function ()
      require('lspconfig')['tsserver'].setup {
        on_attach = function(client, bufnr)
          require('nvim-navic').attach(client, bufnr)
        end
      }
      require('lspconfig')['lua_ls'].setup {
        on_attach = function(client, bufnr)
          require('nvim-navic').attach(client, bufnr)
        end
      }
    end
  },
  {
    'ray-x/lsp_signature.nvim',
    config = function ()
      local lsp_signature_cfg = {
        bind = true,
        use_lspsaga = false,
        doc_lines = 0,
        floating_window = false,
        hint_scheme = 'LspSignatureHintVirtualText',
        hint_prefix = ' ',
      }
      require('lsp_signature').setup(lsp_signature_cfg)
    end
  }
}
