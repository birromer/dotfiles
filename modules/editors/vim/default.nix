{ config, lib, pkgs, ... }:

{
  programs.vim = {
    enable = true;

    plugins = with pkgs.vimPlugins; [
      i3-vim-syntax
      vim-nix
      vim-markdown
      vim-cpp-enhanced-highlight
    ];

    settings = {
      nocompatible = true;
      syntax     = true;
      encoding   = "utf-8";
      number     = "relativenumber";
      cursorline = true;
      expandtab  = true;
      tabstop    = 4;
      shiftwidth = 4;
      autoindent = 4;
      foldenable = true;
      foldmethod = "syntax";
      foldlevel  = 10000;
    };


  };
}
