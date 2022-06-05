{ config, pkgs, home-manager, ... }:

{
  home.file.".doom.d" = {                       # Get Doom Emacs
    source = ./doom.d;                          # Sets up symlink name ".doom.d" for file "doom.d"
    recursive = true;                           # Allow symlinking a directory
    onChange = builtins.readFile ./doom.sh;     # If an edit is detected, it will run this script. Pretty much the same as what is now in default.nix but actually stating the terminal and adding the disown flag to it won't time out
  };

  programs = {
    emacs.enable = true;                        # Get Emacs
  };

  home.packages = with pkgs; [
    ripgrep
    coreutils
    fd
  ];
}
