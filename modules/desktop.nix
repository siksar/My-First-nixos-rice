{ config, pkgs, lib, ... }:
{
	# ========================================================================
	# DESKTOP ENVIRONMENT - Niri
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
	# NIRI WINDOW MANAGER (Rust Based)
	# ========================================================================
	programs.niri = {
		enable = true;
		# Niri package from flake input will be used automatically via nixosModules.niri
	};
	
	# ========================================================================
	# AUTO LOGIN (No Display Manager - Maximum Speed)
	# ========================================================================
	services.greetd = {
		enable = true;
		settings = {
			initial_session = {
				command = "niri-session";
				user = "zixar";
			};
			default_session = {
				command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd niri-session";
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
		greetd.tuigreet
		# Xwayland satellite for Niri X11 compatibility
		xwayland-satellite
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
	# XDG PORTAL - Niri + GTK
	# ========================================================================
	xdg.portal = {
		enable = true;
		extraPortals = [
			pkgs.xdg-desktop-portal-gtk
			pkgs.xdg-desktop-portal-gnome
		];
		config = {
			niri.default = [ "gnome" "gtk" ];
			common.default = [ "gtk" ];
		};
	};
	services.upower.enable = true;
}
