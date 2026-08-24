{
  den.aspects.fzf.homeManager =
    { config, pkgs, ... }:
    {
      programs.fzf = {
        enable = true;
        enableZshIntegration = config.programs.zsh.enable;
        defaultCommand = "${pkgs.ripgrep}/bin/rg --files";
      };
    };
}
