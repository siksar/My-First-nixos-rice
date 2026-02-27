{ config, pkgs, lib, ... }:

{
	programs.neovim = {
		enable = true;
		defaultEditor = true;
		viAlias = true;
		vimAlias = true;
		vimdiffAlias = true;

		# Plugins are managed via Lazy, but we still feed some necessary Nix packages
		plugins = with pkgs.vimPlugins; [
			lazy-nvim
		];

		# LAZYVIM CORE CONFIGURATION (init.lua)
		initLua = ''
			-- Leader key must be set before Lazy is loaded
			vim.g.mapleader = " "
			vim.g.maplocalleader = "\\"

			-- Basic Options (LazyVim handles most, but these are fallbacks)
			vim.opt.number = true
			vim.opt.relativenumber = true
			vim.opt.shiftwidth = 4
			vim.opt.tabstop = 4
			vim.opt.clipboard = "unnamedplus"

			-- Bootstrap Lazy.nvim
			local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
			if not (vim.uv or vim.loop).fs_stat(lazypath) then
				local lazyrepo = "https://github.com/folke/lazy.nvim.git"
				local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
				if vim.v.shell_error ~= 0 then
					vim.api.nvim_echo({
						{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
						{ out, "WarningMsg" },
						{ "\nPress any key to exit..." },
					}, true, {})
					vim.fn.getchar()
					os.exit(1)
				end
			end
			vim.opt.rtp:prepend(lazypath)

			-- SETUP LAZY & PLUGINS
			require("lazy").setup({
				spec = {
					-- Base LazyVim distribution
					{ "LazyVim/LazyVim", import = "lazyvim.plugins" },

					-- 1. AI Auto Completion (Codeium)
					{
						"Exafunction/codeium.vim",
						event = "BufEnter",
						config = function()
							vim.keymap.set("i", "<C-g>", function() return vim.fn["codeium#Accept"]() end, { expr = true, silent = true })
							vim.keymap.set("i", "<C-;>", function() return vim.fn["codeium#CycleCompletions"](1) end, { expr = true, silent = true })
							vim.keymap.set("i", "<C-,>", function() return vim.fn["codeium#CycleCompletions"](-1) end, { expr = true, silent = true })
							vim.keymap.set("i", "<C-x>", function() return vim.fn["codeium#Clear"]() end, { expr = true, silent = true })
						end
					},

					-- 2. Language & Infrastructure Servers (LSP)
					{ "neovim/nvim-lspconfig" },

					-- Mason (Auto-installs LSPs if not provided by Nix)
					{
						"williamboman/mason.nvim",
						opts = {
							ensure_installed = {
								"stylua",
								"shfmt",
								"black",
								"rust-analyzer",
								"gopls",
								"terraform-ls",
								"tflint",
								"docker-compose-language-service",
								"dockerfile-language-server"
							},
						},
					},

					-- Treesitter (Syntax Highlighting)
					{
						"nvim-treesitter/nvim-treesitter",
						opts = {
							ensure_installed = {
								"bash", "c", "diff", "html", "javascript", "jsdoc", "json", "jsonc", "lua", "luadoc", "luap", "markdown", "markdown_inline", "printf", "python", "query", "regex", "toml", "tsx", "typescript", "vim", "vimdoc", "xml", "yaml", "go", "gomod", "gowork", "gosum", "hcl", "terraform", "dockerfile", "nix", "rust"
							},
						},
					},

					-- 3. File Explorer (Neo-tree configuration overrides)
					{
						"nvim-neo-tree/neo-tree.nvim",
						opts = {
							window = { position = "left", width = 30 },
							filesystem = {
								follow_current_file = { enabled = true },
								use_libuv_file_watcher = true,
							},
						},
					},

					-- 4. Terminal Support (Snacks.nvim)
					{
						"folke/snacks.nvim",
						opts = {
							terminal = { enabled = true },
						},
						keys = {
							{ "<c-/>",      function() Snacks.terminal() end, desc = "Toggle Terminal" },
							{ "<c-_>",      function() Snacks.terminal() end, desc = "which_key_ignore" },
						},
					},
				},

				defaults = {
					lazy = false, -- Load plugins immediately by default
					version = false,
				},
				checker = { enabled = true, notify = false }, -- Don't constantly notify about updates
			})

			-- THEME / TRANSPARENCY
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = "*",
				callback = function()
					vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
					vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
				end,
			})

			-- LSP CONFIGURATION FOR NIX (Since masonry doesn't handle Nixos nil well)
			local lspconfig = require("lspconfig")
			if vim.fn.executable("nil") == 1 then
				lspconfig.nil_ls.setup({})
			end
		'';
	};

	# Ensure Stylix applies the theme automatically to NeoVim
	stylix.targets.neovim.enable = true;
}
