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
        filetypes = {
          livemd = true,
          md = true,
          markdown = true,
          rmd = true,
        },
        bib = {
          find_in_root = true,
          default_path = 'bibliography.bib'
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
  {
    'jubnzv/mdeval.nvim',
    ft = { 'markdown', 'livebook' },
    config = function()
      require('mdeval').setup {
        eval_options = {
          elixir = {
            command = { 'elixir', '--eval' },
            languge_code = 'elixir',
            exec_type = 'interpreted'
          }
        }
      }
    end
  },
  {
     'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
    ft = { 'markdown' },
  },
  {
    "epwalsh/obsidian.nvim",
    version = "*",  -- recommended, use latest release instead of latest commit
    lazy = true,
    event = {
      -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
      -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
      -- refer to `:h file-pattern` for more examples
      "BufReadPre " .. vim.fn.expand "~" .. "/Nextcloud/Obsidian/Second Brain/*.md",
    },
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- see below for full list of optional dependencies 👇
    },
    opts = {
      workspaces = {
        {
          name = "personal",
          path = "~/Nextcloud/Obsidian/Second Brain",
        },
      },
      daily_notes = {
        -- Optional, if you keep daily notes in a separate directory.
        folder = "daily",
        -- Optional, if you want to change the date format for the ID of daily notes.
        date_format = "%Y-%m-%d",
        -- Optional, if you want to change the date format of the default alias of daily notes.
        alias_format = "%B %-d, %Y",
        -- Optional, default tags to add to each new daily note created.
        default_tags = { "daily-notes" },
        -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
        template = "templates/daily.md"
      },
    },
  },
  -- auto type bracket pairs
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {} -- this is equalent to setup({}) function
  },
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
      -- iCloud Drive/Obsidian/Second Brain
      local home = vim.fn.expand("~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Second Brain")
      require('telekasten').setup({
        home = home,
        take_over_my_home = true,
        auto_set_filetype = false,
        new_note_filename = 'uuid',
        uuid_type = "%Y%m%d%H%M",
        template_new_note = home .. '/' .. 'templates/knowledge.md',
        template_new_daily = home .. '/' .. 'templates/daily.md',
        template_new_weekly = home .. '/' .. 'templates/weekly.md',
        dailies = home .. '/' .. 'daily'
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
        filetypes = {
          markdown = true
        }
      })
      require('copilot_cmp').setup({})
    end
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, 
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {
      -- See Configuration section for options
      mappings = {
        reset = {
          normal = "<C-x>",
          insert = "<C-x>",
        }
      }
    },
    -- See Commands section for default commands if you want to lazy load on them
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
  },
  {
    'pwntester/octo.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require "octo".setup()
    end
  },
  {
    "aserowy/tmux.nvim",
    config = function () 
      require("tmux").setup({})
    end
  },
  { 
    "mistricky/codesnap.nvim",
    build = "make",
    config = function()
      require("codesnap").setup({
        bg_x_padding = 40,
        bg_y_padding = 30,
        watermark = ""
      })
    end
  },
}
