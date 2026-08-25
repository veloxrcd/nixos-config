{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    neovim
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
    gnome-boxes
  ];

   virtualisation.libvirtd.enable = true;


  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    };

}




