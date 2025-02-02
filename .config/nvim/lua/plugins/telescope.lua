return {
    {
        'nvim-telescope/telescope.nvim',
        version = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim', 'jedrzejboczar/possession.nvim' },
        config = function()
            require('telescope').setup({
                extensions = {
                    fzf = {
                        fuzzy = true, -- false will only do exact matching
                        override_generic_sorter = true, -- override the generic sorter
                        override_file_sorter = true, -- override the file sorter
                        case_mode = "smart_case", -- or "ignore_case" or "respect_case"
                        -- the default case_mode is "smart_case"
                    },
                    media_files = {
                        find_cmd = "rg"
                    }
                }
            })
            require('telescope').load_extension('possession')
            require('telescope').load_extension('fzf')
        end,
    },
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release'
    },
    {
        'stevearc/dressing.nvim',
        event = "VeryLazy",
        config = function()
            require("dressing").setup {
                input = {
                    win_options = {
                        winhighlight = require('ofirkai.plugins.dressing').winhighlight,
                    },
                    relative = "editor"
                },
                select = {
                    backend = { "fzf", "telescope", "builtin" },
                },
            }
        end,
    },
    {
        'nvim-telescope/telescope-media-files.nvim',
        dependencies = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
        config = function()
            require('telescope').load_extension('media_files')
        end
    },
    {
        'nvim-telescope/telescope-symbols.nvim',
        dependencies = { 'nvim-telescope/telescope.nvim' }
    },
    {
        'nvim-telescope/telescope-bibtex.nvim',
        dependencies = { 'nvim-telescope/telescope.nvim' },
        config = function()
            require "telescope".load_extension("bibtex")
        end
    }
}
