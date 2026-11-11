# Migrating this dotfiles repository to mise

Investigated 2026-11-11 against the repository, live configuration link targets,
installed mise 2026.10.25, and current official documentation.

## Implementation status

The first repository migration phase is implemented. The root `mise.toml` now
declares machine packages, dotfile deployment, preferences, and setup tasks.
Native Fish, Git, lazygit, tmux, Obsidian paths, and Yazi assets are reconciled;
the global mise config pins the existing installed runtime versions. Root
`setup.sh` previews by default and provides backup and apply modes.

`simon-mac-mise` and `work-mise` are opt-in Nix outputs for releasing Home Manager
file ownership while retaining system packages. The preflight rejects live
deployment until the ownership handoff is complete. No live handoff, package
installation, shell change, or Nix removal has been performed.

Validation passed for temporary deployment and a second unchanged apply, backup
creation, syntax checks, package metadata dry runs, and evaluation of the personal
Nix handoff system derivation. Full interactive application testing and actual
package installation remain pending. Kaset's tap definition requires Ruby 3 or
newer; the setup wrapper selects Homebrew Ruby. See the root `README.md` for the
current commands and migration sequence. The sections below record the initial
investigation and recommendations.

## Recommendation

Use mise as the entry point for machine setup, dotfile deployment, development
tools, and repeatable setup tasks. Replace Stow, Home Manager, and nix-darwin in
stages. Keep ordinary application configuration files in Git.

For the first migration, keep Homebrew for applications, Fish, Git, tmux, native
libraries, and packages with integration requirements. Move standalone development
tools to mise selectively. Removing Nix and moving every package at once would
make failures harder to diagnose.

This is feasible with your installed mise: `mise bootstrap` and `mise dot` are
already available. Bootstrap covers packages, repositories, dotfiles, shell setup,
macOS preferences, and custom tasks. [Bootstrap documentation](https://mise.jdx.dev/bootstrap.html)

## What exists today

| Layer | Repository evidence | Migration destination |
| --- | --- | --- |
| Legacy installation | `setup.sh`, `.macos/install.sh`, `.macos/Brewfile` | Small installer plus mise bootstrap |
| File deployment | `.config/stow.sh` | Explicit mise `[dotfiles]` entries |
| System packages | `nix/modules/darwin.nix` | Homebrew initially; selected mise tools later |
| Applications and fonts | `nix/modules/homebrew.nix`, `.macos/Brewfile` | One reconciled package manifest |
| Generated user config | `nix/modules/home.nix`, `nix/programs/*.nix` | Native config files deployed by mise |
| macOS preferences | `.macos/os-defaults.sh`, `nix/modules/darwin.nix` | Bootstrap macOS defaults plus a small task |
| Language/tool versions | `.config/mise/config.toml` | Retain and expand global mise configuration |
| Nix installation | `scripts/bootstrap.sh`, `flake.nix` | Retire after replacement validation |

The live machine is using Home Manager links into `/nix/store`, including Fish,
Git, Ghostty, lazygit, Yazi, tmux, Neovim, Hammerspoon, and mise itself. Some are
whole-directory links; others are individual files inside real directories.
Replacing only Stow would leave the active Nix ownership intact.

The existing mise config declares fnox, Go, Node 22.15.0, OpenCode, and Rust.
Except for Node, these use `latest`. That is not equivalent to a pinned Nix
flake. Preserve versions during the initial migration and commit a mise lockfile
for supported tool/platform resolutions. System packages need their own update
policy; the tool lockfile does not lock macOS applications or native libraries.
[Tool versions and lockfiles](https://mise.jdx.dev/getting-started.html)

## Problems to resolve before applying

1. **Two configuration sources have drifted.** Export and compare the live
   Home Manager output with `.config/`; choose the desired result explicitly.
   Git's checked-in native config has a work email, while the personal Nix host
   supplies a personal email. The Nix Git module also adds CodeDiff settings.
   Preserve SSH signing through 1Password and Git LFS installation/integration.
2. **Fish needs consolidation.** The native config contains paths for an old
   username and Bob; the Nix config contains `/run/current-system/sw/bin`.
   Neither checked-in Fish entry point contains `mise activate fish`. Preserve
   the theme functions, aliases, `ya`/OpenCode helpers, completion, and local
   override files when creating the replacement. Audit live Fish snippets too.
3. **tmux has a Nix shell dependency.** `.config/tmux/.tmux.conf` sets
   `/etc/profiles/per-user/simonkrenn/bin/fish`. Replace it with the stable
   Homebrew Fish path before retiring Nix. Keep both the legacy `~/.tmux.conf`
   location and modern config lookup in mind; choose one entry point.
4. **Generated assets must be retained.** The Nix Yazi module fetches Onehunter
   flavors; native theme files alone do not provide those directories. Preserve
   the flavors at a pinned revision and reconcile their names. Export lazygit
   settings and compare Ghostty themes as well.
5. **Package declarations disagree.** OpenCode is declared in both Homebrew and
   mise. Cargo comes from Nix while Rust is in mise. Neovim currently depends
   on Bob in the legacy setup. Choose one owner per executable. Account for
   implicit Home Manager dependencies such as Git LFS and direnv, plus jq used
   by shell helpers and Bun used by setup.sh.
6. **Old setup scripts are unreliable migration entry points.** `setup.sh` mixes
   Bash and Fish syntax and calls Fish scripts with `sh`; `scripts/bootstrap.sh`
   has `#!/user/bin/env bash`, requires an unchecked positional argument, and
   exits when its target directory already exists. Its advertised `work` flake
   target also points at a host directory that does not exist (`darwin-work`
   exists instead).
7. **Do not deploy local application state.** OpenCode has local dependencies
   and a Stow exclusion. mise needs its own exclusions; do not assume it reads
   `.stow-local-ignore`. Keep credentials, private Fish files, databases, and
   generated dependency directories outside deployment and shared history.

## Proposed configuration ownership

- **mise `[tools]`:** keep the existing runtimes; consider Bun, jq, ripgrep, fd,
  bat, fzf, starship, zoxide, lazygit, lazydocker, atuin, Yazi, ast-grep, delta,
  hyperfine, rtk, and television. These names appear in the installed registry.
  Registry availability still needs installation and integration validation.
- **Machine packages:** Fish, Git/Git LFS, tmux, Docker CLI, native libraries,
  compilers, GUI applications, fonts, and initially tap-specific utilities.
  Keep Bob initially or deliberately replace it with mise's Neovim tool.
- **mise dotfiles:** explicit links for each application's files. Prefer
  `symlink-each` where directories also contain local files, especially Fish
  and OpenCode. Whole-directory links suit config-only trees such as Neovim,
  after checking for local state.
- **mise tasks/repos:** TPM checkout, Fisher installation/plugin update,
  external assets, and remaining installers. Make every task safe to rerun;
  keep lazy.nvim, Fisher, and TPM responsible for their plugins.

mise distinguishes machine-wide `[bootstrap.packages]` from per-directory
versioned `[tools]`. Formulae and casks can be declared with `brew:` and
`brew-cask:`. Initially retaining `brew bundle` as a task is also reasonable,
especially for third-party taps. [Package model](https://mise.jdx.dev/bootstrap/packages/)

The built-in brew installer does not require the Homebrew CLI on supported
platforms, but it implements installation itself. Third-party Ruby formulae can
use unsupported features. Validate your taps before replacing `brew bundle`;
there is no need to remove Homebrew to remove Nix.
[Homebrew integration](https://mise.jdx.dev/bootstrap/packages/brew.html)

## Repository layout

Keep `.config/` as the native config source. Use a root `mise.toml` for machine
bootstrap and dotfile paths, and `.config/mise/config.toml` for global tools that
must work outside the dotfiles checkout. Avoid duplicating the same tool list
in both. A root `mise.work.toml` can hold work-specific bootstrap overrides;
global `config.work.toml` can hold global work overrides. Select the environment
consistently with `-E work` or `MISE_ENV`.

This avoids moving the entire repository into `~/.config/mise` and avoids having
a symlinked global config depend accidentally on the command's current directory.
Do not deploy the bootstrap directory itself over the global mise config.

For a root `mise.toml`, representative entries are:

```toml
[dotfiles]
"~/.config/nvim" = { source = ".config/nvim", mode = "symlink" }
"~/.config/fish" = { source = ".config/fish", mode = "symlink-each", exclude = ["private-alias.fish", "local.fish"] }
"~/.config/tmux/tmux.conf" = { source = ".config/tmux/.tmux.conf", mode = "symlink" }
"~/.config/opencode" = { source = ".config/opencode", mode = "symlink-each", exclude = ["node_modules", ".stow-local-ignore"] }

[bootstrap.user]
login_shell = "/opt/homebrew/bin/fish"

[bootstrap.macos.defaults."com.apple.finder"]
ShowPathbar = true
ShowStatusBar = true
```

This illustrates the layout, not a complete or ready-to-apply migration config.
Additional files, package declarations, and corrected native configs are required.
The Fish path assumes your current Apple Silicon Mac. Put mise activation in the
source Fish configuration, after mise is available on PATH; avoid separately
editing the same file through bootstrap shell activation.

`symlink-each` preserves unrelated target files. Existing links pointing elsewhere
can be repointed without `--force`, including Home Manager links. Therefore a
normal apply is already an ownership change. Inspect the preview and finish the
Nix ownership handoff first. [Deployment behavior](https://mise.jdx.dev/dotfiles/managed.html)

## Migration sequence

1. **Capture the baseline.** Record package versions, active configs, link targets,
   current login shell, Nix generation, and Homebrew inventory. Back up both the
   links and dereferenced file contents, plus local files outside Git.
2. **Prepare native configuration.** Reconcile exported Nix output with `.config/`;
   fix paths and identities; preserve Yazi assets and plugin setup. Keep work and
   personal identity overrides separate from shared defaults.
3. **Install replacements alongside Nix.** Use the already installed Homebrew
   mise, install stable Fish/Git/tmux and required packages, then verify their
   absolute paths. Pin the initial runtime versions rather than upgrading during
   the cutover. Ensure native compile dependencies are present.
4. **Preview in isolation.** First test dotfile deployment to temporary targets.
   Preview the complete proposed setup with `mise bootstrap --dry-run`; use
   `mise dot diff` and `mise dot apply --dry-run` for deployment review. Test work
   and personal environments separately.
5. **Transfer ownership.** Keep a working terminal open. Remove migrated file
   declarations from Home Manager and activate that transition while Nix remains
   installed. Preserve any live edits before activation. Then deploy the native
   replacements with mise. Stop running the old Stow installer.
6. **Validate a new login session.** Check executable origins and versions, Fish
   startup, mise project switching, signed Git operations and LFS, Neovim,
   tmux panes, Ghostty appearance switching, Yazi flavors, Hammerspoon, and local
   overrides. Confirm none of the migrated programs require a Nix path.
7. **Retire Nix last.** First validate a clean-machine or separate-account
   bootstrap. Remove nix-darwin/Home Manager activation and Nix-specific shell
   hooks only once replacements work. Handle Determinate Nix removal separately
   after checking for other projects that still use it. Keep the old Git revision
   and Nix generation available through the transition.

mise can set the login shell and register it in `/etc/shells`; this may require
system authentication. Keep the login shell in a stable machine package location.
[Shell setup](https://mise.jdx.dev/bootstrap/shell.html)

This trades Nix's pinned package graph and generations for simpler native files,
tool locks, and package-manager updates. Rollback needs the saved file baseline
and package inventory as well as Git; changing the config back does not by itself
downgrade every machine package.

## Validation performed

- Confirmed the installed binary exposes bootstrap and dotfile commands.
- Inspected live link targets to establish current Home Manager ownership.
- Queried the installed mise registry for candidate tool names.
- In `/private/tmp/mise-migration-investigation`, applied a `symlink-each`
  declaration to temporary targets and verified the created symlink. A second
  dry run reported all files applied.
- Dry-ran a temporary bootstrap declaration containing dotfiles, a Finder
  preference, and the stable Homebrew Fish login shell. All sections parsed;
  the preference and shell already matched this machine.

No real dotfiles, login shell, preferences, or installed packages were changed.
Package installation, full parity, and fresh-machine bootstrap remain untested.
