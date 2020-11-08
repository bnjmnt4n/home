{ pkgs, ... }:

{
  home.packages = with pkgs; [
    chromium
  ];

  programs.firefox = {
    enable = true;
    # TODO: use mainline pkgs.firefox.
    package = pkgs.firefox-wayland;
    # profiles = {
    #   default = {
    #     name = "default";
    #     userChrome = pkgs.lib.readFile ./firefox.userChrome.css;
    #   };
    # };
  };
}
