# Dotfiles

macOS dotfiles managed by mise. Native configuration lives in `.config/`;
`mise.toml` declares machine packages, links, preferences, and plugin setup.
`.config/mise/config.toml` is the single source for global development tool pins.

## Preview

On Apple Silicon macOS, install Command Line Tools, Homebrew, mise, and Python
3.11 or newer and Ruby 3 or newer (`brew install mise python@3.13 ruby`).
Ruby is needed to evaluate the Kaset third-party cask; the wrapper selects
Homebrew Ruby before Apple’s older system Ruby. Clone this repository, then run:

```sh
./setup.sh --dry-run
```

The preview does not install packages or change your configuration. Review it
before applying. This repository includes personal identity and application
choices; adapt those before using it on a different person's machine.

## Migrate an existing Nix machine

Keep an existing terminal session open throughout the handoff.

1. Run `./setup.sh --backup`. This records original symlinks, readable contents,
   and package inventories under `~/.local/state/dotfiles/backups/`. Backups may
   contain private local files; keep them private and outside this repository.
2. Activate the handoff output, which removes Home Manager's user configuration
   declarations while keeping Nix system packages available:

   ```sh
   sudo darwin-rebuild switch --flake .#simon-mac-mise
   # Work host: use .#work-mise instead.
   ```

   The new files must be visible to Nix flakes: review and `git add` the changes
   before rebuilding. Staging is sufficient; committing is optional.
3. Run `./setup.sh --apply`. The preflight refuses deployment while configured
   targets are still declared by the active Home Manager generation, or their
   ownership cannot be verified. Links left behind by older generations are
   allowed only after checking they are absent from the current manifest. A second backup is taken before mise
   installs the packages, deploys configs, sets preferences and the login shell,
   and installs shell/tmux plugin managers. It does not upgrade existing packages
   unless explicitly requested. Real files that conflict with links require
   reconciliation; inspect them instead of using a blanket force flag.
4. Open a new terminal. Check `mise doctor`, tool versions and `command -v`,
   Fish startup, Git SSH signing/LFS, Neovim, tmux, Yazi themes, and Hammerspoon.
   In tmux, use prefix + I to install missing TPM plugins.

Keep using the `*-mise` output during the transition. Rebuilding the old output
would reclaim the same configuration paths. Nix remains installed for rollback
and any projects that depend on it; retire it only after the new setup has been
validated. The previous `setup.sh`, Stow script, and Brewfile are legacy paths;
use mise for all new setup. `.macos/Brewfile` is retained as a compatibility
projection, and does not declare mise-owned runtimes or OpenCode.

To recover, keep mise from applying again, restore the saved files/links from
`original/` using `manifest.json` (remove targets marked `missing`), and reactivate
the previous Nix generation. `contents/` contains dereferenced copies if the old
store paths are unavailable. Review each restore before replacing local edits.
Package downgrades are separate from file restoration.

## New machine

After reviewing the package list and identity settings, run `./setup.sh --apply`.
No Nix installation or Stow run is required. Applications can require first-launch
permissions or sign-in. Docker installs the CLI; select a container runtime
separately if one is needed.

## Local configuration

Fish loads `~/.config/fish/private-alias.fish` and `local.fish` last. These files
are ignored by Git and excluded from deployment. `~/.config/git/local.conf` holds
local Git overrides. Git defaults to the personal identity and uses `work.conf`
for repositories under `~/workspace/work/`; change that include condition or set
an explicit repository-local email if your work checkouts live elsewhere.

The initial mise pins preserve installed versions; Bun is added at its already
installed version. Homebrew supplies stable machine tools, including Neovim,
Fish, Git, and tmux. Bob, Nix Cargo, Homebrew runtimes, and Homebrew OpenCode are
not declared by the new manifest. Existing duplicate installs are left in place
until their consumers are verified; no package pruning is run.

The Yazi flavors are vendored from the deployed snapshot rather than linked to a
user-specific checkout. See `mise/MIGRATION.md` for the initial investigation.
