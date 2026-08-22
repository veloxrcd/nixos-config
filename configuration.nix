{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/core.nix
    ./modules/desktop.nix
    ./modules/networking.nix
    ./modules/sound.nix
    ./modules/services.nix
    ./modules/gaming.nix
    ./modules/programs
  ];

  users.users.mo = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "docker" "gamemode" ];
    shell = pkgs.zsh;
  };

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  system.stateVersion = "26.05";
}
