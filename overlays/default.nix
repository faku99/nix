{
  inputs,
  ...
}:
{
  nix-vscode-extensions = inputs.nix-vscode-extensions.overlays.default;

  # FIXME: remove when nixpkgs#568713 (GCC 16 fix) reaches nixos-unstable
  intel-compute-runtime-legacy1-gcc16 = final: prev: {
    intel-compute-runtime-legacy1 = prev.intel-compute-runtime-legacy1.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ [
        (final.fetchpatch {
          url = "https://github.com/intel/compute-runtime/commit/c1eb6c1a183c2f69e0d6e9ed5aa042fac2201217.patch";
          hash = "sha256-O8ZJaxIr4TF73T+fyEbNjEYFbgwLxIUWoYnorxh8ZTo=";
        })
      ];
    });
  };
}
