# ============================================================================
# GÜN 8: FLAKE'LER
# ============================================================================
# Flake: Nix'in modern paket/proje yönetim sistemi.
# Reproducibility (tekrarlanabilirlik) garanti eder.
#
# Senin ~/dotfiles/flake.nix dosyan bir flake!
# ============================================================================

{
  # ── 1. FLAKE YAPISI ────────────────────────────────────────────────────
  flakeYapisi = ''
    {
      description = "Proje açıklaması";

      inputs = {
        # Bağımlılıklar (diğer flake'ler)
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
      };

      outputs = { self, nixpkgs, ... }: {
        # Çıktılar: paketler, NixOS config, dev shell, vb.
      };
    }
  '';

  # ── 2. INPUTS ──────────────────────────────────────────────────────────
  inputsOrnek = ''
    inputs = {
      # GitHub'dan
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

      # Başka flake'in nixpkgs'ini takip et ( follows)
      home-manager.url = "github:nix-community/home-manager";
      home-manager.inputs.nixpkgs.follows = "nixpkgs";
      # ↑ Bu çok önemli! Aynı nixpkgs versiyonunu kullanır.

      # Lokal path
      # my-lib.url = "path:./lib";
    };
  '';

  # ── 3. SENİN FLAKE.NIX'İN ─────────────────────────────────────────────
  seninFlake = ''
    # ~/dotfiles/flake.nix analizi:

    inputs:
      nixpkgs       → NixOS unstable (en güncel paketler)
      home-manager  → User config yönetimi
      stylix        → System-wide theming
      noctalia-shell → Desktop shell
      zen-browser   → Modern browser
      hyprland      → Wayland compositor
      nixos-hardware → Donanım optimizasyonları

    outputs:
      nixosConfigurations.nixos → NixOS system config
        modules:
          - nixos-hardware (AMD CPU/GPU, SSD)
          - ./configuration.nix (ana config)
          - home-manager (user config)
          - stylix (theming)
  '';

  # ── 4. FLAKE.LOCK ─────────────────────────────────────────────────────
  flakeLock = ''
    # flake.lock: Her input'un TAM versiyonunu sabitler
    # Git commit hash + NAR hash = %100 reproducible

    # Güncelleme:
    # nix flake update            → Tüm input'ları güncelle
    # nix flake update nixpkgs    → Sadece nixpkgs'i güncelle
    # nix flake lock --update-input home-manager  → Tek input

    # ASLA flake.lock'u elle düzenleme!
  '';

  # ── 5. FLAKE KOMUTLARI ────────────────────────────────────────────────
  flakeKomutlari = {
    check = "nix flake check        → Flake'i doğrula";
    show = "nix flake show         → Çıktıları göster";
    update = "nix flake update      → Input'ları güncelle";
    metadata = "nix flake metadata  → Flake bilgileri";
    build = "nixos-rebuild switch --flake .#nixos  → Sistemi rebuild et";
  };

  # ── 6. OUTPUTS TİPLERİ ────────────────────────────────────────────────
  outputTipleri = ''
    outputs = { self, nixpkgs }: {
      # NixOS konfigürasyonu
      nixosConfigurations.hostname = nixpkgs.lib.nixosSystem { ... };

      # Paketler
      packages.x86_64-linux.default = ...;

      # Dev shell (nix develop)
      devShells.x86_64-linux.default = ...;

      # Overlay
      overlays.default = final: prev: { ... };

      # NixOS modülü
      nixosModules.default = { ... };

      # Home Manager modülü
      homeManagerModules.default = { ... };

      # Template
      templates.default = { path = ./template; description = "..."; };
    };
  '';

  # ══════════════════════════════════════════════════════════════════════
  # 📝 PRATİK ÖDEV
  # ══════════════════════════════════════════════════════════════════════
  # 1. cat ~/dotfiles/flake.nix → yapıyı incele
  # 2. nix flake metadata ~/dotfiles → input'ları ve versiyonları gör
  # 3. nix flake show ~/dotfiles → çıktıları listele
  # 4. cat ~/dotfiles/flake.lock | jq '.nodes | keys' → lock dosyasındaki node'lar
  odev = "flake.nix'i anlamak = NixOS'u anlamak";
}
