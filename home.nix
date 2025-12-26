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
  };

  # User-level packages (system'dekiler dışında)
  home.packages = with pkgs; [
    # CLI utilities (istersen ekle)
    # htop
    # neofetch
  ];
}
