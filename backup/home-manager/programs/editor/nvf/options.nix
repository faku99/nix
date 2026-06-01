{
  programs.nvf.settings.vim = {
    viAlias = false;
    vimAlias = true;

    clipboard = {
      enable = true;
      providers.wl-copy.enable = true;
      registers = "unnamedplus";
    };

    options = {
      autoindent = true;
      autoread = true;
      exrc = true;
      list = true;
      listchars = "nbsp:␣,space:·,tab:» ,trail:~";
      secure = true;
      shiftround = true;
      shiftwidth = 4;
      signcolumn = "yes";
      smartindent = true;
      softtabstop = 4;
      tabstop = 4;
    };

    theme = {
      enable = true;
      name = "base16";
      transparent = true;
    };
  };
}
