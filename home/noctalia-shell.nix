{ config, pkgs, inputs, noctalia-shell, ... }:
{
	imports = [ ../base/modules/noctalia-home.nix ];

	# ========================================================================
	# NOCTALIA SHELL - Disabled in favor of Caelstia
	# ========================================================================
	programs.noctalia-shell = {
		enable = false;
		systemd.enable = false;
		package = inputs.noctalia-shell.packages.${pkgs.system}.default;
		
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
			};

			bar = {
				position = "left";
				barType = "simple";
				density = "comfortable";
				showCapsule = false;
				sizes = {
					innerWidth = 64;
					windowPreviewSize = 180;
				};
				flat = true;
				padding = 2;
				showOnHover = false;
				
				widgets = {
					left = [
						{ 
							id = "ControlCenter"; 
							useDistroLogo = true; 
							enableColorization = true; 
							colorizeSystemIcon = "primary"; 
						}
						{ 
							id = "Workspace"; 
							labelMode = "none";
							emptyColor = "primary";
							occupiedColor = "primary";
							focusedColor = "primary";
						}
					];
					center = [
						{ id = "MediaMini"; textColor = "primary"; }
						{ id = "Clock"; clockColor = "primary"; }
						{ 
							id = "NotificationHistory"; 
							iconColor = "primary"; 
							unreadBadgeColor = "primary"; 
						}
					];
					right = [
						{ 
							id = "SystemMonitor"; 
							iconColor = "primary"; 
							textColor = "primary"; 
						}
						{ id = "Battery"; }
					];
				};
			};

			dock = {
				dockType = "static";
			};

			location = {
				name = "Erzurum";
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

		colors = {
			mPrimary = config.lib.stylix.colors.withHashtag.base0D;
			mSecondary = config.lib.stylix.colors.withHashtag.base0E;
			mSurface = config.lib.stylix.colors.withHashtag.base00;
			mOnSurface = config.lib.stylix.colors.withHashtag.base05;
			mOutline = config.lib.stylix.colors.withHashtag.base03;
			mError = config.lib.stylix.colors.withHashtag.base08;
			mSurfaceVariant = config.lib.stylix.colors.withHashtag.base01;
			mOnPrimary = config.lib.stylix.colors.withHashtag.base00;
			mOnSecondary = config.lib.stylix.colors.withHashtag.base00;
			mOnError = config.lib.stylix.colors.withHashtag.base00;
		};
	};
}
