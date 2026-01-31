{ config, pkgs, lib, ... }:
{
  # ========================================================================
  # LAPTOP POWER MANAGEMENT & UNDERVOLT TOOLS
  # Gigabyte Aero X16 1VH (AMD Ryzen + NVIDIA) için optimize edilmiş
  # ========================================================================

  environment.systemPackages = with pkgs; [
    # ─────────────────────────────────────────────────────────────────────
    # AMD RYZEN SPECIFIC TOOLS
    # ─────────────────────────────────────────────────────────────────────
    
    # RyzenAdj - AMD Ryzen mobile processor tuning (TDP, power limits, temps)
    # BIOS'a erişim olmadan undervolt ve TDP ayarı yapabilirsiniz
    ryzenadj
    
    # ─────────────────────────────────────────────────────────────────────
    # GENERAL POWER MANAGEMENT
    # ─────────────────────────────────────────────────────────────────────
    
    # PowerTop - Intel/AMD power consumption analyzer
    powertop
    
    # auto-cpufreq - Automatic CPU power management for laptops
    auto-cpufreq
    
    # s-tui - Terminal UI for monitoring CPU temp, freq, power
    s-tui
    
    # stress-ng - CPU stress testing (s-tui ile birlikte kullanılır)
    stress-ng
    
    # cpupower - CPU frequency scaling utilities
    linuxPackages_latest.cpupower
    
    # ─────────────────────────────────────────────────────────────────────
    # GPU & DISPLAY CONTROL
    # ─────────────────────────────────────────────────────────────────────
    
    # EnvyControl not in nixpkgs - install via pip if needed: pip install envycontrol
    # Alternative: use nvidia-offload wrapper or prime-run
    
    # glxinfo/glxgears - OpenGL testing (part of mesa-demos)
    mesa-demos
    
    # nvtop full - GPU monitoring (RTX 5060 support)
    nvtopPackages.full
    
    # ─────────────────────────────────────────────────────────────────────
    # FAN & PERIPHERAL CONTROL
    # ─────────────────────────────────────────────────────────────────────
    
    # NBFC-Linux - Notebook Fan Control (Gigabyte profiles)
    nbfc-linux
    
    # OpenRGB - Keyboard and system RGB lighting control
    openrgb
    
    # ─────────────────────────────────────────────────────────────────────
    # THERMAL MANAGEMENT
    # ─────────────────────────────────────────────────────────────────────
    
    # lm_sensors - Hardware monitoring (fan speed, temps, voltages)
    lm_sensors
    
    # acpi - Battery and thermal info
    acpi
    
    # thermald - Thermal daemon (Intel/AMD thermal management)
    thermald
    
    # ─────────────────────────────────────────────────────────────────────
    # LAPTOP SPECIFIC
    # ─────────────────────────────────────────────────────────────────────
    
    # brightnessctl - Display brightness control
    brightnessctl
    
    # light - Alternative brightness controller
    light
    
    # acpilight - xbacklight replacement using ACPI
    acpilight
    
    # ─────────────────────────────────────────────────────────────────────
    # SYSTEM MONITORING & HARDWARE UTILS
    # ─────────────────────────────────────────────────────────────────────
    
    # btop - Modern resource monitor
    btop
    
    # iotop - I/O monitoring
    iotop
    
    # perf - Linux performance tools
    linuxPackages_latest.perf
    
    # pciutils - lspci command for hardware inspection
    pciutils
    
    # usbutils - lsusb command for USB device inspection
    usbutils
    
    # ─────────────────────────────────────────────────────────────────────
    # BIOS/FIRMWARE TOOLS
    # ─────────────────────────────────────────────────────────────────────
    
    # fwupd - Firmware updates via Linux (LVFS)
    fwupd
    
    # efibootmgr - EFI boot manager
    efibootmgr
  ];

  # ========================================================================
  # HARDWARE SENSORS
  # ========================================================================
  hardware.sensor.iio.enable = true;  # Accelerometer vb. sensörler

  # ========================================================================
  # UDEV RULES - RyzenAdj ve diğer araçlar için gerekli izinler
  # ========================================================================
  services.udev.extraRules = ''
    # RyzenAdj için MSR erişimi
    KERNEL=="msr", MODE="0660", GROUP="wheel"
    
    # CPU core erişimi
    SUBSYSTEM=="cpu", MODE="0660", GROUP="wheel"
    
    # Backlight kontrolü
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
    
    # NVIDIA GPU power management
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030000", TEST=="power/control", ATTR{power/control}="auto"
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030200", TEST=="power/control", ATTR{power/control}="auto"
  '';

  # ========================================================================
  # KERNEL MODULES - Power management için gerekli modüller
  # ========================================================================
  boot.kernelModules = [
    "msr"           # Model Specific Registers (RyzenAdj için)
    "cpuid"         # CPU identification
    "acpi_cpufreq"  # ACPI CPU frequency scaling
    "coretemp"      # CPU temperature reading
    "k10temp"       # AMD K10/Zen temperature
  ];

  # ========================================================================
  # SYSCTL - Power management optimizations
  # ========================================================================
  boot.kernel.sysctl = {
    # Laptop mode - agresif güç tasarrufu
    "vm.laptop_mode" = 5;
    
    # Dirty page writeback tuning
    "vm.dirty_writeback_centisecs" = 6000;
    "vm.dirty_expire_centisecs" = 6000;
    
    # Swappiness - RAM tercih et
    "vm.swappiness" = 10;
  };

  # ========================================================================
  # THERMALD SERVICE
  # ========================================================================
  services.thermald.enable = true;

  # ========================================================================
  # AUTO-CPUFREQ SERVICE - Best automatic power management for laptops
  # ========================================================================
  services.auto-cpufreq = {
    enable = true;
    settings = {
      charger = {
        governor = "performance";
        turbo = "auto";
      };
      battery = {
        governor = "powersave";
        turbo = "never";
      };
    };
  };

  # ========================================================================
  # FWUPD SERVICE - Firmware updates
  # ========================================================================
  services.fwupd.enable = true;

  # ========================================================================
  # OPENRGB - Hardware access for RGB control
  # ========================================================================
  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";  # AMD chipset
  };

  # ========================================================================
  # POWERTOP AUTO-TUNE (opsiyonel)
  # ========================================================================
  powerManagement.powertop.enable = true;

  # ========================================================================
  # SYSTEMD SERVICES
  # ========================================================================
  
  # RyzenAdj auto-apply service (örnek - değerleri laptopunuza göre ayarlayın)
  systemd.services.ryzenadj-tune = {
    description = "Apply RyzenAdj power settings";
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    
    # Bu servis opsiyonel olarak enable edilebilir
    # Varsayılan olarak disable - istediğinizde enable edin
    enable = false;  # "systemctl enable ryzenadj-tune" ile aktif edin
    
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      # Örnek değerler - Gigabyte Aero X16 için ayarlayın:
      # --stapm-limit: Sustained TDP (mW)
      # --fast-limit: Fast boost TDP (mW)
      # --slow-limit: Slow boost TDP (mW)
      # --tctl-temp: Temperature limit (°C)
      ExecStart = "${pkgs.ryzenadj}/bin/ryzenadj --stapm-limit=35000 --fast-limit=45000 --slow-limit=35000 --tctl-temp=95";
    };
  };

  # CPU frequency on boot (performance mode for AC)
  systemd.services.cpu-performance-mode = {
    description = "Set CPU to performance mode on AC power";
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "cpu-perf" ''
        # Check if on AC power
        if [ -f /sys/class/power_supply/AC*/online ] && [ "$(cat /sys/class/power_supply/AC*/online)" = "1" ]; then
          for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
            echo "performance" > "$cpu" 2>/dev/null || true
          done
        fi
      '';
    };
  };
  
  # ========================================================================
  # USER GROUPS
  # ========================================================================
  # video grubu brightness kontrolü için gerekli (configuration.nix'te tanımlı)
}
