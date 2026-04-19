# Neovim Config — Agents Guide

## Structure

```
nvim/
├── init.lua                  # Entry point — sets load order
├── lazy-lock.json            # Plugin lockfile (auto-managed)
├── compiler/minitest.vim     # Custom compiler for Ruby minitest
├── snippets/                 # LuaSnip snippet files (JS/TS/Ruby)
└── lua/
    ├── vars.lua              # Editor options (tabs, line numbers, etc.)
    ├── lazy_bootstrap.lua    # Bootstraps lazy.nvim on first run
    ├── mappings.lua          # All keybindings
    ├── commands.lua          # Custom :Commands
    ├── autocmds.lua          # Autocommands
    ├── postconfig.lua        # Final setup (colorscheme, Mason installs)
    ├── util.lua              # Shared utilities and constants
    └── plugins/              # One file per feature domain
        ├── lsp.lua           # LSP, Mason, null-ls, diagnostics
        ├── cmp.lua           # Completion (nvim-cmp + LuaSnip)
        ├── treesitter.lua    # Syntax, folds, text objects
        ├── telescope.lua     # Fuzzy finder + extensions
        ├── git.lua           # fugitive, diffview, gitsigns
        ├── ui.lua            # noice, neotest, colorscheme, trouble
        ├── dap.lua           # Debugger (Ruby, Python, JS)
        ├── misc.lua          # Copilot, notes, editing helpers, sessions
        ├── nvimtree.lua      # File tree
        ├── bufferline.lua    # Buffer tabs
        ├── lualine.lua       # Statusline + winbar
        ├── terminal.lua      # toggleterm
        ├── code_runner.lua   # <F7> run current file
        └── db.lua            # vim-dadbod SQL UI
```

## Load order (init.lua)

`vars` → `lazy_bootstrap` → `lazy.setup('plugins')` → `commands` → `mappings` → `autocmds` → `postconfig`

Plugins must be loaded before commands, mappings, and autocmds.

## Key conventions

**Keybindings** — all go in `mappings.lua`. Use the `map()` helper from `util.lua`:
```lua
map('n', '<leader>xx', ':SomeCmd<CR>', 'Description')
```

**Adding a plugin** — create or edit the relevant file in `lua/plugins/`. Each file returns a list of lazy.nvim plugin specs. Use lazy loading (`event`, `ft`, `cmd`) wherever possible.

**LSP servers** — managed through two lists in `util.lua`:
- `mason_lsp_servers` — installed and configured by Mason automatically
- `mason_ensure_installed` — other Mason packages (formatters, linters, DAP adapters)

Servers that can't be Mason-managed (currently `pylsp`, `ruby_lsp`) are configured directly in `lsp.lua` and must be installed separately.

**Custom commands** — add to `commands.lua`. Commands that depend on Noice (e.g. output display) follow the `Gc` pattern there.

**Autocommands** — add to `autocmds.lua`. Autocommands that are tightly coupled to a plugin can live in that plugin's spec instead.

## Notable design decisions

- **Colorscheme**: `ofirkai` — set last in `postconfig.lua` so it can override plugin highlights.
- **Treesitter folding**: `foldmethod=expr` is set globally in `vars.lua`; don't set it per-buffer unless intentional.
- **typescript-tools.nvim** replaces `tsserver` — do not also enable `tsserver` via mason-lspconfig.
- **Local config**: `vim.opt.exrc = true` — projects can override settings via a `.nvim.lua` file at the project root.
- **Auto-format on save**: wired up in the `LspAttach` callback in `lsp.lua` via a `BufWritePre` autocmd; disable per-project via `.nvim.lua`.

## Languages with DAP debuggers configured

| Language   | Adapter                              |
|------------|--------------------------------------|
| Ruby       | nvim-dap-ruby (Puma + test configs)  |
| Python     | dap-python (`~/.pyenv/shims/python`) |
| JavaScript | vscode-js-debug (`~/Projects/vscode-js-debug`) |

## Note-taking integrations

Two note systems are wired up in `misc.lua`:
- **Obsidian.nvim** — vault path set from `$NEXTCLOUD_PATH`
- **Telekasten** — Zettelkasten-style notes; keybindings under `<leader>z*`

Both depend on `$NEXTCLOUD_PATH` being set in the environment.
