{ config, pkgs, lib, ... }:
{
    boot = {
    # ========================================================================
    # KERNEL - CachyOS Bore (Scheduler Optimized for Interactivity)
    # ========================================================================
    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore;
    
    # ========================================================================
    # KERNEL PARAMETERS
    # ========================================================================
    kernelParams = [
      # AMD P-State
      "amd_pstate=active"
      
      # IOMMU for GPU passthrough capability
      "iommu=pt"
      "amd_iommu=on"
      
      # NVIDIA
      "nvidia-drm.modeset=1"
      "nvidia-drm.fbdev=1"
      
      # Quiet boot
      "quiet"
      "loglevel=3"
      
      # EC (Embedded Controller) write support for power management
      "ec_sys.write_support=1"
    ];
    
    # ========================================================================
    # KERNEL MODULES
    # ========================================================================
    kernelModules = [ "kvm-amd" "acpi_call" ];
    initrd.kernelModules = [ "amdgpu" ];
    
    # Extra kernel modules for power management
    extraModulePackages = with config.boot.kernelPackages; [
      acpi_call  # ACPI call for power profile control (Gigabyte EC)
    ];
  };

  # ========================================================================
  # CPU POWER MANAGEMENT
  # ========================================================================
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "schedutil";
  };

  # ========================================================================
  # ZRAM SWAP
  # ========================================================================
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  # ========================================================================
  # HARDWARE & FIRMWARE
  # ========================================================================
  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
}
