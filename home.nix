{ config, pkgs, ... }:

{
  # Home Manager sürümü
  home.stateVersion = "25.11";

  # User bilgileri
  home.username = "zixar";
  home.homeDirectory = "/home/zixar";

  # Git configuration
  programs.git = {
    enable = true;
    userName = "zixar";
    userEmail = "halilbatuhanyilmaz@proton.me";  # DEĞİŞTİR!
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };

  # Bash configuration
  programs.bash = {
    enable = true;
    
    shellAliases = {
      ll = "ls -la";
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
      update = "cd /etc/nixos && sudo nix flake update && sudo nixos-rebuild switch --flake .#nixos";
      cleanup = "sudo nix-collect-garbage -d && sudo nix-store --optimize";
    };
    
    bashrcExtra = ''
      # Custom prompt
      PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    '';
  };

  # GTK theme (GNOME için)
  gtk = {
  enable = true;
  theme = {
    name = "Adwaita-dark";
    package = pkgs.gnome-themes-extra;
  };
  iconTheme = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
  };
  
  # Force overwrite - mevcut dosyaların üzerine yaz
  gtk2.configLocation = "${config.home.homeDirectory}/.gtkrc-2.0";
  gtk2.extraConfig = "";
  gtk3.extraConfig = {
    gtk-application-prefer-dark-theme = true;
  };
  gtk4.extraConfig = {
    gtk-application-prefer-dark-theme = true;
  };
};
  # ========================================================================
  # HYPRLAND CONFIGURATION
  # ========================================================================
  
  wayland.windowManager.hyprland = {
    enable = true;
    
    # Config'leri ~/.config/hyprland/'a link et
    extraConfig = ''
      source = ~/.config/hyprland/hyprland.conf
    '';
  };

  # ========================================================================
  # ZSH + STARSHIP
  # ========================================================================
  
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    shellAliases = {
      ll = "ls -la";
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
      update = "cd /etc/nixos && sudo nix flake update && rebuild";
      cleanup = "sudo nix-collect-garbage -d && sudo nix-store --optimize";
      lm = "lmstudio";  # LM Studio shortcut
    };
    
    # Auto fastfetch on terminal start
    initExtra = ''
      # Auto fastfetch
      if [[ -z $FASTFETCH_RAN ]]; then
        export FASTFETCH_RAN=1
        fastfetch
      fi
      
      # Custom functions
      mkcd() { mkdir -p "$1" && cd "$1"; }
    '';
  };

  # Starship prompt (princess theme)
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    
    settings = {
      format = "$directory$git_branch$git_status$character";
      
      # Princess prompt colors
      character = {
        success_symbol = "[🌹](bold #e88388)";
        error_symbol = "[✗](bold #e88388)";
      };
      
      directory = {
        style = "bold #f5a97f";
        truncation_length = 3;
        truncate_to_repo = true;
      };
      
      git_branch = {
        symbol = "🌿 ";
        style = "bold #90a090";
      };
      
      git_status = {
        style = "bold #e88388";
        ahead = "⇡$\{count\}";
        behind = "⇣$\{count\}";
        diverged = "⇕⇡$\{ahead_count\}⇣$\{behind_count\}";
      };
    };
  };

  # ========================================================================
  # KITTY TERMINAL
  # ========================================================================
  
  programs.kitty = {
    enable = true;
    
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };
    
    settings = {
      # Princess theme colors
      background = "#2e2a3d";
      foreground = "#f4e8d8";
      
      cursor = "#e88388";
      cursor_text_color = "#2e2a3d";
      
      selection_background = "#e88388";
      selection_foreground = "#2e2a3d";
      
      # Black
      color0 = "#1a1820";
      color8 = "#3d3846";
      
      # Red (rose)
      color1 = "#e88388";
      color9 = "#f5c2c7";
      
      # Green
      color2 = "#90a090";
      color10 = "#b0c0b0";
      
      # Yellow (sunset)
      color3 = "#f5a97f";
      color11 = "#ffc9a0";
      
      # Blue (lavender)
      color4 = "#a8b4d8";
      color12 = "#c8d4f8";
      
      # Magenta (dusty pink)
      color5 = "#d4b5d4";
      color13 = "#f4d5f4";
      
      # Cyan
      color6 = "#a0c0c0";
      color14 = "#c0e0e0";
      
      # White (cream)
      color7 = "#f4e8d8";
      color15 = "#ffffff";
      
      # Window
      background_opacity = "0.92";
      window_padding_width = 12;
      
      # No bell
      enable_audio_bell = false;
      
      # Cursor
      cursor_blink_interval = 0;
    };
  };

  # ========================================================================
  # FASTFETCH
  # ========================================================================
  
  programs.fastfetch = {
    enable = true;
    
    settings = {
      logo = {
        type = "kitty-direct";
        # USER WILL SET: source = "/path/to/princess/image.png";
        # Leave blank for now
        source = ".config/fastfetch/nixos-logo.jpg";
        width = 30;
        height = 15;
      };
      
      display = {
        separator = " 🌹 ";
        color = {
          keys = "#e88388";
          title = "#f5a97f";
        };
      };
      
      modules = [
        {
          type = "title";
          format = "{user-name}@{host-name}";
        }
        "separator"
        {
          type = "os";
          key = "OS";
        }
        {
          type = "kernel";
          key = "Kernel";
        }
        {
          type = "packages";
          key = "Packages";
        }
        {
          type = "wm";
          key = "WM";
        }
        {
          type = "terminal";
          key = "Terminal";
        }
        {
          type = "shell";
          key = "Shell";
        }
        "separator"
        {
          type = "uptime";
          key = "Uptime";
        }
        {
          type = "memory";
          key = "Memory";
        }
      ];
    };
  };

  # ========================================================================
  # ROFI
  # ========================================================================
  
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    
    terminal = "${pkgs.kitty}/bin/kitty";
    
    # Princess theme
    theme = "~/.config/hyprland/rofi/launcher.rasi";
    
    extraConfig = {
      modi = "drun,emoji,window";
      show-icons = true;
      icon-theme = "Papirus";
      drun-display-format = "{name}";
      disable-history = false;
      display-drun = "  Apps";
      display-window = " 󰕰 Windows";
      display-emoji = " 󰞅 Emoji";
    };
  };

  # ========================================================================
  # PACKAGES
  # ========================================================================
  
  home.packages = with pkgs; [
    # Wayland utilities
    wl-clipboard
    grim
    slurp
    swappy
    
    # Screenshot tool
    grimblast
    
    # Wallpaper
    swww
    
    # Emoji picker support
    rofimoji
    
    # Fonts
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    font-awesome
  ];

  # ========================================================================
  # FILE MANAGEMENT
  # ========================================================================
  
  # Create config directories
  home.file = {
    # Hyprland configs
  #  ".config/hyprland/hyprland.conf".source = ./hyprland/hyprland.conf;
   # ".config/hyprland/keybinds.conf".source = ./hyprland/keybinds.conf;
   # ".config/hyprland/windowrules.conf".source = ./hyprland/windowrules.conf;
   # ".config/hyprland/autostart.conf".source = ./hyprland/autostart.conf;
   # ".config/hyprland/themes/princess.conf".source = ./hyprland/themes/princess.conf;
    
    # Waybar
   # ".config/hyprland/waybar/config.jsonc".source = ./hyprland/waybar/config.jsonc;
   # ".config/hyprland/waybar/style.css".source = ./hyprland/waybar/style.css;
    
    # Rofi
  #  ".config/hyprland/rofi/launcher.rasi".source = ./hyprland/rofi/launcher.rasi;
 #   ".config/hyprland/rofi/emoji.rasi".source = ./hyprland/rofi/emoji.rasi;
  };
}
