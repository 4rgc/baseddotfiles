package.path = package.path .. ';../?.lua'
local map = require('util').map
local mason_lsp_servers = require('util').mason_lsp_servers
local mason_servers_no_version = {}
for i, v in ipairs(mason_lsp_servers) do mason_servers_no_version[i] = v:gsub('@.*', '') end
local non_mason_servers = { 'pylsp', 'ruby_lsp' }
local non_mason_server_executables = {
    pylsp = 'pylsp',
    ruby_lsp = 'solargraph',
}

-- Check if we have all non-mason servers installed
for _, server in ipairs(non_mason_servers) do
    if vim.fn.executable(non_mason_server_executables[server]) == 0 then
        file = io.open(require('vim.lsp.log').get_filename(), 'a')
        file:write('\n[WARN]['.. os.date("%Y-%m-%d %H:%M:%S") .. '] (lsp.lua) Non-mason server ' .. server .. ' not found, skipping')
        file:close()
        table.remove(non_mason_servers, table.getn(non_mason_servers))
    end
end

-- Check if we have solargraph installed, use it if we do
if vim.fn.executable('solargraph') == 1 then
    table.insert(non_mason_servers, 'solargraph')
else
    table.insert(mason_servers_no_version, 'solargraph')
end

local all_servers = {}
table.move(mason_servers_no_version, 1, #mason_servers_no_version, 1, all_servers)

-- Attaches any custom non-mason lsp servers with correct keybindings
table.move(non_mason_servers, 1, #non_mason_servers, #all_servers + 1, all_servers)


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
    map('n', 'J', vim.diagnostic.open_float, 'Show diagnostics', bufopts)
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

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

return {
    -- show current cursor context in winbar/statusbar
    { 'SmiteshP/nvim-navic', dependencies = { 'neovim/nvim-lspconfig' } },
    {
        -- install lsp servers seamlessly
        'williamboman/mason.nvim',
        dependencies = {
            'williamboman/mason-registry',
        },
        config = function()
            require('mason').setup()
        end
    },
    {
        -- integrate mason lsp servers with lspconfig
        'williamboman/mason-lspconfig.nvim',
        dependencies = { 'williamboman/mason.nvim' },
        config = function()
            require('mason-lspconfig').setup {
                ensure_installed = mason_lsp_servers,
            }
        end
    },
    {
        -- lua lsp setup plugin
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "luvit-meta/library", words = { "vim%.uv" } },
            },
        },
    },
    {
        -- set up lsp servers from mason and otherwise
        'neovim/nvim-lspconfig',
        dependencies = { 'williamboman/mason-lspconfig.nvim' },
        config = function()
            local lsp = require('lspconfig')
            local util = require('lspconfig.util')

            for _, server in ipairs(all_servers) do
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
                elseif (server == 'pylsp') then
                    lsp.pylsp.setup {
                        cmd = { "pylsp" --[[ , "-v"  ]] },
                        root_dir = function(fname)
                            local root_files = {
                                'pyproject.toml',
                                'setup.py',
                                'setup.cfg',
                                'requirements.txt',
                                'Pipfile',
                                '.pylintrc',
                                '.flake8',
                            }
                            return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname)
                        end,
                        settings = {
                            pylsp = {
                                configurationSources = { "flake8" },
                                plugins = {
                                    pylint = {
                                        -- enable if ruff isn't good enough
                                        enabled = false,
                                    },
                                    pyflakes = { enabled = false },
                                    pycodestyle = { enabled = false },
                                    pydocstyle = { enabled = true },
                                    mccabe = { enabled = true },
                                    flake8 = {
                                        enabled = true,
                                    },
                                    autopep8 = { enabled = false },
                                    yapf = { enabled = false },
                                    pylsp_black = { enabled = true },
                                    pylsp_mypy = { enabled = true },
                                    ruff = { enabled = true },
                                    rope_autoimport = { enabled = true },
                                },
                            }
                        },
                        on_attach = function(client, bufnr)
                            require('nvim-navic').attach(client, bufnr)
                            on_attach(client, bufnr)
                        end
                    }
                elseif (server == 'ruby_lsp') then
                    lsp.ruby_lsp.setup({
                        on_attach = function(client, bufnr)
                            require('nvim-navic').attach(client, bufnr)
                            on_attach(client, bufnr)
                        end
                    })
                elseif (server == 'eslint') then
                    lsp.eslint.setup {
                        on_attach = function(client, bufnr)
                            require('nvim-navic').attach(client, bufnr)
                            on_attach(client, bufnr)
                        end
                    }
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
        'nvimtools/none-ls.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local null_ls = require('null-ls')

            null_ls.setup {
                sources = {
                    null_ls.builtins.completion.spell,
                    null_ls.builtins.diagnostics.npm_groovy_lint,
                    -- javascript/typescript formatting
                    null_ls.builtins.formatting.prettierd
                },
                on_attach = on_attach
            }
        end
    },
    {
        -- pick up local prettier config file
        'numToStr/prettierrc.nvim',
        ft = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'html', 'css', 'sass', 'less',
            'markdown', 'telekasten', 'yaml', 'vue', 'json', 'graphql' },
    },
    {
        -- refactoring utils
        "ThePrimeagen/refactoring.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("refactoring").setup()

            -- Refactoring mappings
            vim.keymap.set("x", "<space>re", ":Refactor extract ")
            vim.keymap.set("x", "<space>rf", ":Refactor extract_to_file ")

            vim.keymap.set("x", "<space>rv", ":Refactor extract_var ")

            vim.keymap.set({ "n", "x" }, "<space>ri", ":Refactor inline_var")

            vim.keymap.set("n", "<space>rI", ":Refactor inline_func")

            vim.keymap.set("n", "<space>rb", ":Refactor extract_block")
            vim.keymap.set("n", "<space>rbf", ":Refactor extract_block_to_file")
            vim.keymap.set(
                { "n", "x" },
                "<leader>rr",
                function() require('refactoring').select_refactor() end
            )
        end,
    },
    {
        -- typescript lsp (removes need for tsserver and other lsps)
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        config = function()
            require("typescript-tools").setup {
                on_attach = function(client, bufnr)
                    require('nvim-navic').attach(client, bufnr)
                    client.server_capabilities.documentFormattingProvider = false
                    client.server_capabilities.documentRangeFormattingProvider = false
                    on_attach(client, bufnr)
                end,
                settings = {
                    expose_as_code_action = "all"
                }
            }
        end,
        opts = {},
    }
}
