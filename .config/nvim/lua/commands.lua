local mason_registry = require('mason-registry')
local mason_ensure_installed = require('util').mason_ensure_installed

vim.api.nvim_create_user_command(
  'Gc',
  function(opts)
    args = {}
    for i, v in ipairs(opts.fargs) do
      if i ~= 0 and i ~= 1 then
        table.insert(args, v)
      end
    end
    require('noice')
        .redirect(
          string.format(
          -- pass all arguments from the values in the opts.fargs table to git commit
            'Git commit %s', table.concat(args, ' ')
          ),
          {
            {
              view = 'cmdline_output',
              filter = { event = "msg_show", kind = { "echo", "echoerr", "echomsg" } }
            },
            {
              view = 'notify',
              filter = { event = "msg_show", kind = { "echo", "echoerr", "echomsg" } }
            },
          }
        )
  end,
  { nargs = "*" }
)

vim.api.nvim_create_user_command("MasonEnsureInstalled", function()
  -- filter out the already installed packages
  local installed = mason_registry.get_installed_package_names()
  local installed_inverted = {}

  for _, package in ipairs(installed) do
      installed_inverted[package] = true
  end

  local to_install = {}
  for _, package in ipairs(mason_ensure_installed) do
    if not installed_inverted[package] then
      table.insert(to_install, package)
    end
  end
  if #to_install == 0 then
    vim.print("All Mason packages are already installed")
    return
  end
  vim.cmd("MasonInstall " .. table.concat(to_install, " "))
end, {})

vim.api.nvim_create_user_command("CopyRelPath", function()
    local path = vim.fn.expand("%")
    vim.fn.setreg("+", path)
    vim.notify('Copied "' .. path .. '" to the clipboard!')
end, {})

vim.api.nvim_create_user_command("CopyAbsPath", function()
    local path = vim.fn.expand("%:p")
    vim.fn.setreg("+", path)
    vim.notify('Copied "' .. path .. '" to the clipboard!')
end, {})
