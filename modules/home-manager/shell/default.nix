{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    types
    ;
  cfg = config.userConfig.shell;

  mkEverythingDefault = attr: lib.attrsets.mapAttrs (name: value: mkDefault value) attr;

  coreUtilsAliases = mkEverythingDefault {
    ls = "eza -lg --git";

    cp = "cp -iv";
    mv = "mv -iv";
    rm = "rm -iv";
  };
in
{
  imports = [
    ./zsh
  ];

  options.userConfig.shell = {
    enable = mkEnableOption "Shell";

    executable = mkOption {
      type = types.str;
      description = "Executable path";
    };
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      SHELL = cfg.executable;
    };

    home.packages = with pkgs; [
      eza
    ];

    home.shellAliases = coreUtilsAliases;
    programs.bash.shellAliases = coreUtilsAliases;
    programs.zsh.shellAliases = coreUtilsAliases;
  };
}
