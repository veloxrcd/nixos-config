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
}
