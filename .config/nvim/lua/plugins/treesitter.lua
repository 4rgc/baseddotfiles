return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').setup {}

      -- Install parsers
      require('nvim-treesitter').install {
        'awk', 'bash', 'bibtex', 'c', 'cmake', 'comment', 'cpp', 'css', 'csv', 'desktop', 'devicetree', 'diff',
        'dockerfile', 'dot', 'elixir', 'git_config', 'git_rebase', 'gitattributes', 'gitcommit', 'gitignore', 'gpg',
        'graphql', 'groovy', 'html', 'http', 'hyprlang', 'ini', 'java', 'javadoc', 'javascript', 'jq', 'jsdoc',
        'json', 'json5', 'jsonc', 'latex', 'lua', 'luadoc', 'make', 'markdown', 'markdown_inline', 'mermaid',
        'meson', 'nginx', 'passwd', 'pem', 'prisma', 'printf', 'properties', 'python', 'query', 'readline', 'regex',
        'requirements', 'ruby', 'rust', 'scss', 'sql', 'ssh_config', 'tmux', 'todotxt', 'tsv', 'tsx', 'typescript',
        'udev', 'vim', 'vimdoc', 'xml', 'yaml',
      }

      -- Enable treesitter highlighting for all supported filetypes
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })

      vim.treesitter.language.register("markdown", "livebook")
    end
  },
  { 'nvim-treesitter/nvim-treesitter-context' },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('nvim-treesitter-textobjects').setup {
        select = {
          lookahead = true,
          selection_modes = {
            ['@parameter.outer'] = 'v',
            ['@function.outer'] = 'V',
            ['@class.outer'] = '<c-v>',
          },
          include_surrounding_whitespace = true,
        },
        move = {
          set_jumps = true,
        },
      }

      -- Select keymaps
      vim.keymap.set({ "x", "o" }, "af", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "if", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "ac", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@condition.outer", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "ic", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@condition.inner", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "as", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
      end)

      -- Move keymaps
      vim.keymap.set({ "n", "x", "o" }, "]m", function()
        require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "]]", function()
        require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "]o", function()
        require("nvim-treesitter-textobjects.move").goto_next_start({ "@loop.inner", "@loop.outer" }, "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "]s", function()
        require("nvim-treesitter-textobjects.move").goto_next_start("@local.scope", "locals")
      end)
      vim.keymap.set({ "n", "x", "o" }, "]z", function()
        require("nvim-treesitter-textobjects.move").goto_next_start("@fold", "folds")
      end)
      vim.keymap.set({ "n", "x", "o" }, "]M", function()
        require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "][", function()
        require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "[m", function()
        require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "[[", function()
        require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "[M", function()
        require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "[]", function()
        require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "]c", function()
        require("nvim-treesitter-textobjects.move").goto_next("@conditional.outer", "textobjects")
      end)
      vim.keymap.set({ "n", "x", "o" }, "[c", function()
        require("nvim-treesitter-textobjects.move").goto_previous("@conditional.outer", "textobjects")
      end)

      -- LSP interop
      vim.keymap.set("n", "<leader>dm", function()
        require("nvim-treesitter-textobjects.lsp_interop").peek_definition_code("@function.outer", "textobjects")
      end)
      vim.keymap.set("n", "<leader>dM", function()
        require("nvim-treesitter-textobjects.lsp_interop").peek_definition_code("@class.outer", "textobjects")
      end)
    end
  },
  {
    'windwp/nvim-ts-autotag',
    config = function()
      require('nvim-ts-autotag').setup {}
    end
  },
  {
    'axelvc/template-string.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('template-string').setup {}
    end
  }
}
