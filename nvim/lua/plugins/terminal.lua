return {
    {
        'akinsho/toggleterm.nvim',
        version = "*",
        opts = {
            size = '15',
            direction = 'horizontal',
            close_on_exit = true,
        },
        config = function()
            require('toggleterm').setup {
                open_mapping = [[<c-\>]]
            }
        end
    }
}
