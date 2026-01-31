{ config, lib, pkgs, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = lib.mkDefault true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/
    powerManagement.enable = lib.mkDefault true;

    # Fine-grained power management. Turns off the GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = lib.mkDefault false; # Often causes issues, keeping false for stability

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    # User might need this True for 50 series? 
    # Context says "RTX 5060", which is Blackwell. Open kernel modules are REQUIRED for Blackwell.
    open = lib.mkDefault true;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = lib.mkDefault true;

    # Prime configuration
    prime = {
      # Hybrid offload mode
      offload = {
        enable = lib.mkDefault true;
        enableOffloadCmd = lib.mkDefault true;
      };
      
      # Reverse Prime (using dGPU as output for internal screen) not enabled by default
      # Sync mode not enabled by default for "generic" hardware repo config, 
      # usually offload is the safe default for laptops.

      # Bus IDs - MUST be set by the user or detected?
      # nixos-hardware configs usually expect the user to ensure these are correct 
      # or try to set common defaults if model is strict.
      # For now keeping them commented or variable? 
      # Actually, for a specific sub-model (Aero 16 X16), these might be constant.
      # Checking user's current config: Nvidia 100:0:0, AMD 101:0:0
      
      amdgpuBusId = lib.mkDefault "PCI:101:0:0"; 
      nvidiaBusId = lib.mkDefault "PCI:100:0:0";
    };
  };
}
