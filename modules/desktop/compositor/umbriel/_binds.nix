{ lib, ... }:
let
  workspaces = builtins.genList (n: if n == 0 then 10 else n) 10;

  workspaceBinds = lib.listToAttrs (
    map (n: lib.nameValuePair "Mod+${toString (lib.mod n 10)}" "workspace-switch:${toString n}") workspaces
  );
  moveToWorkspaceBinds = lib.listToAttrs (
    map (
      n: lib.nameValuePair "Mod+Shift+${toString (lib.mod n 10)}" "window-move-to-workspace:${toString n}"
    ) workspaces
  );
in
{
  "Mod+Q" = {
    action = "window-close";
    repeat = false;
  };
  "Mod+D" = {
    action = "window-toggle-floating";
    repeat = false;
  };
  "Mod+F" = {
    action = "window-toggle-fullscreen";
    repeat = false;
  };

  "Mod+H" = "window-focus-left";
  "Mod+J" = "window-focus-down";
  "Mod+K" = "window-focus-up";
  "Mod+L" = "window-focus-right";

  "Mod+Shift+H" = "column-move-left";
  "Mod+Shift+J" = "window-move-down";
  "Mod+Shift+K" = "window-move-up";
  "Mod+Shift+L" = "column-move-right";
}
// workspaceBinds
// moveToWorkspaceBinds
// {
  "Mod+Return" = {
    action = "spawn:$TERMINAL";
    repeat = false;
  };
  "Mod+Space" = {
    action = "spawn:$DESKTOP_LAUNCHER";
    repeat = false;
  };
  "Mod+Shift+Space" = {
    action = "spawn:$DESKTOP_POWERMENU";
    repeat = false;
  };

  "XF86AudioMute" = {
    action = "spawn:wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
    allow_when_inhibited = true;
    repeat = false;
  };
  "XF86AudioLowerVolume" = {
    action = "spawn:wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
    allow_when_inhibited = true;
    repeat = true;
  };
  "XF86AudioRaiseVolume" = {
    action = "spawn:wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
    allow_when_inhibited = true;
    repeat = true;
  };

  "XF86MonBrightnessUp" = {
    action = "spawn:brightnessctl set +10%";
    repeat = true;
  };
  "XF86MonBrightnessDown" = {
    action = "spawn:brightnessctl set 10%-";
    repeat = true;
  };
}
