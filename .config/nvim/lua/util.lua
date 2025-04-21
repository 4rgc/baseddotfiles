local M = {}

M.map = function(mode, lhs, rhs, desc, opts)
    opts = opts or { silent = true }
    opts.desc = desc
    vim.keymap.set(mode, lhs, rhs, opts)
end

M.read_exec_path = function(exec_name)
    local handle = io.popen("which " .. exec_name)
    local result = handle:read("*a"):gsub("\n", "")
    handle:close()
    return result
end

M.unpack = unpack or table.unpack

M.mason_lsp_servers = { 'eslint', 'lua_ls', 'sqlls', 'rust_analyzer', 'marksman', 'jsonls', 'html',
    'graphql', 'dockerls', 'docker_compose_language_service', 'dotls', 'basedpyright', 'elixirls', 'nextls' }

M.mason_ensure_installed = { 'eslint-lsp', 'lua-language-server', 'sqlls', 'rust-analyzer', 'marksman', 'json-lsp', 'html-lsp', 'graphql-language-service-cli', 'dockerfile-language-server', 'docker-compose-language-service', 'dot-language-server', 'prettier', 'prettierd', 'basedpyright', 'elixir-ls', 'nextls' }

return M
