{ config, pkgs, ... }:
{
  # ========================================================================
  # DESKTOP ENVIRONMENTS
  # ========================================================================
  
  services = {
    xserver = {
      enable = true;
      xkb.layout = "us";
      autoRepeatDelay = 300;
      autoRepeatInterval = 20;
    };
  };

  # ========================================================================
  # SDDM DISPLAY MANAGER (Wayland)
  # ========================================================================
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  
  # Auto-login for zixar
  services.displayManager.autoLogin = {
    enable = true;
    user = "zixar";
  };
  
  # Default session (Hyprland)
  services.displayManager.defaultSession = "hyprland";

  # ========================================================================
  # COSMIC DESKTOP (Session option)
  # ========================================================================
  services.desktopManager.cosmic.enable = true;

  # ========================================================================
  # KDE PLASMA 6 (Session option)
  # ========================================================================
  services.desktopManager.plasma6.enable = true;
  
  # KDE specific packages
  environment.systemPackages = with pkgs; [
    # Core KDE utilities
    kdePackages.dolphin
    kdePackages.ark
    kdePackages.konsole
    kdePackages.gwenview
    kdePackages.spectacle
    kdePackages.kate
    
    # System
    adwaita-icon-theme
    vanilla-dmz
    pavucontrol
    papirus-icon-theme
  ];

  # ========================================================================
  # DCONF & GTK INTEGRATION
  # ========================================================================
  programs.dconf.enable = true;
  
  # Cursor theme
  environment.variables = {
    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE = "24";
  };

  # ========================================================================
  # XDG PORTAL - COSMIC + KDE + GTK
  # ========================================================================
  xdg.portal = {
    enable = true;
    extraPortals = [ 
      pkgs.xdg-desktop-portal-gtk 
      pkgs.xdg-desktop-portal-cosmic
      pkgs.kdePackages.xdg-desktop-portal-kde
    ];
    config = {
      common.default = [ "kde" "gtk" ];
      cosmic.default = [ "cosmic" "gtk" ];
      kde.default = [ "kde" "gtk" ];
    };
  };
}
