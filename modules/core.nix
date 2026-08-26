{ pkgs, ... }:

{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # All system fonts unified cleanly into one core module
  fonts.packages = with pkgs; [
    nerd-fonts.meslo-lg
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
  ];

  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    unzip
    p7zip
    pciutils
    usbutils
  ];
}

