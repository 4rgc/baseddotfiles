local nextcloudPath = vim.fn.expand("$NEXTCLOUD_PATH")
local secondBrainPath = nextcloudPath .. "/Obsidian/Second Brain"

return {
  {
    -- sessions
    'jedrzejboczar/possession.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
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
    opts = {
      eval_options = {
        elixir = {
          command = { 'elixir', '--eval' },
          languge_code = 'elixir',
          exec_type = 'interpreted'
        }
      }
    }
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
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    event = {
      -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
      -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
      -- refer to `:h file-pattern` for more examples
      "BufReadPre " .. vim.fn.expand "~" .. "/Obsidian/Second Brain/*.md",
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
          path = secondBrainPath,
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
    opts = {}
  },
  -- useful methods
  'nvim-lua/plenary.nvim',
  -- surround chunks of text/code with brackets/tags/quotes
  {
    'kylechui/nvim-surround',
    event = { "BufReadPre", "BufNewFile" },
    version = "*",
    opts = {}
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
    opts = {}
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
    'tpope/vim-dispatch',
    lazy = true,
  },
  -- Zettelkasten plugin and deps
  {
    'renerocksai/telekasten.nvim',
    event = { "BufReadPre " .. secondBrainPath .. "/*.md" },
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function()
      -- iCloud Drive/Obsidian/Second Brain
      local home = secondBrainPath
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
    event = "VeryLazy",
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
    event = "VeryLazy",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken",                          -- Only on MacOS or Linux
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
    'powerman/vim-plugin-AnsiEsc',
    event = { "BufReadPre", "BufNewFile" },
  },
  {
    'm00qek/baleia.nvim',
    event = { "BufReadPre", "BufNewFile" },
    opts = {}
  },
  {
    'pwntester/octo.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    event = "VeryLazy",
    opts = {}
  },
  {
    "aserowy/tmux.nvim",
    opts = {}
  },
  {
    "mistricky/codesnap.nvim",
    event = "VeryLazy",
    build = "make",
    opts = {
      bg_x_padding = 40,
      bg_y_padding = 30,
      watermark = ""
    }
  }
}
