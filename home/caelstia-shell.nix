{ config, pkgs, inputs, caelestia-shell, ... }:
{
	imports = [ caelestia-shell.homeManagerModules.default ];

	# ========================================================================
	# CAELSTIA SHELL - Hyprland Desktop Shell
	# ========================================================================
	programs.caelestia = {
		enable = true;
		systemd = {
			enable = false; # Started via Hyprland exec-once
		};
		settings = {
			appearance = {
				rounding.scale = 1.0;
				padding.scale = 1.0;
				font = {
					family = {
						sans = "Inter";
						mono = "JetBrainsMono Nerd Font";
						clock = "Roboto";
					};
					size.scale = 1.0;
				};
				transparency = {
					enabled = true;
					base = 0.9;
				};
				# theme = {
				# 	primary = "#bb7744";    # Rust/Orange
				# 	secondary = "#c9a554";  # Gold
				# 	background = "#222222"; # Dark Grey
				# 	text = "#c2c2b0";       # Cream
				# 	accent = "#b36d43";     # Copper
				# 	success = "#5f875f";    # Green
				# 	error = "#8a6f5c";      # Red
				# };
			};

			bar = {
				status = {
					showBattery = true;
					showNetwork = true;
					showBluetooth = true;
					showAudio = true;
					showLockStatus = true;
				};
				sizes = {
					innerWidth = 28; # Reduced from 32
					windowPreviewSize = 180;
				};
				flat = true;
				padding = 2; # Reduced from 4
				showOnHover = false;
			};

			general = {
				logo = "nixos";
			};
			
			launcher = {
				actionPrefix = ":";
			};

			paths = {
				wallpaperDir = "~/Pictures/Wallpapers";
			};
		};
		cli = {
			enable = true;
			settings = {
				theme.enableGtk = true;
			};
		};
	};
}
