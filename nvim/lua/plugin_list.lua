-- Autosetup packer on system

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  -- My plugins here

  use {'neoclide/coc.nvim', branch = 'release'}

  vim.g.coc_global_extensions = {
    'coc-tslint-plugin',
    'coc-tsserver',
    'coc-css',
    'coc-html',
    'coc-json',
    'coc-prettier',
    'friendly-snippets',
    'coc-webview',
    'coc-lua',
    'coc-markdown-preview-enhanced'
  }

  use {'jiangmiao/auto-pairs'}

  use {'maxmellon/vim-jsx-pretty'}

  use 'nvim-tree/nvim-web-devicons'

  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    }
  }

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }

  use {'akinsho/bufferline.nvim', tag = "v3.*", requires = 'nvim-tree/nvim-web-devicons'}

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  use 'nvim-lua/plenary.nvim'

  use {
    'jedrzejboczar/possession.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
  }

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.x',
  -- or                            , branch = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use {
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
    disable = false
  }

  use 'ofirgall/ofirkai.nvim'

  use 'p00f/nvim-ts-rainbow'

  use 'nvim-treesitter/nvim-treesitter-context'

  use({
    "nvim-treesitter/nvim-treesitter-textobjects",
    after = "nvim-treesitter",
    requires = "nvim-treesitter/nvim-treesitter",
  })

  use 'neovim/nvim-lspconfig' -- Configurations for Nvim LSP

  use {
    "SmiteshP/nvim-navic",
    requires = "neovim/nvim-lspconfig"
  }

  use 'ray-x/lsp_signature.nvim'

  use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }

  use 'tpope/vim-fugitive'

  use({'jakewvincent/mkdnflow.nvim',
    rocks = 'luautf8', -- Ensures optional luautf8 dependency is installed
  })

  use 'fannheyward/telescope-coc.nvim'

  use({
    'kylechui/nvim-surround',
    tag = "*",
  })

  use 'lewis6991/gitsigns.nvim'

  use({
    'mrjones2014/legendary.nvim',
    -- sqlite is only needed if you want to use frecency sorting
    -- requires = 'kkharji/sqlite.lua'
  })

  use 'folke/which-key.nvim'

  -- Must keep at the end to ensure packer bootstrap on new machines
  if packer_bootstrap then
    require('packer').sync()
  end
end)
