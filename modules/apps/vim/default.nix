{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      vim-nix
      vim-markdown
      nerdtree
      auto-pairs
      vim-lastplace
      wombat256-vim
      srcery-vim
      lightline-vim
      indent-blankline-nvim
    ];

    extraConfig = ''
      set nocompatible true
      set syntax     true
      set encoding   utf-8
      set number     relativenumber
      set cursorline true
      set expandtab  true
      set tabstop    4
      set shiftwidth 4
      set autoindent 4
      set foldenable true
      set foldmethod syntax
      set foldlevel  10000
    '';

  };
}
