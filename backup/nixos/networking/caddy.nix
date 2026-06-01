{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
  cfg = config.nixosConfig.networking.caddy;
in
{
  options.nixosConfig.networking.caddy = {
    enable = mkEnableOption "Caddy server";

    configFile = mkOption {
      type = types.path;
      description = "Caddy configuration file";
    };
  };

  config = mkIf cfg.enable {
    services.caddy = {
      enable = true;
      package = pkgs.caddy.withPlugins {
        plugins = [
          "github.com/greenpau/caddy-security@v1.1.31"
        ];
        hash = "sha256-vxZZqQD+BfKcqWfjL5dkZ7o8m+KoYFeuXQbANcsOP1k=";
      };
      inherit (cfg) configFile;
      adapter = "caddyfile";
    };
  };
}
