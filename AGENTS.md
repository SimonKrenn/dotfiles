# AGENTS.md - Dotfiles Repository

This document provides guidance for AI coding agents working in this repository.

## Repository Overview

This is a macOS personal dotfiles repository using GNU Stow for symlink management. It configures a terminal-based development environment centered around Neovim, Fish shell, tmux, and various CLI tools.

## Build/Setup Commands

| Command | Description |
|---------|-------------|
| `./setup.sh` | Main installation - runs stow, macOS setup, Fisher plugins, TPM |
| `./.config/stow.sh` | Creates config directories and stows all dotfiles |
| `./.macos/install.sh` | Runs `brew bundle` to install Homebrew dependencies |
| `./.macos/os-defaults.sh` | Sets macOS system preferences |

### No Traditional Build/Test/Lint

This is a configuration repository, not a code project. There are no test suites, CI pipelines, or linting commands. The "build" process is running `setup.sh` to install and symlink configurations to `~/.config/`.

## Project Structure

```
dotfiles/
├── .config/              # Main configuration directory (stow source)
│   ├── fish/             # Fish shell config
│   ├── nvim/             # Neovim configuration (Lua)
│   ├── tmux/             # Terminal multiplexer
│   ├── ghostty/          # Terminal emulator + themes
│   ├── git/              # Git configuration
│   ├── lazygit/          # Git TUI
│   ├── opencode/         # AI agent configurations
│   ├── hammerspoon/      # macOS automation (Lua)
│   └── ...               # Other tool configs
├── .macos/               # macOS-specific setup scripts
├── .editorconfig         # Editor style settings
├── .luarc.json           # Lua LSP globals (vim, Snacks)
└── setup.sh              # Main installation script
```

## Code Style Guidelines

### General (from .editorconfig)

- **Indentation:** 2 spaces (no tabs)
- **Line endings:** LF (Unix-style)
- **Final newline:** Always include
- **Trailing whitespace:** Trim

### Lua (Neovim/Hammerspoon)

#### File Organization

```
nvim/lua/
├── config/           # Core options and plugin manager setup
├── aucmd/            # Autocommands
├── lualine/          # Custom statusline components
└── plugins/
    ├── lsp.lua       # LSP configuration
    ├── editor/       # Editor functionality (completion, treesitter, etc.)
    ├── ui/           # UI plugins (themes, statusline, etc.)
    ├── lang/         # Language-specific plugins
    └── utils/        # Utility plugins
```

#### Naming Conventions

- **Variables:** `snake_case` (e.g., `server_config`, `default_icons`)
- **Functions:** `snake_case` (e.g., `client_supports_method`)
- **Keymap descriptions:** Use `[L]etter [N]otation` pattern (e.g., `"[G]oto [D]efinition"`)
- **Local vim aliases:** Short names like `local o, opt, wo, g = vim.o, vim.opt, vim.wo, vim.g`

#### Plugin Specification Pattern (lazy.nvim)

```lua
-- Simple plugin
return {
  "author/plugin-name",
  opts = { ... },
}

-- Full plugin spec
return {
  {
    "author/plugin-name",
    dependencies = { "dep1", "dep2" },
    event = "VeryLazy",
    keys = {
      { "<leader>key", function() ... end, desc = "[D]escription" },
    },
    opts = { ... },
    config = function(_, opts)
      require("plugin").setup(opts)
    end,
  },
}
```

#### Import Pattern

```lua
-- Top of file for frequently used modules
local Component = require("module.component")

-- Inside functions for lazy loading
require("plugin").method()
```

#### Lua Style

- Trailing commas in tables
- Use `vim.tbl_extend` / `vim.tbl_deep_extend` for merging configs
- Create autocommands with `vim.api.nvim_create_autocmd` and named augroups
- LSP keymaps scoped to buffer via callback pattern

### Fish Shell

#### File Organization

- `config.fish` - Main config, sources other files conditionally
- `alias.fish` - Aliases and simple functions
- `fish_plugins` - Fisher plugin list

#### Patterns

```fish
# Conditional sourcing
if [ -f $HOME/.config/fish/alias.fish ]
    source $HOME/.config/fish/alias.fish
end

# Environment variables
set -Ux EDITOR nvim
set -q XDG_CONFIG_HOME || set -Ux XDG_CONFIG_HOME $HOME/.config

# Path modifications
fish_add_path /opt/homebrew/bin

# Tool initialization
starship init fish | source
zoxide init fish | source
```

### Bash Scripts

- Shebang: `#!/bin/bash`
- macOS detection: `if [[ "$OSTYPE" == "darwin"* ]]; then`
- Relative paths with `./` prefix

## Formatting Tools

Formatting is handled by external tools via Neovim's conform.nvim:

| Language | Formatters |
|----------|------------|
| Lua | stylua |
| TypeScript/JavaScript | biome, prettierd, prettier |
| YAML | yamlfix |
| Nix | nixfmt |

## Key Technologies

| Category | Tools |
|----------|-------|
| Shell | Fish (primary), Bash (scripts) |
| Editor | Neovim (Lua config) |
| Terminal | Ghostty, tmux |
| Git | lazygit, gitsigns, diffview |
| Dotfiles | GNU Stow |
| Plugin Managers | lazy.nvim, Fisher, TPM |

## Agent-Specific Notes

### When Modifying Neovim Config

1. Follow the existing plugin structure in `lua/plugins/`
2. Use lazy.nvim spec format with `opts` when possible
3. Add keymaps with descriptive `desc` using `[L]etter` notation
4. Test changes by restarting Neovim or running `:Lazy reload <plugin>`

### When Modifying Fish Config

1. Keep aliases in `alias.fish`, not `config.fish`
2. Use `set -Ux` for exported environment variables
3. Use `fish_add_path` instead of manual PATH manipulation

### When Adding New Tool Configurations

1. Create directory under `.config/<tool-name>/`
2. Update `.config/stow.sh` if new directories need creation
3. Add any Homebrew dependencies to `.macos/Brewfile`

### OpenCode Agent Configurations

This repository contains AI agent configurations in `.config/opencode/`:
- `autonomous.md` - End-to-end Jira implementation
- `code-reviewer.md` - Code review (read-only)
- `jira-planner.md` - Implementation planning
- `ta-engineer.md` - Test automation
- `docs-writer.md` - Documentation writing
- `change-summarizer.md` - PR description generation

## Error Handling

### Lua

```lua
-- Use pcall for potentially failing operations
local ok, result = pcall(require, "optional-module")
if not ok then
  vim.notify("Module not found", vim.log.levels.WARN)
  return
end
```

### Fish

```fish
# Check command existence
if type -q some_command
    some_command
end

# Check file existence
if [ -f "$file" ]
    source "$file"
end
```
