return {
    {
        'mfussenegger/nvim-dap',
        dependencies = {
            'suketa/nvim-dap-ruby',
            'mfussenegger/nvim-dap-python',
        },
        config = function()
            vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = '', linehl = '', numhl = '' })
            require('dap-ruby').setup()
            require('dap-python').setup('~/.pyenv/shims/python')
            local dap = require('dap')
            table.insert(
                dap.configurations.ruby,
                {
                    type = 'ruby',
                    request = 'attach',
                    name = 'Start SG Rails server',
                    command = "puma",
                    bundle = "bundle",
                    script = "-C config/puma.rb",
                    port = 38698,
                    server = "127.0.0.1",
                    options = {
                        source_filetype = "ruby",
                    },
                    localfs = true,
                    waiting = 15000,
                }
            )
            table.insert(
                dap.configurations.ruby,
                {
                    type = 'ruby',
                    request = 'attach',
                    name = 'Run current test file',
                    command = "ruby",
                    bundle = "bundle",
                    script = "-Itest ${file}",
                    port = 38698,
                    server = "127.0.0.1",
                    options = {
                        source_filetype = "ruby",
                    },
                    localfs = true,
                    waiting = 5000,
                }
            )
            table.insert(
                dap.configurations.ruby,
                {
                    type = 'ruby',
                    request = 'attach',
                    name = 'Run current test file (non-bundle test)',
                    command = "bundle exec test_launcher",
                    bundle = "",
                    script = "${file}",
                    port = 38698,
                    server = "127.0.0.1",
                    options = {
                        source_filetype = "ruby",
                    },
                    localfs = true,
                    waiting = 500,
                }
            )
            table.insert(
                dap.configurations.ruby,
                {
                    type = 'ruby',
                    request = 'attach',
                    name = 'Run current test file (current line)',
                    command = "test_launcher",
                    bundle = "bundle",
                    script = "${file}",
                    port = 38698,
                    server = "127.0.0.1",
                    options = {
                        source_filetype = "ruby",
                    },
                    localfs = true,
                    waiting = 15000,
                    current_line = true
                }
            )
        end
    },
    {
        'rcarriga/nvim-dap-ui',
        dependencies = {
            'mfussenegger/nvim-dap'
        },
        config = function()
            require('dapui').setup()
            local dap, dapui = require("dap"), require("dapui")
            dap.listeners.after.event_initialized["dapui_config"] = function()
              dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
              dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
              dapui.close()
            end
        end
    }
}
