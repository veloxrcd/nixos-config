{ pkgs, inputs, ... }:


{
  imports = [
    ./dev.nix
  ];

   
   programs.nh = {
   enable = true;
   flake = "/home/mo/nixos-config";
   };

   programs.fish.enable = true;


  environment.systemPackages = with pkgs; [
    firefox
    vlc
    mpv
    file-roller
    inputs.termipedia.packages.${system}.termipedia
    chromium
    github-cli
    fishPlugins.tide
  ];
}
