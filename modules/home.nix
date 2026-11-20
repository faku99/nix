{
  den.default.homeManager =
    { config, lib, pkgs, ... }:
    {
      news.display = "silent";

      home.homeDirectory = lib.mkDefault "/home/${config.home.username}";
      home.stateVersion = "26.05";
      home.packages = with pkgs; [
        ouch
        fd
        ripgrep
        unzip
      ];

      programs = {
        gpg.enable = true;
        home-manager.enable = true;
      };
    };
}
