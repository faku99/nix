{
  den.aspects.nvf.homeManager =
    { lib, ... }:
    {
      programs.nvf.settings.vim = {
        statusline.lualine = {
          enable = true;

          setupOpts = {
            sections = {
              lualine_a = [
                {
                  "@1" = "mode";
                  icons_enabled = true;
                }
              ];
              lualine_b = [
                {
                  "@1" = "filetype";
                  icon = {
                    align = "left";
                  };
                }
                {
                  "@1" = "filename";
                  path = 1;
                  symbols = {
                    modified = "[M]";
                    readonly = "[RO]";
                    unnamed = "[NO NAME]";
                    newfile = "[NEW]";
                  };
                }
              ];
              lualine_c = [
                {
                  "@1" = "diff";
                  colored = false;
                  diff_color = {
                    added = "DiffAdd";
                    modified = "DiffChange";
                    removed = "DiffDelete";
                  };
                  symbols = {
                    added = "+";
                    modified = "~";
                    removed = "-";
                  };
                }
              ];

              lualine_x = [
                (lib.generators.mkLuaInline ''
                  {
                    -- Lsp server name
                    function()
                      local buf_ft = vim.bo.filetype
                      local excluded_buf_ft = { toggleterm = true, NvimTree = true, ["neo-tree"] = true, TelescopePrompt = true }

                      if excluded_buf_ft[buf_ft] then
                        return ""
                        end

                      local bufnr = vim.api.nvim_get_current_buf()
                      local clients = vim.lsp.get_clients({ bufnr = bufnr })

                      if vim.tbl_isempty(clients) then
                        return "No Active LSP"
                      end

                      local active_clients = {}
                      for _, client in ipairs(clients) do
                        table.insert(active_clients, client.name)
                      end

                      return table.concat(active_clients, ", ")
                    end,
                  }
                '')
                {
                  "@1" = "diagnostics";
                  sources = [
                    "nvim_lsp"
                    "nvim_diagnostic"
                    "nvim_diagnostic"
                    "vim_lsp"
                    "coc"
                  ];
                  symbols = {
                    error = "󰅙  ";
                    warn = "  ";
                    info = "  ";
                    hint = "󰌵 ";
                  };
                  colored = true;
                  update_in_insert = false;
                  always_visible = false;
                  diagnostics_color = {
                    color_error = {
                      fg = "red";
                    };
                    color_warn = {
                      fg = "yellow";
                    };
                    color_info = {
                      fg = "cyan";
                    };
                  };
                }
              ];

              lualine_y = [
                {
                  "@1" = "t";
                  maxcount = 999;
                  timeout = 120;
                }
                {
                  "@1" = "branch";
                  icon = "";
                }
              ];

              lualine_z = [
                {
                  "@1" = "%{&expandtab?'󱁐 ':'󰌒 '}%{&tabstop}";
                }
                {
                  "@1" = "progress";
                }
                {
                  "@1" = "location";
                }
                {
                  "@1" = "fileformat";
                  symbols = {
                    unix = "LF";
                    dos = "CRLF";
                    mac = "CR";
                  };
                }
              ];
            };
          };
        };
      };
    };
}
