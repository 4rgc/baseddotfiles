return {
  {
    'CRAG666/code_runner.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    config = function ()
      require('code_runner').setup {
        focus = false,
        filetype = {
          python = 'python -u',
        }
      }
    end
  }
}
