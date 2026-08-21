{
  description = "My NixOS system and home configurations";

  inputs = {
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Temporary pin since Hyprland requires glaze < 8
    nixpkgs.url = "github:nixos/nixpkgs/4b1cd35e951dd2760cf83fe5bf5129d26464ae31";
    systems.url = "github:nix-systems/default-linux";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    # Dendritic pattern
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    den.url = "github:denful/den";

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

    noctalia = {
      url = "github:noctalia-dev/noctalia/refs/tags/v4.7.7";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    glide-browser = {
      url = "github:glide-browser/glide.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland/refs/tags/v0.56.1";
    };
    nix-gl = {
      url = "github:nix-community/nixgl";
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

    # AI
    oh-my-opencode-slim = {
      url = "github:alvinunreal/oh-my-opencode-slim";
      flake = false;
    };
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}
