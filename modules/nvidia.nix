{ config, pkgs, ... }:
{
  # ========================================================================
  # GPU CONFIGURATION - AMD + NVIDIA PRIME
  # ========================================================================
  
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  
  services.xserver.videoDrivers = [ "nvidia" ];
  
  hardware.nvidia = {
    modesetting.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;  # Beta for RTX 5060 support
    open = true;  # REQUIRED for RTX 50 series (Blackwell) GPUs!
    nvidiaSettings = true;
    
    powerManagement.enable = true;
    powerManagement.finegrained = false;  # Disable for sync mode
    
    # Dynamic Boost - allows GPU to use more power when CPU is idle
    dynamicBoost.enable = true;
    
    prime = {
      # Sync mode - Nvidia GPU always active, better for gaming
      sync.enable = true;
      
      # Bus IDs from lspci (hex 64 = decimal 100, hex 65 = decimal 101)
      amdgpuBusId = "PCI:101:0:0";
      nvidiaBusId = "PCI:100:0:0";
    };
  };
  
  # nvidia-powerd is started automatically when dynamicBoost is enabled
}
