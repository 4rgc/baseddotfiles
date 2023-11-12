local map = require('util').map

-- helper methods --

local getFType = function() return vim.bo.filetype end

local function anyStrOrStrArr(strOrStrArrValue, strValue, predicate)
    if type(strOrStrArrValue) == "string" then
        return predicate(strOrStrArrValue, strValue)
    elseif type(strOrStrArrValue) == "table" then
        for _, v in ipairs(strOrStrArrValue) do
            if predicate(v, strValue) then
                return true
            end
        end
    end
    return false
end

function MappingWithFType(ftype, action)
    return function()
        if anyStrOrStrArr(ftype, getFType(), function(str1, str2) return str1 == str2 end)
        then
            action()
        else
            print('Not a ' .. ftype .. ' file')
        end
    end
end

-- map markdown preview
map('n', '<leader>mp', MappingWithFType(
        { 'markdown', 'telekasten' },
        function() vim.cmd('MarkdownPreviewToggle') end
    ),
    'Open Markdown Preview'
)

-- map nvimtree
map('n', '<leader>tt', '<Cmd>NvimTreeToggle<CR>')

-- map close buffer
map('n', '<leader>q', ':bp<bar>sp<bar>bn<bar>bd<CR>')

-- map goto buffer number
map('n', '<leader>1', '<Cmd>BufferLineGoToBuffer 1<CR>')
map('n', '<leader>2', '<Cmd>BufferLineGoToBuffer 2<CR>')
map('n', '<leader>3', '<Cmd>BufferLineGoToBuffer 3<CR>')
map('n', '<leader>4', '<Cmd>BufferLineGoToBuffer 4<CR>')
map('n', '<leader>5', '<Cmd>BufferLineGoToBuffer 5<CR>')
map('n', '<leader>6', '<Cmd>BufferLineGoToBuffer 6<CR>')
map('n', '<leader>7', '<Cmd>BufferLineGoToBuffer 7<CR>')
map('n', '<leader>8', '<Cmd>BufferLineGoToBuffer 8<CR>')
map('n', '<leader>9', '<Cmd>BufferLineGoToBuffer 9<CR>')
map('n', '<leader>$', '<Cmd>BufferLineGoToBuffer -1<CR>')

-- Telescope mappings
map('n', '<leader>ff', '<cmd>Telescope git_files<cr>')
map('n', '<leader>fa', '<cmd>Telescope find_files find_command=rg,--no-ignore-vcs,--hidden,--files<cr>')
map('n', '<leader>fg', '<cmd>Telescope live_grep<cr>')
map('n', '<leader>fb', '<cmd>Telescope buffers<cr>')
map('n', '<leader>fh', '<cmd>Telescope help_tags<cr>')
map('n', '<leader>fm', '<cmd>Telescope media_files<cr>')
map('n', '<leader>fs', '<cmd>Telescope symbols<cr>')
map('n', '<leader>fb', '<cmd>Telescope bibtex<cr>')

-- git mappings
map('n', '<leader>gs', '<cmd>:G<CR>')
map('n', '<leader>gd', '<cmd>DiffviewOpen<CR>')
map('n', '<leader>gC', '<cmd>DiffviewClose<CR>')
map('n', '<leader>gS', '<cmd>DiffviewOpen HEAD^..HEAD<CR>')
map('n', '<leader>gc', '<cmd>Telescope git_branches<CR>')
map('n', '<leader>gh', '<cmd>DiffviewFileHistory %<CR>')
map('n', '<leader>gH', '<cmd>DiffviewFileHistory .<CR>')
map('n', '<leader>gp', '<cmd>Git push<CR>')

-- lsp mappings
local opts = { noremap = true, silent = true }
map('n', '<space>e', vim.diagnostic.open_float, 'Open float', opts)
map('n', '[d', vim.diagnostic.goto_prev, 'Go to next', opts)
map('n', ']d', vim.diagnostic.goto_next, 'Go to previous', opts)
map('n', '<space>q', vim.diagnostic.setloclist, 'Set loclist', opts)

map("n", "<C-p>", "<cmd>lua require('legendary').find()<CR>", 'Open Legendary')

-- Markdown mappings
map({ 'n', 'v' }, '<C-l>', MappingWithFType('markdown', function() vim.cmd('MkdnCreateLink') end),
    'Create markdown hyperlink')

-- db mappings
map('n', '<leader>du', '<Cmd>DBUIToggle<CR>', 'Toggle DB UI')
map('n', '<leader>db', '<Cmd>DBUIFindBuffer<CR>', 'Find DB UI Buffer')
map('n', '<leader>dl', '<Cmd>DBUILastQueryInfo<CR>', 'Last query info')

-- code_runner mappings
map('n', '<F7>', '<Cmd>RunCode<CR>', 'Run current file')

-- Trouble mappings
map("n", "<space>xx", "<cmd>TroubleToggle<cr>", 'Toggle trouble',
    { silent = true, noremap = true }
)
map("n", "<space>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", 'Toggle trouble from workspace diagnostics',
    { silent = true, noremap = true }
)
map("n", "<space>xd", "<cmd>TroubleToggle document_diagnostics<cr>", 'Toggle trouble from document diagnostics',
    { silent = true, noremap = true }
)
map("n", "<space>xl", "<cmd>TroubleToggle loclist<cr>", 'Toggle trouble from loclist',
    { silent = true, noremap = true }
)
map("n", "<space>xq", "<cmd>TroubleToggle quickfix<cr>", 'Toggle trouble quickfix items',
    { silent = true, noremap = true }
)
map("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", 'Toggle trouble from references',
    { silent = true, noremap = true }
)

-- Zettelkasten mappings
-- Most used functions
map("n", "<leader>zf", function()
    require('telekasten').search_notes({ with_live_grep = true })
end, 'Find notes')
map("n", "<leader>zg", "<cmd>Telekasten search_notes<CR>", 'Search notes')
map("n", "<leader>zd", "<cmd>Telekasten goto_today<CR>", 'Go to today')
map("n", "<leader>zz", "<cmd>Telekasten follow_link<CR>", 'Follow link')
map("n", "<leader>zn", "<cmd>Telekasten new_note<CR>", 'Create new note')
map("n", "<leader>zc", "<cmd>Telekasten show_calendar<CR>", 'Show calendar')
map("n", "<leader>zb", "<cmd>Telekasten show_backlinks<CR>", 'Show backlinks')
map("n", "<leader>zI", "<cmd>Telekasten insert_img_link<CR>", 'Insert image link')

-- Neotest mappings
map("n", "<space>tt", "<cmd>Neotest run<CR>", 'Test nearest')
map("n", "<space>tf", "<cmd>Neotest run file<CR>", 'Test file')
map("n", "<space>to", "<cmd>Neotest output<CR>", 'View test output')
map("n", "<space>ts", "<cmd>Neotest summary<CR>", 'Toggle test summary')
map("n", "<space>tj", "<cmd>Neotest jump next<CR>", 'Jump to next test')
map("n", "<space>tk", "<cmd>Neotest jump prev<CR>", 'Jump to previous test')

-- Dap mappings 
map('n', '<F5>', function() require('dap').continue() end, 'Continue')
map('n', '<F10>', function() require('dap').step_over() end, 'Step over')
map('n', '<F11>', function() require('dap').step_into() end, 'Step into')
map('n', '<F12>', function() require('dap').step_out() end, 'Step out')
map('n', '<Leader>b', function() require('dap').toggle_breakpoint() end, 'Toggle breakpoint')
map('n', '<Leader>B', function() require('dap').set_breakpoint() end, 'Set breakpoint')
map('n', '<Leader>lp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, 'Log point')
map('n', '<Leader>dr', function() require('dap').repl.open() end, 'Open REPL')
map('n', '<Leader>dd', function() require('dap').run_last() end, 'Run last')
map({'n', 'v'}, '<Leader>dh', function()
  require('dap.ui.widgets').hover()
end, 'Hover')
map({'n', 'v'}, '<Leader>dp', function()
  require('dap.ui.widgets').preview()
end, 'Preview')
map('n', '<Leader>df', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.frames)
end, 'Frames')
map('n', '<Leader>ds', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.scopes)
end, 'Scopes')
map('n', '<leader>dt', function()
    require('dapui').toggle()
end, 'Variables')
