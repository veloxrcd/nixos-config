{ pkgs, inputs, ... }:


{
  imports = [
    ./dev.nix
  ];

  environment.systemPackages = with pkgs; [
    firefox
    vlc
    mpv
    file-roller
    inputs.termipedia.packages.${system}.termipedia
    chromium
  ];
}
