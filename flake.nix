{ config, lib, pkgs, ... }:

{
  description = "minimal flake for my macos setup";

  inputs = {
    # monorepo with all derivations for building sw
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # manage and generate configurations in home dir
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # manage system level software
    darwin = {
      url = "github:lnl7/nix-darwin";
      darwin.inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # function with inputs as parameters
  outputs = inputs @ { nixpkgs, home-manager, darwin, ... }: {
    darwinConfigurations.MBP = inputs.darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      pkgs = import inputs.nixpkgs { system = "aarch64-darwin"; };
      modules = [
        # accepts pkgs and whatever else is passed to the function
        ({ pkgs, ... }: {
          programs.zsh.enable = true;
          environment = {
            shells = [ pkgs.bash pkgs.zsh ];
            loginShell = pkgs.zsh;
            systemPackages = [ pkgs.coreutils ];
            systemPath = [ "/opt/homebrew/bin" ];
            pathsToLink = [ "/Applications" ];
          };
          nix.extraOptions = "experimental-features = nix-command flakes";
          system.keyboard.enableKeyMapping = true;
          fonts = {
            fontDir.enable = false;  # disable if installed fonts outside
            fonts.fonts = [ pkgs.nerdfonts ];
          };
          services.nix-daemon.enable = true;
          system.defaults = {
            finder = {
              AppleShowAllExtensions = true;
              _FXShowPosixPathInTitle = true;
            };
            dock.autohide = true;
            NSGlobalDomain = {
              AppleShowAllExtensions = true;
              InitialKeyRepeat = 14;
              KeyRepeat = 1;
            };
          };

          # backwards compat; don't change
          system.stateVersion = 4;
          homebrew = {
            enable = true;
            caskArgs.no_quarantine = true;
            global.brewfile = true;
            masApps = { };
            casks = [
              "dropbox"
              "firefox"
              "flameshot"
              "font-hack-nerd-font"
              "font-inconsolata-lgc-nerd-font"
              "font-mononoki"
              "inkscape"
              "megasync"
              "sage"
              "spotify"
              "stats"
              "thunderbird"
              "vlc"
            ];
            taps = [
              "koekeishiya/formulae"
              "zegervdv/zathura"
              "felixkratz/formulae"
              "d12frosted/emacs-plus"
            ];
            brews = [
              "emacs-plus"
              "sketchybar"
              "zathura"
              "girara"
              "zathura-pdf-poppler"
            ];
          };

        })
      ];
    };
  };
}
