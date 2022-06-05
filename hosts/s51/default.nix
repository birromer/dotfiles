# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  user = "birromer";

  custom_layout = pkgs.writeText "xkb-layout" ''
    keycode 91 = period period period periodcentered
    keycode 46 = l L NoSymbol NoSymbol bar
    keycode 45 = k K NoSymbol NoSymbol backslash
  '';

  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"

  '';

in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot = {
    # kernelPackages = pkgs.linuxPackages_latest;  # get latest kernel

    loader = {
      # enable grub
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 10;

      grub ={
        useOSProber = true;  # detect multiple operating systems
        configurationLimit = 3;
      };
    };
  };

  networking = {
    hostName = "s51";  # define hostname

    useDHCP = false;
    interfaces = {
      enp3s0.useDHCP = true;
      wlo1.useDHCP = true;
    };
  };

  # Network proxy configuration
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";


  # Everything that runs as a service
  services = {

    xserver = {
      enable = true;  # enable X11

      displayManager = {
        gdm.enable = true; 
        defaultSession = "gnome-xorg";
        sessionCommands = "${pkgs.xorg.xmodmap}/bin/xmodmap ${custom_layout}";
      };

      desktopManager.gnome.enable = true;

      windowManager.i3.enable = true;
      windowManager.i3.package = pkgs.i3-gaps;

      libinput.enable = true;  # enable touchpad support (enabled default in most desktopManager).

      videoDrivers = [ "nvidia" ];
    };

    blueman.enable = true;
   };

  hardware = {
    opengl.enable = true;

    nvidia = {
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;

      prime = {
        offload.enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  # Sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    emacs
    firefox
    nvidia-offload 
  ];

#  programs = {
#    steam.enable = true;
#    gamemode.enable = true;
#  };

  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

