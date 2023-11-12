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
    event = 'BufReadPre',
    config = function()
      vim.cmd [[highlight IndentBlanklineIndent1 guibg=#2E2314 gui=nocombine]]
      vim.cmd [[highlight IndentBlanklineIndent2 guibg=#292B1C gui=nocombine]]
      vim.cmd [[highlight IndentBlanklineIndent3 guibg=#232B1E gui=nocombine]]
      vim.cmd [[highlight IndentBlanklineIndent4 guibg=#202A24 gui=nocombine]]
      vim.cmd [[highlight IndentBlanklineIndent5 guibg=#2A2327 gui=nocombine]]
      vim.opt.list = true
      vim.opt.listchars:append "space:⋅"
      require('indent_blankline').setup {
        space_char_blankline = " ",
        space_char_highlight_list = {
          'IndentBlanklineIndent1',
          'IndentBlanklineIndent2',
          'IndentBlanklineIndent3',
          'IndentBlanklineIndent4',
          'IndentBlanklineIndent5'
        },
        context_char = '▎',
        show_trailing_blankline_indent = false,
        show_current_context = true,
        show_current_context_start = true,
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
