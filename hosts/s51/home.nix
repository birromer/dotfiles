{ config, lib, pkgs, user, home-manager, ...}:

{
  # General configurations
  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
    stateVersion = "21.11";
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

#  environment.pathsToLing = [ "/libexec" ];

  home.packages = with pkgs; [
    # Communication
    spotify
    discord
    slack
    gnomeExtensions.nordvpn-connect
    thunderbird

    # Media
    calibre
    mcomix3
    qbittorrent
    libreoffice
    zathura
    vlc
    zotero
    qdirstat

    # Gaming
    steam
    lutris

    # Desktop
    i3status-rust
    i3lock
    i3lock-fancy
    i3blocks
    rofi
    dmenu
  ];

  programs = {
    rofi.enable = true;
  };


  # home.file.".doom.d" = {
  #   source ./doom.d;
  #   recursive = true;
  #   onChange = builtins.readFile ./doom.sh;
  # }

}
