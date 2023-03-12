vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- setup monokai theme
require('ofirkai').setup {}

-- empty setup using defaults
require("nvim-tree").setup()

local navic = require('nvim-navic')
navic.setup {
    separator = "  "
}

require("lspconfig").clangd.setup {
    on_attach = function(client, bufnr)
        navic.attach(client, bufnr)
    end
}

local ofirkai_lualine = require('ofirkai.statuslines.lualine')
local winbar = {
	lualine_a = {},
	lualine_b = {
		{
			'filename',
			icon = '',
			color = ofirkai_lualine.winbar_color,
			padding = { left = 4 }
		},
	},
	lualine_c = {
		{
			navic.get_location,
			icon = "",
			cond = navic.is_available,
			color = ofirkai_lualine.winbar_color,
		},
	},
	lualine_x = {},
	lualine_y = {},
	lualine_z = {}
}

-- setup lualine
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = require('ofirkai.statuslines.lualine').theme,
    disabled_filetypes = { -- Recommended filetypes to disable winbar
			winbar = { 'gitcommit', 'NvimTree', 'toggleterm', 'fugitive' },
	},
  },
  winbar = winbar,
  inactive_winbar = winbar
}

-- setup bufferline
require("bufferline").setup{
    highlights = require('ofirkai.tablines.bufferline').highlights, -- Must
	options = { -- Optional, recommended
		themable = true, -- Must
		separator_style = 'slant',
		offsets = { { filetype = 'NvimTree', text = 'File Explorer', text_align = 'center' } },
		show_buffer_icons = true,
		numbers = 'ordinal',
		max_name_length = 40,
	},
}

-- setup possession
require('possession').setup {
    commands = {
        save = 'SSave',
        load = 'SLoad',
        delete = 'SDelete',
        list = 'SList',
    }
}

-- setup telescope
require('telescope').setup({
  extensions = {
    coc = {
      prefer_locations = true
    }
  }
})

-- setup telescope with possession
require('telescope').load_extension('possession')

-- setup telescope with coc
require('telescope').load_extension('coc')

-- setup treesitter
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  rainbow = {
      enable = true,
      extended_mode = false
  },
  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@condition.outer",
        ["ic"] = "@condition.inner",
        -- You can optionally set descriptions to the mappings (used in the desc parameter of
        -- nvim_buf_set_keymap) which plugins like which-key display
        -- You can also use captures from other query groups like `locals.scm`
        ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
      },
      -- You can choose the select mode (default is charwise 'v')
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * method: eg 'v' or 'o'
      -- and should return the mode ('v', 'V', or '<c-v>') or a table
      -- mapping query_strings to modes.
      selection_modes = {
        ['@parameter.outer'] = 'v', -- charwise
        ['@function.outer'] = 'V', -- linewise
        ['@class.outer'] = '<c-v>', -- blockwise
      },
      -- If you set this to `true` (default is `false`) then any textobject is
      -- extended to include preceding or succeeding whitespace. Succeeding
      -- whitespace has priority in order to act similarly to eg the built-in
      -- `ap`.
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * selection_mode: eg 'v'
      -- and should return true of false
      include_surrounding_whitespace = true,
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = { query = "@class.outer", desc = "Next class start" },
        --
        -- You can use regex matching and/or pass a list in a "query" key to group multiple queires.
        ["]o"] = "@loop.*",
        -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
        --
        -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
        -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
        ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
        ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
      -- Below will go to either the start or the end, whichever is closer.
      -- Use if you want more granular movements
      -- Make it even more gradual by adding multiple queries and regex.
      goto_next = {
        ["]d"] = "@conditional.outer",
      },
      goto_previous = {
        ["[d"] = "@conditional.outer",
      }
    },
    lsp_interop = {
      enable = true,
      border = 'none',
      floating_preview_opts = {},
      peek_definition_code = {
        ["<leader>df"] = "@function.outer",
        ["<leader>dF"] = "@class.outer",
      },
    },
  },
}

-- configure lsp_signature
local lsp_signature_cfg = {
	bind = true,
	use_lspsaga = false,
	doc_lines = 0,
	floating_window = false,
	hint_scheme = 'LspSignatureHintVirtualText',
	hint_prefix = ' ',
}
require "lsp_signature".setup(lsp_signature_cfg)

-- configure devicons
require'nvim-web-devicons'.setup {
    color_icons = true;
}

-- mkdnflow setup
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
-- SETUP END --

-- ----------MAPPINGS----------
-- ----------------------------

-- helper methods --
local function map(mode, lhs, rhs, desc, opts)
  opts = opts or { silent = true }
  opts.desc = desc
  vim.keymap.set(mode, lhs, rhs, opts)
end

local getFType = function () return vim.bo.filetype end

function MappingWithFType(ftype, action)
    return function ()
        if getFType() == ftype
        then
            action()
        else
            print('Not a ' .. ftype .. ' file')
        end
    end
end

function GetCursorPos ()
    return unpack(vim.api.nvim_win_get_cursor(0))
end

function InsertLineAtCursor (line)
    local row, col = GetCursorPos()
    vim.api.nvim_buf_set_text(0, row-1, col, row-1, col, {line})
end

-- map markdown preview
map('n', '<leader>mp', MappingWithFType(
    'markdown',
    function () vim.cmd('CocCommand markdown-preview-enhanced.openPreview')end
  ),
  'Open Markdown Preview'
)

-- map nvimtree
map('n', '<leader>tt', '<Cmd>NvimTreeToggle<CR>')

