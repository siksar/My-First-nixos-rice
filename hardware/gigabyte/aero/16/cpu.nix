{ config, lib, pkgs, ... }:

{
  # Output of lscpu/hardware probes would confirm this, assuming Ryzen AI 7 350 (Zen 5)
  # or similar modern AMD CPU based on conversation context.
  
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  
  boot.kernelParams = [
    "amd_pstate=active" # Enable AMD P-State driver for better power efficiency/performance
  ];
}
