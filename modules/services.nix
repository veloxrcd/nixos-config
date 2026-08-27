{...}:

{
  services.fwupd.enable = true;
  services.thermald.enable = true;
  services.input-remapper.enable = true;
  services.power-profiles-daemon.enable = true;
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
