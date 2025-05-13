{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.userConfig.programs.editor.vscode;
in
{
  options.userConfig.programs.editor.vscode = {
    enable = lib.mkEnableOption "vscode";

    defaultEditor = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use vscode as default editor";
    };
  };

  config = lib.mkIf cfg.enable {
    userConfig.programs.editor = lib.mkIf cfg.defaultEditor {
      enable = true;
      executable = "vscodium";
    };

    # Packages often required by extensions
    home.packages = with pkgs; [
      caddy
      clang-tools
      nixd
      nixfmt-rfc-style
    ];

    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;

      mutableExtensionsDir = false;

      profiles.default = {
        extensions = with pkgs.vscode-marketplace; [
          aaron-bond.better-comments
          cschlosser.doxdocgen
          eamodio.gitlens
          esbenp.prettier-vscode
          jnoortheen.nix-ide
          llvm-vs-code-extensions.vscode-clangd
          matthewpi.caddyfile-support
          ms-vscode.cpptools
          xaver.clang-format
        ];

        userSettings = {
          # Diff editor settings
          "diffEditor.ignoreTrimWhitespace" = false;

          # Editor settings
          "editor.insertSpaces" = true;
          "editor.minimap.enabled" = false;
          "editor.renderWhitespace" = "all";
          "editor.rulers" = [
            80
            120
          ];
          "editor.tabSize" = 4;

          # Explorer settings
          "explorer.confirmDragAndDrop" = false;
          "explorer.confirmDelete" = false;

          # Extensions settings
          "extensions.experimental.affinity" = {
            "asvetliakov.vscode-neovim" = 1;
          };

          # Files settings
          "files.associations" = {
            "*.h" = "c";
          };
          "files.insertFinalNewline" = true;
          "files.trimTrailingWhitespace" = true;

          # Window settings
          "window.menuBarVisibility" = "toggle";

          # Workbench settings
          "workbench.colorTheme" = "Dark Modern";
          "workbench.startupEditor" = "none";

          "update.showReleaseNotes" = false;

          "C_Cpp.intelliSenseEngine" = "disabled";

          "[c][cpp]" = {
            "editor.defaultFormatter" = "xaver.clang-format";
          };

          "[json]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };

          "[nix]" = {
            "editor.insertSpaces" = true;
            "editor.tabSize" = 2;
            "editor.defaultFormatter" = "jnoortheen.nix-ide";
            "editor.formatOnPaste" = true;
            "editor.formatOnSave" = true;
            "editor.formatOnType" = false;
          };

          "[yaml]" = {
            "editor.tabSize" = 2;
          };

          # llvm-vs-code-extensions.vscode-clangd
          "clangd.arguments" = [
            "--header-insertion=never"
          ];

          # jnoortheen.nix-ide
          "nix.enableLanguageServer" = true;
          "nix.formatterPath" = "nixfmt";
          "nix.serverPath" = "nixd";

          # asvetliakov.vscode-neovim
          "vscode-neovim.ctrlKeysForInsertMode" = [
            "a"
            "c"
            "h"
            "j"
            "m"
            "o"
            "r"
            "t"
            "u"
            "w"
          ];

          # matthewpi.caddyfile-support
          "caddyfile.executable" = "${pkgs.caddy}/bin/caddy";
        };
      };
    };

    stylix.targets.vscode.enable = false;
  };
}
