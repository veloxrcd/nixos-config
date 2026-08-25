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

services.tlp = {
  enable = true;
  settings = {
    # Prevent the Intel GPU from dropping to minimum power speeds
    INTEL_GPU_MIN_FREQ_ON_AC = 800; # Boosts base clock from 300MHz to 800MHz
    INTEL_GPU_MAX_FREQ_ON_AC = 1150; # Maximum frequency for UHD 620
    INTEL_GPU_BOOST_FREQ_ON_AC = 1150;
    
    # You can keep energy saving active on battery if you prefer:
    INTEL_GPU_MIN_FREQ_ON_BAT = 300;
    INTEL_GPU_MAX_FREQ_ON_BAT = 800;
  };
};


fonts.packages = with pkgs; [
nerd-fonts.iosevka
];


}

