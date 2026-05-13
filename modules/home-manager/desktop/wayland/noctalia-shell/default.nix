{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.userConfig.desktop.wayland.noctalia-shell;
in
{
  imports = [ inputs.noctalia.homeModules.default ];

  options.userConfig.desktop.wayland.noctalia-shell = {
    enable = lib.mkEnableOption "Noctalia Shell";
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings = {
        "$menu" = "noctalia-shell ipc call launcher toggle";
        exec-once = [
          "noctalia-shell"
        ];
      };
    };

    programs.noctalia-shell = {
      enable = true;

      colors = {
        mBackground = lib.mkForce "#${config.lib.stylix.colors.base00}";
        mOnBackground = lib.mkForce "#${config.lib.stylix.colors.base05}";
        mPrimary = lib.mkForce "#${config.lib.stylix.colors.base0D}";
        mOnPrimary = lib.mkForce "#${config.lib.stylix.colors.base00}";
        mSecondary = lib.mkForce "#${config.lib.stylix.colors.base0E}";
        mOnSecondary = lib.mkForce "#${config.lib.stylix.colors.base00}";
        mSurface = lib.mkForce "#${config.lib.stylix.colors.base00}";
        mOnSurface = lib.mkForce "#${config.lib.stylix.colors.base05}";
        mOutline = lib.mkForce "#${config.lib.stylix.colors.base03}";
      };

      settings = {
        settingsVersion = 59;
        bar = {
          density = "comfortable";
          fontScale = 1.20;
          showCapsule = false;
          enableExclusionZoneInset = false;
          outerCorners = false;
          widgets = {
            left = [
              {
                colorizeSystemIcon = "primary";
                colorizeSystemText = "none";
                customIconPath = "";
                enableColorization = true;
                icon = "rocket";
                iconColor = "none";
                id = "Launcher";
                useDistroLogo = true;
              }
              {
                characterCount = 2;
                colorizeIcons = false;
                emptyColor = "none";
                enableScrollWheel = true;
                focusedColor = "primary";
                followFocusedScreen = false;
                fontWeight = "semibold";
                groupedBorderOpacity = 1;
                hideUnoccupied = false;
                iconScale = 0.8;
                id = "Workspace";
                labelMode = "index";
                occupiedColor = "none";
                pillSize = 0.8;
                showApplications = false;
                showApplicationsHover = false;
                showBadge = true;
                showLabelsOnlyWhenOccupied = false;
                unfocusedIconsOpacity = 1;
              }
            ];
            center = [
              {
                clockColor = "primary";
                customFont = "JetBrainsMono Nerd Font";
                formatHorizontal = "yyyy-MM-dd HH:mm";
                formatVertical = "HH:mm - yyyy-MM-dd";
                id = "Clock";
                tooltipFormat = "yyyy-MM-dd HH:mm:ss";
                useCustomFont = true;
              }
            ];
            right = [
              {
                blacklist = [ ];
                chevronColor = "none";
                colorizeIcons = true;
                drawerEnabled = false;
                hidePassive = true;
                id = "Tray";
                pinned = [ ];
              }
              {
                compactMode = false;
                hideMode = "hidden";
                hideWhenIdle = false;
                id = "MediaMini";
                maxWidth = 145;
                panelShowAlbumArt = true;
                scrollingMode = "hover";
                showAlbumArt = true;
                showArtistFirst = true;
                showProgressRing = true;
                showVisualizer = false;
                textColor = "none";
                useFixedWidth = false;
                visualizerType = "linear";
              }
              {
                displayMode = "onhover";
                iconColor = "none";
                id = "Volume";
                middleClickCommand = "pwvucontrol || pavucontrol";
                textColor = "none";
              }
              {
                hideWhenZero = true;
                hideWhenZeroUnread = true;
                iconColor = "none";
                id = "NotificationHistory";
                showUnreadBadge = true;
                unreadBadgeColor = "secondary";
              }
              {
                compactMode = false;
                diskPath = "/home";
                iconColor = "none";
                id = "SystemMonitor";
                showCpuCores = false;
                showCpuFreq = false;
                showCpuTemp = true;
                showCpuUsage = true;
                showDiskAvailable = false;
                showDiskUsage = false;
                showDiskUsageAsPercent = false;
                showGpuTemp = false;
                showLoadAverage = false;
                showMemoryAsPercent = false;
                showMemoryUsage = true;
                showNetworkStats = true;
                showSwapUsage = false;
                textColor = "none";
                useMonospaceFont = true;
                usePadding = true;
              }
              {
                displayMode = "onhover";
                iconColor = "none";
                id = "Network";
                textColor = "none";
              }
              {
                iconColor = "error";
                id = "SessionMenu";
              }
            ];
          };
          middleClickAction = "settings";
          middleClickFollowMouse = true;
        };
        general = {
          avatarImage = "/home/lelisei/.face";
          radiusRatio = 0.3;
          iRadiusRatio = 0.3;
          clockFormat = "hh\\nmm";
        };
        ui = {
          fontDefault = "DejaVu Sans";
          fontFixed = "JetBrainsMono Nerd Font";
        };
        location = {
          name = "Lausanne, Switzerland";
          weatherShowEffects = false;
          showWeekNumberInCalendar = true;
          hideWeatherCityName = true;
          autoLocate = false;
        };
        wallpaper = {
          directory = "/home/lelisei/Pictures/Wallpapers";
        };
        appLauncher = {
          enableClipboardHistory = true;
          showCategories = false;
        };
        controlCenter = {
          diskPath = "/home";
          cards = [
            {
              enabled = true;
              id = "profile-card";
            }
            {
              enabled = true;
              id = "shortcuts-card";
            }
            {
              enabled = true;
              id = "audio-card";
            }
            {
              enabled = false;
              id = "brightness-card";
            }
            {
              enabled = true;
              id = "weather-card";
            }
            {
              enabled = false;
              id = "media-sysmon-card";
            }
          ];
        };
        systemMonitor = {
          warningColor = "#89b482";
          criticalColor = "#ea6962";
        };
        dock = {
          enabled = false;
        };
        sessionMenu = {
          enableCountdown = false;
          largeButtonsStyle = false;
          powerOptions = [
            {
              action = "lock";
              command = "";
              countdownEnabled = true;
              enabled = false;
              keybind = "";
            }
            {
              action = "suspend";
              command = "";
              countdownEnabled = true;
              enabled = false;
              keybind = "";
            }
            {
              action = "hibernate";
              command = "";
              countdownEnabled = true;
              enabled = false;
              keybind = "";
            }
            {
              action = "reboot";
              command = "";
              countdownEnabled = true;
              enabled = true;
              keybind = "1";
            }
            {
              action = "logout";
              command = "";
              countdownEnabled = true;
              enabled = false;
              keybind = "";
            }
            {
              action = "shutdown";
              command = "";
              countdownEnabled = true;
              enabled = true;
              keybind = "2";
            }
            {
              action = "rebootToUefi";
              command = "";
              countdownEnabled = true;
              enabled = true;
              keybind = "3";
            }
            {
              action = "userspaceReboot";
              command = "";
              countdownEnabled = true;
              enabled = false;
              keybind = "";
            }
          ];
        };
      };
    };
  };
}
