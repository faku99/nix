# { vars, ... }:
{
  programs.git = {
    enable = true;

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };

    userName = "Lucas Elisei";
    # userEmail = if vars.isWork
    # 	then "lelisei@tandemdiabetes.com"
    # 	else "lucas@elisei.ch";
  };
}
