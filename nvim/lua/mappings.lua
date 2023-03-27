local map = require('util').map

-- helper methods --

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

-- map markdown preview
map('n', '<leader>mp', MappingWithFType(
    'markdown',
    function () vim.cmd('MarkdownPreviewToggle')end
  ),
  'Open Markdown Preview'
)

-- map nvimtree
map('n', '<leader>tt', '<Cmd>NvimTreeToggle<CR>')

-- map close buffer
map('n', '<leader>q', ':bp<bar>sp<bar>bn<bar>bd<CR>')

-- map goto buffer number
map ('n', '<leader>1', '<Cmd>BufferLineGoToBuffer 1<CR>'  )
map ('n', '<leader>2', '<Cmd>BufferLineGoToBuffer 2<CR>'  )
map ('n', '<leader>3', '<Cmd>BufferLineGoToBuffer 3<CR>'  )
map ('n', '<leader>4', '<Cmd>BufferLineGoToBuffer 4<CR>'  )
map ('n', '<leader>5', '<Cmd>BufferLineGoToBuffer 5<CR>'  )
map ('n', '<leader>6', '<Cmd>BufferLineGoToBuffer 6<CR>'  )
map ('n', '<leader>7', '<Cmd>BufferLineGoToBuffer 7<CR>'  )
map ('n', '<leader>8', '<Cmd>BufferLineGoToBuffer 8<CR>'  )
map ('n', '<leader>9', '<Cmd>BufferLineGoToBuffer 9<CR>'  )
map ('n', '<leader>$', '<Cmd>BufferLineGoToBuffer -1<CR>' )

-- Telescope mappings
map ( 'n', '<leader>ff', '<cmd>Telescope git_files<cr>' )
map ( 'n', '<leader>fa', '<cmd>Telescope find_files find_command=rg,--no-ignore-vcs,--hidden,--files<cr>' )
map ( 'n', '<leader>fg', '<cmd>Telescope live_grep<cr>' )
map ( 'n', '<leader>fb', '<cmd>Telescope buffers<cr>' )
map ( 'n', '<leader>fh', '<cmd>Telescope help_tags<cr>' )

-- git mappings
map ( 'n', '<leader>gs', '<cmd>:G<CR>' )
map ( 'n', '<leader>gd', '<cmd>DiffviewOpen<CR>' )
map ( 'n', '<leader>gC', '<cmd>DiffviewClose<CR>' )
map ( 'n', '<leader>gS', '<cmd>DiffviewOpen HEAD^..HEAD<CR>' )
map ( 'n', '<leader>gc', '<cmd>Telescope git_branches<CR>' )
map ( 'n', '<leader>gh', '<cmd>DiffviewFileHistory %<CR>' )
map ( 'n', '<leader>gH', '<cmd>DiffviewFileHistory .<CR>' )
map ( 'n', '<leader>gp', '<cmd>Git push<CR>' )

-- lsp mappings
local opts = { noremap=true, silent=true }
map('n', '<space>e', vim.diagnostic.open_float, 'Open float', opts)
map('n', '[d', vim.diagnostic.goto_prev, 'Go to next', opts)
map('n', ']d', vim.diagnostic.goto_next, 'Go to previous', opts)
map('n', '<space>q', vim.diagnostic.setloclist, 'Set loclist', opts)

map("n", "<C-p>", "<cmd>lua require('legendary').find()<CR>", 'Open Legendary')

-- Markdown mappings
map({ 'n', 'v' }, '<C-l>', MappingWithFType('markdown', function () vim.cmd('MkdnCreateLink') end), 'Create markdown hyperlink')

-- db mappings
map('n', '<leader>du', '<Cmd>DBUIToggle<CR>', 'Toggle DB UI')
map('n', '<leader>db', '<Cmd>DBUIFindBuffer<CR>', 'Find DB UI Buffer')
map('n', '<leader>dl', '<Cmd>DBUILastQueryInfo<CR>', 'Last query info')
