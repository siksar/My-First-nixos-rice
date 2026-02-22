# ============================================================================
# GÜN 6: NixOS MODÜL SİSTEMİ
# ============================================================================
# NixOS'un süper gücü: her şey bir modül. Modüller birbirinin üzerine
# bindirilir (merge), çakışmalar type system ile yönetilir.
#
# Bu dosya çalıştırılabilir değil — kavramsal eğitim.
# Gerçek örnekler: ~/dotfiles/modules/ ve ~/dotfiles/configuration.nix
# ============================================================================

{
  # ── 1. MODÜL YAPISI ────────────────────────────────────────────────────
  # Her NixOS modülü bir FONKSİYONdur:
  # { config, pkgs, lib, ... }: { ... }
  #
  # Parametreler:
  # - config : Tüm modüllerin birleştirilmiş config'i (READ-ONLY)
  # - pkgs   : Nixpkgs paket koleksiyonu
  # - lib    : Yardımcı fonksiyonlar (mkOption, mkIf, mkForce, ...)
  # - ...    : Diğer argümanlar (inputs, specialArgs, vb.)

  modulYapisi = ''
    # Minimal modül örneği:
    { config, pkgs, ... }:
    {
      # OPTIONS: Bu modülün sunduğu ayarlar
      options.services.myService = {
        enable = lib.mkEnableOption "My Service";
        port = lib.mkOption {
          type = lib.types.port;
          default = 8080;
        };
      };

      # CONFIG: Ayarlara göre yapılandırma
      config = lib.mkIf config.services.myService.enable {
        systemd.services.myService = {
          wantedBy = [ "multi-user.target" ];
          script = "exec my-binary --port=$\{toString config.services.myService.port}";
        };
      };
    }
  '';

  # ── 2. IMPORTS ─────────────────────────────────────────────────────────
  # imports: diğer modülleri dahil et
  # Senin configuration.nix'teki gibi:
  importsOrnek = ''
    imports = [
      ./hardware-configuration.nix
      ./modules/kernel.nix        # Kernel config
      ./modules/nvidia.nix        # GPU config
      ./modules/stylix.nix        # Theming
    ];
  '';
  # Her import edilen dosya da bir modül — hepsi merge edilir!

  # ── 3. LIB FONKSİYONLARI ──────────────────────────────────────────────
  libFonksiyonlari = {
    # mkIf: koşullu config (lazy evaluation!)
    # config = lib.mkIf config.services.nginx.enable { ... };

    # mkDefault: düşük öncelikli değer (override edilebilir)
    # boot.plymouth.theme = lib.mkDefault "breeze";

    # mkForce: yüksek öncelikli değer (override eder)
    # "col.active_border" = lib.mkForce "rgb(bb7744)";

    # mkMerge: birden fazla config'i birleştir
    # config = lib.mkMerge [ { a = 1; } { b = 2; } ];

    # mkOption: option tanımla
    # type'lar: types.str, types.int, types.bool, types.port,
    #           types.listOf, types.attrsOf, types.enum, types.nullOr

    # mkEnableOption: enable = true/false kısayolu
    # services.foo.enable = lib.mkEnableOption "Foo service";
    aciklama = "lib.* NixOS'un configuration DSL'idir";
  };

  # ── 4. ÖNCELIK SİSTEMİ ────────────────────────────────────────────────
  # Modüller çakıştığında öncelik belirler:
  # 1. mkForce  (en yüksek - 50)
  # 2. Normal   (varsayılan - 100)
  # 3. mkDefault (düşük - 1000)
  # 4. mkOptionDefault (en düşük - 1500)
  oncelik = ''
    # Senin dotfiles'ından gerçek örnek:
    # stylix.nix:  boot.plymouth.theme = lib.mkDefault "breeze";
    # → Eğer başka modül plymouth theme set ederse, o kazanır
    #
    # hyprland.nix: "col.active_border" = lib.mkForce "rgb(bb7744)";
    # → Stylix border rengi set etse bile, senin rengin kazanır
  '';

  # ── 5. KONFİGÜRASYON SİSTEMİ ─────────────────────────────────────────
  # Senin ~/dotfiles/ yapısı:
  # flake.nix              ← Giriş noktası
  # ├── configuration.nix  ← Modülleri import eder
  # │   ├── modules/kernel.nix
  # │   ├── modules/nvidia.nix
  # │   ├── modules/stylix.nix
  # │   └── ...
  # └── home.nix           ← Home Manager modülleri
  #     ├── home/hyprland.nix
  #     ├── home/noctalia.nix
  #     ├── home/kitty.nix
  #     └── ...

  # ── 6. HOME MANAGER MODÜLLER ──────────────────────────────────────────
  homeManagerOrnek = ''
    # Home Manager de aynı modül pattern'ini kullanır
    # Ama system-level değil, user-level config

    # System (configuration.nix):
    #   services.nginx.enable = true;     ← root servisi

    # Home Manager (home.nix):
    #   programs.kitty.enable = true;     ← user programı
    #   programs.git.enable = true;

    # Fark: Home Manager ~ ile erişir, system /etc ile
  '';

  # ── 7. specialArgs ve extraSpecialArgs ─────────────────────────────────
  specialArgsOrnek = ''
    # flake.nix'ten modüllere ekstra argüman geçirmek:
    specialArgs = { inherit inputs; };
    # → Artık her modülde { inputs, ... }: diyebilirsin

    # Home Manager için:
    home-manager.extraSpecialArgs = { inherit inputs; };
  '';

  # ══════════════════════════════════════════════════════════════════════
  # 📝 PRATİK ÖDEV
  # ══════════════════════════════════════════════════════════════════════
  # 1. ~/dotfiles/configuration.nix dosyasını aç, imports listesini incele
  # 2. ~/dotfiles/modules/kernel.nix dosyasını aç:
  #    - Hangi parametreleri alıyor? (config, pkgs, lib, ...)
  #    - boot.kernelPackages nasıl set ediliyor?
  # 3. mkForce ve mkDefault kullanılan yerleri dotfiles'da ara:
  #    grep -r "mkForce\|mkDefault" ~/dotfiles/
  # 4. configuration.nix'te specialArgs'ın nasıl geldiğini anla
  odev = "~/dotfiles/ içindeki modülleri incele!";
}
