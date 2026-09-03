{ den, ... }:
{
  # ~/.librewolf and ~/.mozilla aren't persisted - revisit once the impermanence aspect exists
  den.aspects.librewolf.homeManager =
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
        };

        settings = {
          # Auto-enable extensions
          "extensions.autoDisableScopes" = 0;

          # Restore previous session
          "browser.startup.page" = 3;

          # Clear-on-shutdown privacy
          "privacy.clearOnShutdown.cookies" = false;
          "privacy.clearOnShutdown.downloads" = false;
          "privacy.clearOnShutdown.history" = false;

          "identity.fxaccounts.enabled" = true;
        };
      };
    };

  den.aspects.librewolf-default = {
    includes = [ den.aspects.librewolf ];

    homeManager =
      {
        xdg.mimeApps.defaultApplications = {
          "text/html" = [ "librewolf.desktop" ];
          "text/xml" = [ "librewolf.desktop" ];
          "x-scheme-handle/http" = [ "librewolf.desktop" ];
          "x-scheme-handle/https" = [ "librewolf.desktop" ];
        };

        home.sessionVariables.BROWSER = "librewolf";
      };
  };
}
