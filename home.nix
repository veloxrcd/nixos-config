{ pkgs, inputs, ... }:

{
  home.username = "mo";
  home.homeDirectory = "/home/mo";
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
  imports = [ 
   inputs.areofyl-fetch.homeManagerModules.default 
  ];
   
  programs.fetch = {
    enable = true;
  };

 
xdg.configFile."sway".source = ./dotfiles/sway;
  xdg.configFile."kitty".source = ./dotfiles/kitty;
  xdg.configFile."nwg-panel".source = ./dotfiles/nwg-panel;
  xdg.configFile."nwg-drawer".source = ./dotfiles/nwg-drawer;
  xdg.configFile."waybar".source = ./dotfiles/waybar;
  xdg.configFile."rofi".source = ./dotfiles/rofi;


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
    nwg-panel
    nwg-drawer
    nwg-bar
    nwg-dock
    nwg-look
    nwg-displays
    nwg-wrapper
    nwg-clipman
    kitty
    swaybg
    waybar
    autotiling
    librsvg
    rofimoji
    rofi
    swaylock-effects
    inputs.zen-browser.packages.${pkgs.system}.default
    fastfetch
    cmatrix
    lavat
  ];

  fonts.fontconfig.enable = true;

}
