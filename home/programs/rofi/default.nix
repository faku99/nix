{pkgs, ...}: {
  programs.rofi = {
    enable = true;
    plugins = with pkgs; [
      rofi-calc
      rofi-emoji
    ];
  };

  home.packages = with pkgs; [
    rofi-power-menu
  ];
}
