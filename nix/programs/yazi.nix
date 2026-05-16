{ pkgs, ... }:

let flavors =  pkgs.fetchFromGitHub {
  owner = "SimonKrenn";
  repo = "onehunter.nvim";
  rev= "main";
  sha256 = "sha256-WiJYbcQOpN8xcBUSOxAHSK/td4QaHm62nbyerHvebs0=";
};
in
{
  programs.yazi = {
    enable = true;
    settings = {
      mgr = {
        show_hidden = true;
      };
      opener = {
        edit = [
          {
            run = "$VISUAL $@"; 
            block = true; 
            for = "unix"; 
          }
        ];
      };
    };
    theme = {
      dark = "onehunter-dark";
      light = "onehunter-light";
    };
    flavors = {
      onehunter-dark = "${flavors}/extras/yazi/onehunter.yazi";
      onehunter-light = "${flavors}/extras/yazi/onehunter-light.yazi";
    };
  };
}
