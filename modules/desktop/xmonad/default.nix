{ config, lib, pkgs, user, home-manager, ... }:

{
  home.packages = with pkgs; [
    playerctl
    system-config-printer
    xautolock
    xorg.xbacklight
    xmonad
    xmobar
  ];

  xsession.windowManager.xmonad = {
    enable = true;

  }
}
