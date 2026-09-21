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
  ];
}
