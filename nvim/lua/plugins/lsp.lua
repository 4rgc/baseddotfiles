package.path = package.path .. ';../?.lua'
local map = require('util').map
local mason_servers = require('util').mason_servers

local formattingAugrp = vim.api.nvim_create_augroup("LspFormatting", {})

local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    map('n', 'gD', vim.lsp.buf.declaration, 'Go to declaration', bufopts)
    map('n', 'gd', vim.lsp.buf.definition, 'Go to definition', bufopts)
    map('n', 'K', vim.lsp.buf.hover, 'Show documentation', bufopts)
    map('n', 'gi', vim.lsp.buf.implementation, 'Go to implementation', bufopts)
    map('n', '<C-k>', vim.lsp.buf.signature_help, 'Show signature', bufopts)
    map('n', '<space>wa', vim.lsp.buf.add_workspace_folder, 'Add workspace folder', bufopts)
    map('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, 'Remove workspace folder', bufopts)
    map('n', '<space>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, 'List workspace folders', bufopts)
    map('n', '<space>D', vim.lsp.buf.type_definition, 'Type definition', bufopts)
    map('n', '<space>rn', vim.lsp.buf.rename, 'Rename', bufopts)
    map('n', '<space>ca', vim.lsp.buf.code_action, 'Code action', bufopts)
    map('n', 'gr', vim.lsp.buf.references, 'Show references', bufopts)
    map('n', '<space>f', function() vim.lsp.buf.format { async = true } end, 'Format', bufopts)

    if client.supports_method("textDocument/formatting") then
        vim.api.nvim_clear_autocmds({ group = formattingAugrp, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = formattingAugrp,
            buffer = bufnr,
            callback = function(args)
                local file = args.file
                if not string.find(file, '.*md$') then
                    vim.lsp.buf.format()
                end
            end,
        })
    end
end

return {
    { 'SmiteshP/nvim-navic', dependencies = { 'neovim/nvim-lspconfig' } },
    {
        'ray-x/lsp_signature.nvim',
        config = function()
            local lsp_signature_cfg = {
                bind = true,
                use_lspsaga = false,
                doc_lines = 0,
                floating_window = false,
                hint_scheme = 'LspSignatureHintVirtualText',
                hint_prefix = ' ',
            }
            require('lsp_signature').setup(lsp_signature_cfg)
        end
    },
    {
        'williamboman/mason.nvim',
        config = function()
            require('mason').setup()
        end
    },
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = { 'williamboman/mason.nvim' },
        config = function()
            require('mason-lspconfig').setup {
                ensure_installed = mason_servers,
            }
        end
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = { 'williamboman/mason-lspconfig.nvim' },
        config = function()
            local lsp = require('lspconfig')

            for _, server in ipairs(mason_servers) do
                -- Special ls setup
                if (server == 'lua_ls') then
                    lsp.lua_ls.setup {
                        settings = {
                            Lua = {
                                runtime = {
                                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                                    version = 'LuaJIT',
                                },
                                diagnostics = {
                                    -- Get the language server to recognize the `vim` global
                                    globals = { 'vim' },
                                },
                                workspace = {
                                    -- Make the server aware of Neovim runtime files
                                    library = vim.api.nvim_get_runtime_file("", true),
                                    checkThirdParty = false, -- THIS IS THE IMPORTANT LINE TO ADD
                                },
                                -- Do not send telemetry data containing a randomized but unique identifier
                                telemetry = {
                                    enable = false,
                                },
                            },
                        },
                        on_attach = function(client, bufnr)
                            require('nvim-navic').attach(client, bufnr)
                            on_attach(client, bufnr)
                        end
                    }

                    -- General ls setup
                else
                    lsp[server].setup {
                        on_attach = function(client, bufnr)
                            require('nvim-navic').attach(client, bufnr)
                            on_attach(client, bufnr)
                        end
                    }
                end
            end
        end
    },
    {
        'jose-elias-alvarez/null-ls.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local null_ls = require('null-ls')

            null_ls.setup {
                sources = {
                    null_ls.builtins.completion.spell,
                    null_ls.builtins.diagnostics.npm_groovy_lint,
                    null_ls.builtins.diagnostics.pylint,
                    null_ls.builtins.formatting.isort.with({
                        extra_args = { "--line-length=120" }
                    }),
                    null_ls.builtins.formatting.black,
                    null_ls.builtins.formatting.prettier,
                    null_ls.builtins.diagnostics.ruff,
                    null_ls.builtins.diagnostics.rubocop,
                    null_ls.builtins.formatting.rubocop
                },
                on_attach = on_attach
            }
        end
    },
    {
        'numToStr/prettierrc.nvim',
        ft = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'html', 'css', 'sass', 'less',
            'markdown', 'telekasten', 'yaml', 'vue', 'json', 'graphql' },
    }
}
