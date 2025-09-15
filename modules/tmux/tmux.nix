# modules/tmux/tmux.nix
{ pkgs, ... }:

{
  # 1. Benötigte Pakete installieren
  home.packages = [
    pkgs.tmux
    pkgs.gawk # Oh My Tmux! benötigt gawk
  ];

  # 2. Das "Oh My Tmux!" Repository klonen
  # Wir klonen es nach ~/.config/oh-my-tmux
  home.file.".config/oh-my-tmux" = {
    source = pkgs.fetchFromGitHub {
      owner = "gpakosz";
      repo = ".tmux";
      rev = "master";
      # Absichtlich falscher Hash, um den richtigen zu bekommen
      hash = "sha256-XXiyPSvrrtZgQ1IN797O1vgZDkwppKImgL+OQE507Fs=";
    };
    recursive = true;
  };

  # 3. Die .tmux.conf Datei mit dem richtigen Inhalt erstellen
  home.file.".tmux.conf" = {
    text = ''
      # Lade die lokale Konfiguration, falls vorhanden
      source-file ~/.tmux.conf.local

      # Lade die Oh My Tmux Konfiguration
      source-file ~/.config/oh-my-tmux/.tmux.conf
    '';
  };
}

