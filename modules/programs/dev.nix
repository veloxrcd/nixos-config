{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    neovim
    vscodium
    git
    gh
    gnumake
    gcc
    ripgrep
    fd
    lua-language-server
    stylua
    tree-sitter
    docker-compose
  ];

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };
}
