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

  imports =
    [(import ../../modules/daemons)] ++
    [(import ../../modules/desktop)] ++
    [(import ../../modules/dev)] ++
    [(import ../../modules/editors)] ++
    [(import ../../modules/programs)] ++
    [(import ../../modules/themes)];

  home.packages = with pkgs; [
    # Communication
    spotify
    discord
    slack

    # Media
    calibre
    mcomix3
    qbittorrent
    libreoffice

    # Gaming
    steam
    lutris
  ];



  # home.file.".doom.d" = {
  #   source ./doom.d;
  #   recursive = true;
  #   onChange = builtins.readFile ./doom.sh;
  # }

}
