# modules/neovim/default.nix
{ pkgs, ... }:

{
  # 1. Pakete, die für die Neovim-Konfiguration benötigt werden
  home.packages = [
    pkgs.neovim
    pkgs.git
  ];

  # 2. Die LazyVim Starter-Konfiguration klonen
  home.file.".config/nvim" = {
    source = pkgs.fetchFromGitHub {
      owner = "LazyVim";
      repo = "starter";
      rev = "main";
      # Wir verwenden einen leeren Hash, damit Nix uns den richtigen gibt.
      hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    };
    recursive = true;
  };
}

