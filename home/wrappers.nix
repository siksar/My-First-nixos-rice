# HOW TO CREATE WRAPPERS IN NIX

# SIMPLE SHELL SCRIPT METHOD (For quick fixes)

# #!/bin/sh

{ pkgs, ... }:
{
	# Example: Creating a wrapper for 'deezer' (if installed) to force Wayland
	home.packages = [
		(pkgs.writeShellScriptBin "nixos-safe-switch" ''
			FLAKE_DIR="$HOME/dotfiles/flake"

			echo "🚀 Attempting safe system switch..."
			if nh os switch "$FLAKE_DIR"; then
				echo "✅ System switched successfully!"
			else
				echo "⚠️ Switch failed! This might be due to a switch inhibitor (e.g., dbus-broker update)."
				echo "🔄 Attempting a safe boot deployment instead..."
				if nh os boot "$FLAKE_DIR"; then
					echo "✅ Boot deployment successful!"
					read -p "Mevcut oturumu korumak icin sistemi yeniden baslatmak ister misiniz? [e/H] " -n 1 -r
					echo
					if [[ $REPLY =~ ^[EeYy]$ ]]; then
						echo "Rebooting..."
						systemctl reboot
					else
						echo "Lütfen en kısa sürede sistemi yeniden başlatın!"
					fi
				else
					echo "❌ Boot deployment also failed. Please check your configuration."
					exit 1
				fi
			fi
		'')

		(pkgs.writeShellScriptBin "deezer-wayland" ''
			# This is a simple wrapper script
			export NIXOS_OZONE_WL=1
			exec deezer --enable-features=UseOzonePlatform --ozone-platform=wayland "$@"
		'')
	];
}
