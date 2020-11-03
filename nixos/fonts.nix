{ pkgs, ... }:

{
  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      ia-writer-duospace
      inter
      iosevka
      libre-baskerville
      nerdfonts
      source-code-pro
      source-sans-pro
      source-serif-pro
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
      monospace = [ "Source Code Pro" ];
      sansSerif = [ "Source Sans Pro" ];
      serif = [ "Source Serif Pro" ];
      };
    };
  };
}
