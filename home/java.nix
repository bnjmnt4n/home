{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    jetbrains.idea-community
    openjdk11
  ];
}
