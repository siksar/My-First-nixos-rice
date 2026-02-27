{ config, pkgs, lib, ... }:

{
	# KERNEL PACKAGES - Linux 6.18
	boot.kernelPackages = pkgs.linuxPackages_latest;

	# KERNEL MODULES
	boot.kernelModules = [
		"kvm-amd"
		"acpi_call"
		"amdxdna"          # NPU support
		"amd-pmf"          # Platform Management Framework
		"gigabyte-wmi"     # Gigabyte sensor/WMI support
		"zram"
	];

	# Essential modules for early boot
	boot.initrd.kernelModules = [
		"amdgpu"
		"nvme"
		"zram"
	];

	# Extra module packages
	boot.extraModulePackages = with config.boot.kernelPackages; [
		acpi_call
	];

	# KERNEL PARAMETERS - Performance & Compatibility
	boot.kernelParams = [
		# CPU Power & Scheduling (amd-pstate-epp is default in recent kernels)
		"amd_pstate=active"
		"amd_prefcore=enable"

		# Hardware Support
		"amd_iommu=on"
		"iommu=pt"
		"amdxdna.enable=1"                  # Enable NPU

		# Graphics & Display (Hybrid Graphics: AMD + NVIDIA)
		"amdgpu.sg_display=0"               # Fixes some flickering on iGPU
		"amdgpu.ppfeaturemask=0xffffffff"   # Unlock full GPU features
		"amdgpu.gttsize=12288"              # Allow up to 12GB system RAM for VRAM (Fix 512MB limit)
		"nvidia-drm.modeset=1"              # REQUIRED for Wayland on NVIDIA
		"nvidia-drm.fbdev=1"                # Framebuffer device for high-res console

		# Power Saving Latency Optimization
		"nvme_core.default_ps_max_latency_us=0"
		"pcie_aspm=force"
		"amd_pmf.core_pmf_enable=1"         # Enable AMD PMF Core for Ryzen AI 300 Series
		"usbcore.autosuspend=-1"            # Prevent USB device disconnects

		# Tam Sessiz Boot (Silent Boot) & Sistem Kararlılığı
		"quiet"
		"splash"
		"boot.shell_on_fail"
		"loglevel=3"
		"rd.systemd.show_status=false"      # systemd loglarını gizle
		"rd.udev.log_level=3"               # udev loglarını gizle
		"udev.log_priority=3"
		"nowatchdog"
		"nmi_watchdog=0"
	];

	# SILENT BOOT (NixOS Özel Ayarları)
	boot.consoleLogLevel = 0;
	boot.initrd.verbose = false;

	# BLACKLIST - Remove Unwanted Modules
	boot.blacklistedKernelModules = [
		"iTCO_wdt"
		"softdog"
		"intel_idle"       # AMD CPU -> No Intel Idle needed
		"intel_pstate"     # AMD CPU -> No Intel P-State needed
		"pcspkr"           # Silence PC speaker beep
		"nouveau"          # Blacklist open-source NVIDIA to prevent conflicts
		"asus-wmi"         # Prevent conflict with AMD PMF on Gigabyte laptops
		"asus_wmi"
	];

	# MODPROBE CONFIGURATION
	boot.extraModprobeConfig = ''
		options rtw89_pci disable_aspm_l1=1 disable_aspm_l1ss=1
		options rtw89_core disable_ps_mode=1

		options amd_pstate mode=active
		options amdgpu dc=1 dpm=1
		options nvme default_ps_max_latency_us=0
		options zram num_devices=1
		install asus-wmi /bin/false
		install asus_wmi /bin/false
	'';

	# SYSTEM PACKAGES - Kernel Specific
	environment.systemPackages = with pkgs; [
		# Essential tools for monitoring kernel performance
		config.boot.kernelPackages.cpupower
		lm_sensors
		powertop
		nvtopPackages.full    # GPU monitoring
	];

	# POWER MANAGEMENT & ZRAM
	powerManagement = {
		enable = true;
		cpuFreqGovernor = "powersave";  # amd-pstate=active ile varsayılan olarak powersave kullanılmalıdır. Performans gerektiğinde EPP ile yönetilir.
		powertop.enable = false;          # Disable auto-tune to avoid conflicts with custom scripts
	};

	zramSwap = {
		enable = true;
		algorithm = "zstd";
		memoryPercent = 50;
	};

	# SYSCTL TUNING - Throughput & Latency
	boot.kernel.sysctl = {
		# Virtual Memory (CachyOS/Xanmod Defaults)
		"vm.swappiness" = 10;
		"vm.dirty_ratio" = 10;
		"vm.dirty_background_ratio" = 5;
		"vm.vfs_cache_pressure" = 50;
		"vm.page-cluster" = 0;
		"vm.watermark_boost_factor" = 0;
		"vm.watermark_scale_factor" = 125;

		# BORE/Xanmod Scheduler Mimic (EVEEDF Tuning for 6.19 kernel)
		"kernel.sched_cfs_bandwidth_slice_us" = 3000; # Daha sık aralıklarla context-switch (Oyun/Desktop akıcılığı)
		"kernel.sched_latency_ns" = 4000000;          # BORE tarzı düşük gecikme
		"kernel.sched_min_granularity_ns" = 400000;   # Ufak işleri daha hızlı bitirme fırsatı
		"kernel.sched_wakeup_granularity_ns" = 500000;
		"kernel.sched_migration_cost_ns" = 250000;    # Thread'lerin çekirdekler arası zıplamasını yavaşlatır (Önbellek israfını keser)

		"net.core.rmem_max" = 16777216;
		"net.core.wmem_max" = 16777216;
		"net.ipv4.tcp_rmem" = "4096 87380 16777216";
		"net.ipv4.tcp_wmem" = "4096 65536 16777216";
		"net.ipv4.tcp_window_scaling" = 1;

		# Networking (BBR Congestion Control, MTU Probing & IPv6 Opts)
		"net.core.default_qdisc" = "cake";
		"net.ipv4.tcp_congestion_control" = "bbr";
		"net.ipv4.tcp_mtu_probing" = 1;
		"net.ipv4.tcp_fastopen" = 3;                  # Hem IPv4 hem IPv6 için TCP Fast Open (Gecikmeyi düşürür)
		"net.ipv6.conf.all.use_tempaddr" = lib.mkForce 2;         # IPv6 Gizlilik eklentileri (MAC adresini gizler, geçici IP üretir)
		"net.ipv6.conf.default.use_tempaddr" = lib.mkForce 2;

		# Watchdog
		"kernel.nmi_watchdog" = 0;

		# Filesystem Monitoring
		"fs.inotify.max_user_watches" = 524288;
	};

	# FIRMWARE
	hardware.enableRedistributableFirmware = true;
	hardware.enableAllFirmware = true;
	hardware.cpu.amd.updateMicrocode = true;
}
