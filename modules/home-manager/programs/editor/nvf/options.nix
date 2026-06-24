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
      autoindent = true;  # Keep indentation from previous line
      autoread = true;
      cindent = true;     # Like smartindent, but stricter and more customisable
      colorcolumn = "120";
      expandtab = true;   # Use softtabstop spaces instead of tabs
      exrc = true;
      list = true;
      listchars = "nbsp:␣,space:·,tab:» ,trail:~";
      secure = true;
      shiftround = true;
      shiftwidth = 4;     # Indent by 4 spaces when using >>, <<, ==, ...
      signcolumn = "yes";
      smartindent = true; # Automatically insert indentation in some cases
      softtabstop = 4;    # Indent by 4 spaces when pressing TAB
    };

    theme = {
      enable = true;
      name = "base16";
      transparent = true;
    };
  };
}
