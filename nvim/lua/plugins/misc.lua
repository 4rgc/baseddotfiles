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
    { 'jiangmiao/auto-pairs',     event = 'BufReadPost' },
    -- pretty print jsx
    { 'maxmellon/vim-jsx-pretty', ft = { 'javascriptreact', 'typescriptreact' } },
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
    { 'p00f/nvim-ts-rainbow', lazy = true },
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
        event = 'BufReadPre',
        config = function()
            require('nvim-navic').setup {
                separator = "  "
            }
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
        'folke/trouble.nvim',
        config = function()
            require('trouble').setup {}
        end
    },
    {
        'folke/todo-comments.nvim',
        lazy = true,
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('todo-comments').setup {}
        end
    },
    {
        'brenoprata10/nvim-highlight-colors',
        event = 'BufReadPre',
        config = function()
            require('nvim-highlight-colors').setup {
                enable_tailwind = true
            }
        end
    },
    {
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
                show_trailing_blankline_indent = false,
                show_current_context = true,
                show_current_context_start = true,
            }
        end
    },
    {
        'vim-test/vim-test',
        dependencies = { 'tpope/vim-dispatch' },
        config = function()
            vim.cmd("let test#strategy = 'dispatch'")
        end
    },
    {
        'tpope/vim-dispatch'
    }
}
