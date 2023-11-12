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
    ft = 'markdown',
    config = function()
      require('mkdnflow').setup({
        perspective = {
          priority = 'root',
          root_tell = 'index.md'
        },
        bib = {
          find_in_root = true,
          default_path = 'ref.bib'
        },
        yaml = {
          bib = { override = true }
        },
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
  { 'jiangmiao/auto-pairs', event = 'BufReadPost' },
  -- useful methods
  'nvim-lua/plenary.nvim',
  -- surround chunks of text/code with brackets/tags/quotes
  {
    'kylechui/nvim-surround',
    version = "*",
    config = function()
      require('nvim-surround').setup()
    end
  },
  {
    'iamcco/markdown-preview.nvim',
    ft = 'markdown',
    build = function() vim.fn['mkdp#util#install']() end,
  },
  {
    'L3MON4D3/LuaSnip',
    event = 'BufReadPre',
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
    event = 'BufReadPre',
    config = function()
      require('Comment').setup()
    end
  },
  { 'tpope/vim-dotenv' },
  {
    'vim-test/vim-test',
    dependencies = { 'tpope/vim-dispatch' },
    config = function()
      vim.cmd("let g:test#strategy = 'dispatch'")

      -- Use "bundle exec ruby -Itest" as a custom executable for ruby tests
      vim.cmd("let test#ruby#minitest#executable = 'bundle exec ruby -Itest'")
    end
  },
  {
    'tpope/vim-dispatch'
  },
  -- Zettelkasten plugin and deps
  {
    'renerocksai/telekasten.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function()
      local home = vim.fn.expand("~/zk/zettels")
      require('telekasten').setup({
        home = home, -- Put the name of your notes directory here
        take_over_my_home = true,
        auto_set_filetype = false,
        new_note_filename = 'uuid',
        uuid_type = "%Y%m%d%H%M",
        extension = '.md', -- differentiate between markdown files and Zettelkasten files
        template_new_note = home .. '/' .. 'templates/new_note.zkt.md',
        template_new_daily = home .. '/' .. 'templates/daily.zkt.md',
        template_new_weekly = home .. '/' .. 'templates/weekly.zkt.md',
      })
    end
  },
  {
    -- add copilot
    'zbirenbaum/copilot.lua',
    dependencies = { 'zbirenbaum/copilot-cmp' },
    event = "InsertEnter",
    cmd = 'Copilot',
    config = function()
      require('copilot').setup({
        panel = {
          auto_refresh = false,
          keymap = {
            accept = "<CR>",
            jump_prev = "[[",
            jump_next = "]]",
            refresh = "gr",
            open = "<M-CR>",
          },
        },
        suggestion = {
          auto_trigger = true,
          keymap = {
            accept = "<M-l>",
            prev = "<M-[>",
            next = "<M-]>",
            dismiss = "<C-]>",
          },
        },
      })
      require('copilot_cmp').setup({})
    end
  },
  {
    -- display ansi colored text
    'powerman/vim-plugin-AnsiEsc'
  },
  {
    'm00qek/baleia.nvim',
    config = function()
      require('baleia').setup()
    end
  }
}
