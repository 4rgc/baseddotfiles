return {
    {
        'nvim-telescope/telescope.nvim',
        version = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim', 'jedrzejboczar/possession.nvim' },
        config = function()
            require('telescope').setup({
                extensions = {
                    media_files = {
                      find_cmd = "rg"
                    }
                }
            })
            require('telescope').load_extension('possession')
        end,
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
                    backend = { "telescope", "fzf", "builtin" },
                },
            }
        end,
    },
    {
        'nvim-telescope/telescope-media-files.nvim',
        dependencies = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
        config = function ()
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
        config = function ()
            require"telescope".load_extension("bibtex")
        end
    }
}
