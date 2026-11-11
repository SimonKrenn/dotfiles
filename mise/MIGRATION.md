# Mise migration status

Machine setup is declared in the root `mise.toml`. Native application configs
remain in `.config/`, and `.config/mise/config.toml` owns global runtime pins.
See [the README](../README.md) for prerequisites and setup commands.

## Existing Nix machines

1. Run `./setup.sh --backup` from the repository root.
2. Activate `simon-mac-mise` or `work-mise` to release Home Manager's config
   ownership while retaining Nix system packages.
3. Preview with `./setup.sh`, then apply with `./setup.sh --apply`.
4. Validate a new terminal session before retiring Nix.

Both bootstrap and `mise dot apply` run the same pre-dotfiles hook. It rejects
active or unverifiable Nix ownership, then backs up the deployment targets once.
Old Home Manager links may be replaced only when absent from the active manifest.
Backups include original links, readable contents, and package inventories under
`~/.local/state/dotfiles/backups/`. Run the explicit backup before bootstrap if
you need a package inventory from before installation.

## Remaining validation

- Install packages and test setup on a clean machine or separate account.
- Check Fish startup and local overrides, mise project switching, Git signing
  and LFS, Neovim, tmux plugins, Ghostty, Yazi flavors, and Hammerspoon.
- Check executable paths before removing duplicate installations.
- Keep the Nix generation and file backups until the replacement is verified.

The repository supplies native configs, vendored Yazi flavors, and opt-in Nix
handoff outputs. No live handoff or package installation was performed as part
of preparing the migration. Package versions and file backups have separate
rollback paths; restoring config files does not downgrade installed packages.
