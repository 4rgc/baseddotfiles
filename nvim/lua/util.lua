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

M.mason_servers = { 'eslint', 'lua_ls', 'tsserver', 'sqlls', 'rust_analyzer', 'marksman', 'jsonls', 'html',
    'graphql', 'dockerls', 'docker_compose_language_service', 'dotls', }

return M
