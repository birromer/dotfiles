{ config, pkgs, ... }:

{
  # General configurations
  home = {
    username = "birromer";
    homeDirectory = "/home/birromer";
    stateVersion = "21.11";
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    htop
    gnome.gnome-tweaks
    gnomeExtensions.nordvpn-connect
    spotify
    discord
    thunderbird
    zathura
    vlc
    zotero
    qdirstat
    qbittorrent
    megasync
    flameshot
    slack
    i3status-rust
    i3lock-fancy
    neofetch
    xorg.xmodmap
    feh
    dunst
    redshift
    calibre
    mcomix3
    rofi
    pavucontrol
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
