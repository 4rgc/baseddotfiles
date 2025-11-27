package.path = package.path .. ';../?.lua'
local map = require('util').map

return {
  {
    'tpope/vim-dadbod',
    lazy = true,
  },
  {
    'kristijanhusak/vim-dadbod-ui',
    lazy = true,
  }
}
