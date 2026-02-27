{ config, pkgs, lib, ... }:
{
	# HELIX EDITOR (Rust based - Neovim alternatifi)

	programs.helix = {
		enable = true;
		defaultEditor = false;  # Using Neovim as default

		# Stylix manages helix settings and theme.
		settings = {
			# theme = "tokyonight"; # Managed by Stylix now

			editor = {
				line-number = "relative";
				mouse = true;
				bufferline = "multiple";
				cursorline = true;
				color-modes = true;

				cursor-shape = {
					insert = "bar";
					normal = "block";
					select = "underline";
				};

				statusline = {
					left = ["mode" "spinner" "file-name" "read-only-indicator" "file-modification-indicator"];
					right = ["diagnostics" "selections" "register" "position" "file-encoding"];
				};

				lsp = {
					display-messages = true;
					display-inlay-hints = true;
				};

				indent-guides = {
					render = true;
					character = "▏";
				};
			};

			keys.normal = {
				space.w = ":w";
				space.q = ":q";
				"C-d" = ["half_page_down" "align_view_center"];
				"C-u" = ["half_page_up" "align_view_center"];
			};
		};

		languages = {
			language = [
				{
					name = "nix";
					auto-format = true;
					formatter = { command = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt"; };
				}
				{
					name = "rust";
					auto-format = true;
				}
				{
					name = "python";
					auto-format = true;
					formatter = { command = "${pkgs.black}/bin/black"; args = ["-"]; };
				}
			];
		};
	};

	# Neovim configuration moved to home/nvim.nix

	# LSP SERVERS & TOOLS
	home.packages = with pkgs; [
		# AI Editor
		cursor-cli

		# Nix
		nil
		nixpkgs-fmt

		# Python
		pyright
		black

		# Rust
		rust-analyzer

		# JavaScript/TypeScript
		nodePackages.typescript-language-server
		nodePackages.prettier

		# Lua (Helix için de faydalı olabilir)
		lua-language-server

		# General
		nodePackages.vscode-langservers-extracted

		# Markdown
		marksman

		# TOML
		taplo

		# YAML
		yaml-language-server

		# DevOps & Scripting LSPs (NeoVim Code Completion for New Languages)
		bash-language-server
		gopls
		terraform-ls
		docker-compose-language-service
		nodePackages.dockerfile-language-server-nodejs
	];

	stylix.targets.helix.enable = true;
}
