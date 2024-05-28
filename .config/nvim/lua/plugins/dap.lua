return {
    {
        'mfussenegger/nvim-dap',
        dependencies = {
            'suketa/nvim-dap-ruby',
            'mfussenegger/nvim-dap-python',
            'mxsdev/nvim-dap-vscode-js',
            'nvim-neotest/nvim-nio'
        },
        config = function()
            vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = '', linehl = '', numhl = '' })
            require('dap-ruby').setup()
            require('dap-python').setup('~/.pyenv/shims/python')
            require('dap-vscode-js').setup({
                debugger_path = "/Users/bohda/Projects/vscode-js-debug",                                   -- Path to vscode-js-debug installation.
                adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
            })
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
            for _, language in ipairs({ 'javascript', 'typescript' }) do
                dap.configurations[language] = {
                    {
                        type = "pwa-node",
                        request = "launch",
                        name = "Launch file",
                        program = "${file}",
                        cwd = "${workspaceFolder}",
                    },
                    {
                        type = "pwa-node",
                        request = "attach",
                        name = "Attach",
                        processId = require 'dap.utils'.pick_process,
                        cwd = "${workspaceFolder}",
                        skipFiles = { "**/node_modules/**" },
                        trace = true
                    }
                }
            end
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
