{ pkgs, ... }:

{
  # Fast terminal emulator.
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";

      font = {
        normal.family = "Iosevka Term";
        size = 14;
      };

      window.padding = {
        x = 5;
        y = 5;
      };

      # Modus Operandi theme
      colors = {
        primary = {
          background = "#ffffff";
          foreground = "#000000";
        };
        normal = {
          black   = "#000000";
          red     = "#a60000";
          green   = "#005e00";
          yellow  = "#813e00";
          blue    = "#0031a9";
          magenta = "#721045";
          cyan    = "#00538b";
          white   = "#bfbfbf";
        };
        bright = {
          black   = "#595959";
          red     = "#972500";
          green   = "#315b00";
          yellow  = "#70480f";
          blue    = "#2544bb";
          magenta = "#5317ac";
          cyan    = "#005a5f";
          white   = "#ffffff";
        };
      };
    };
  };
}
