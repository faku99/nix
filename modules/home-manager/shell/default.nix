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
    mkForce
    mkIf
    mkOption
    types
    ;
  cfg = config.userConfig.shell;

  mkEverythingDefault = attr: lib.attrsets.mapAttrs (name: value: mkDefault value) attr;

  coreUtilsAliases = mkEverythingDefault {
    ls = "ls -l --color=always --group-directories-first";

    cp = "cp -iv";
    mv = "mv -iv";
    rm = "rm -iv";

    cht = "cht.sh";
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
      cht-sh
      eza
    ];

    home.shellAliases = coreUtilsAliases;

    userConfig.programs.sh-utils.fzf.enable = mkForce true;

    programs.bash.shellAliases = coreUtilsAliases;
    programs.zsh.shellAliases = coreUtilsAliases;
  };
}
