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
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # HomeManager
    claude-desktop = {
      url = "github:k3d3/claude-desktop-linux-flake";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      systems,
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
            config = {
              allowUnfree = true;
              segger-jlink.acceptLicense = true;
              permittedInsecurePackages = [
                "segger-jlink-qt4-810"
              ];
            };
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
                sharedModules = [
                  inputs.sops-nix.homeManagerModules.sops
                  outputs.homeManagerModules
                  inputs.nvf.homeManagerModules.default
                ];
                extraSpecialArgs = specialArgs.${system};
              };
            }
          ];
        };
    in
    {
      inherit lib;

      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      overlays = import ./overlays { inherit inputs outputs; };

      packages = forAllSystems (system: import ./pkgs { pkgs = nixpkgsFor.${system}; });

      templates = import ./templates;

      nixosConfigurations = {
        jupiter = nixosConfig {
          modules = [ ./hosts/jupiter ];
          system = "x86_64-linux";
        };

        pluto = nixosConfig {
          modules = [ ./hosts/pluto ];
          system = "aarch64-linux";
        };

        saturn = nixosConfig {
          modules = [ ./hosts/saturn ];
          system = "x86_64-linux";
        };
      };
    };
}
