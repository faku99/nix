{
  config,
  pkgs,
  ...
}: {
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryPackage =
      if config.gtk.enable
      then pkgs.pinentry-gnome3
      else pkgs.pinentry-tty;
  };
}
