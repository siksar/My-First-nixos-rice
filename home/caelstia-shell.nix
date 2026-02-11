{ config, pkgs, lib, caelstia, ... }:                                                                                                                                                                       
{
	# ========================================================================
	# CAELSTIA SHELL - Modern Wayland Desktop Shell
	# ========================================================================
  
	imports = [ caelstia.homeManagerModules.default ];
  
	programs.caelestia = {
		enable = true;
		# Disable systemd service to prevent double instances (launched by Hyprland/Niri)
		systemd.enable = false;
	};

	# Disable the service explicitly if the module defaults to true and doesn't respect the above
	systemd.user.services.caelestia-shell.enable = false;

