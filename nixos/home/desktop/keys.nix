{ config, lib, pkgs, ... }:

let
  launcher = "${lib.getBin pkgs.i3}/bin/i3-msg exec";

in {
  services.sxhkd = {
    enable = true;

    keybindings = {
      "XF86AudioMute" = "${lib.getBin pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
      "XF86AudioLowerVolume" = "${lib.getBin pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
      "XF86AudioRaiseVolume" = "${lib.getBin pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";

      "XF86AudioMicMute" = "${lib.getBin pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";

      "XF86MonBrightnessDown" = "${lib.getBin pkgs.brightnessctl}/bin/brightnessctl s 5%-";
      "XF86MonBrightnessUp" = "${lib.getBin pkgs.brightnessctl}/bin/brightnessctl s +5%";

      # Open an interactive application launcher.
      "super + space" = "${launcher} '${lib.getBin pkgs.rofi}/bin/rofi -show run --lines 10'";
      # Launch a new terminal.
      "{super, alt} + Return" = "${launcher} '${lib.getBin pkgs.alacritty}/bin/alacritty'";
      # Launch firefox.
      "super + w" = "${launcher} '${lib.getBin "firefox-sandboxed"}'";
      # Lock the screen.
      "super + shift + l" = "${launcher} '${lib.getBin pkgs.xautolock}/bin/xautolock -locknow'";

      # Screenshot the current window.
      "Print" = "${lib.getBin pkgs.scrot}/bin/scrot -u -e '${lib.getBin pkgs.coreutils}/bin/mv $f \\${config.xdg.userDirs.desktop}/'";
      # Screenshot the whole screen.
      "super + Print" = "${lib.getBin pkgs.scrot}/bin/scrot -e '${lib.getBin pkgs.coreutils}/bin/mv $f \\${config.xdg.userDirs.desktop}/'";
    };
  };
}
