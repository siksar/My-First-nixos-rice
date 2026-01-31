{ config, pkgs, ... }:
{
  # ========================================================================
  # SYSTEM PACKAGES
  # ========================================================================
  
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # Core utilities
    vim
    wget
    git
    fastfetch
    htop
    nvtopPackages.amd  # AMD için doğru paket
    lact               # AMD GPU kontrol (gaming.nix'ten taşındı)
    antigravity   
    # Browser & Productivity
    brave
    bitwarden-desktop
    home-manager   
    bottles 
    # AI Tools
    lmstudio
    localsend
    wine
     winetricks
    dxvk
    vkd3d
    # AppImage support
    appimage-run
    # Development tools
    vscode
    docker
        gruvbox-gtk-theme
    gruvbox-dark-icons-gtk
    docker-compose
  ];
  # AppImage binfmt registration
  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };
  services.flatpak.enable = true;
  programs = {
    git = {
      enable = true;
      config = {
        init.defaultBranch = "main";
      };
    };
    
    neovim = {
      enable = true;
      defaultEditor = true;
    };
  };
}
