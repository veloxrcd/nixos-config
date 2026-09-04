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
    qemu
    virt-manager
    virt-viewer
    rot8
  ];

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };
}

