{ config, pkgs, lib, ... }:
{
	# ========================================================================
	# DESKTOP ENVIRONMENT - Hyprland
	# ========================================================================
	services = {
		xserver = {
			enable = true;
			xkb.layout = "us";
			autoRepeatDelay = 300;
			autoRepeatInterval = 20;
		};
	};
	# ========================================================================
	# HYPRLAND WINDOW MANAGER
	# ========================================================================
	programs.hyprland = {
		enable = true;
		xwayland.enable = true;
	};
	
	# ========================================================================
	# AUTO LOGIN (GreetD → Hyprland)
	# ========================================================================
	services.greetd = {
		enable = true;
		settings = {
			initial_session = {
				command = "Hyprland";
				user = "zixar";
			};
			default_session = {
				command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd Hyprland";
				user = "greeter";
			};
		};
	};
	
	# Disable ReGreet as we are using auto-login
	programs.regreet.enable = false;

	# ========================================================================
	# ESSENTIAL DESKTOP PACKAGES
	# ========================================================================
	environment.systemPackages = with pkgs; [
		# Archive manager
		file-roller
		# Image viewer
		imv
		# System
		adwaita-icon-theme
		papirus-icon-theme
		pavucontrol
		# Greeters
		tuigreet
	];
	# ========================================================================
	# DCONF & GTK INTEGRATION
	# ========================================================================
	programs.dconf.enable = true;
	# Cursor theme
	environment.variables = {
		XCURSOR_THEME = "Adwaita";
		XCURSOR_SIZE = "24";
	};
	# ========================================================================
	# XDG PORTAL - Hyprland + GTK
	# ========================================================================
	xdg.portal = {
		enable = true;
		extraPortals = [
			pkgs.xdg-desktop-portal-gtk
			pkgs.xdg-desktop-portal-hyprland
		];
		config = {
			hyprland.default = [ "hyprland" "gtk" ];
			common.default = [ "gtk" ];
		};
	};
	services.upower.enable = true;
}
