{ config, pkgs, lib, ... }:
{
	# POWER EFFICIENCY - TLP & Thermal Management

	environment.systemPackages = [ pkgs.tlp ];

	# TLP - Advanced Power Management
	services.tlp = {
		enable = true;
		settings = {
			# ─────────────────────────────────────────────────────────────────────
			CPU_SCALING_GOVERNOR_ON_AC = "schedutil";
			CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
			CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
			CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
			CPU_BOOST_ON_AC = 1;
			CPU_BOOST_ON_BAT = 0;
			CPU_MIN_PERF_ON_AC = 0;
			CPU_MAX_PERF_ON_AC = 100;
			CPU_MIN_PERF_ON_BAT = 0;
			CPU_MAX_PERF_ON_BAT = 30;

			# ─────────────────────────────────────────────────────────────────────
			PLATFORM_PROFILE_ON_AC = "balanced";
			PLATFORM_PROFILE_ON_BAT = "low-power";

			# ─────────────────────────────────────────────────────────────────────
			AMDGPU_ABM_LEVEL_ON_AC = 0;
			AMDGPU_ABM_LEVEL_ON_BAT = 3;  # Adaptive backlight management

			# ─────────────────────────────────────────────────────────────────────
			USB_AUTOSUSPEND = 1;
			USB_EXCLUDE_BTUSB = 1;        # Bluetooth adapter hariç tut

			RUNTIME_PM_ON_AC = "auto";
			RUNTIME_PM_ON_BAT = "auto";

			# ─────────────────────────────────────────────────────────────────────
			AHCI_RUNTIME_PM_ON_AC = "auto";
			AHCI_RUNTIME_PM_ON_BAT = "auto";

			# NVMe APST (Autonomous Power State Transitions)

			# ─────────────────────────────────────────────────────────────────────
			WIFI_PWR_ON_AC = "off";
			WIFI_PWR_ON_BAT = "on";

			# ─────────────────────────────────────────────────────────────────────
			PCIE_ASPM_ON_AC = "default";
			PCIE_ASPM_ON_BAT = "powersupersave";
		};
	};

	# Auto-cpufreq devre dışı (TLP ile çakışmasın)
	services.auto-cpufreq.enable = lib.mkForce false;

	# Power-profiles-daemon devre dışı (TLP ile çakışmasın)
	services.power-profiles-daemon.enable = lib.mkForce false;

	# Thermald - termal yönetim
	services.thermald.enable = true;
}
