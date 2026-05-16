{
  homebrew = {
    enable = true;

    taps = [
      "homebrew/bundle"
      "homebrew/cask-fonts"
      "arl/arl"
      "max-sixty/worktrunk"
      "sozercan/repo"
    ];

    brews = [
      "bob"
      "docker"
      "fisher"
      "gitmux"
      "mole"
      "opencode"
      "wakatime-cli"
      "wt"
      "trufflehog"
    ];

    casks = [
      "google-chrome"
      "1password"
      "1password-cli"
      "obsidian"
      "raycast"
      "raindropio"
      "hammerspoon"
      "cryptomator"
      "ghostty"
      "yaak"
      "font-monaspice-nerd-font"
      "font-ia-writer-quattro"
      "font-geist-mono"
      "kaset"
    ];
  };
}
