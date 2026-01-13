package.path = package.path .. ';../?.lua'
local map = require('util').map
local mason_lsp_servers = require('util').mason_lsp_servers
local mason_servers_no_version = {}
for i, v in ipairs(mason_lsp_servers) do mason_servers_no_version[i] = v:gsub('@.*', '') end
local non_mason_servers = { 'pylsp', 'ruby_lsp' }
local non_mason_server_executables = {
    pylsp = 'pylsp',
    ruby_lsp = 'ruby-lsp',
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

local all_servers = {}
table.move(mason_servers_no_version, 1, #mason_servers_no_version, 1, all_servers)

-- Attaches any custom non-mason lsp servers with correct keybindings
table.move(non_mason_servers, 1, #non_mason_servers, #all_servers + 1, all_servers)


local formattingAugrp = vim.api.nvim_create_augroup("LspFormatting", {})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    local bufnr = assert(args.buf)
    local navic = require("nvim-navic")

    if client.server_capabilities.documentSymbolProvider then
      navic.attach(client, bufnr)
    end
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    local bufopts = { noremap = true, silent = true, buffer = bufnr }

    if client:supports_method('textDocument/declaration') then
      map('n', 'gD', vim.lsp.buf.declaration, 'Go to declaration', bufopts)
    end
    if client:supports_method('textDocument/definition') then
      map('n', 'gd', vim.lsp.buf.definition, 'Go to definition', bufopts)
    end
    map('n', 'K', vim.lsp.buf.hover, 'Show documentation', bufopts)
    map('n', 'J', vim.diagnostic.open_float, 'Show diagnostics', bufopts)
    map('n', '<C-i>', vim.lsp.buf.signature_help, 'Show signature', bufopts)
    if client:supports_method('textDocument/implementation') then
      map('n', 'gi', vim.lsp.buf.implementation, 'Go to implementation', bufopts)
    end
    if client:supports_method('textDocument/typeDefinition') then
      map('n', '<space>D', vim.lsp.buf.type_definition, 'Type definition', bufopts)
    end
    if client:supports_method('workspace/executeCommand') then
      map('n', '<space>ca', vim.lsp.buf.code_action, 'Code action', bufopts)
    end
    if client:supports_method('textDocument/rename') then
      map('n', '<space>rn', vim.lsp.buf.rename, 'Rename', bufopts)
    end
    if client:supports_method('textDocument/references') then
      map('n', 'gr', vim.lsp.buf.references, 'Show references', bufopts)
    end
    if client:supports_method('textDocument/formatting') then
      map('n', '<space>f', function() vim.lsp.buf.format { async = true } end, 'Format', bufopts)
    end

    -- -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
    -- if client:supports_method('textDocument/completion') then
    --     -- Optional: trigger autocompletion on EVERY keypress. May be slow!
    --     -- local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
    --     -- client.server_capabilities.completionProvider.triggerCharacters = chars
    --     vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    -- end
    -- Auto-format ("lint") on save.
    -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
    if not client:supports_method('textDocument/willSaveWaitUntil')
        and client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
        end,
      })
    end
  end,
})

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

return {
    -- show current cursor context in winbar/statusbar
    {
      'SmiteshP/nvim-navic', dependencies = { 'neovim/nvim-lspconfig' }
    },
    {
        -- install lsp servers seamlessly
        'williamboman/mason.nvim',
        event = { 'BufReadPost', 'BufNewFile' },
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
    event = { 'BufReadPost', 'BufNewFile' },
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
            flags = { exit_timeout = 5000 },
            settings = {
              pylsp = {
                skip_token_initialization = true,
                configurationSources = { "flake8" },
                plugins = {
                  pylint = {
                    -- enable if ruff isn't good enough
                    enabled = true,
                    args = { '--errors-only' }
                  },
                  pylsp_mypy = { enabled = true },
                  pyflakes = { enabled = false },
                  pycodestyle = { enabled = false },
                  pydocstyle = { enabled = true },
                  mccabe = { enabled = true },
                  -- flake8 = {
                  --     enabled = true,
                  -- },
                  autopep8 = { enabled = false },
                  yapf = { enabled = false },
                  pylsp_black = { enabled = true },
                  ruff = { enabled = true },
                  rope_autoimport = { enabled = true },
                },
              }
            },
          }
        elseif (server == 'ruby_lsp') then
          lsp.ruby_lsp.setup {}
        elseif (server == 'eslint') then
          lsp.eslint.setup {}
        else
          lsp[server].setup {}
        end
      end
    end
  },
    {
        'nvimtools/none-ls.nvim',
        event = { 'BufReadPost', 'BufNewFile' },
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local null_ls = require('null-ls')

            null_ls.setup {
                sources = {
                    null_ls.builtins.completion.spell,
                    -- javascript/typescript formatting
                    null_ls.builtins.formatting.prettierd,
                    null_ls.builtins.diagnostics.mypy,
                    null_ls.builtins.formatting.mix,
                    null_ls.builtins.diagnostics.credo,
                    null_ls.builtins.formatting.surface,
                },
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
        ft = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        config = function()
            require("typescript-tools").setup {
                on_attach = function(client, bufnr)
                    client.server_capabilities.documentFormattingProvider = false
                    client.server_capabilities.documentRangeFormattingProvider = false
                end,
                settings = {
                    expose_as_code_action = "all"
                }
            }
        end,
        opts = {},
    }
}
