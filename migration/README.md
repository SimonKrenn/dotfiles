# Mise bootstrap trial (Apple Silicon macOS)

This is an additive trial, not an instruction to uninstall Nix. Nix and Stow are
currently active side-by-side. Their original files, setup scripts and flake are
unchanged. Trial-specific changes live here, so switching branches does not edit
files already linked by Stow. Use a **separate checkout**: keep the original checkout
at its original path for existing Stow links and Nix rebuilds.

## Try it

Prerequisites: Git/Xcode command-line tools, Python 3.11+, and a mise version
supporting the current bootstrap schema. The target schema is the documentation
published for mise 2026.9.8; native execution against that release still needs
verification. Older mise supplied by your Nix generation may lack these features.
Do not uninstall Nix to obtain a newer mise.

```sh
git clone --branch codex/mise-bootstrap-trial \
  https://github.com/SimonKrenn/dotfiles.git ~/workspace/dotfiles-mise-trial
cd ~/workspace/dotfiles-mise-trial
python3 migration/validate.py
python3 -m unittest discover -s migration -p 'test_*.py'
# Review mise.toml and migration/ before granting trust.
mise trust
bash migration/bootstrap.sh --dry-run
```

The wrapper defaults to dry-run and accepts no arbitrary passthrough flags.
No hooks or plugin task run in dry-run. A mise dry-run can still evaluate trusted
configuration expressions and inspect/download metadata; it is not a sandbox.

For a full apply use a disposable Apple Silicon macOS VM. A separate account
isolates dotfiles but NOT /opt/homebrew, /Applications or other shared host paths.
Changing HOME or XDG_CONFIG_HOME is NOT a full-machine isolation strategy.

```sh
# In the disposable VM, after reviewing the preview:
DOTFILES_MISE_TRIAL_APPLY=1 bash migration/bootstrap.sh --apply
# Run again to check convergence:
DOTFILES_MISE_TRIAL_APPLY=1 bash migration/bootstrap.sh --apply
mise bootstrap status
```

On a populated account, preflight refuses symlink targets, symlink ancestors,
nested symlinks, and legacy ~/.tmux.conf or ~/.gitconfig precedence. It does not
delete, adopt, overwrite or back up anything. Regular-file conflicts are left
to mise's own conflict handling. Never add --force-dotfiles to bypass ownership.
The guard belongs to the wrapper: direct `mise bootstrap` bypasses it.

## Migration decisions

- mise.toml: host packages, repos, dotfiles, macOS defaults and a final task.
- migration/mise/config.toml: global runtime configuration copied to the home
  directory. Root tools match it for first-run installation; validation catches
  drift. Retains Node 22.15.0 and the existing floating runtime versions; adds Bun.
- OpenCode is owned by mise tools, not also brew. No second mise, Rust or Cargo
  package. Fish/tmux stay in /opt/homebrew; login shell is deliberately unchanged.
- Native Fish combines theme handling, aliases/functions and private/local
  hooks; activates mise explicitly; removes machine-specific usernames.
- Native Git retains signing, LFS, delta and rerere and adds Nix's CodeDiff
  commands. Email is deliberately not selected: create
  ~/.config/git/local.gitconfig with the appropriate [user] email for each machine.
  It is not a declared target. Check `git config --show-origin --get user.email`.
- Ghostty/Atuin/Yazi native settings agree with the inspected Nix configuration.
  Yazi flavors are copied from a pinned theme checkout instead of the existing
  machine-dependent flavor symlinks. Lazygit uses Nix's pagers structure and
  preserves Stow's commitizen command.
- Both old tmux loaders are replaced by one canonical ~/.config/tmux/tmux.conf;
  preflight stops if ~/.tmux.conf could override it.
- Trial deployment uses copies: editing runtime configs or plugin state cannot
  write back into the checkout. Existing edits may conflict on subsequent apply;
  transfer intentional changes back to the source explicitly.
- Fish and Git are file-granular; private aliases and identity stay unmanaged.
  OpenCode excludes node_modules and the Stow ignore file. No history watcher
  or synchronization to a public repository is enabled.
- TPM checkout is declarative. The final task installs missing Fisher plugins
  and invokes TPM in a dedicated tmux server, leaving the real server alone.
  No updates to already-installed Fisher plugins are requested.

## Deliberately deferred

This trial is not yet a complete Nix replacement. Package availability and third-
party tap compatibility need a real macOS apply. Floating package versions do
not provide Nix generation reproducibility or transactional rollback.

- rtk, kaset and nixfmt from the Nix inventory await package/backend decisions;
  Nix itself and its daemon remain installed.
- Keep bob as the Neovim owner; select/install the same Neovim version you use
  today with bob before testing Neovim. No automatic latest-Neovim replacement.
- tokscale, fff-mcp, git-ai, OpenCode dependencies, Codex CLI vs desktop app,
  optional VS Code extensions and Raycast import need explicit follow-up.
  Their old curl installers are not silently executed.
- Work Git email, private aliases, app sign-in, 1Password authorization and
  Hammerspoon accessibility permissions are manual.
- chflags nohidden ~/Library, login-shell changes and Nix/Stow removal are not
  performed. Change the login shell only after /opt/homebrew/bin/fish is verified.

## Existing-machine handoff and rollback

Before an eventual real migration, record the current Nix generation, login shell,
package inventory, symlink destinations, resolved config contents and private
files. Keep a filesystem backup and the original checkout.

For EACH target, determine whether Stow or Home Manager owns it. Remove that
target's declaration from the owning manager and activate that change first,
or unstow only its owning package. Recheck links and move conflicting regular
files into your backup deliberately. Do not blanket-unstow, force copies, or
remove the Nix store. Then run the wrapper preflight and preview again.

On rollback, restore the saved files/links and manager declarations and activate
the saved Nix generation as appropriate. Merely checking out main does not undo
copied files, installed packages or preferences. Removing the trial does not
uninstall its host packages. Prefer a VM snapshot for complete trial rollback.

## Verification checklist

- Static validator and unit tests pass.
- Native mise bootstrap --dry-run accepts all configuration sections.
- Apply twice; the second run creates no duplicate plugins or altered configs.
- Open a new Fish shell; check mise doctor, mise which node, node --version.
- Outside the checkout, confirm the same global tools are available.
- Start tmux with its new config; verify splits use Fish and themes/plugins work.
- Verify Neovim, Ghostty, Yazi flavors, Lazygit and Git LFS.
- In a throwaway Git repository, verify identity and a signed commit after
  configuring 1Password; do not change a real project's history to test signing.

Local validation in the implementation environment covers TOML parsing, source
inventory, package ownership constraints, runtime parity, Bash parsing, Git
config parsing and seven unit tests. That Linux environment has neither mise nor
Fish; native mise/Fish execution and macOS package/application testing are outstanding.

References:
- [Bootstrap](https://mise.jdx.dev/bootstrap.html)
- [Brew packages](https://mise.jdx.dev/bootstrap/packages/brew.html)
- [Dotfiles](https://mise.jdx.dev/dotfiles.html)
- [Repos](https://mise.jdx.dev/bootstrap/repos.html)
- [Shell](https://mise.jdx.dev/bootstrap/shell.html)
