{ inputs, ... }:
{
  den.aspects.nvf.homeManager =
    { pkgs, ... }:
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
      programs.nvf.settings.config.vim = {
        binds.whichKey.register."<leader>r" = "Review";

        # Dependencies
        startPlugins = [
          pkgs.vimPlugins.nui-nvim
          pkgs.vimPlugins.codediff-nvim
        ];

        lazy.plugins."review.nvim" = {
          package = review-nvim;
          cmd = [ "Review" ];
          event = [ "" ];
          keys = [
            (mkKeymap "n" "<leader>rr" "<cmd>Review<cr>" {
              desc = "Open diff review";
            })
            (mkKeymap "n" "<leader>re" "<cmd>Review export<cr>" {
              desc = "Export comments to clipboard";
            })
          ];
        };
      };
    };
}
