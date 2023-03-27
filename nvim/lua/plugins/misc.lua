return {
  {
    -- sessions
    'jedrzejboczar/possession.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('possession').setup {
        commands = {
          save = 'SSave',
          load = 'SLoad',
          delete = 'SDelete',
          list = 'SList',
        },
        plugins = {
          delete_hidden_buffers = {
            hooks = {
              'before_load',
              not vim.o.sessionoptions:match('buffer') and 'before_save',
            },
            force = false, -- or fun(buf): boolean
          }
        },
      }
    end
  },
  {
    -- Markdown helper commands
    'jakewvincent/mkdnflow.nvim',
    config = function()
      require('mkdnflow').setup({
        mappings = {
          MkdnFoldSection = { 'n', '<leader>fs' },
          MkdnToggleToDo = { { 'n', 'v' }, '<C-c>' },
          MkdnTableNextCell = { 'i', '<Tab>' },
          MkdnTablePrevCell = { 'i', '<S-Tab>' },
          MkdnTableNextRow = false,
          MkdnTablePrevRow = { 'i', '<M-CR>' },
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
    config = function()
      -- needed because somehow the automatic setup doesn't work
      require('ofirkai').setup {}
    end
  },
  -- colorful brackets
  'p00f/nvim-ts-rainbow',
  -- surround chunks of text/code with brackets/tags/quotes
  {
    'kylechui/nvim-surround',
    version = "*",
    config = function()
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
    config = function()
      require('nvim-navic').setup {
        separator = "  "
      }
    end
  },
  {
    'iamcco/markdown-preview.nvim',
    build = function() vim.fn['mkdp#util#install']() end,
  },
  {
    'L3MON4D3/LuaSnip',
    -- follow latest release.
    version = '1.*',
    -- install jsregexp (optional!).
    build = 'make install_jsregexp',
    config = function()
      require("luasnip.loaders.from_snipmate").lazy_load()
    end
  },
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  },
  { 'tpope/vim-dotenv' }
}
