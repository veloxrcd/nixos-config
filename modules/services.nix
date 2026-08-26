{...}:

{
  services.fwupd.enable = true;
  services.thermald.enable = true;
  services.input-remapper.enable = true;
  services.power-profiles-daemon.enable = true;
  services.flatpak.enable = true;
  services.flatpak.remotes = [{
   name = "flathub";
   location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
   }
   ];

    services.flatpak.packages = [
      "org.vinegarhq.Sober"
      "app.zen_browser.zen"
      "com.discordapp.Discord"
      "org.altaqwaa.Altaqwaa"
      ];


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
