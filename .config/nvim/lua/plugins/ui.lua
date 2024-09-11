return {
  {
    -- Notifications/messages
    'folke/noice.nvim',
    event = "VeryLazy",
    dependencies = { 'MunifTanjim/nui.nvim', 'rcarriga/nvim-notify' },
    config = function()
      require('noice').setup({
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = true,         -- use a classic bottom cmdline for search
          command_palette = true,       -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false,           -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false,       -- add a border to hover docs and signature help
        }
      })

      -- the plugin hides the bottom cmdline, so we show the partial command in the statusline
      vim.opt.showcmdloc = 'statusline'
    end
  },
  {
    -- testing UI
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-jest",
      "MarkEmmons/neotest-deno",
      "marilari88/neotest-vitest",
      "jfpedroza/neotest-elixir",
      "andy-bell101/neotest-java",
      "nvim-neotest/neotest-plenary"
    },
    config = function()
      require('neotest').setup({
        adapters = {
          require('neotest-python')({}),
          require('neotest-jest')({
            jestCommand = "npm test --"
          }),
          require('neotest-deno')({}),
          require('neotest-vitest')({}),
          require('neotest-elixir')({}),
          require('neotest-java')({}),
          require('neotest-plenary')({}),
        }
      })
    end
  },
  {
    -- Indentation coloring
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    event = 'BufReadPre',
    config = function()
      local hooks = require "ibl.hooks"
      -- create the highlight groups in the highlight setup hook, so they are reset
      -- every time the colorscheme changes
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "IblWhitespace1", { bg = "#2E2314", nocombine = true })
        vim.api.nvim_set_hl(0, "IblWhitespace2", { bg = "#292B1C", nocombine = true })
        vim.api.nvim_set_hl(0, "IblWhitespace3", { bg = "#232B1E", nocombine = true })
        vim.api.nvim_set_hl(0, "IblWhitespace4", { bg = "#202A24", nocombine = true })
        vim.api.nvim_set_hl(0, "IblWhitespace5", { bg = "#2A2327", nocombine = true })
        vim.api.nvim_set_hl(0, "IblIndent1", { fg = "#c81e54" })
        vim.api.nvim_set_hl(0, "IblIndent2", { fg = "#baac2c" })
        vim.api.nvim_set_hl(0, "IblIndent3", { fg = "#8fbe27" })
        vim.api.nvim_set_hl(0, "IblIndent4", { fg = "#2f99b6" })
        vim.api.nvim_set_hl(0, "IblIndent5", { fg = "#8a5bf1" })
      end)
      vim.opt.list = true
      vim.opt.listchars:append "space:⋅"
      require("ibl").setup {
        whitespace = {
          highlight = {
            'IblWhitespace1',
            'IblWhitespace2',
            'IblWhitespace3',
            'IblWhitespace4',
            'IblWhitespace5'
          },
        },
        scope = {
          char = '▎',
          highlight = {
            'IblIndent1',
            'IblIndent2',
            'IblIndent3',
            'IblIndent4',
            'IblIndent5'
          },
        },
        indent = {
            char = '│',
            tab_char = '│'
        }
      }
    end
  },
  -- pretty print jsx
  { 'maxmellon/vim-jsx-pretty', ft = { 'javascriptreact', 'typescriptreact' } },
  -- {
  --   -- goated theme
  --   'ofirgall/ofirkai.nvim',
  --   config = function()
  --     -- needed because somehow the automatic setup doesn't work
  --     require('ofirkai').setup {}
  --     -- set the colorcolumn after the theme is loaded
  --     vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#171712" })
  --   end
  -- },
  {
    'uZer/pywal16.nvim',
    config = function()
      require('pywal16').setup()
    end
  },
  -- colorful brackets
  { 'p00f/nvim-ts-rainbow',     lazy = true },
  {
    -- list, make commands/keymaps/functions/autocmds
    'mrjones2014/legendary.nvim',
    opts = { include_builtin = true, auto_register_which_key = true }
  },
  {
    -- show keymaps
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
  {
    -- find out current semantic position in a file
    'SmiteshP/nvim-navic',
    event = 'BufReadPre',
    config = function()
      require('nvim-navic').setup {
        separator = "  "
      }
    end
  },
  {
    -- show diagnostics in the workspace
    'folke/trouble.nvim',
    opts = {},
    cmd = "Trouble",
    keys = {
      {
        "<space>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<space>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<space>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<space>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<space>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<space>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
  {
    -- highlight todo comments
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('todo-comments').setup {}
    end,
    opts = {}
  },
  {
    -- highlight hex/rgb/hsl colors
    'brenoprata10/nvim-highlight-colors',
    event = 'BufReadPre',
    config = function()
      require('nvim-highlight-colors').setup {
        enable_tailwind = true
      }
    end
  },
  {
    -- improve quickfix ui
    'kevinhwang91/nvim-bqf'
  },
}
