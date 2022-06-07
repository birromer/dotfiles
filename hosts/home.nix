{ config, lib, pkgs, user, ... }:

{
  # Import home-manager modules
  imports =
    (import ../modules/apps)     ++
    (import ../modules/desktop)  ++
    (import ../modules/daemons)  ++
    (import ../modules/dev)      ++
    (import ../modules/hardware);

  # General configurations
  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
    stateVersion = "21.11";
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  home = {
    packages = with pkgs; [
      cmake
      pandoc
      htop
      gnome.gnome-tweaks
      megasync
      flameshot
      neofetch
      xorg.xmodmap
      feh
      dunst
      redshift
      pavucontrol
      starship
    ];

    pointerCursor = {
      name = "Dracula-cursors";
      package = pkgs.dracula-theme;
      size = 16;
    };
  };

  gtk = {                                     # Theming
    enable = true;
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "JetBrains Mono Medium";
    };
  };
}
