{ config, pkgs, ... }:
{
  # ========================================================================
  # NETWORKING CONFIGURATION
  # ========================================================================
  
  networking = {
    hostName = "nixos";
    
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
    
    firewall = {
      enable = true;
      allowedTCPPorts = [ 27015 27036 ];
      allowedUDPPorts = [ 27015 27031 27036 ];
      allowedTCPPortRanges = [ ];
      allowedUDPPortRanges = [ ];
    };
  };
  services.resolved = {
    enable = true;
    dnssec = "false";
    extraConfig = ''
      DNS=1.1.1.1 1.0.0.1
      FallbackDNS=8.8.8.8 8.8.4.4
    '';
  };
}
