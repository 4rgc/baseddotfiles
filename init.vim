" this will install vim-plug if not installed
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif
    
call plug#begin()
  Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'} " this is for auto complete, prettier and tslinting

  let g:coc_global_extensions = ['coc-tslint-plugin', 'coc-tsserver', 'coc-css', 'coc-html', 'coc-json', 'coc-prettier']  " list of CoC extensions needed

  Plug 'jiangmiao/auto-pairs' "this will auto close ( [ {

  " these two plugins will add highlighting and indenting to JSX and TSX files.
  Plug 'maxmellon/vim-jsx-pretty' 
  Plug 'nvim-tree/nvim-web-devicons' " optional, for file icons
  Plug 'nvim-tree/nvim-tree.lua'
  Plug 'nvim-lualine/lualine.nvim'
  Plug 'akinsho/bufferline.nvim', { 'tag': 'v3.*' }
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'nvim-lua/plenary.nvim'
  Plug 'jedrzejboczar/possession.nvim'
  Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.1' }
  Plug 'ofirgall/ofirkai.nvim'
  Plug 'p00f/nvim-ts-rainbow'
  Plug 'nvim-treesitter/nvim-treesitter'
  Plug 'nvim-treesitter/nvim-treesitter-context'
  Plug 'nvim-treesitter/nvim-treesitter-textobjects'
  Plug 'neovim/nvim-lspconfig'
  Plug 'SmiteshP/nvim-navic'
  Plug 'ray-x/lsp_signature.nvim'
  Plug 'sindrets/diffview.nvim'
  Plug 'tpope/vim-fugitive'
  Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
  Plug 'jakewvincent/mkdnflow.nvim'
  Plug 'fannheyward/telescope-coc.nvim'
  Plug 'kylechui/nvim-surround'
  Plug 'lewis6991/gitsigns.nvim'
call plug#end()

lua require('config')

set relativenumber
set tabstop=2
set shiftwidth=2
set expandtab
set textwidth=80

" mappings
  " close buffer
  nnoremap <silent> <leader>Bc :bp<bar>sp<bar>bn<bar>bd<CR>
  " goto open buffer number
  nnoremap <silent><leader>1 <Cmd>BufferLineGoToBuffer 1<CR>
  nnoremap <silent><leader>2 <Cmd>BufferLineGoToBuffer 2<CR>
  nnoremap <silent><leader>3 <Cmd>BufferLineGoToBuffer 3<CR>
  nnoremap <silent><leader>4 <Cmd>BufferLineGoToBuffer 4<CR>
  nnoremap <silent><leader>5 <Cmd>BufferLineGoToBuffer 5<CR>
  nnoremap <silent><leader>6 <Cmd>BufferLineGoToBuffer 6<CR>
  nnoremap <silent><leader>7 <Cmd>BufferLineGoToBuffer 7<CR>
  nnoremap <silent><leader>8 <Cmd>BufferLineGoToBuffer 8<CR>
  nnoremap <silent><leader>9 <Cmd>BufferLineGoToBuffer 9<CR>
  nnoremap <silent><leader>$ <Cmd>BufferLineGoToBuffer -1<CR>
  nnoremap <leader>ff <cmd>Telescope find_files<cr>
  nnoremap <leader>fg <cmd>Telescope live_grep<cr>
  nnoremap <leader>fb <cmd>Telescope buffers<cr>
  nnoremap <leader>fh <cmd>Telescope help_tags<cr>
  nnoremap <leader>gs <cmd>:G<CR>
  nnoremap <leader>gd <cmd>DiffviewOpen<CR>
  nnoremap <leader>gS <cmd>DiffviewOpen HEAD^..HEAD<CR>
  nnoremap <leader>gc <cmd>Telescope git_branches<CR>
  nnoremap <leader>gh <cmd>DiffviewFileHistory %<CR>
  nnoremap <leader>gH <cmd>DiffviewFileHistory .<CR>
  nnoremap <leader>gp <cmd>Git push<CR>
  " coc autocomplete
  
  " Use tab for trigger completion with characters ahead and navigate
  " NOTE: There's always complete item selected by default, you may want to enable
  " no select by `"suggest.noselect": true` in your configuration file
  " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
  " other plugin before putting this into your config
  inoremap <silent><expr> <TAB>
        \ coc#pum#visible() ? coc#pum#next(1) :
        \ CheckBackspace() ? "\<Tab>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
