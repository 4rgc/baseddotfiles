-- empty setup using defaults
require('nvim-tree').setup()

require('possession').setup {
    commands = {
        save = 'SSave',
        load = 'SLoad',
        delete = 'SDelete',
        list = 'SList',
    }
}

require('telescope').setup({
  extensions = {
    coc = {
      prefer_locations = true
    }
  }
})

require('telescope').load_extension('possession')

require('telescope').load_extension('coc')
require('mkdnflow').setup({
    mappings = {
        MkdnTableNextCell = {'i', '<F2>'},
        MkdnTablePrevCell = {'i', '<F3>'},
        MkdnFoldSection = {'n', '<leader>fs'},
        MkdnToggleToDo = {{'n', 'v'}, '<C-c>'}
    }
})

require('nvim-surround').setup()

require('gitsigns').setup()

require('legendary').setup{ include_builtin = true, auto_register_which_key = true }

