return {
  {
    'nvim-telescope/telescope.nvim',
    version = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim', 'jedrzejboczar/possession.nvim', 'fannheyward/telescope-coc.nvim' },
    config = function ()
      require('telescope').setup({
        extensions = {
          coc = {
            prefer_locations = true
          }
        }
      })
      require('telescope').load_extension('possession')
      require('telescope').load_extension('coc')

    end,
  },
  {
    'stevearc/dressing.nvim',
    event = "BufReadPre",
    config = function()
      require("dressing").setup {
        input = { relative = "editor" },
        select = {
          backend = { "telescope", "fzf", "builtin" },
        },
      }
    end,
  }
}
