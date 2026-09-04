{ pkgs, inputs, ... }:


{
  imports = [
    ./dev.nix
  ];

   
   programs.nh = {
   enable = true;
   flake = "/home/mo/nixos-config";
   };

   programs.fish = {
  enable = true;

  interactiveShellInit = ''
    # Permanent Tide layout: NixOS logo -> Path -> Prompt Arrow
    set -g tide_left_prompt_items os pwd newline character
    set -g tide_git_status_items
  '';
};


  environment.systemPackages = with pkgs; [
    vlc
    mpv
    file-roller
    inputs.termipedia.packages.${system}.termipedia
    chromium
    fishPlugins.tide
    ydotool
    wtype
  ];
}
