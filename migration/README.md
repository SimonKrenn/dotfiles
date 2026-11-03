# Mise bootstrap trial (Apple Silicon macOS)

This branch provides replacement setup while keeping active Nix/Stow sources
intact. Use a separate, persistent checkout: existing Stow links must keep their
original checkout path. Do not uninstall Nix before testing its replacement.

## Prepare and preview

Prerequisites: Apple Silicon macOS, Xcode command-line tools, Homebrew at
`/opt/homebrew` (https://brew.sh). Kaset requires macOS 15.4+.

```sh
bash migration/prepare.sh --dry-run
bash migration/prepare.sh --apply
export PATH="/opt/homebrew/bin:$PATH"
python3 migration/validate.py
python3 -m unittest discover -s migration -p 'test_*.py'
python3 migration/check-packages.py
# Review mise.toml and migration/ before granting trust.
mise trust
bash migration/bootstrap.sh --dry-run
```

Preparation installs missing mise, Python 3.13 and Ruby. The wrapper requires
mise 2026.10.25+ and Python 3.11+, and puts Homebrew Ruby 3 on PATH so third-party
package definitions can be evaluated. Upgrade an older mise with `brew upgrade mise`.
Both scripts default to preview. Preview can fetch metadata and evaluate trusted
expressions, but prints bootstrap hooks/tasks without executing them. It is not
a sandbox. The package checker checks every definition, including installed
packages the native preview skips; availability does not prove installation.

## Apply in a disposable macOS VM

A separate account does not isolate `/opt/homebrew` or `/Applications`; changing
XDG paths does not isolate the machine either.

```sh
DOTFILES_MISE_TRIAL_APPLY=1 bash migration/bootstrap.sh --apply
# Repeat to test convergence:
DOTFILES_MISE_TRIAL_APPLY=1 bash migration/bootstrap.sh --apply
mise bootstrap status
```

Apply preflight refuses target, ancestor and nested symlinks and legacy
`~/.tmux.conf` / `~/.gitconfig` precedence. It stops at the home boundary, so
macOS's `/var` symlink is not mistaken for a config owner. It never adopts or
backs up existing files; regular-file conflicts use mise's own handling. Direct
`mise bootstrap` bypasses the wrapper; do not force deployment past existing owners.

Apply installs packages, copies configs, selects `/opt/homebrew/bin/fish` as the
login shell, installs runtimes and runs final setup. A login-shell change may
request authorization; open a new terminal afterward. Final setup installs
Neovim through bob, locked OpenCode dependencies when manifests change, missing
Fisher/TPM plugins and unhides `~/Library`. Existing Fisher plugins are not upgraded.

## Ownership and versions

- `mise.toml` owns host packages, dotfiles, TPM, defaults, login shell and setup.
  Packages include rtk, nixfmt, Kaset and fff-mcp. Codex desktop is a cask; its CLI
  is a separate mise tool.
- `migration/mise/config.toml` deploys the global runtimes, matching the root
  inventory so tools work outside the checkout. Bun, Node, Go, Rust, fnox,
  OpenCode, tokscale and Codex CLI are mise-owned. Node remains 22.15.0.
- `mise.lock` and `.mise/locks/` record runtime versions/dependencies and deploy
  beside the global config. They do not lock Homebrew or provide Nix generations.
  Refresh with `mise lock --platform macos-arm64`; add `--bump` to update floating
  requests. Review root outputs and discard extra locks emitted for legacy
  `.config/mise`; only the root lock and its dependency metadata are deployed.
- Bob owns Neovim, pinned to 0.12.6 in `migration/neovim-version`. Change that file
  to select another exact release; final setup applies the selection.
- Fish preserves theme handling, aliases/functions and private/local hooks;
  mise activates interactively and uses shims in noninteractive Fish scripts.
- Git retains signing, LFS, delta, rerere and CodeDiff. Set per-machine email in
  unmanaged `~/.config/git/local.gitconfig`, for example `[user]` followed by
  `email = mail@simonkrenn.dev`. Use the work address on the work machine and
  check `git config --show-origin --get user.email`.
- Yazi themes are vendored from an explicit commit with license/provenance under
  `migration/yazi/flavors`, allowing preview before any repository clone.
- One canonical tmux config uses Homebrew Fish. TPM setup uses an independent
  tmux server, leaving the existing server alone.
- Deployment uses copies. Edit checkout sources and reapply; transfer intentional
  runtime edits back first. Private Fish hooks and Git overrides stay unmanaged.
  OpenCode deploys individual files and leaves node_modules to npm, with lifecycle
  scripts disabled. Agent deployment targets only `~/.agents/skills`.
- Personal/work hosts currently share packages. Local overrides own identity;
  add explicit host profiles if package inventories need to differ.

## Optional integrations

`mise run setup:git-ai` explicitly opts into upstream Git AI v1.7.5 installation
and agent integration. It verifies the committed installer SHA-256 before running
it; this is not the unrelated `daidi/tap/git-ai`. Review a release and its checksum
before updating. fff-mcp uses Homebrew, so its curl installer is unnecessary.
OpenCode's enabled fff entry uses the executable on PATH. Configure Codex MCP
separately with the absolute `/opt/homebrew/bin/fff-mcp` path if needed.

App sign-in, 1Password authorization, Hammerspoon accessibility permissions,
Raycast imports and optional editor extensions remain user setup. Nix/Stow
uninstallation is a separate final migration step.

## Existing-machine handoff and recovery

Save the active Nix generation, login shell, package inventory, symlink ownership,
resolved generated configs and private files. Keep a filesystem backup and the
original checkout. For each target, remove its declaration from its current
manager and activate that change, or unstow its owning package. Recheck ownership
and move conflicting regular files into backup deliberately before preview/apply.
Verify replacement Fish before releasing the old login shell's package.

Recovery requires restoring saved files, links, manager declarations, login shell
and the Nix generation. Checking out main does not undo copies, packages or
preferences. Use a VM snapshot for complete trial rollback.

## Validation

Static inventory/runtime-lock parity, Bash/Git parsing, nine ownership/wrapper
regression tests, Fish syntax, package availability, and native bootstrap preview
are checked without applying to the live machine. Preview can warn that the
current Nix-owned global config target is untrusted; apply preflight refuses
that owner, and root/global tool parity is validated independently.

Full VM apply, repeat-run convergence, plugin downloads, Neovim startup and GUI
behavior remain unverified. Check mise doctor, runtimes outside the checkout,
noninteractive Fish, tmux splits, Git LFS/signing, Ghostty and Yazi in that test.

References: [Bootstrap](https://mise.jdx.dev/bootstrap.html),
[Homebrew packages](https://mise.jdx.dev/bootstrap/packages/brew.html),
[Dotfiles](https://mise.jdx.dev/dotfiles.html),
[Shell](https://mise.jdx.dev/bootstrap/shell.html).
