{
  inputs,
  ...
}:
{
  nix-vscode-extensions = inputs.nix-vscode-extensions.overlays.default;

  # For every flake input, aliases 'pkgs.inputs.${flake}' to
  # 'inputs.${flake}.packages.${pkgs.system}' or
  # 'inputs.${flake}.legacyPackages.${pkgs.system}'
  flake-inputs = final: _: {
    inputs = builtins.mapAttrs (
      _: flake:
      let
        legacyPackages = (flake.legacyPackages or { }).${final.system} or { };
        packages = (flake.packages or { }).${final.system} or { };
      in
      if legacyPackages != { } then legacyPackages else packages
    ) inputs;
  };

  # My custom packages
  additions = final: prev: import ../pkgs { pkgs = final; };

  modifications = final: prev: {
    flameshot = prev.flameshot.overrideAttrs (_: {
      cmakeFlags = [
        "-DUSE_WAYLAND_CLIPBOARD=true"
        "-DUSE_WAYLAND_GRIM=true"
      ];
    });
  };
}
