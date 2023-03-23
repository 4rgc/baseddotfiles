local M = {}

M.map = function(mode, lhs, rhs, desc, opts)
  opts = opts or { silent = true }
  opts.desc = desc
  vim.keymap.set(mode, lhs, rhs, opts)
end

M.mason_servers = { 'eslint', 'lua_ls', 'tsserver', 'sqlls', 'rust_analyzer', 'pyright', 'marksman', 'jsonls', 'html',
  'graphql', 'dockerls', 'docker_compose_language_service', 'dotls', 'cucumber_language_server', 'cssls',
  'clangd', 'cmake', 'bashls', 'yamlls' }

return M
