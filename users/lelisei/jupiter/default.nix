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

    programs = {
      browser = {
        librewolf = {
          enable = true;
          defaultBrowser = true;
        };
      };

      editor = {
        neovim = {
          enable = true;
          defaultEditor = true;
        };
        vscode.enable = true;
      };
    };
  };
}
