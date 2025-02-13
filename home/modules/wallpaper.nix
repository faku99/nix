{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.wallpaper;
in {
  options.wallpaper = {
    generate = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      inputSVG = mkOption {
        type = types.nullOr types.path;
        default = null;
      };
      width = mkOption {
        type = types.nullOr types.int;
        default = null;
      };
      height = mkOption {
        type = types.nullOr types.int;
        default = null;
      };
    };

    path = mkOption {
      type = types.nullOr types.path;
      default =
        if cfg.generate.enable
        then let
          bgColor = config.lib.stylix.colors.withHashtag.base00;
          fgColor = config.lib.stylix.colors.withHashtag.base05;
        in
          pkgs.runCommand "wallpaper.png" {} ''
            ${lib.getExe pkgs.wallpaper-gen} ${cfg.generate.inputSVG} '${bgColor}' '${fgColor}' '${builtins.toString cfg.generate.width}x${builtins.toString cfg.generate.height}' $out
          ''
        else null;
    };
  };

  config = mkIf cfg.generate.enable {
    assertions = [
      {
        assertion = (cfg.generate.inputSVG != null) && (cfg.generate.width != null) && (cfg.generate.height != null);
        message = "You must provide an SVG, width and height when generating a wallpaper.";
      }
    ];
  };
}
