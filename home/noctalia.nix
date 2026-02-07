{ config, pkgs, lib, noctalia, ... }:
{
  # ========================================================================
  # NOCTALIA SHELL - Modern Wayland Desktop Shell
  # ========================================================================
  # IMPERATIVE MODE: Settings are managed via Noctalia GUI
  # Only enable the shell and define userTemplates for theme propagation
  
  imports = [ noctalia.homeModules.default ];
  
  programs.noctalia-shell = {
    enable = true;
    
    # NO SETTINGS HERE - Let Noctalia manage its own config via GUI
    # User's GUI settings will persist across home-manager switches
    
    # Only define userTemplates for theme propagation to other apps
    settings = {
      settingsVersion = 0;
      
      # ====================================================================
      # USER TEMPLATES - Propagate Noctalia theme to other apps
      # ====================================================================
      # These templates allow Noctalia to update theme colors in other apps
      # when you change theme in Noctalia Settings → Color Scheme
      userTemplates = {
        # Zen Browser CSS theme
        zen = {
          input_path = "${config.home.homeDirectory}/.config/noctalia/templates/zen-browser.css";
          output_path = "${config.home.homeDirectory}/.mozilla/zen-browser/profile/chrome/userChrome.css"; 
        };
        # Kitty terminal theme
        kitty = {
          input_path = "${config.home.homeDirectory}/.config/noctalia/templates/kitty.conf";
          output_path = "${config.home.homeDirectory}/.config/kitty/current-theme.conf";
          post_hook = "killall -SIGUSR1 kitty";
        };
        # Starship prompt theme
        starship = {
          input_path = "${config.home.homeDirectory}/.config/noctalia/templates/starship.toml";
          output_path = "${config.home.homeDirectory}/.config/starship.toml";
        };
        # GTK3 theme override
        gtk3 = {
          input_path = "${config.home.homeDirectory}/.config/noctalia/templates/gtk3.css";
          output_path = "${config.home.homeDirectory}/.config/gtk-3.0/gtk.css";
        };
        # GTK4 theme override
        gtk4 = {
          input_path = "${config.home.homeDirectory}/.config/noctalia/templates/gtk4.css";
          output_path = "${config.home.homeDirectory}/.config/gtk-4.0/gtk.css";
        };
      };
    };
  };

  # ========================================================================
  # TEMPLATE FILES - These are the source templates Noctalia will process
  # ========================================================================
  # Noctalia replaces {{variable}} placeholders with current theme colors
  
  xdg.configFile."noctalia/templates/zen-browser.css".source = ./templates/zen-browser.css;
  xdg.configFile."noctalia/templates/kitty.conf".source = ./templates/kitty.conf;
  xdg.configFile."noctalia/templates/starship.toml".source = ./templates/starship.toml;
  
  # GTK Templates for system-wide theme override
  xdg.configFile."noctalia/templates/gtk3.css".text = ''
    /* Noctalia Template - GTK3 Colors */
    /* These colors will be replaced by Noctalia based on current theme */
    @define-color accent_color {{accent}};
    @define-color accent_bg_color {{accent}};
    @define-color window_bg_color {{background}};
    @define-color window_fg_color {{foreground}};
    @define-color headerbar_bg_color {{background_alt}};
    @define-color headerbar_fg_color {{foreground}};
    @define-color card_bg_color {{surface}};
    @define-color card_fg_color {{foreground}};
    @define-color popover_bg_color {{surface}};
    @define-color popover_fg_color {{foreground}};
    @define-color view_bg_color {{background}};
    @define-color view_fg_color {{foreground}};
  '';
  
  xdg.configFile."noctalia/templates/gtk4.css".text = ''
    /* Noctalia Template - GTK4 Colors */
    /* These colors will be replaced by Noctalia based on current theme */
    @define-color accent_color {{accent}};
    @define-color accent_bg_color {{accent}};
    @define-color window_bg_color {{background}};
    @define-color window_fg_color {{foreground}};
    @define-color headerbar_bg_color {{background_alt}};
    @define-color headerbar_fg_color {{foreground}};
    @define-color card_bg_color {{surface}};
    @define-color card_fg_color {{foreground}};
    @define-color popover_bg_color {{surface}};
    @define-color popover_fg_color {{foreground}};
    @define-color view_bg_color {{background}};
    @define-color view_fg_color {{foreground}};
  '';
}
