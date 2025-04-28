{
  description = "My NixOS system and home configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default-linux";

    # Shared
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
    };
    nurpkgs = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS

    # HomeManager

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprpanel = {
      url = "github:jas-singhfsu/hyprpanel";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    claude-desktop = {
      url = "github:k3d3/claude-desktop-linux-flake";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      sops-nix,
      systems,
      stylix,
      ...
    }:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib;

      forAllSystems = lib.genAttrs (import systems);

      inputPkgsFor =
        pkgs:
        forAllSystems (
          system:
          import pkgs {
            inherit system;
            config.allowUnfree = true;
          }
        );

      # Nixpkgs for each system
      nixpkgsFor = inputPkgsFor nixpkgs;

      # specialArgs shared between nixosConfig and homeConfig
      specialArgs = forAllSystems (system: {
        inherit inputs outputs;
        self = self;
        pkgs-stable = (inputPkgsFor inputs.nixpkgs-stable).${system};
      });

      nixosConfig =
        { modules, system }:
        lib.nixosSystem {
          pkgs = nixpkgsFor.${system};
          specialArgs = specialArgs.${system};

          modules = modules ++ [
            outputs.nixosModules
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                sharedModules = [ outputs.homeManagerModules ];
                extraSpecialArgs = specialArgs.${system};
              };
            }
          ];
        };
    in
    {
      inherit lib; # sops-nix stylix;

      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      home-manager = {
        useGlobalPkgs = true;
        extraSpecialArgs = {
          inherit nixpkgs;
        };
        backupFileExtension = "hm-bak";
      };

      overlays = import ./overlays { inherit inputs outputs; };

      # packages = forEachSystem (pkgs: import ./pkgs { inherit pkgs; });
      packages = forAllSystems (system: import ./pkgs { pkgs = nixpkgsFor.${system}; });

      nixosConfigurations = {
        # Home desktop
        home = lib.nixosSystem {
          modules = [ ./system/hosts/home ];
          specialArgs = {
            inherit inputs outputs;
          };
        };

        # Work desktop
        work = lib.nixosSystem {
          modules = [ ./system/hosts/work ];
          specialArgs = {
            inherit inputs outputs;
          };
        };

        pluto = nixosConfig {
          modules = [ ./hosts/pluto ];
          system = "aarch64-linux";
        };
      };

      homeConfigurations = {
        # Home desktop
        home = lib.homeManagerConfiguration {
          modules = [
            ./home/hosts/home
            ./modules/home-manager
          ];
          pkgs = nixpkgsFor.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs;
          };
        };

        # Work desktop
        work = lib.homeManagerConfiguration {
          modules = [
            ./home/hosts/work
            ./modules/home-manager
          ];
          pkgs = nixpkgsFor.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs;
          };
        };
      };
    };
}
