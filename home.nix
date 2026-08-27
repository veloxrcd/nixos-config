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

  home.sessionVariables = {
    EDITOR = "nvim";
    };

xdg.configFile."sway".source = ./dotfiles/sway;
  xdg.configFile."kitty".source = ./dotfiles/kitty;
  xdg.configFile."waybar".source = ./dotfiles/waybar;
  xdg.configFile."rofi".source = ./dotfiles/rofi;


  home.packages = with pkgs; [
    pwvucontrol
    cliphist
    yazi
    wl-clipboard
    jetbrains-mono
    kitty
    slurp
    statix
    deadnix
    nixfmt
    fzf
    ripgrep
    fd
    nix-search-tv
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
