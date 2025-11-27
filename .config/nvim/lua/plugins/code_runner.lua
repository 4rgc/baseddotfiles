return {
    {
        'CRAG666/code_runner.nvim',
        cmd = { "CodeRunner", "RunCode" },
        dependencies = {
            'nvim-lua/plenary.nvim'
        },
        config = function()
            require('code_runner').setup {
                focus = false,
                filetype = {
                    python = 'python -u',
                    elixir = 'elixir',
                }
            }
        end
    }
}
