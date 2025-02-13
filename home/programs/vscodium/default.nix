{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    extensions = with pkgs.vscode-marketplace; [
      jnoortheen.nix-ide
      kamadorueda.alejandra
    ];

    mutableExtensionsDir = false;

    userSettings = {
      # Editor settings
      "editor.renderWhitespace" = "all";
      "editor.rulers" = [80 120];

      # Explorer settings
      "explorer.confirmDragAndDrop" = false;
      "explorer.confirmDelete" = false;

      # Window settings
      "window.menuBarVisibility" = "toggle";

      # Nix specific
      "[nix]" = {
        "editor.insertSpaces" = true;
        "editor.tabSize" = 2;
        "editor.defaultFormatter" = "kamadorueda.alejandra";
        "editor.formatOnPaste" = true;
        "editor.formatOnSave" = true;
        "editor.formatOnType" = false;
      };
      "nix.enableLanguageServer" = true;
      "nix.formatterPath" = "alejandra";
      "nix.serverPath" = "nixd";
    };
  };

  stylix.targets.vscode.enable = false;
}
