{ config, lib, pkgs, ... }:

{
  imports = [
    ../../home/base.nix
    ../../home/graphical.nix
    ../../home/java.nix
    # ../../home/r.nix
  ];

  # TODO: remove?
  home.username = "bnjmnt4n";
  home.homeDirectory = "/home/bnjmnt4n";

  # Miscellaneous/temporary packages.
  home.packages = with pkgs; [
    discord
    # musescore
    # octave
    teams
  ];
}
