{
  appimageTools,
  fetchurl,
}: let
  version = "0.5.4";
  pname = "prospect-mail";

  src = fetchurl {
    url = "https://github.com/julian-alarcon/prospect-mail/releases/download/v${version}/Prospect-Mail-${version}.AppImage";
    hash = "sha512-b5YycqTUU4XOfrqIzGXeNMUf5abFh5PYkn8nDQ+OjWKEi1ZGABG4PFMeBmBAg6guj1p8LiwkYFwBJ20ehTc/Og==";
  };

  appimageContents = appimageTools.extractType1 {inherit pname version src;};
in
  appimageTools.wrapType1 rec {
    inherit pname version src;
    extraPkgs = appimageTools.defaultFhsEnvArgs.multiPkgs;
    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
      install -m 444 -D ${appimageContents}/${pname}.png $out/share/icons/hicolor/512x512/apps/${pname}.png
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace 'Exec=AppRun --no-sandbox %U' 'Exec=${pname} %U'
    '';
  }
