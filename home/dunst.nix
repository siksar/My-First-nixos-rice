{ config, pkgs, ... }:
{
  # ========================================================================
  # DUNST - Notification Daemon with Gruvbox Theme
  # ========================================================================
  
  services.dunst = {
    enable = true;
    
    settings = {
      global = {
        # Display
        monitor = 0;
        follow = "mouse";
        
        # Geometry
        width = "(300, 400)";
        height = 150;
        origin = "top-right";
        offset = "70x20";  # Account for vertical waybar on right
        
        # Progress bar
        progress_bar = true;
        progress_bar_height = 10;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 150;
        progress_bar_max_width = 300;
        
        # Padding
        padding = 15;
        horizontal_padding = 15;
        text_icon_padding = 15;
        
        # Frame
        frame_width = 2;
        frame_color = "#d65d0e";
        gap_size = 5;
        
        # Separator
        separator_height = 2;
        separator_color = "frame";
        
        # Sorting
        sort = true;
        
        # Font
        font = "JetBrainsMono Nerd Font 11";
        
        # Format
        format = "<b>%s</b>\\n%b";
        alignment = "left";
        vertical_alignment = "center";
        show_age_threshold = 60;
        ellipsize = "end";
        ignore_newline = false;
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = true;
        
        # Icons
        icon_position = "left";
        min_icon_size = 32;
        max_icon_size = 48;
        icon_path = "/run/current-system/sw/share/icons/Papirus-Dark/48x48/status:/run/current-system/sw/share/icons/Papirus-Dark/48x48/devices:/run/current-system/sw/share/icons/Papirus-Dark/48x48/apps";
        
        # History
        sticky_history = true;
        history_length = 20;
        
        # Misc
        dmenu = "${pkgs.rofi}/bin/rofi -dmenu -p dunst";
        browser = "${pkgs.xdg-utils}/bin/xdg-open";
        always_run_script = true;
        
        # Mouse actions
        mouse_left_click = "do_action, close_current";
        mouse_middle_click = "close_all";
        mouse_right_click = "close_current";
        
        # Corners
        corner_radius = 10;
      };
      
      # Urgency levels - Gruvbox colors
      urgency_low = {
        background = "#282828";
        foreground = "#a89984";
        frame_color = "#689d6a";
        timeout = 5;
        icon = "dialog-information";
      };
      
      urgency_normal = {
        background = "#282828";
        foreground = "#ebdbb2";
        frame_color = "#d65d0e";
        timeout = 10;
        icon = "dialog-information";
      };
      
      urgency_critical = {
        background = "#282828";
        foreground = "#fb4934";
        frame_color = "#cc241d";
        timeout = 0;
        icon = "dialog-error";
      };
      
      # Custom rules
      volume = {
        appname = "changevolume";
        history_ignore = true;
        timeout = 2;
      };
      
      brightness = {
        appname = "changebrightness";
        history_ignore = true;
        timeout = 2;
      };
      
      spotify = {
        appname = "Spotify";
        frame_color = "#1db954";
      };
      
      discord = {
        appname = "discord";
        frame_color = "#5865f2";
      };
    };
  };
  
  # ========================================================================
  # LIBNOTIFY
  # ========================================================================
  home.packages = [ pkgs.libnotify ];
  
  # ========================================================================
  # NOTIFICATION SCRIPTS
  # ========================================================================
  
  # Volume notification script
  home.file.".local/bin/notify-volume" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      
      volume=$(pamixer --get-volume)
      muted=$(pamixer --get-mute)
      
      if [ "$muted" = "true" ]; then
        icon="audio-volume-muted"
        text="Muted"
      elif [ "$volume" -lt 33 ]; then
        icon="audio-volume-low"
        text="$volume%"
      elif [ "$volume" -lt 66 ]; then
        icon="audio-volume-medium"
        text="$volume%"
      else
        icon="audio-volume-high"
        text="$volume%"
      fi
      
      dunstify -a "changevolume" -u low -i "$icon" -r 2593 "Volume" "$text" -h int:value:"$volume"
    '';
  };
  
  # Brightness notification script
  home.file.".local/bin/notify-brightness" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      
      brightness=$(brightnessctl -m | cut -d',' -f4 | tr -d '%')
      
      if [ "$brightness" -lt 33 ]; then
        icon="display-brightness-low"
      elif [ "$brightness" -lt 66 ]; then
        icon="display-brightness-medium"
      else
        icon="display-brightness-high"
      fi
      
      dunstify -a "changebrightness" -u low -i "$icon" -r 2594 "Brightness" "$brightness%" -h int:value:"$brightness"
    '';
  };
}
