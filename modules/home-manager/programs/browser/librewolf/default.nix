{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.userConfig.programs.browser.librewolf;

  profileName = "default";
in
{
  options.userConfig.programs.browser.librewolf = {
    enable = lib.mkEnableOption "Librewolf";

    defaultBrowser = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Set Librewolf as default browser";
    };
  };

  config = lib.mkIf cfg.enable {
    userConfig.programs.browser = lib.mkIf cfg.defaultBrowser {
      enable = true;
      executable = "librewolf";
      desktop = "librewolf.desktop";
    };

    programs.librewolf = {
      enable = true;

      package = pkgs.librewolf-wayland;

      languagePacks = [
        "en-US"
        "fr"
      ];

      policies = {
        Cookies = {
          Behavior = "reject";
          Allow = [
            "https://github.com"
            "https://searx.foobar.vip"
            "https://twitch.tv"

            # Work-related
            # TODO: Find a way to allow those only in work containers
            "https://bamboo.tandemdiabetes.com"
            "https://bitbucket.tandemdiabetes.com"
            "https://confluence.tandemdiabetes.com:8443"
            "https://jira.tandemdiabetes.com:8443"
            "https://tandem.okta.com"

            # Personal stuff
            "https://elisei.ch"
          ];
        };

        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableSetDesktopBackground = true;
        DisableTelemetry = true;

        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        PasswordManagerEnabled = false;

        UserMessaging = {
          ExtensionRecommendations = false;
          SkipOnboarding = true;
        };
      };

      profiles.${profileName} = {
        isDefault = true;

        containersForce = true;
        containers = {
          self = {
            id = 1;
            color = "blue";
            icon = "circle";
          };
          work = {
            id = 2;
            color = "orange";
            icon = "briefcase";
          };
        };

        search = {
          default = "SearXNG";
          force = true;
          engines = {
            "SearXNG" = {
              description = "SearXNG - foobar.vip";
              iconURL = "https://searx.foobar.vip/static/themes/simple/img/favicon.svg";
              urls = [
                {
                  template = "https://searx.foobar.vip/?q={searchTerms}";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };
          };
        };

        settings = {
          # Auto-enable extensions
          "extensions.autoDisableScopes" = 0;

          # Restore previous session
          "browser.startup.page" = 3;
          # Homepage
          "browser.startup.homepage" = "https://searx.foobar.vip/";

          # Clear-on-shutdown privacy
          "privacy.clearOnShutdown.cookies" = false;
          "privacy.clearOnShutdown.downloads" = false;
          "privacy.clearOnShutdown.history" = false;

          "identity.sync.tokenserver.uri" = "https://mozilla-sync.elisei.ch/1.0/sync/1.5";
        };
      };
    };

    stylix.targets.librewolf.enable = true;
    stylix.targets.librewolf.profileNames = [ profileName ];
  };
}
