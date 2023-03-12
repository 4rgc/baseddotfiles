
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

-- map close buffer
map('n', '<leader>Bc', ':bp<bar>sp<bar>bn<bar>bd<CR>')

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

-- git mappings
map ( 'n', '<leader>ff', '<cmd>Telescope find_files<cr>' )
map ( 'n', '<leader>fg', '<cmd>Telescope live_grep<cr>' )
map ( 'n', '<leader>fb', '<cmd>Telescope buffers<cr>' )
map ( 'n', '<leader>fh', '<cmd>Telescope help_tags<cr>' )
map ( 'n', '<leader>gs', '<cmd>:G<CR>' )
map ( 'n', '<leader>gd', '<cmd>DiffviewOpen<CR>' )
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

local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
map("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', 'Autocomplete next', opts)
map("i", "<S-TAB>", [[coc#pum#visible() ?'{} coc#pum#prev(1) : "\<C-h>"]], 'Autocomplete prev', opts)
map("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], 'Autocomplete select', opts)

-- GoTo code navigation
map("n", "gd", "<Plug>(coc-definition)", 'Go to definition', {silent = true})
map("n", "gy", "<Plug>(coc-type-definition)", 'Go to type definition', {silent = true})
map("n", "gi", "<Plug>(coc-implementation)", 'Go to implementation', {silent = true})
map("n", "gr", "<Plug>(coc-references)", 'References', {silent = true})

-- Symbol renaming
map("n", "<leader>rn", "<Plug>(coc-rename)", 'Rename', {silent = true})


-- Formatting selected code
map("x", "<leader>f", "<Plug>(coc-format-selected)", 'Format selected', {silent = true})
map("n", "<leader>f", "<Plug>(coc-format-selected)", 'Format selected', {silent = true})

vim.api.nvim_create_augroup("CocGroup", {})

-- Setup formatexpr specified filetype(s)
vim.api.nvim_create_autocmd("FileType", {
    group = "CocGroup",
    pattern = "typescript,json",
    command = "setl formatexpr=CocAction('formatSelected')",
    desc = "Setup formatexpr specified filetype(s)."
})

-- Update signature help on jump placeholder
vim.api.nvim_create_autocmd("User", {
    group = "CocGroup",
    pattern = "CocJumpPlaceholder",
    command = "call CocActionAsync('showSignatureHelp')",
    desc = "Update signature help on jump placeholder"
})

vim.api.nvim_create_autocmd("CursorHold", {
    group = "CocGroup",
    command = "silent call CocActionAsync('highlight')",
    desc = "Highlight symbol under cursor on CursorHold"
})
