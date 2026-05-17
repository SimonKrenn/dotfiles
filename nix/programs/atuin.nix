{ ... }:
{
  programs.atuin = {
    enable = true;
    settings = {
      enter_accept = false;
      keymap_mode = "vim-normal";
      inline_height = 40;
    };
  };
}
