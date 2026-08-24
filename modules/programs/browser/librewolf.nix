{
  # ~/.librewolf and ~/.mozilla aren't persisted - revisit once the impermanence aspect exists
  den.aspects.librewolf.homeManager =
    { config, ... }:
    let
      profileName = "default";
    in
    {
      programs.librewolf = {
        enable = true;

        languagePacks = [
          "en-US"
          "fr"
        ];

        policies = {
          Cookies = {
            Behavior = "reject";
            Allow = [
              "https://elisei.ch"
              "https://github.com"
              "https://twitch.tv"
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
                description = "SearXNG - elisei.ch";
                icon = "https://searxng.elisei.ch/static/themes/simple/img/favicon.svg";
                urls = [
                  {
                    template = "https://searxng.elisei.ch/?q={searchTerms}";
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
          "identity.fxaccounts.enabled" = true;
        };
      };

      stylix.targets.librewolf.enable = true;
      stylix.targets.librewolf.profileNames = [ profileName ];
    };
}
