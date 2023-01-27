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

          inputs.home-manager.darwinModules.home-manager {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.bernardo.imports = [
                ({ pkgs, ... }: {
                  # don't change this when you change package input
                  home.stateVersion = "22.11";
                  # home-manager configurations
                  home.packages = [
                    pkgs.ripgrep
                    pkgs.fd
                    pkgs.curl
                    pkgs.less
                    inputs.pwnvim.packages."aarch64-darwin".default
                  ];
                  # home.sessionVariables = {
                  #   PAGER = "less";
                  #   CLICLOLOR = 1;
                  #   EDITOR = "nvim";
                  # };
                  programs = {
                    bat = {
                      enable = true;
                      config.theme = "TwoDark";
                    };
                    fzf = {
                      enable = true;
                      enableZshIntegration = true;
                    };
                    exa.enable = true;
                    git.enable = true;
                    zsh = {
                      enable = true;
                      enableCompletion = true;
                      enableAutosuggestions = true;
                      enableSyntaxHighlighting = true;
                      shellAliases = {
                        ls = "ls --color=auto -F";
                        la = "ls -a";
                        ll = "ls -l";
                        kakapo = "curl parrot.live";
                      };
                    };
                    starship = {
                      enable = true;
                      enableZshIntegration = true;
                    };
                  };
                  home.file.".inputrc".text = ''
                    set show-all-if-ambiguous on
                    set completion-ignore-case on
                    set mark-directories on
                    set mark-symlinked-directories on
                    set match-hidden-files off
                    set visible-stats on
                    set keymap vi
                    set editing-mode vi-insert
                  '';
                })
              ];
            };
          }
        })
      ];
    };
  };
}
