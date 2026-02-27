{ config, pkgs, ... }:
{
	programs.nushell = {
		enable = true;

		# Environment variables
		environmentVariables = {
			EDITOR = "nvim";
			VISUAL = "nvim";
		};

		# Shell Aliases - only nushell-specific ones
		shellAliases = {
			# Nushell-specific compatibility aliases
			conf = "z /etc/nixos"; # Using zoxide

			# System info aliases
			neofetch = "fastfetch";
		};

		# Extra Config
		extraConfig = ''
			$env.config = {
				show_banner: false,
				ls: {
					use_ls_colors: true,
					clickable_links: true,
				},
				rm: {
					always_trash: true, # Safety first!
				},
				table: {
					mode: "rounded", # Aesthetic table borders
				},
				# Integration with other tools
				completions: {
					external: {
						enable: true,
						max_results: 100,
					}
				}
			}

			# Custom Commands — flake: ~/dotfiles/flake
			def sys-rebuild [] {
				cd ($env.HOME + "/dotfiles/flake")
				git add .
				git commit -m 'auto'
				nixos-safe-switch
			}

			def fullrebuild [] {
				let flake = $env.HOME + "/dotfiles/flake"
				print "Rebuilding NixOS System..."
				nixos-safe-switch
				print "Rebuilding Home Manager..."
				home-manager switch --flake ($flake + "#zixar") -b backup
			}

			def sys-home [] {
				let flake = $env.HOME + "/dotfiles/flake"
				cd $flake
				try { git add . } catch { print "Git add failed or nothing to add" }
				print "Rebuilding Home Manager..."
				home-manager switch --flake ($flake + "#zixar") -b backup
			}

			def sys-full [] {
				sys-rebuild
				home-manager switch --flake ($env.HOME + "/dotfiles/flake") + "#zixar"
			}

			def sys-clean [] {
				sudo nix-collect-garbage -d
				sudo nix-store --optimize
			}

			# Hızlı UI ve Home Manager derleme / reload komutu
			def zixreload [] {
				let dotfiles = $env.HOME + "/dotfiles"
				cd $dotfiles
				try { git add . } catch { print "Git add atlandı" }
				print "🚀 Rebuilding Home Manager..."
				home-manager switch --flake ($dotfiles + "/flake#zixar") -b backup
				print "✨ Reloading Noctalia Shell..."
				try { systemctl --user restart noctalia-shell } catch { print "Failed to restart noctalia via systemd..." }
				print "✅ Tüm ekran ve konfigürasyonlar başarıyla yenilendi!"
			}

			# Zoxide/Starship/Carapace hooks are auto-added

			# Run Fastfetch (System Fetch) on startup
			fastfetch
		'';
	};

	# Carapace - Multi-shell completion tailored for Nushell
	programs.carapace = {
		enable = true;
		enableNushellIntegration = true;
	};
}
