{ config, pkgs, ... }:

{
  home.username = "mo";
  home.homeDirectory = "/home/mo";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  # Noctalia & Niri Dependencies
  home.packages = with pkgs; [
    # Audio & Clipboard
    pwvucontrol
    cliphist
    wl-clipboard
    jetbrains-mono
  ];

  # Allow fonts to be discovered system-wide
  fonts.fontconfig.enable = true;

  # Shell aliases
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    shellAliases = {
      rebuild = "cd ~/nixos-config && git add . && (git diff --cached --quiet || git commit -m \"rebuild: $(date +'%Y-%m-%d %H:%M:%S')\") && doas nixos-rebuild switch --flake .#nixos";
      conf = "nvim ~/nixos-config/configuration.nix";
      homeconf = "nvim ~/nixos-config/home.nix";
      flakeconf = "nvim ~/nixos-config/flake.nix";
      deskconf = "nvim ~/nixos-config/modules/desktop.nix";
      servconf = "nvim ~/nixos-config/modules/services.nix";
      progconf = "nvim ~/nixos-config/modules/programs/default.nix";
      devconf = "nvim ~/nixos-config/modules/programs/dev.nix";
      gameconf = "nvim ~/nixos-config/modules/gaming.nix";
      nixdir = "cd ~/nixos-config && nvim .";
    };

    initExtra = ''
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
  };
}
