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

      vim.api.nvim_create_user_command(
        'Gc',
        function(opts)
          args = {}
          for i, v in ipairs(opts.fargs) do
            if i ~= 0 and i ~= 1 then
              table.insert(args, v)
            end
          end
          require('noice')
              .redirect(
                string.format(
                -- pass all arguments from the values in the opts.fargs table to git commit
                  'Git commit %s', table.concat(args, ' ')
                ),
                {
                  {
                    view = 'cmdline_output',
                    filter = { event = "msg_show", kind = { "echo", "echoerr", "echomsg" } }
                  },
                  {
                    view = 'notify',
                    filter = { event = "msg_show", kind = { "echo", "echoerr", "echomsg" } }
                  },
                }
              )
        end,
        { nargs = "*" }
      )
    end
  },
  {
    -- testing UI
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "zidhuss/neotest-minitest",
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
          require('neotest-minitest')({
            test_cmd = function()
              return vim.tbl_flatten({
                'bundle',
                'exec',
                'ruby',
                '-Itest',
              })
            end
          }),
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
          highlight = {
            'IblIndent1',
            'IblIndent2',
            'IblIndent3',
            'IblIndent4',
            'IblIndent5'
          },
        }
      }
    end
  },
  -- pretty print jsx
  { 'maxmellon/vim-jsx-pretty', ft = { 'javascriptreact', 'typescriptreact' } },
  {
    -- goated theme
    'ofirgall/ofirkai.nvim',
    config = function()
      -- needed because somehow the automatic setup doesn't work
      require('ofirkai').setup {}
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
    config = function()
      require('trouble').setup {}
    end
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
