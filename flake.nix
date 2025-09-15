{
  description = "Meine plattformübergreifende Nix-Konfiguration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    homeConfigurations."linux-user" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;

      # Hier importieren wir alle unsere Module
      modules = [
        # 1. Das Hauptmodul mit den globalen Einstellungen und der zentralen Dateiverwaltung
        ({ pkgs, ... }: {
          home.username = "dennis";
          home.homeDirectory = "/home/dennis";
          home.stateVersion = "23.11";

          # Globale Pakete, die zu keinem speziellen Modul gehören
          home.packages = [
            pkgs.ripgrep
          ];

          # Wichtige Grundeinstellungen
          programs.home-manager.enable = true;
          programs.bash.enable = true;

          # --- ZENTRALE DOTFILE-VERWALTUNG ---
          # Alles, was unter ~/.config leben soll

          xdg.configFile = {
            # nvim bleibt ein rekursives Verzeichnis
            "nvim" = {
              source = ./dotfiles/.config/nvim;
              recursive = true;
            };
            # wezterm ist jetzt eine einzelne Datei
            "wezterm.lua" = {
              source = ./dotfiles/.config/wezterm.lua;
            };
          };
          # Alles, was direkt im Home-Verzeichnis leben soll
          home.file = {
            ".tmux.conf" = {
              source = ./dotfiles/.tmux.conf;
            };
          };
        })

        # 2. Import der anwendungsspezifischen Module
        ./modules/neovim/default.nix
        ./modules/tmux/tmux.nix
        # Hier könnten wir ein ./modules/wezterm.nix hinzufügen, das nur `home.packages = [ pkgs.wezterm ];` enthält.
      ];
    };
  };
}

