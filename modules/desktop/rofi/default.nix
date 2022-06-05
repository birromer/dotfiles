{ config, lib, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    configPath = "onemon.rasi";
  };
}
