# modules/neovim/default.nix
{ pkgs, ... }:

{
  home.packages = [
    pkgs.neovim
    pkgs.git
  ];

}

