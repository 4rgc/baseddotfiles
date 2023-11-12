return {
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = { "c", "lua", "vim", "vimdoc", "query", 'dockerfile', 'dot', 'git_rebase',
                    'gitattributes',
                    'gitcommit', 'gitignore', 'graphql', 'html', 'javascript', 'jsdoc', 'json', 'json5', 'latex', 'lua',
                    'markdown', 'markdown_inline', 'sql', 'python', 'regex', 'ruby', 'rust', 'scss', 'tsx', 'typescript',
                    'yaml' },
                highlight = {
                    enable = true,
                    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                    -- Using this option may slow down your editor, and you may see some duplicate highlights.
                    -- Instead of true it can also be a list of languages
                    additional_vim_regex_highlighting = false,
                },
                rainbow = {
                    enable = true,
                    extended_mode = false
                },

                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            -- You can use the capture groups defined in textobjects.scm
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@condition.outer",
                            ["ic"] = "@condition.inner",
                            ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
                        },
                        selection_modes = {
                            ['@parameter.outer'] = 'v', -- charwise
                            ['@function.outer'] = 'V', -- linewise
                            ['@class.outer'] = '<c-v>', -- blockwise
                        },
                        include_surrounding_whitespace = true,
                    },
                    move = {
                        enable = true,
                        set_jumps = true, -- whether to set jumps in the jumplist
                        goto_next_start = {
                            ["]m"] = "@function.outer",
                            ["]]"] = { query = "@class.outer", desc = "Next class start" },
                            --
                            -- You can use regex matching and/or pass a list in a "query" key to group multiple queires.
                            ["]o"] = "@loop.*",
                            -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
                            --
                            -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
                            -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
                            ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
                            ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
                        },
                        goto_next_end = {
                            ["]M"] = "@function.outer",
                            ["]["] = "@class.outer",
                        },
                        goto_previous_start = {
                            ["[m"] = "@function.outer",
                            ["[["] = "@class.outer",
                        },
                        goto_previous_end = {
                            ["[M"] = "@function.outer",
                            ["[]"] = "@class.outer",
                        },
                        goto_next = {
                            ["]c"] = "@conditional.outer",
                        },
                        goto_previous = {
                            ["[c"] = "@conditional.outer",
                        }
                    },
                    lsp_interop = {
                        enable = true,
                        border = 'none',
                        floating_preview_opts = {},
                        peek_definition_code = {
                            ["<leader>dm"] = "@function.outer",
                            ["<leader>dM"] = "@class.outer",
                        },
                    },
                },
            }
        end
    },
    { 'nvim-treesitter/nvim-treesitter-context' },
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        dependencies = { 'nvim-treesitter',
            'nvim-treesitter/nvim-treesitter' }
    },
    {
        'windwp/nvim-ts-autotag',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
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
