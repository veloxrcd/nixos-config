{ pkgs, inputs, ... }:

{
  imports = [
    inputs.plasma-manager.homeModules.plasma-manager
  ];

  programs.plasma = {
    enable = true;

    configFile = {
      # Fonts & Appearance
      "kdeglobals"."General"."font" = "Iosevka Nerd Font,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,,0,0";
      "kdeglobals"."General"."fixed" = "Iosevka Nerd Font,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,,0,0";
      "kdeglobals"."General"."menuFont" = "Iosevka Nerd Font,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,,0,0";
      "kdeglobals"."General"."toolBarFont" = "Iosevka Nerd Font,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,,0,0";
      "kdeglobals"."General"."smallestReadableFont" = "Iosevka Nerd Font,8,-1,5,400,0,0,0,0,0,0,0,0,0,0,1,,0,0";

      # Window Colors
      "kdeglobals"."WM"."activeBackground" = "30,30,46";
      "kdeglobals"."WM"."activeForeground" = "205,214,244";
      "kdeglobals"."WM"."inactiveBackground" = "30,30,46";
      "kdeglobals"."WM"."inactiveForeground" = "186,194,222";

      # Tiling & KWin Plugins
      "kwinrc"."Plugins"."poloniumEnabled" = true;
      "kwinrc"."Plugins"."krohnkiteEnabled" = false;
      "kwinrc"."Plugins"."blurEnabled" = true;

      # Locale
      "plasma-localerc"."Formats"."LANG" = "en_GB.UTF-8";

      # Input Devices
      "kcminputrc"."Libinput/1739/52619/SYNA8004:00 06CB:CD8B Touchpad"."Enabled" = true;
      "kcminputrc"."Libinput/12625/12320/YICHIP 2.4G Receiver Mouse"."PointerAcceleration" = 0.20;
      "kcminputrc"."Libinput/12625/12320/YICHIP 2.4G Receiver Mouse"."PointerAccelerationProfile" = 1;

      # KWallet
      "kwalletrc"."Wallet"."Enabled" = false;

      # Wallpaper
      "plasmarc"."Wallpapers"."usersWallpapers" = "/home/mo/Downloads/storm.jpg";
    };

    shortcuts = {
      # Application Launchers
      "services/kitty.desktop"."_launch" = "Meta+Return";
      "services/app.zen_browser.zen.desktop"."_launch" = "Meta+T";

      # Window Management
      "kwin"."Window Close" = "Meta+Q";
      "kwin"."Window Fullscreen" = [ "F11" "Meta+F" ];
      "kwin"."Window Maximize" = "Meta+PgUp";
      "kwin"."Window Minimize" = "Meta+PgDown";
      "kwin"."Window Restore" = "Meta+Backspace";
      "kwin"."Overview" = "Meta+W";
      "kwin"."Grid View" = "Meta+G";
      "kwin"."Show Desktop" = "Meta+D";
      "kwin"."Kill Window" = "Meta+Ctrl+Esc";

      # Polonium Tiling Controls
      "kwin"."PoloniumToggleActiveTiling" = "Meta+Shift+Space";
      "kwin"."PoloniumActivateLeft" = "Meta+H";
      "kwin"."PoloniumActivateBelow" = "Meta+J";
      "kwin"."PoloniumActivateAbove" = "Meta+K";
      "kwin"."PoloniumActivateRight" = "Meta+L";
      "kwin"."PoloniumPlaceLeft" = "Meta+Shift+H";
      "kwin"."PoloniumPlaceBelow" = "Meta+Shift+J";
      "kwin"."PoloniumPlaceAbove" = "Meta+Shift+K";
      "kwin"."PoloniumPlaceRight" = "Meta+Shift+L";
      "kwin"."PoloniumResizeLeft" = "Meta+Ctrl+H";
      "kwin"."PoloniumResizeDown" = "Meta+Ctrl+J";
      "kwin"."PoloniumResizeUp" = "Meta+Ctrl+K";
      "kwin"."PoloniumResizeRight" = "Meta+Ctrl+L";

      # System & Media
      "kmix"."mute" = "Volume Mute";
      "kmix"."decrease_volume" = "Volume Down";
      "kmix"."increase_volume" = "Volume Up";
      "kmix"."mic_mute" = [ "Microphone Mute" "Meta+Volume Mute" ];

      # Session
      "ksmserver"."Lock Session" = [ "Screensaver" "Meta+L" ];
      "ksmserver"."Log Out" = "Ctrl+Alt+Del";
    };
  };
}
