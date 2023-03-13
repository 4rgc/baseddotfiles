return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'ofirgall/ofirkai.nvim', 'SmiteshP/nvim-navic' },
  config = function ()
    local navic = require('nvim-navic')
    local ofirkai_lualine = require('ofirkai.statuslines.lualine')
    local winbar = {
      lualine_a = {},
      lualine_b = {
        {
          'filename',
          icon = '',
          color = ofirkai_lualine.winbar_color,
          padding = { left = 4 }
        },
      },
      lualine_c = {
        {
          navic.get_location,
          icon = "",
          cond = navic.is_available,
          color = ofirkai_lualine.winbar_color,
        },
      },
      lualine_x = {},
      lualine_y = {},
      lualine_z = {}
    }
    require('lualine').setup {
      options = {
        icons_enabled = true,
        theme = require('ofirkai.statuslines.lualine').theme,
        disabled_filetypes = { -- Recommended filetypes to disable winbar
            winbar = { 'gitcommit', 'NvimTree', 'toggleterm', 'fugitive' },
        },
      },
      winbar = winbar,
      inactive_winbar = winbar
    }
  end
}
