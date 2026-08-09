{ pkgs, ... }:

{
  home.username = "mo";
  home.homeDirectory = "/home/mo";

  home.packages = with pkgs; [
    htop
    fastfetch
    ripgrep
    fd
    fzf
    lazygit
    zsh-powerlevel10k
  ];

  programs.firefox = {
    enable = true;
    profiles.mo = {
      isDefault = true;
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "svg.context-properties.content.enabled" = true;
        "sidebar.revamp" = true;
        "sidebar.verticalTabs" = true;
      };
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" "docker" ];
    };

    initContent = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';

    shellAliases = {
      rebuild = "cd ~/nixos-config && git add . && (git diff --cached --quiet || git commit -m \"rebuild: $(date +'%Y-%m-%d %H:%M:%S')\") && doas nixos-rebuild switch --flake .#nixos";
      conf = "nvim ~/nixos-config/configuration.nix";
      homeconf = "nvim ~/nixos-config/home.nix";
      flakeconf = "nvim ~/nixos-config/flake.nix";
      servconf = "nvim ~/nixos-config/modules/services.nix";
      progconf = "nvim ~/nixos-config/modules/programs/default.nix";
      devconf = "nvim ~/nixos-config/modules/programs/dev.nix";
      gameconf = "nvim ~/nixos-config/modules/gaming.nix";
      nixdir = "cd ~/nixos-config && nvim .";
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "mo";
        email = "mo@example.com";
      };
    };
  };

  home.stateVersion = "26.11";
}

