# modules/neovim/default.nix
{ pkgs, ... }:

{
  home.packages = [
    pkgs.neovim
    pkgs.git
  ];

  home.file.".config/nvim" = {
    # KORREKTUR: Wir müssen zwei Ebenen nach oben (aus /neovim und aus /modules)
    source = ../../dotfiles/nvim; 
    recursive = true;
  };
}

