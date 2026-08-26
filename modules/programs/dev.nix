{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    neovim
    gh
    gnumake
    gcc
    lua-language-server
    stylua
    tree-sitter
    docker-compose
    gnome-boxes
    obs-studio
  ];

  virtualisation.libvirtd.enable = true;

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };
}

