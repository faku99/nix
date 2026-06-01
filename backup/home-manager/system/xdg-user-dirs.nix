{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;
  cfg = config.userConfig.system.xdgUserDirs;
in
{
  options.userConfig.system.xdgUserDirs = {
    enable = mkEnableOption "XDG User Dirs";

    xdgDirs = mkOption {
      type = types.attrs;
      default = {
        desktop = null;
        documents = "documents";
        download = "downloads";
        music = null;
        pictures = null;
        publicShare = null;
        templates = null;
        videos = null;
      };
      description = "XDG dirs to used";
    };
  };

  config = mkIf cfg.enable {
    userConfig.system.impermanence = {
      directories = lib.lists.remove null (builtins.attrValues cfg.xdgDirs);
    };

    xdg.userDirs =
      {
        enable = true;
        createDirectories = true;
      }
      // lib.attrsets.mapAttrs (
        key: val: if builtins.isNull val then val else "${config.home.homeDirectory}/${val}"
      ) cfg.xdgDirs;
  };
}
