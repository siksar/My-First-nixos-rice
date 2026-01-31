{ config, lib, pkgs, ... }:

{
  # Improve WiFi/Bluetooth coexistence and stability for Intel/Killer cards
  boot.extraModprobeConfig = ''
    options iwlwifi bt_coex_active=1 power_save=0
    options iwlmvm power_scheme=1
  '';
  
  # Note: 11n_disable=1 is sometimes recommended but can limit speed. 
  # We start with bt_coex_active=1 (coexistence enabled) and power_save=0.
  
  # Ensure bluetooth is enabled
  hardware.bluetooth.enable = lib.mkDefault true;
  hardware.bluetooth.powerOnBoot = lib.mkDefault true;
}
