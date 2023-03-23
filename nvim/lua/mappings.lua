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

-- autocomplete mapping
function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

local autocmp_opts = {noremap = true, expr = true, replace_keycodes = false}
map("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', 'Autocomplete next', autocmp_opts)
map("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], 'Autocomplete prev', autocmp_opts)
map("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], 'Autocomplete select', autocmp_opts)

-- Use <c-j> to trigger snippets
map("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")
-- Use <c-space> to trigger completion
map("i", "<c-space>", "coc#refresh()", 'Autocomplete', {expr = true})

-- Use `[g` and `]g` to navigate diagnostics
-- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
map("n", "[g", "<Plug>(coc-diagnostic-prev)", 'Previous diagnostic')
map("n", "]g", "<Plug>(coc-diagnostic-next)", 'Next diagnostic')

-- GoTo code navigation
map("n", "gd", "<Plug>(coc-definition)", 'Go to definition')
map("n", "gy", "<Plug>(coc-type-definition)", 'Go to type definition')
map("n", "gi", "<Plug>(coc-implementation)", 'Go to implementation')
map("n", "gr", "<Plug>(coc-references)", 'References')

-- Symbol renaming
map("n", "<leader>rn", "<Plug>(coc-rename)", 'Rename')

-- Formatting selected code
map("x", "<leader>f", "<Plug>(coc-format-selected)", 'Format selected')
map("n", "<leader>f", "<Plug>(coc-format-selected)", 'Format selected')

-- Use K to show documentation in preview window
function _G.show_docs()
    local cw = vim.fn.expand('<cword>')
    if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
        vim.api.nvim_command('h ' .. cw)
    elseif vim.api.nvim_eval('coc#rpc#ready()') then
        vim.fn.CocActionAsync('doHover')
    else
        vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
    end
end
map("n", "K", '<CMD>lua _G.show_docs()<CR>', 'Show docs')

-- Apply codeAction to the selected region
-- Example: `<leader>aap` for current paragraph
local ca_opts = {nowait = true}
map('x', '<leader>a', '<Plug>(coc-codeaction-selected)', 'Apply codeaction', ca_opts)
map('n', '<leader>a', '<Plug>(coc-codeaction-selected)', 'Apply codeaction', ca_opts)

-- Remap keys for apply code actions at the cursor position.
map('n', '<leader>ac', '<Plug>(coc-codeaction-cursor)', 'Apply codeaction at cursor', ca_opts)
-- Remap keys for apply code actions affect whole buffer.
map('n', '<leader>as', '<Plug>(coc-codeaction-source)', 'Apply codeaction for source', ca_opts)
-- Remap keys for applying codeActions to the current buffer
map('n', '<leader>ac', '<Plug>(coc-codeaction)', 'Apply codeaction to current buffer', ca_opts)
-- Apply the most preferred quickfix action on the current line.
map('n', '<leader>qf', '<Plug>(coc-fix-current)', 'Fix current', ca_opts)

-- Remap keys for apply refactor code actions.
map('n', '<leader>re', '<Plug>(coc-codeaction-refactor)', 'Refactor')
map('x', '<leader>r', '<Plug>(coc-codeaction-refactor-selected)', 'Refactor')
map('n', '<leader>r', '<Plug>(coc-codeaction-refactor-selected)', 'Refactor')

-- Run the Code Lens actions on the current line
map('n', '<leader>cl', '<Plug>(coc-codelens-action)', 'Run Code Lens on current line', ca_opts)

-- Remap <C-f> and <C-b> to scroll float windows/popups
---@diagnostic disable-next-line: redefined-local
local scroll_opts = { nowait = true, expr = true }
map('n', '<C-f>', 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', scroll_opts)
map('n', '<C-b>', 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', scroll_opts)
map('i', '<C-f>',
  'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', scroll_opts)
map('i', '<C-b>',
  'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', scroll_opts)
map('v', '<C-f>', 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', scroll_opts)
map('v', '<C-b>', 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', scroll_opts)

-- Use CTRL-S for selections ranges
-- Requires 'textDocument/selectionRange' support of language server
map('n', '<C-s>', '<Plug>(coc-range-select)', 'Select range')
map('x', '<C-s>', '<Plug>(coc-range-select)', 'Select range')

-- Add `:Format` command to format current buffer
vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})

-- " Add `:Fold` command to fold current buffer
vim.api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)", {nargs = '?'})

-- Add `:OR` command for organize imports of the current buffer
vim.api.nvim_create_user_command("OR", "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})

-- Add (Neo)Vim's native statusline support
-- NOTE: Please see `:h coc-status` for integrations with external plugins that
-- provide custom statusline: lightline.vim, vim-airline
vim.opt.statusline:prepend("%{coc#status()}%{get(b:,'coc_current_function','')}")

-- Mappings for CoCList
-- code actions and coc stuff
---@diagnostic disable-next-line: redefined-local
local list_opts = {nowait = true}
-- Show all diagnostics
map('n', '<space>a', ':<C-u>CocList diagnostics<cr>', 'Show all diagnostics', list_opts)
-- Manage extensions
map('n', '<space>e', ':<C-u>CocList extensions<cr>', 'Manage extensions', list_opts)
-- Show commands
map('n', '<space>c', ':<C-u>CocList commands<cr>', 'Show commands', list_opts)
-- Find symbol of current document
map('n', '<space>o', ':<C-u>CocList outline<cr>', 'Find symbol of current document', list_opts)
-- Search workspace symbols
map('n', '<space>s', ':<C-u>CocList -I symbols<cr>', 'Search workspace symbols', list_opts)
-- Do default action for next item
map('n', '<space>j', ':<C-u>CocNext<cr>', 'Do default action for next item', list_opts)
-- Do default action for previous item
map('n', '<space>k', ':<C-u>CocPrev<cr>', 'Do default action for previous item', list_opts)
-- Resume latest coc list
map('n', '<space>p', ':<C-u>CocListResume<cr>', 'Resume latest coc list', list_opts)

map("n", "<C-p>", "<cmd>lua require('legendary').find()<CR>", 'Open Legendary')

-- Markdown mappings
map({ 'n', 'v' }, '<C-l>', MappingWithFType('markdown', function () vim.cmd('MkdnCreateLink') end), 'Create markdown hyperlink')
