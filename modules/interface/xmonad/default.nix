{ config, lib, pkgs, user, home-manager, ... }:

{
  home.packages = with pkgs; [
    playerctl
    system-config-printer
    xautolock
    xorg.xbacklight
  ];

  xsession.windowManager.xmonad = {
    enableContribAndExtras = true;
#    config = "xmonad.hs";
  };
}
