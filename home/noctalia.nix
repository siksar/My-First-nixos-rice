{ config, pkgs, lib, noctalia, ... }:
{
  # ========================================================================
  # NOCTALIA SHELL - Modern Wayland Desktop Shell
  # ========================================================================
  
  imports = [ noctalia.homeModules.default ];
  
  programs.noctalia-shell = {
    enable = true;
    
    settings = {
      settingsVersion = 0;
      
      # ====================================================================
      # BAR CONFIGURATION - Left side vertical bar
      # ====================================================================
      bar = {
        barType = "simple";
        position = "left";
        density = "compact";
        showOutline = false;
        showCapsule = true;
        capsuleOpacity = 1;
        backgroundOpacity = 0.93;
        floating = false;
        marginVertical = 4;
        marginHorizontal = 4;
        frameThickness = 8;
        frameRadius = 12;
        outerCorners = true;
        exclusive = true;
        displayMode = "always_visible";
        
        widgets = {
          left = [
            { id = "Launcher"; useDistroLogo = true; }
            { id = "Workspace"; }
          ];
          center = [];
          right = [
            { id = "SystemMonitor"; }
            { id = "Tray"; }
            { id = "NotificationHistory"; }
            { id = "Battery"; warningThreshold = 30; }
            { id = "Volume"; }
            { id = "Brightness"; }
            { id = "Clock"; formatVertical = "HH mm"; useMonospacedFont = true; }
            { id = "ControlCenter"; }
          ];
        };
      };
      
      # ====================================================================
      # DOCK CONFIGURATION
      # ====================================================================
      dock = {
        enabled = true;
        position = "bottom";
        displayMode = "auto_hide";
        backgroundOpacity = 0.95;
        floatingRatio = 1;
        size = 1;
        onlySameOutput = true;
        pinnedApps = [ "kitty" "app.zen_browser.zen" "thunar" "discord" "code" ];
        colorizeIcons = false;
        inactiveIndicators = true;
        deadOpacity = 0.6;
        animationSpeed = 1;
      };
      
      # ====================================================================
      # GENERAL SETTINGS
      # ====================================================================
      general = {
        avatarImage = "/home/zixar/Pictures/logo_v2.png";
        dimmerOpacity = 0.2;
        scaleRatio = 1;
        radiusRatio = 1;
        animationSpeed = 1;
        animationDisabled = false;
        lockOnSuspend = true;
        showSessionButtonsOnLockScreen = true;
        enableShadows = true;
        shadowDirection = "bottom_right";
        language = "";
        telemetryEnabled = false;
      };
      
      # ====================================================================
      # UI SETTINGS
      # ====================================================================
      ui = {
        fontDefault = "JetBrainsMono Nerd Font";
        fontFixed = "JetBrainsMono Nerd Font";
        fontDefaultScale = 1;
        fontFixedScale = 1;
        tooltipsEnabled = true;
        panelBackgroundOpacity = 0.93;
        panelsAttachedToBar = true;
      };
      
      # ====================================================================
      # LOCATION & WEATHER
      # ====================================================================
      location = {
        name = "Istanbul, Turkey";
        weatherEnabled = true;
        weatherShowEffects = true;
        useFahrenheit = false;
        use12hourFormat = false;
        showWeekNumberInCalendar = true;
        showCalendarEvents = true;
        showCalendarWeather = true;
      };
      
      # ====================================================================
      # WALLPAPER MANAGER
      # ====================================================================
      wallpaper = {
        enabled = true;
        directory = "/home/zixar/Pictures/Wallpapers";
        showHiddenFiles = false;
        viewMode = "single";
        setWallpaperOnAllMonitors = true;
        fillMode = "crop";
        automationEnabled = false;
        transitionDuration = 1500;
        transitionType = "random";
        panelPosition = "follow_bar";
      };
      
      # ====================================================================
      # APP LAUNCHER
      # ====================================================================
      appLauncher = {
        enableClipboardHistory = true;
        autoPasteClipboard = false;
        enableClipPreview = true;
        clipboardWrapText = true;
        clipboardWatchTextCommand = "wl-paste --type text --watch cliphist store";
        clipboardWatchImageCommand = "wl-paste --type image --watch cliphist store";
        position = "center";
        useApp2Unit = false;
        sortByMostUsed = true;
        terminalCommand = "kitty -e";
        viewMode = "list";
        showCategories = true;
        iconMode = "tabler";
        enableSettingsSearch = true;
        enableWindowsSearch = true;
      };
      
      # ====================================================================
      # CONTROL CENTER
      # ====================================================================
      controlCenter = {
        position = "close_to_bar_button";
        diskPath = "/";
        shortcuts = {
          left = [
            { id = "Network"; }
            { id = "Bluetooth"; }
            { id = "WallpaperSelector"; }
            { id = "NoctaliaPerformance"; }
          ];
          right = [
            { id = "Notifications"; }
            { id = "PowerProfile"; }
            { id = "KeepAwake"; }
            { id = "NightLight"; }
          ];
        };
        cards = [
          { enabled = true; id = "profile-card"; }
          { enabled = true; id = "shortcuts-card"; }
          { enabled = true; id = "audio-card"; }
          { enabled = true; id = "brightness-card"; }
          { enabled = true; id = "weather-card"; }
          { enabled = true; id = "media-sysmon-card"; }
        ];
      };
      
      # ====================================================================
      # SYSTEM MONITOR
      # ====================================================================
      systemMonitor = {
        cpuWarningThreshold = 80;
        cpuCriticalThreshold = 90;
        tempWarningThreshold = 80;
        tempCriticalThreshold = 90;
        gpuWarningThreshold = 80;
        gpuCriticalThreshold = 90;
        memWarningThreshold = 80;
        memCriticalThreshold = 90;
        enableDgpuMonitoring = true;
        cpuPollingInterval = 3000;
        tempPollingInterval = 3000;
        gpuPollingInterval = 3000;
      };
      
      # ====================================================================
      # SESSION MENU (Power Menu)
      # ====================================================================
      sessionMenu = {
        enableCountdown = true;
        countdownDuration = 10000;
        position = "center";
        showHeader = true;
        largeButtonsStyle = false;
        showNumberLabels = true;
        powerOptions = [
          { action = "lock"; enabled = true; }
          { action = "suspend"; enabled = true; }
          { action = "hibernate"; enabled = true; }
          { action = "reboot"; enabled = true; }
          { action = "logout"; enabled = true; }
          { action = "shutdown"; enabled = true; }
        ];
      };
      
      # ====================================================================
      # NOTIFICATIONS
      # ====================================================================
      notifications = {
        enabled = true;
        location = "top_right";
        overlayLayer = true;
        backgroundOpacity = 0.95;
        respectExpireTimeout = false;
        lowUrgencyDuration = 3;
        normalUrgencyDuration = 8;
        criticalUrgencyDuration = 15;
        enableKeyboardLayoutToast = true;
        enableMediaToast = true;
        saveToHistory = { low = true; normal = true; critical = true; };
      };
      
      # ====================================================================
      # OSD (On-Screen Display)
      # ====================================================================
      osd = {
        enabled = true;
        location = "top_right";
        autoHideMs = 2000;
        overlayLayer = true;
        backgroundOpacity = 0.95;
      };
      
      # ====================================================================
      # AUDIO SETTINGS
      # ====================================================================
      audio = {
        volumeStep = 5;
        volumeOverdrive = false;
        cavaFrameRate = 30;
        visualizerType = "linear";
        volumeFeedback = true;
      };
      
      # ====================================================================
      # BRIGHTNESS
      # ====================================================================
      brightness = {
        brightnessStep = 5;
        enforceMinimum = true;
        enableDdcSupport = false;
      };
      
      # ====================================================================
      # COLOR SCHEMES - Gruvbox Theme
      # ====================================================================
      colorSchemes = {
        useWallpaperColors = false;
        predefinedScheme = "Gruvbox";
        darkMode = true;
        schedulingMode = "off";
      };
      
      # ====================================================================
      # NIGHT LIGHT
      # ====================================================================
      nightLight = {
        enabled = false;
        forced = false;
        autoSchedule = true;
        nightTemp = "4000";
        dayTemp = "6500";
        manualSunrise = "06:30";
        manualSunset = "18:30";
      };
      # ====================================================================
      # USER TEMPLATES
      # ====================================================================
      userTemplates = {
        zen = {
          input_path = "${config.home.homeDirectory}/.config/noctalia/templates/zen-browser.css";
          output_path = "${config.home.homeDirectory}/.mozilla/zen-browser/profile/chrome/userChrome.css"; 
        };
        kitty = {
          input_path = "${config.home.homeDirectory}/.config/noctalia/templates/kitty.conf";
          output_path = "${config.home.homeDirectory}/.config/kitty/current-theme.conf";
          post_hook = "killall -SIGUSR1 kitty";
        };
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

  # Ensure templates are linked to the correct location for Noctalia to read
  xdg.configFile."noctalia/templates/zen-browser.css".source = ./templates/zen-browser.css;
  xdg.configFile."noctalia/templates/kitty.conf".source = ./templates/kitty.conf;
  xdg.configFile."noctalia/templates/starship.toml".source = ./templates/starship.toml;
  
  # GTK Templates for Noctalia theme override
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
