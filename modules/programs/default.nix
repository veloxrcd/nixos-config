{ pkgs, ... }:

{
  imports = [
    ./dev.nix
  ];

  environment.systemPackages = with pkgs; [
    firefox
    brave
    vlc
    mpv
    alacritty
    file-roller
  ];
}
