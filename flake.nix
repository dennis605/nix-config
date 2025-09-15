{
  description = "Meine erste Nix-Konfiguration";

  inputs = {
    # Wir sagen Nix: "Hole dir die Paketsammlung von diesem GitHub-Repository"
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      # Wichtig: Wir sagen Home Manager, er soll die gleiche nixpkgs-Version
      # benutzen, die wir oben definiert haben. Das verhindert Konflikte.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # Wir übergeben die Inputs (nixpkgs, home-manager) an die Outputs, damit wir sie verwenden können.
  outputs = { self, nixpkgs, home-manager, ... }: {

    # Wir definieren eine "Home-Konfiguration" und geben ihr einen Namen, z.B. "linux-user"
    homeConfigurations."linux-user" = home-manager.lib.homeManagerConfiguration {
      
      # Wir müssen angeben, für welches System wir bauen (z.B. ein Linux-PC mit Intel/AMD-CPU)
      pkgs = nixpkgs.legacyPackages.x86_64-linux;

      # Hier kommt die eigentliche Konfiguration für den Benutzer rein.
      # Das Modul ist eine Funktion, die 'pkgs' als Argument erhält.
      modules = [
        ({ pkgs, ... }: {
          home.username = "dennis";
          home.homeDirectory = "/home/dennis";

          # Hier ist die Liste der Pakete, die wir installieren wollen.
          home.packages = [
            pkgs.ripgrep  # Wir referenzieren ripgrep aus nixpkgs
            pkgs.wezterm
            pkgs.gh
          ];

          # Diese Zeile ist wichtig, damit Home Manager sich selbst verwalten kann.
          programs.home-manager.enable = true;
          programs.bash.enable = true;

          # Diese Zeile ist eine Art "Version-Pinning" für deine Konfiguration.
          # Es ist gute Praxis, sie zu setzen.
          home.stateVersion = "23.11";
        })
      ];
    };
  };
}

