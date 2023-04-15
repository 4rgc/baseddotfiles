return {
    'akinsho/bufferline.nvim',
    version = 'v3.*',
    dependencies = { 'nvim-tree/nvim-web-devicons', 'ofirgall/ofirkai.nvim' },
    config = function()
        require('bufferline').setup {
            highlights = require('ofirkai.tablines.bufferline').highlights, -- Must
            options = {
                                                                      -- Optional, recommended
                themable = true,                                      -- Must
                separator_style = 'slant',
                offsets = { { filetype = 'NvimTree', text = 'File Explorer', text_align = 'center' } },
                show_buffer_icons = true,
                numbers = 'ordinal',
                max_name_length = 40,
            },
        }
    end
}
