{
  bash,
  imagemagick,
  inkscape,
  lib,
  writeShellApplication,
  ...
}:
(writeShellApplication {
  name = "wallpaper-gen";
  runtimeInputs = [
    bash
    imagemagick
    inkscape
  ];
  text = builtins.readFile ./wallpaper-gen.sh;
})
// {
  meta = with lib; {
    licenses = licenses.mit;
    platforms = platforms.all;
    mainProgram = "wallpaper-gen";
  };
}
