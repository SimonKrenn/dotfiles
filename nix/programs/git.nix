{ ... }:
{
  programs.git = {
    enable = true;
    userName = "Simon Krenn";

    signing = {
      format = "ssh";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKOZCQsHAYrEv2BzBLelFzdSX9aVx0sgXZBxdhS9Ojam";
      signByDefault = true;
      signer = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
    };

    delta = {
      enable = true;
      options = {
        navigate = true;
      };
    };

    lfs.enable = true;

    extraConfig = {
      interactive = {
        diffFilter = "delta --color-only";
      };

      merge = {
        conflictStyle = "zdiff3";
      };

      rerere = {
        enabled = true;
      };
    };

    settings = {
      core = {
        pager = "delta";
      };
    };
  };
}
