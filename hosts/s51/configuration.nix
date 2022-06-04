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
    # wireless.enable = true;  # enables wireless support via wpa_supplicant
    # networkmanager.enable = true;
  };

  time.timeZone = "Europe/Paris";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking = {
    useDHCP = false;

    interfaces = {
      enp3s0.useDHCP = true;
      wlo1.useDHCP = true;
    };
  };

  # Network proxy configuration
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Internationalisation properties
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "pt_BR.UTF-8";
      LC_MONETARY = "pt_BR.UTF-8";
    };
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "br-abnt";
  };

  # Everything that runs as a service
  services = {

    xserver = {
      enable = true;  # enable X11

      displayManager = {
        gdm.enable = true; 
        defaultSession = "gnome";
        sessionCommands = "${pkgs.xorg.xmodmap}/bin/xmodmap ${custom_layout}";
      };

      desktopManager.gnome.enable = true;

      windowManager.i3.enable = true;

      layout = "br";  # keymap

      libinput.enable = true;  # enable touchpad support (enabled default in most desktopManager).

 #      videoDrivers = [ "nvidia" ];
    };

    printing.enable = true;  # CUPS to print documents

    openssh.enable = true;  # Enable the OpenSSH daemon
   };

  # Sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;
#   hardware.nvidia.modsetting.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim 
    git
    emacs
    zsh
    wget
    tmux
    ranger
    firefox
  ];

  programs = {
    mtr.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    zsh = {
      enable = true;
      ohMyZsh.enable = true;
    };
  };

  # gtk = {
  #   enable = true;
  #   theme = {
  #     name = "Dracula";
  #     package = pkgs.dracula-theme;
  #   };
  #    cursorTheme = {
  #      name = "Dracula-cursors";
  #      package = pkgs.dracula-theme;
  #      size = 16;
  #    };
  #   iconTheme = {
  #     name = "Papirus-dark";
  #     package = pkgs.papirus-icon-theme;
  #   };
  # };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # nix = {
  #   settings.auto-optimise-store = true;

  #   gc = {
  #     automatic = true;
  #     dates = "weekly";
  #     options = "--delete-older-than 15d";
  #   };
  # };

  # Define user accounts
  users = {
    defaultUserShell = pkgs.zsh;

    users.${user} = {
      isNormalUser = true;
      initialPassword = "nixos";
      extraGroups = [ "wheel" ];  # enables ‘sudo’
    };
  };

  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

