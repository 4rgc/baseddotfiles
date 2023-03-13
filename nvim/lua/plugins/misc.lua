return {
  {
    -- sessions
    'jedrzejboczar/possession.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function ()
      require('possession').setup {
          commands = {
              save = 'SSave',
              load = 'SLoad',
              delete = 'SDelete',
              list = 'SList',
          }
      }
    end
  },
  {
    -- Markdown helper commands
    'jakewvincent/mkdnflow.nvim',
    config = function ()
      require('mkdnflow').setup({
          mappings = {
              MkdnTableNextCell = {'i', '<F2>'},
              MkdnTablePrevCell = {'i', '<F3>'},
              MkdnFoldSection = {'n', '<leader>fs'},
              MkdnToggleToDo = {{'n', 'v'}, '<C-c>'}
          }
      })
    end
  },
  -- auto type bracket pairs
  'jiangmiao/auto-pairs',
  -- pretty print jsx
  'maxmellon/vim-jsx-pretty',
  -- useful methods
  'nvim-lua/plenary.nvim',
  -- goated theme
  {
    'ofirgall/ofirkai.nvim',
    config = function ()
      -- needed because somehow the automatic setup doesn't work
      require('ofirkai').setup()
    end
  },
  -- colorful brackets
  'p00f/nvim-ts-rainbow',
  -- surround chunks of text/code with brackets/tags/quotes
  {
    'kylechui/nvim-surround',
    version = "*",
    config = function ()
      require('nvim-surround').setup()
    end
  },
  -- list, make commands/keymaps/functions/autocmds
  {
    'mrjones2014/legendary.nvim',
    opts = { include_builtin = true, auto_register_which_key = true }
  },
  -- show keymaps
  {
    'folke/which-key.nvim',
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      })
    end,
  },
  -- find out current semantic position in a file
  {
    'SmiteshP/nvim-navic',
    config = function ()
      require('nvim-navic').setup {
          separator = "  "
      }
    end
  }
}
