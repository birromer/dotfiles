{ config, lib, pkgs, user, ... }:

{
  # Import home-manager modules
  # imports =
  #   [(import ../modules/daemons)] ++
  #   [(import ../modules/desktop)] ++
  #   [(import ../modules/editors)] ++
  #   [(import ../modules/hardware)] ++
  #   [(import ../modules/programs)] ++
  #   [(import ../modules/shell)] ++
  #   [(import ../modules/themes)];

  # General configurations
  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
    stateVersion = "21.11";
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    htop
    gnome.gnome-tweaks
    gnomeExtensions.nordvpn-connect
    i3status-rust
    i3lock-fancy
    thunderbird
    zathura
    vlc
    zotero
    qdirstat
    megasync
    flameshot
    neofetch
    xorg.xmodmap
    feh
    dunst
    redshift
    rofi
    pavucontrol
    starship
  ];


}
