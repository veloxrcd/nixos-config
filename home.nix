{ pkgs, inputs, ... }:

{
  home.username = "mo";
  home.homeDirectory = "/home/mo";
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
  imports = [ 
   inputs.areofyl-fetch.homeManagerModules.default 
   ./modules/plasma.nix
  ];
   
  programs.fetch = {
    enable = true;
  };

 xdg.configFile."kitty/kitty.conf".source = ./dotfiles/kitty/kitty.conf;
 xdg.configFile."hypr/hyprland.lua".source = ./dotfiles/hypr/hyprland.lua;
  home.packages = with pkgs; [
    pwvucontrol
    cliphist
    wl-clipboard
    jetbrains-mono
    kitty
    statix
    deadnix
    nixfmt
    fzf
    ripgrep
    fd
    nix-search-tv
  ];

  fonts.fontconfig.enable = true;

}
