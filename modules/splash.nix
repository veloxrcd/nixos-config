{ config, pkgs, ... }:

{
  boot = {
    # Enable Plymouth with the BGRT theme to keep the Lenovo logo
    plymouth = {
      enable = true;
      theme = "bgrt";
    };

    # Hide regular kernel text scrolling during boot
    consoleLogLevel = 0;
    initrd.verbose = false;
    
    # Kernel parameters for a completely silent, smooth transition
    kernelParams = [ 
      "quiet" 
      "splash" 
      "boot.shell_on_fail" 
      "loglevel=3" 
      "rd.systemd.show_status=false" 
      "rd.udev.log_level=3" 
      "udev.log_priority=3" 
    ];
    
    # Load graphics drivers early in the boot process
    initrd.systemd.enable = true;
  };
}

