{ config, pkgs, ... }:
{
  # ========================================================================
  # GAMING - Steam, Gamemode, GPU Tools
  # ========================================================================
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    remotePlay.openFirewall = true;
  };
  
  services.switcherooControl.enable = true;
  # NOT: LACT paketi packages.nix'te eklendi
  # lactd servisi yok, sadece GUI uygulaması var
  programs.gamemode = {
    enable = true;
    settings.general.renice = 10;
  };
  
  # ========================================================================
  # GPU POWER LIMIT - Increase from 30W to 100W
  # ========================================================================
  systemd.services.nvidia-power-limit = {
    description = "Set NVIDIA GPU Power Limit";
    wantedBy = [ "graphical.target" ];
    after = [ "nvidia-persistenced.service" "display-manager.service" ];
    requires = [ "nvidia-persistenced.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      # Wait for GPU to be available, retry a few times
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.linuxPackages.nvidia_x11.bin}/bin/nvidia-smi -pl 100 || true'";
    };
  };
  
  # Enable nvidia-persistenced for power management
  hardware.nvidia.nvidiaPersistenced = true;
}
