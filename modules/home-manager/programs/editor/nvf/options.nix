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
      list = true;
      listchars = "nbsp:␣,space:·,tab:» ,trail:~";
      shiftwidth = 4;
      signcolumn = "yes";
      smartindent = true;
      tabstop = 4;
      wrap = false;
    };

    theme = {
      enable = true;
      name = "base16";
      transparent = true;
    };
  };
}
