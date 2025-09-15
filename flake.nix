{
    description = "Meine erste Nix Konfiguration";
    
    inputs = {
      # Hier kommen später unsere Zutaten (z.B. die Paketsammlung) rein.
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

      home-manager = {
      url = "github:nix-community/home-manager";
      # Wichtig: Wir sagen Home Manager, er soll die gleiche nixpkgs-Version
      # benutzen, die wir oben definiert haben. Das verhindert Konflikte.
      inputs.nixpkgs.follows = "nixpkgs";
    };

      };

    outputs = {self,nixpkgs, home-manager, ... }: {
      homeConfigurations."linux-user" = home-manager.lib.homeManagerConfiguration {
      
      # Wir müssen angeben, für welches System wir bauen (z.B. ein Linux-PC mit Intel/AMD-CPU)
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      pkgs = nixpkgs.

      # Hier kommt die eigentliche Konfiguration für den Benutzer rein.
      # Wir starten mit einer leeren Liste von Modulen.
      modules = [
        {
          # Hier fügen wir gleich unsere Pakete und Einstellungen ein.
          # Ersetze die folgenden zwei Zeilen mit deinen echten Daten!
          home.username = "dennis";
          home.homeDirectory = "/home/dennis";

          # Hier ist die Liste der Pakete, die wir installieren wollen.
          home.packages = [
            pkgs.ripgrep  # Wir referenzieren ripgrep aus nixpkgs
          ];

          # Diese Zeile ist wichtig, damit Home Manager sich selbst verwalten kann.
          programs.home-manager.enable = true;
          programs.bash.enable = true;

          # Diese Zeile ist eine Art "Version-Pinning" für deine Konfiguration.
          # Es ist gute Praxis, sie zu setzen.
          home.stateVersion = "23.11";
         
          
        }
      ];
    };
     # Hier definieren wir später, was Nix mit den Zutaten machen soll.

      }
  }
