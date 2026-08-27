{ pkgs, ... }:

{
  services.displayManager.sddm.wayland.enable = true;
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    package = pkgs.swayfx;
  };

  environment.systemPackages = with pkgs; [
    kdePackages.dolphin
  ];

  environment.sessionVariables = {
    KWIN_DRM_USE_TRIPLE_BUFFERING = "1";
  };

  programs.qylock = {
    enable = true;
    theme = "sword";
  };
  
  
}

