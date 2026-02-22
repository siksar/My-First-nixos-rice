# ============================================================================
# GÜN 9: HOME MANAGER PATTERNS
# ============================================================================
# Home Manager: kullanıcı seviyesi konfigürasyon yönetimi.
# NixOS system config'inden bağımsız, user dotfiles yönetir.
#
# Senin ~/dotfiles/home.nix ve ~/dotfiles/home/ dizini bunu kullanıyor.
# ============================================================================

{
  # ── 1. HOME MANAGER ENTEGRASYONU ──────────────────────────────────────
  entegrasyon = ''
    # İki kullanım modu:
    # A) Standalone: home-manager switch --flake .#user
    # B) NixOS Modülü: flake.nix içinde import (SENİN KULLANIMIN)

    # Senin flake.nix'te:
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;      # System pkgs kullan
      home-manager.useUserPackages = true;    # User PATH'e ekle
      home-manager.extraSpecialArgs = { inherit inputs; };
      home-manager.users.zixar = import ./home.nix;
    }
  '';

  # ── 2. PROGRAMS.* PATTERN ─────────────────────────────────────────────
  # En çok kullanılan pattern — program + config tek yerde
  programsPattern = ''
    programs.kitty = {
      enable = true;        # Paketi yükle + config oluştur
      settings = {          # ~/.config/kitty/kitty.conf üretir
        font_family = "JetBrainsMono Nerd Font";
        font_size = 13;
      };
    };

    programs.git = {
      enable = true;
      settings = {
        user.name = "zixar";
        user.email = "email@example.com";
      };
    };
  '';

  # ── 3. HOME.FILE PATTERN ──────────────────────────────────────────────
  homeFilePattern = ''
    # Dosyayı doğrudan home dizinine yaz
    home.file = {
      # Source'tan kopyala
      ".local/bin/script" = {
        source = ./scripts/my-script.sh;
        executable = true;
      };

      # İçeriği doğrudan yaz
      ".config/app/config.json".text = builtins.toJSON {
        key = "value";
      };
    };
  '';

  # ── 4. XDG PATTERN ────────────────────────────────────────────────────
  xdgPattern = ''
    xdg = {
      enable = true;
      configFile = {
        # ~/.config/app/config.toml oluşturur
        "app/config.toml".text = "key = value";
      };
      dataFile = {
        # ~/.local/share/app/data.json
        "app/data.json".text = "{}";
      };
    };
  '';

  # ── 5. SERVICES PATTERN ───────────────────────────────────────────────
  servicesPattern = ''
    # User-level systemd services
    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 3600;
    };

    systemd.user.services.my-daemon = {
      Unit.Description = "My Background Service";
      Service.ExecStart = "my-daemon --config ...";
      Install.WantedBy = [ "default.target" ];
    };
  '';

  # ── 6. SENİN HOME.NIX'İNDEKİ PATTERN'LER ─────────────────────────────
  seninPatternlerin = ''
    # 1. Modüler yapı: home/hyprland.nix, home/kitty.nix, ...
    # 2. Rust tool'ları: eza, bat, fd, ripgrep, ...
    # 3. Shell alias'ları: home.shellAliases { ... }
    # 4. Session variables: home.sessionVariables { ... }
    # 5. GTK/QT theming: gtk = { ... }; qt = { ... };
    # 6. XDG: xdg.userDirs, xdg.mimeApps
    # 7. Wallpaper script: home.file.".local/bin/wallpaper-cycle"
  '';

  # ── 7. ACTIVATION SCRIPTS ─────────────────────────────────────────────
  activationOrnek = ''
    # Rebuild sırasında çalıştırılacak komutlar
    home.activation = {
      createDirectories = lib.hm.dag.entryAfter [ "writeBoundary" ] '''
        mkdir -p $HOME/Projects
        mkdir -p $HOME/Screenshots
      ''';
    };
  '';

  # ══════════════════════════════════════════════════════════════════════
  # 📝 PRATİK ÖDEV
  # ══════════════════════════════════════════════════════════════════════
  # 1. cat ~/dotfiles/home.nix → imports, shellAliases, packages'ı incele
  # 2. cat ~/dotfiles/home/kitty.nix → programs.kitty yapısını oku
  # 3. cat ~/dotfiles/home/hyprland.nix → wayland.windowManager.hyprland'ı incele
  # 4. home-manager generations → aktif generation'ları listele
  odev = "Home Manager = kullanıcı dünyasının NixOS'u";
}
