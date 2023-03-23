return {
  {
    'nvim-telescope/telescope.nvim',
    version = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim', 'jedrzejboczar/possession.nvim' },
    config = function ()
      require('telescope').setup({
        extensions = {
          coc = {
            prefer_locations = true
          }
        }
      })
      require('telescope').load_extension('possession')
    end,
  },
  {
    'stevearc/dressing.nvim',
    event = "BufReadPre",
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
  }
}
