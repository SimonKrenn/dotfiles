{ ... }:
{
  programs.git = {
    enable = true;

    signing = {
      format = "ssh";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKOZCQsHAYrEv2BzBLelFzdSX9aVx0sgXZBxdhS9Ojam";
      signByDefault = true;
      signer = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
    };

    lfs.enable = true;

    settings = {
      user.name = "Simon Krenn";
      core.pager = "delta";
      merge.conflictStyle = "zdiff3";
      rerere.enabled = true;
      merge.tool = "codediff";
      mergetool.codediff.cmd = ''nvim "$MERGED" -c "CodeDiff merge \"$MERGED\""'';
      diff.tool = "codediff";
      difftool.codediff.cmd = ''nvim "$LOCAL" "$REMOTE" +"CodeDiff file $LOCAL $REMOTE"'';
    };
  };
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
    };
  };
}
