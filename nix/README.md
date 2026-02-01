# Nix migration

This directory holds the parallel Nix setup used to migrate from stow.

## Bootstrap

Replace placeholder hostnames and usernames in `nix/hosts/*.nix`.

### macOS (nix-darwin)

```sh
darwin-rebuild switch --flake .#work-mac
```

### Linux (standalone Home Manager)

```sh
home-manager switch --flake .#linux-laptop
```

## Secrets overlay

Optional private modules live in `nix/secrets/` and are git-ignored.
Create `nix/secrets/work.nix` or `nix/secrets/personal.nix` to extend the
corresponding host config.

Example overrides:

```nix
{ lib, ... }:
{
  networking.hostName = "my-private-hostname";
  home.username = "my-user";
  home.homeDirectory = "/Users/my-user";
}
```
