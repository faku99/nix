{ den, ... }:
{
  den.homes.aarch64-linux.pluto.userName = "lelisei";

  den.aspects.pluto = {
    includes = with den.aspects; [
      lelisei
      theme
      direnv
      git
      ssh
      nvf
      eza
      nix-helper
      zsh
    ];

    homeManager = {
      programs.zsh.envExtra = ''
        export PATH="$HOME/.nix-profile/bin:$PATH"
      '';
    };
  };
}
