# ============================================================================
# GÜN 10: DEBUGGING VE NİX REPL
# ============================================================================
# Nix'te hata ayıklama teknikleri: nix repl, trace, drv analizi.
# Hafta 2 final — artık NixOS konfigürasyonunu tam anlayabilirsin!
#
#   nix repl → bu dosyayı :l ile yükle
# ============================================================================

{
  # ── 1. NIX REPL ────────────────────────────────────────────────────────
  nixRepl = ''
    # REPL başlat ve flake yükle:
    nix repl
    :lf ~/dotfiles           → flake'i yükle
    :l <nixpkgs>             → nixpkgs'i yükle

    # Temel komutlar:
    :?                       → yardım
    :t <expr>                → tip göster
    :p <expr>                → tam evaluate et ve yazdır
    :b <drv>                 → derivation'ı build et
    :q                       → çık

    # Örnekler:
    pkgs.kitty               → kitty paketi (derivation)
    pkgs.kitty.meta           → paket metadata
    pkgs.kitty.meta.license    → lisans bilgisi
    builtins.attrNames pkgs    → TÜM paket isimleri (ÇOK büyük!)
  '';

  # ── 2. TRACE: PRINTF DEBUGGING ────────────────────────────────────────
  traceOrnek = let
    debug = x: builtins.trace "DEBUG: x = ${toString x}" x;
    result = debug 42;
  in result;
  # stderr'e "trace: DEBUG: x = 42" yazar, 42 döndürür

  traceIleri = let
    data = { name = "zixar"; age = 25; };

    # builtins.traceVerbose: daha detaylı
    # builtins.trace (builtins.toJSON data) data → JSON olarak trace
    traced = builtins.trace (builtins.toJSON data) data;
  in traced;

  # ── 3. YAYGIN HATALAR ─────────────────────────────────────────────────
  hatalar = {
    # 1. "infinite recursion" → rec set'te döngüsel referans
    # rec { a = b; b = a; }  → HATA!

    # 2. "attribute 'x' missing" → set'te olmayan key'e erişim
    # Çözüm: `or` kullan → set.x or "default"

    # 3. "called with unexpected argument" → fonksiyona fazla argüman
    # Çözüm: { ... } ekle → { name, ... }: ...

    # 4. "file not found" → import path yanlış
    # Çözüm: relative path doğru mu kontrol et

    # 5. "is not a function" → import edilen dosya fonksiyon değil set
    # Çözüm: dosyanın { config, pkgs, ... }: ile başladığını kontrol et

    aciklama = "Hataları okumayı öğren — Nix hata mesajları detaylıdır";
  };

  # ── 4. NIX KOMUTLARI ──────────────────────────────────────────────────
  komutlar = {
    eval = "nix eval -f file.nix          → dosyayı evaluate et";
    build = "nix build .#package          → paketi build et";
    run = "nix run .#package               → paketi çalıştır";
    develop = "nix develop                 → dev shell'e gir";
    flakeCheck = "nix flake check          → flake'i doğrula";
    search = "nix search nixpkgs firefox   → paket ara";
    showDrv = "nix show-derivation .#pkg   → derivation detayları";
    path = "nix path-info .#pkg            → store path";
    why = "nix why-depends .#a .#b         → bağımlılık zinciri";
    dryRun = "nixos-rebuild dry-run --flake .#nixos → kuru çalıştırma";
  };

  # ── 5. DERİVATİON ANALİZİ ─────────────────────────────────────────────
  derivationAnaliz = ''
    # Derivation = build planı. Nix'in temel birimi.
    # Her paket bir derivation'dır.

    # Store path yapısı:
    # /nix/store/<hash>-<name>-<version>
    # /nix/store/abc123...-kitty-0.35.0

    # Bağımlılık analizi:
    nix-store -q --referrers /nix/store/...-kitty   → Kim buna bağlı?
    nix-store -q --references /nix/store/...-kitty  → Bu neye bağlı?
    nix-store -q --tree /nix/store/...-kitty        → Ağaç görünümü
  '';

  # ── 6. HAFTA 2 TOPARLAMA ──────────────────────────────────────────────
  toparlama = ''
    Hafta 2'de öğrendiklerin:
    ✅ NixOS modül sistemi: options, config, imports, merge
    ✅ Overlay ve override: paket özelleştirme
    ✅ Flake'ler: inputs, outputs, lock, komutlar
    ✅ Home Manager: programs.*, home.file, services
    ✅ Debugging: nix repl, trace, hata analizi

    Artık ~/dotfiles/ yapını tam anlıyorsun!
    Haftaya: Rust ile tanışma — Nix shell'de Rust geliştirme.
  '';

  # ══════════════════════════════════════════════════════════════════════
  # 📝 PRATİK ÖDEV (Hafta 2 Final)
  # ══════════════════════════════════════════════════════════════════════
  # 1. nix repl aç, :lf ~/dotfiles yap
  #    - nixosConfigurations.nixos.config.boot.kernelPackages yazdır
  #    - nixosConfigurations.nixos.config.services.xserver yazdır
  #
  # 2. nix flake check ~/dotfiles → hata var mı?
  #
  # 3. nix search nixpkgs "terminal emulator" → alternatif terminaller bul
  #
  # 4. nix why-depends ile kitty'nin neye bağlı olduğunu araştır
  odev = "nix repl = en güçlü debugging aracın!";
}
