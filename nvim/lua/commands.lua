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
