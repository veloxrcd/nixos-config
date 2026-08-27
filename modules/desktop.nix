{ pkgs, ... }:

{
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  programs.hyprland = {
    enable = true;
    withUWSM = true; # Clean systemd session management
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    kdePackages.kate
    kdePackages.spectacle
    kdePackages.ark
    kdePackages.dolphin
    kdePackages.konsole
    kdePackages.plasma-systemmonitor
    waybar
    rofi
    dunst
    hyprpaper
    qt5.qtwayland
    qt6.qtwayland
  ];

  environment.sessionVariables = {
    KWIN_DRM_USE_TRIPLE_BUFFERING = "1";
  };

  programs.qylock = {
    enable = true;
    theme = "sword";
  };
  
  
}

