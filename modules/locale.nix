{
  den.default.nixos = {
    time.timeZone = "Europe/Zurich";

    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = {
        LC_MEASUREMENT = "fr_CH.UTF-8";
        LC_MONETARY = "fr_CH.UTF-8";
        LC_NUMERIC = "fr_CH.UTF-8";
        LC_PAPER = "fr_CH.UTF-8";
      };
    };
  };
}
