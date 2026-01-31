{ config, lib, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.nbfc-linux ];

  # Configure NBFC using the identified profile for Gigabyte Aero 16
  environment.etc."nbfc/nbfc.json".source = ./nbfc-config.json;

  systemd.services.nbfc_service = {
    description = "NoteBook FanControl service";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.nbfc-linux}/bin/nbfc_service --config-file /etc/nbfc/nbfc.json";
      Restart = "always";
      RestartSec = 5;
    };
    script = ''
        modprobe ec_sys write_support=1
    '';
  };
}
