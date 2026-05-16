{ ... }:
{
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        showFileIcons = true;
        showIcons = true;
        nerdFontsVersion = "3";
      };
      git = {
        pagers = [
          {
            pager = "delta --paging=never";
            colorArg = "always";
          }
        ];
      };
    }; 
  };
}
