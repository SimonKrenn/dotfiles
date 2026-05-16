{pkgs, ...} : {
  nix.settings.experimental-features = "nix-command flakes";
  ## turn off nix-darwin management of nix because determinate-nix uses its own daemon
  nix.enable = false;

  system.primaryUser = "simonkrenn";

  users.users.simonkrenn = {
      name = "simonkrenn";
      home = "/Users/simonkrenn";
      shell = pkgs.fish;
  };

  environment.systemPackages = with pkgs; [
    git
    tmux
    fish
    bat
    gh
    glab
    starship
    fzf
    mise
    lazygit
    ast-grep
    eza
    stow
    yazi
    zoxide
    fd
    ripgrep
    btop
    atuin
    chafa
    resvg
    delta
    git-filter-repo
    lazydocker
    sesh
    gcc
    rtk
    erdtree
    hyperfine
    libiconv
    cargo
  ];
  
  programs.fish.enable = true;
  system.stateVersion = 5;
}
