{ pkgs, ... }:

{
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    package = pkgs.swayfx;
  };

  environment.systemPackages = with pkgs; [
    kdePackages.kate
    kdePackages.spectacle
    kdePackages.ark
    kdePackages.dolphin
    kdePackages.konsole
    kdePackages.plasma-systemmonitor
  ];

  environment.sessionVariables = {
    KWIN_DRM_USE_TRIPLE_BUFFERING = "1";
  };

  programs.qylock = {
    enable = true;
    theme = "sword";
  };
  
  
}

