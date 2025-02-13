{lib, ...}: let
  inherit (lib) types mkOption;
in {
  options.nvidiaSupport = mkOption {
    type = types.bool;
    default = false;
    description = ''
      NVIDIA Graphics Card Support
    '';
  };
}
