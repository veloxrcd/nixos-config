{ config, pkgs, ... }:

{
  boot = {
    # 1. CRITICAL: Force the Intel modesetting driver to load in Stage 1 initrd
    initrd.kernelModules = [ "i915" ];

    # 2. Configure Plymouth
    plymouth = {
      enable = true;
      theme = "bgrt"; 
    };

    # 3. Clean kernel parameters that won't stall the GPU
    kernelParams = [ 
      "quiet" 
      "splash"
      "i915.fastboot=1"          # Prevents Intel from blinking or resetting the display
      "fbcon=nodefer"            # Force the frame buffer to initialize instantly
    ];

    # 4. Turn off systemd's aggressive silencing which can block the DRM graphics stack
    consoleLogLevel = 3;
    initrd.verbose = false;
  };
}
