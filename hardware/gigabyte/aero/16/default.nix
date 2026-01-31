{ lib, pkgs, ... }:

{
  imports = [
    ./cpu.nix
    ./gpu.nix
    ./network.nix
    ./fans.nix
  ];

  # Force stable kernel as requested for stability
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_stable;

  # Standard boot loader settings (verify if needed here or keeps it to user config)
  # Hardware modules usually focus on hardware support, not bootloader preference.
  # But we can ensure efi support.
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;
}
