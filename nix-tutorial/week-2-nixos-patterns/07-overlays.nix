# ============================================================================
# GÜN 7: OVERLAY'LAR VE ÖZELLEŞTİRME
# ============================================================================
# Overlay: Nixpkgs paketlerini değiştirmek veya yeni paketler eklemek.
# Override: Tek bir paketin build parametrelerini değiştirmek.
#
# Kavramsal eğitim — gerçek kullanım flake.nix veya configuration.nix içinde.
# ============================================================================

{
  # ── 1. OVERLAY NEDİR? ──────────────────────────────────────────────────
  # Overlay: (final: prev: { ... }) şeklinde bir fonksiyon
  # - prev (veya super): Mevcut paketler
  # - final (veya self): Overlay uygulandıktan sonraki paketler
  overlayKonsept = ''
    # Basit overlay:
    nixpkgs.overlays = [
      (final: prev: {
        # Yeni paket ekle
        my-tool = final.callPackage ./my-tool.nix { };

        # Mevcut paketi değiştir
        neovim = prev.neovim.override {
          withNodeJs = true;
        };
      })
    ];
  '';

  # ── 2. OVERRIDE vs OVERLAY ────────────────────────────────────────────
  farklar = {
    # override: Tek pakete özel, yerinde değişiklik
    # overlay: Tüm pkgs'e uygulanır, zincirlenebilir

    # override örneği:
    overrideOrnek = ''
      pkgs.mpv.override {
        scripts = [ pkgs.mpvScripts.mpris ];
      }
    '';

    # overrideAttrs: build sürecini değiştir
    overrideAttrsOrnek = ''
      pkgs.hello.overrideAttrs (old: {
        pname = "hello-custom";
        postInstall = (old.postInstall or "") + '''
          echo "Custom hello installed!"
        ''';
      })
    '';
  };

  # ── 3. SENIN DOTFILES'INDA KULLANIM ───────────────────────────────────
  gercekKullanim = ''
    # ~/dotfiles/modules/nvidia.nix'teki NVIDIA patch:
    # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.production.overrideAttrs ...
    # Bu, production driver'ına kernel 6.19 patch'i uygular

    # ~/dotfiles/home/wrappers.nix'teki wrapper'lar:
    # pkgs.writeShellScriptBin ile yeni komutlar oluşturur
    # Bu overlay değil ama benzer konsept — paket oluşturma
  '';

  # ── 4. callPackage PATTERN ─────────────────────────────────────────────
  callPackageOrnek = ''
    # callPackage: bir .nix dosyasını pkgs'ten otomatik argümanlarla çağır
    # Nix'in dependency injection mekanizması

    # my-tool.nix:
    # { lib, stdenv, fetchFromGitHub, rustPlatform, ... }:
    # rustPlatform.buildRustPackage { ... }

    # overlay'da:
    # my-tool = final.callPackage ./my-tool.nix { };
    # → lib, stdenv, vs. otomatik olarak final'dan inject edilir
  '';

  # ── 5. nixpkgs.config ─────────────────────────────────────────────────
  nixpkgsConfig = ''
    # allowUnfree: Proprietary paketlere izin ver
    nixpkgs.config.allowUnfree = true;

    # Senin flake.nix'inde allowUnfree yok ama
    # NVIDIA driver unfree olduğu için bir yerde tanımlı olmalı
    # (home-manager.useGlobalPkgs = true; global config'i kullanır)
  '';

  # ══════════════════════════════════════════════════════════════════════
  # 📝 PRATİK ÖDEV
  # ══════════════════════════════════════════════════════════════════════
  # 1. ~/dotfiles/modules/nvidia.nix'te overrideAttrs kullanımını incele
  # 2. ~/dotfiles/home/wrappers.nix'te writeShellScriptBin kullanımını oku
  # 3. Kendi basit wrapper'ını düşün: ne yapardı?
  odev = "Overlay ve override konseptlerini anla!";
}
