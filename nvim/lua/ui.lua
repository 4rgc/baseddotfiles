-- UI related setup

-- setup monokai theme
require('ofirkai').setup()

-- current cursor location plugin
local navic = require('nvim-navic')
navic.setup {
    separator = "  "
}

-- feed current file location to lualine below tabs
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

-- line below tabs
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

-- tabline
require('bufferline').setup{
    highlights = require('ofirkai.tablines.bufferline').highlights, -- Must
	options = { -- Optional, recommended
		themable = true, -- Must
		separator_style = 'slant',
		offsets = { { filetype = 'NvimTree', text = 'File Explorer', text_align = 'center' } },
		show_buffer_icons = true,
		numbers = 'ordinal',
		max_name_length = 40,
	},
}

require('nvim-web-devicons').setup {
    color_icons = true;
}

