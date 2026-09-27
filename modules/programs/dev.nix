{ pkgs, inputs, ... }:

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
    (python3.withPackages (ps: [ ps.evdev ]))
  ];

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;



boot.plymouth = {
    enable = true;
    theme = "mac-style";
    themePackages = [
      inputs.mac-style-plymouth.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };


  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };
}
