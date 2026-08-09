{ pkgs, ... }:

{
  services.fwupd.enable = true;
  services.thermald.enable = true;

  # Explicitly disabled to resolve auto-cpufreq collision with KDE Plasma 6
  services.power-profiles-daemon.enable = false;
  services.auto-cpufreq.enable = true;

  services.flatpak.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };



  security.doas = {
    enable = true;
    extraRules = [{
      users = [ "mo" ];
      keepEnv = true;
      persist = true;
    }];
  };
}
