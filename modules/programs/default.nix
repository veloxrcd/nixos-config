{ pkgs, inputs, ... }:


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
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.termipedia.packages.${system}.termipedia
  ];
}
