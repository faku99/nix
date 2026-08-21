{ den, ... }:
{
  den.homes.aarch64-linux.pluto.userName = "lelisei";

  den.aspects.pluto = {
    includes = with den.aspects; [
      lelisei
      theme-standalone
      direnv
      git
      ssh
      nvf
      opencode
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
