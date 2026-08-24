{
  den.aspects.okular.homeManager =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.kdePackages.okular ];

      xdg.mimeApps.defaultApplications = {
        "application/pdf" = "okularApplication_pdf.desktop";
      };
    };
}
