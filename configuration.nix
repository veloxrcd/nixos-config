{ pkgs, inputs, ... }:

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
 

 environment.shellAliases = {
rebuild = "cd ~/nixos-config && git add . && nh os switch . && nixsync";
      conf = "nvim ~/nixos-config/configuration.nix";
      homeconf = "nvim ~/nixos-config/home.nix";
      flakeconf = "nvim ~/nixos-config/flake.nix";
      deskconf = "nvim ~/nixos-config/modules/desktop.nix";
      servconf = "nvim ~/nixos-config/modules/services.nix";
      progconf = "nvim ~/nixos-config/modules/programs/default.nix";
      devconf = "nvim ~/nixos-config/modules/programs/dev.nix";
      gameconf = "nvim ~/nixos-config/modules/gaming.nix";
      nixdir = "cd ~/nixos-config && nvim .";
      nixsync = "cd ~/nixos-config/ && git add . && git commit -m \"Backup: (date -Iseconds)\" && git push origin main";
      clean = "nh clean all --keep 4";
      "," = "nix run nixpkgs#";
      dotdir = "cd ~/nixos-config/dotfiles && nvim .";
 };

nix.gc = {
  automatic = true;
  dates = "weekly";
  options = "--delete-older-than 7d";
};

boot.supportedFilesystems = [ "btrfs" ];
hardware.graphics.enable = true;
boot.kernelPackages = pkgs.linuxPackages_latest;

  users.users.mo = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "docker" "gamemode" ];
    shell = pkgs.fish;
  };

  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  system.stateVersion = "26.05";
}
