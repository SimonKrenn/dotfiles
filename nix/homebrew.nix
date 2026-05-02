{
  homebrew = {
    enable = true;

    taps = [
      "homebrew/bundle"
      "homebrew/cask-fonts"
      "arl/arl"
      "max-sixty/worktrunk"
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
    ];

    casks = [
      "google-chrome"
      "visual-studio-code"
      "1password"
      "1password-cli"
      "obsidian"
      "jetbrains-toolbox"
      "raycast"
      "raindropio"
      "hammerspoon"
      "codex"
      "cryptomator"
      "ghostty"
      "yaak"
      "font-monaspice-nerd-font"
      "font-ia-writer-quattro"
      "font-geist-mono"
    ];
  };
}
