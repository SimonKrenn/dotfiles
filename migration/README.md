# Mise bootstrap trial

Apple Silicon macOS setup using mise for packages, runtimes, dotfiles and defaults.
Use a separate, persistent checkout while Nix/Stow still own the existing files.

## Setup

Install Homebrew and Xcode command-line tools, then:

```sh
brew install mise python@3.13 ruby
export PATH="/opt/homebrew/bin:$PATH"
# Review mise.toml and migration/ before trusting the checkout.
mise trust
bash migration/bootstrap.sh --dry-run
bash migration/bootstrap.sh --apply
```

The wrapper defaults to preview. `--apply` checks existing file ownership first;
it refuses Nix/Stow symlinks, nested links and legacy Git/tmux loaders. Release
those targets from their current manager before applying. Regular-file conflicts
use mise's handling; do not bypass them with force flags. Direct `mise bootstrap`
bypasses the ownership check. Homebrew Ruby is needed to preview third-party taps.

Test full installation and repeat-run convergence in a disposable macOS VM first.
A separate account does not isolate Homebrew or Applications. The trial has passed
static checks and native preview; full installation and GUI behavior are unverified.

## Files to edit

- `mise.toml`: packages, deployment paths, defaults, login shell and setup task.
- `migration/mise/config.toml`: the single runtime inventory, shared by project and
  global config. Tools remain available outside this checkout. Global settings
  deploy separately from `migration/mise/settings.toml`.
- `mise.lock` and `.mise/locks/`: resolved runtime versions and dependencies, also
  deployed globally. Refresh with `mise lock --platform macos-arm64`; add `--bump`
  to update floating versions. Discard extra output for legacy `.config/mise`.
- `migration/neovim-version`: exact Neovim version installed through bob.
- `migration/post-bootstrap.sh`: Neovim, locked OpenCode dependencies, missing
  Fisher/TPM plugins and Library visibility. Existing Fisher plugins are retained.
- Native app configs live in `migration/` or `.config/`, as listed in `mise.toml`.
  Deployment uses copies: edit the source and reapply, or copy runtime edits back.
  Vendored Yazi themes include their source commit and license.

Set per-machine Git email in unmanaged `~/.config/git/local.gitconfig`:

```gitconfig
[user]
  email = mail@simonkrenn.dev
```

Use the work address on the work machine. Private/local Fish hooks are unmanaged.
App sign-in, 1Password authorization, Hammerspoon accessibility and Raycast imports
remain manual. Git AI is optional; use its [upstream installation instructions](https://github.com/git-ai-project/git-ai#install).
Codex CLI and desktop are separate installs; fff-mcp comes from Homebrew.

Apply selects Homebrew Fish as the login shell; reopen the terminal afterward.
Verify `mise doctor`, runtimes outside the checkout, Fish scripts, tmux, Neovim,
Git signing/LFS, Ghostty and Yazi. A preview with scoped trust can warn about
global mise destination files; source configs are checked separately by the validator.

## Checks and handoff

```sh
python3 migration/validate.py
python3 -m unittest discover -s migration -p 'test_*.py'
bash migration/bootstrap.sh --dry-run
```

Before handing off the real machine, save the active Nix generation, login shell,
resolved configs, private files and symlink ownership. Release each target from
Home Manager or Stow, preview, then apply. Keep Nix and the original checkout until
daily workflows pass. Mise's locks do not lock Homebrew or provide Nix generations;
recovery requires the saved files, shell and manager state. Checking out main does
not undo installed packages, copied files or preferences. Use a VM snapshot for
complete trial rollback.
