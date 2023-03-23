local M = {}

M.map = function (mode, lhs, rhs, desc, opts)
  opts = opts or { silent = true }
  opts.desc = desc
  vim.keymap.set(mode, lhs, rhs, opts)
end

return M
