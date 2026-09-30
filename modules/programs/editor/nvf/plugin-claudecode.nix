{
  den.aspects.nvf.homeManager =
    { pkgs, ... }:
    let
      key = key: action: desc: {
        mode = "n";
        inherit key action desc;
      };
    in
    {
      programs.nvf.settings.config.vim = {
        binds.whichKey.register."<leader>a" = "Claude Code";

        lazy.plugins."claudecode.nvim" = {
          package = pkgs.vimPlugins.claudecode-nvim;
          cmd = [
            "ClaudeCode"
            "ClaudeCodeFocus"
            "ClaudeCodeSelectModel"
            "ClaudeCodeAdd"
            "ClaudeCodeSend"
            "ClaudeCodeDiffAccept"
            "ClaudeCodeDiffDeny"
            "ClaudeCodeStatus"
          ];
          keys = [
            (key "<leader>aa" "<cmd>ClaudeCode<cr>" "Toggle Claude")
            (key "<leader>af" "<cmd>ClaudeCodeFocus<cr>" "Focus Claude")
            (key "<leader>ar" "<cmd>ClaudeCode --resume<cr>" "Resume session")
            (key "<leader>ac" "<cmd>ClaudeCode --continue<cr>" "Continue session")
            (key "<leader>am" "<cmd>ClaudeCodeSelectModel<cr>" "Select model")
            (key "<leader>ab" "<cmd>ClaudeCodeAdd %<cr>" "Add current buffer")
            (key "<leader>ada" "<cmd>ClaudeCodeDiffAccept<cr>" "Accept diff")
            (key "<leader>add" "<cmd>ClaudeCodeDiffDeny<cr>" "Reject diff")
            {
              mode = "v";
              key = "<leader>as";
              action = "<cmd>ClaudeCodeSend<cr>";
              desc = "Send selection to Claude";
            }
          ];
          setupModule = "claudecode";
          setupOpts = { };
        };
      };
    };
}
