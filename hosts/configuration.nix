# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, inputs, user, ... }:

{
  # imports =
  #   [
  #     ./hardware-configuration.nix
  #   ];

  # Internationalisation properties
  time.timeZone = "Europe/Paris";

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

  # Everything that runs as a service in all computers
  services = {
    xserver = {
      layout = "br";  # keymap
      libinput.enable = true;  # enable touchpad support (enabled default in most desktopManager).
    };

    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
    };

    pulse.enable = true;

    printing.enable = true;  # CUPS to print documents

    openssh.enable = true;  # Enable the OpenSSH daemon
  };

  sound = {
    enable = true;
    mediakeys.enable = true;
  };

  hardware.

  # Fonts
  fonts.fonts = with pkgs; [
    source-code-pro
    font-awesome
    corefonts
    siji
  ];

  # Define user accounts
  users.users.${user} = {
    isNormalUser = true;
    initialPassword = "nixos";
    extraGroups = [ "wheel" "video" "audio" "camera" "networkmanager" ];
    shell = pkgs.zsh;
  };

  # Always enable flakes and garbage collection
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';

    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 15d";
    };
  };

  # List packages installed in system profile
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    vim
    nano
    emacs
    zsh
    wget
    alacritty
    tmux
    ranger
    usbutils
    pciutils
  ];

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    zsh = {
      enable = true;
      ohMyZsh.enable = true;
    };
  };

  environment = {
    variables = {
      TERMINAL = "alacritty";
      EDITOR = "vim";
      VISUAL = "vim";
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

