{ config, pkgs, ... }:

{
  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
      wifi.powersave = false;
      settings = {
        device = {
          "wifi.scan-rand-mac-address" = "no";
        };
      };
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
  };
}

