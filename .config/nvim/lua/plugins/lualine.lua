return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'ofirgall/ofirkai.nvim', 'SmiteshP/nvim-navic' },
    config = function()
        local navic = require('nvim-navic')
        -- local ofirkai_lualine = require('ofirkai.statuslines.lualine')

        -- Bottom line (statusline)
        local sections = {
            lualine_x = {
                {
                    require("noice").api.status.message.get_hl,
                    cond = require("noice").api.status.message.has,
                },
                '%S',
                {
                    require("noice").api.status.mode.get,
                    cond = require("noice").api.status.mode.has,
                    -- color = { fg = "#ff9e64" },
                },
                {
                    require("noice").api.status.search.get,
                    cond = require("noice").api.status.search.has,
                    -- color = { fg = "#ff9e64" },
                },
            }
        }

        -- Top filename line (winbar)
        local winbar = {
            lualine_a = {},
            lualine_b = {
                {
                    'filename',
                    icon = '',
                    -- color = ofirkai_lualine.winbar_color,
                    padding = { left = 4 },
                },
            },
            lualine_c = {
                {
                    function()
                        return ( navic.get_location() ~= "" and " " or "" ) .. navic.get_location()
                    end,
                    cond = function()
                        return navic.is_available()
                    end,
                    -- color = ofirkai_lualine.winbar_color,
                },
            },
            lualine_x = {},
            lualine_y = {},
            lualine_z = {}
        }

        require('lualine').setup {
            options = {
                icons_enabled = true,
                -- theme = require('ofirkai.statuslines.lualine').theme,
                theme = 'pywal16-nvim',
                disabled_filetypes = { -- Recommended filetypes to disable winbar
                    winbar = { 'gitcommit', 'NvimTree', 'toggleterm', 'fugitive', 'dapui_console', 'dap-repl', 'dapui_scopes', 'dapui_breakpoints', 'dapui_stacks', 'dapui_watches' },
                },
            },
            winbar = winbar,
            inactive_winbar = winbar,
            sections = sections
        }
    end
}
