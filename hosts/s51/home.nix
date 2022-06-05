{ config, lib, pkgs, user, ... }:

{
  # General configurations
  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
    stateVersion = "21.11";
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    spotify
    discord
    qbittorrent
    slack
    calibre
    mcomix3
    steam
    lutris
    starship
  ];

  # home.file.".doom.d" = {
  #   source ./doom.d;
  #   recursive = true;
  #   onChange = builtins.readFile ./doom.sh;
  # }

}
