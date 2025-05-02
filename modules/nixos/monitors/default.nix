{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkOption types;
  cfg = config.nixosConfig.monitors;
in
{
  options.nixosConfig.monitors = mkOption {
    type = types.listOf (
      types.submodule {
        options = {
          name = mkOption {
            type = types.str;
            example = "DP-1";
          };
          primary = mkOption {
            type = types.bool;
            default = false;
          };
          width = mkOption {
            type = types.int;
            example = 1920;
          };
          height = mkOption {
            type = types.int;
            example = 1080;
          };
          refreshRate = mkOption {
            type = types.int;
            default = 60;
          };
          position = mkOption {
            type = types.str;
            default = "auto";
          };
          enabled = mkOption {
            type = types.bool;
            default = true;
          };
          workspace = mkOption {
            type = types.nullOr types.str;
            default = null;
          };
        };
      }
    );
    default = [ ];
  };

  config = mkIf (lib.length cfg > 0) {
    assertions = [
      {
        assertion = ((lib.length cfg) != 0) -> ((lib.length (lib.filter (m: m.primary) cfg)) == 1);
        message = "Exactly one monitor must be set to primary.";
      }
    ];
  };
}
