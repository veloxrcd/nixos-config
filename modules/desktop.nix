{ pkgs, ... }:

{
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  environment.systemPackages = with pkgs; [
    kdePackages.kate
    kdePackages.spectacle
    kdePackages.ark
    kdePackages.dolphin
    kdePackages.konsole
    kdePackages.plasma-systemmonitor
];

environment.sessionVariables = {
  # Forces KWin to use triple buffering on Wayland for smoother rendering
  KWIN_DRM_USE_TRIPLE_BUFFERING = "1";
};


programs.qylock = {
enable = true;
theme = "sword";
};


fonts.packages = with pkgs; [
nerd-fonts.iosevka
];


}

