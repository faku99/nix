{
  pkgs,
  ...
}:
{
  home.username = "lelisei";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    fd
  ];

  userConfig = {
    global.enable = true;

    shell = {
      zsh = {
        enable = true;
        defaultShell = true;
      };
    };

    system = {
      impermanence = {
        enable = true;
        directories = [
          "nix"
          "sources"
        ];
      };
    };
  };
}
