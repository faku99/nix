{ inputs, ... }:
{
  den.aspects.nvf.homeManager =
    { lib, pkgs, ... }:
    let
      inherit (inputs.nvf.lib.nvim.binds) mkKeymap;

      review-nvim = pkgs.vimUtils.buildVimPlugin {
        pname = "review.nvim";
        version = "v1.10.1";
        src = pkgs.fetchFromGitHub {
          owner = "georgeguimaraes";
          repo = "review.nvim";
          tag = "v1.10.1";
          hash = "sha256-Wc4jPQ44bZKoJ8pidtL9N79nPBNBwqnn1XkGW+2bQbQ=";
        };
        meta.homepage = "https://github.com/georgeguimaraes/review.nvim";
      };
    in
    {
      # Reviews exported to .review/inbox for the nvim-review Claude Code plugin
      programs.git.ignores = [ ".review" ];

      programs.nvf.settings.config.vim = {
        binds.whichKey.register."<leader>r" = "Review";

        # codediff would download its watcher into the read-only store; polling is used instead
        luaConfigRC.codediff-watcher = inputs.nvf.lib.nvim.dag.entryAnywhere ''
          vim.env.CODEDIFF_WATCHER_NO_AUTO_INSTALL = "1"
        '';

        startPlugins = [ pkgs.vimPlugins.nui-nvim ];

        extraPlugins.codediff = {
          package = pkgs.vimPlugins.codediff-nvim;
          setup = ''
            require("codediff").setup {
              diff = { layout = "inline" },
              explorer = { view_mode = "tree" },
              history = { view_mode = "tree" },
              keymaps = {
                view = {
                  next_hunk = { "}", "]c" },
                  prev_hunk = { "{", "[c" },
                  next_file = "<c-n>",
                  prev_file = "<c-p>",
                },
                explorer = {
                  refresh = "<c-r>",
                  fold_toggle = "<tab>",
                },
                history = {
                  refresh = "<c-r>",
                  fold_toggle = "<tab>",
                },
              },
            }
          '';
        };

        lazy.plugins."review.nvim" = {
          package = review-nvim;
          setupModule = "review";
          setupOpts.export.on_export = lib.generators.mkLuaInline ''
            function(markdown, _)
              local root = vim.fs.root(0, ".git") or vim.fn.getcwd()
              local dir = root .. "/.review/inbox"
              vim.fn.mkdir(dir, "p")
              local file = dir .. "/" .. os.date("%Y%m%d-%H%M%S") .. ".md"
              vim.fn.writefile(vim.split(markdown, "\n", { plain = true }), file)
              vim.notify("Review sent to Claude Code", vim.log.levels.INFO)
            end
          '';
          #cmd = [ "Review" ];
          event = [ "DeferredUIEnter" ];
          keys = [
            (mkKeymap "n" "<leader>rr" "<cmd>Review<cr>" {
              desc = "Open diff review";
            })
            (mkKeymap "n" "<leader>rd" "<cmd>Review delete<cr>" {
              desc = "Delete comment";
            })
            (mkKeymap "n" "<leader>re" "<cmd>Review edit<cr>" {
              desc = "Edit comment";
            })
            (mkKeymap "n" "<leader>rn" ":Review note<cr>" {
              desc = "Add comment";
            })
            (mkKeymap "n" "<leader>rx" "<cmd>Review export<cr>" {
              desc = "Export review";
            })
          ];
        };
      };
    };
}
