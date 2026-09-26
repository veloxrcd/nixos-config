{ config, pkgs, ... }:

{
  boot = {
    # 1. Force the integrated Intel kernel modesetting to load early
    initrd.kernelModules = [ "i915" ];

    # 2. Enable Plymouth using the fallback-friendly default theme
    plymouth = {
      enable = true;
      theme = "bgrt"; 
    };

    # 3. Tell the kernel to allocate simple graphics space immediately
    kernelParams = [ 
      "quiet" 
      "splash"
      "plymouth.use-simpledrm"
    ];

    # 4. Give systemd enough visibility to hand over graphics smoothly
    consoleLogLevel = 3;
    initrd.verbose = false;
    initrd.systemd.enable = true;
  };
}
