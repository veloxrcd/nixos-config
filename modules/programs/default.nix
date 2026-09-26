{ pkgs, inputs, ... }:

{
  imports = [
    ./dev.nix
  ];

  programs.nh = {
    enable = true;
    flake = "/home/mo/nixos-config";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;


   
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "sudo" "colored-man-pages" ];
    };

    promptInit = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
 # Strip the background color blocks completely
    typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND=none
    typeset -g POWERLEVEL9K_DIR_BACKGROUND=none
    typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND=none

    # Enforce a minimal layout layout elements
    POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon dir prompt_char)
    POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()

    # Style the text components with clear foreground colors
    typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=4    # Clean Blue NixOS icon
    typeset -g POWERLEVEL9K_DIR_FOREGROUND=7        # Soft white path text
    typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_LEFT_FOREGROUND=2 # Clean green prompt arrow

    # Force the explicit NixOS logo glyph character
    typeset -g POWERLEVEL9K_OS_ICON_CONTENT_EXPANDED=' '
    '';
  };

  environment.systemPackages = with pkgs; [
    zsh-powerlevel10k
    vlc
    mpv
    file-roller
    inputs.termipedia.packages.${system}.termipedia
    chromium
    wtype
    ffmpeg-full
    widevine-cdm
  ];
}
