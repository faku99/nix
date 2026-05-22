{
  lib,
  ...
}:
let
  inherit (lib.generators) mkLuaInline;

  mod = "SUPER";

  # Bind helper
  bind = key: dsp: {
    _args = [
      key
      dsp
    ];
  };
  bindFlags = flags: key: dsp: {
    _args = [
      key
      dsp
      flags
    ];
  };
  bindLocked = bindFlags { locked = true; };
  bindLockedRepeat = bindFlags {
    locked = true;
    repeating = true;
  };
  bindRepeat = bindFlags { repeating = true; };
  bindMouse = bindFlags { mouse = true; };

  # Dispatcher helpers
  killActive = mkLuaInline "hl.dsp.window.close()";
  exec = cmd: mkLuaInline ''hl.dsp.exec_cmd("${cmd}")'';
  toggleFullscreen = mkLuaInline ''hl.dsp.window.fullscreen({ action = "toggle" })'';
  toggleFloating = mkLuaInline ''hl.dsp.window.float({ action = "toggle" })'';
  layoutmsg = msg: mkLuaInline ''hl.dsp.layout("${msg}")'';
  moveFocus = dir: mkLuaInline ''hl.dsp.focus({ direction = "${dir}" })'';
  moveWindow = dir: mkLuaInline ''hl.dsp.window.move({ direction = "${dir}" })'';
  focusWorkspace = n: mkLuaInline ''hl.dsp.focus({ workspace = "${toString n}" })'';
  moveToWorkspace = n: mkLuaInline ''hl.dsp.window.move({ workspace = "${toString n}" })'';
  dragWindow = mkLuaInline "hl.dsp.window.drag()";
  resizeWindow = mkLuaInline "hl.dsp.window.resize()";

  workspaces = builtins.genList (
    n:
    let
      key = if n == 10 then 0 else n;
    in
    {
      inherit key n;
    }
  ) 11;
in
[
  # Window management
  (bind "${mod} + Q" killActive)
  (bind "${mod} + D" toggleFloating)
  (bind "${mod} + F" toggleFullscreen)
  (bind "${mod} + V" (layoutmsg "togglesplit"))

  # Move focus
  (bind "${mod} + H" (moveFocus "left"))
  (bind "${mod} + J" (moveFocus "down"))
  (bind "${mod} + K" (moveFocus "up"))
  (bind "${mod} + L" (moveFocus "right"))

  # Move window
  (bind "${mod} + SHIFT + H" (moveWindow "left"))
  (bind "${mod} + SHIFT + J" (moveWindow "down"))
  (bind "${mod} + SHIFT + K" (moveWindow "up"))
  (bind "${mod} + SHIFT + L" (moveWindow "right"))
]
# Move focus to workspace
++ map (w: bind "${mod} + ${toString w.key}" (focusWorkspace w.n)) workspaces
# Move window to workspace
++ map (w: bind "${mod} + SHIFT + ${toString w.key}" (moveToWorkspace w.n)) workspaces
++ [
  # Apps
  (bind "${mod} + RETURN" (exec "$TERMINAL"))
  (bind "${mod} + SPACE" (exec "$DESKTOP_LAUNCHER"))
  (bind "${mod} + SHIFT + SPACE" (exec "$DESKTOP_POWERMENU"))

  # Volume
  (bindLocked "XF86AudioMute" (exec "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
  (bindLockedRepeat "XF86AudioLowerVolume" (exec "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
  (bindLockedRepeat "XF86AudioRaiseVolume" (exec "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"))

  # Brightness
  (bindRepeat "XF86MonBrightnessUp" (exec "brightnessctl set +10%"))
  (bindRepeat "XF86MonBrightnessDown" (exec "brightnessctl set 10%-"))

  # Move/resize window
  (bindMouse "${mod} + mouse:272" dragWindow)
  (bindMouse "${mod} + mouse:273" resizeWindow)
]
