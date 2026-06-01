{ pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    package = if pkgs.stdenv.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;

    settings = {
      "font-family" = "MonaspiceNe Nerd Font";
      theme = "dark:onehunter-dark,light:onehunter-light";
      "font-size" = 14;
      "macos-icon" = "custom-style";
      "macos-icon-frame" = "plastic";
      "macos-icon-screen-color" = "E6B455";
      "macos-option-as-alt" = "left";
      keybind = [
        "alt+left=unbind"
      ];
      "background-opacity" = 0.9;
      "background-blur" = 80;
      "notify-on-command-finish" = "unfocused";
      "notify-on-command-finish-action" = "no-bell,notify";
      "desktop-notifications" = true;
      "bell-features" = "attention,title";
    };
    themes = {
      onehunter-dark = {
        background = "191d21";
        foreground = "e0e0e0";
        cursor-color = "e0e0e0";
        selection-background = "5c5c5c";
        palette = [
          "0=#191d21"
          "1=#F44747"
          "2=#5BD1B9"
          "3=#f9c35a"
          "4=#43AAF9"
          "5=#B480D6"
          "6=#71C6E7"
          "7=#e0e0e0"
          "8=#191d21"
          "9=#f4457d"
          "10=#B7F0E5"
          "11=#45505b"
          "12=#6182B8"
          "13=#EE808B"
          "14=#D7C9F0"
          "15=#e0e0e0"
        ];
      };
      onehunter-light = {
        background = "fff";
        foreground = "313131";
        cursor-color = "e0e0e0";
        selection-background = "71C6E7";
        palette = [
          "0=#191d21"
          "1=#F44747"
          "2=#5BD1B9"
          "3=#f9c35a"
          "4=#43AAF9"
          "5=#B480D6"
          "6=#71C6E7"
          "7=#e0e0e0"
          "8=#191d21"
          "9=#f4457d"
          "10=#B7F0E5"
          "11=#45505b"
          "12=#6182B8"
          "13=#EE808B"
          "14=#D7C9F0"
          "15=#e0e0e0"
        ];
      };
    };
  };
}
