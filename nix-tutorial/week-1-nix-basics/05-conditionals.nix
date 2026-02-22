# ============================================================================
# GÜN 5: KOŞULLAR, ASSERT VE BUILTINS DERİN DALİŞ
# ============================================================================
# Nix'te kontrol akışı: if-then-else, assert, ve güçlü builtins kütüphanesi.
# Bugün ayrıca dosya/yol işlemleri ve string manipülasyonu öğreneceğiz.
#
#   nix eval -f 05-conditionals.nix
# ============================================================================

{
  # ── 1. IF-THEN-ELSE ────────────────────────────────────────────────────
  # Nix'te if bir EXPRESSION'dır — her zaman bir değer döndürür
  # else ZORUNLUDUR (çünkü her ifade değer üretmeli)
  basitIf = if 2 > 1 then "büyük" else "küçük";  # → "büyük"

  # İç içe if
  derecelendirme = let
    not_ = 85;
  in
    if not_ >= 90 then "AA"
    else if not_ >= 80 then "BA"
    else if not_ >= 70 then "BB"
    else "CC";  # → "BA"

  # if ile platform kontrolü (NixOS'ta sık kullanılır)
  platformKontrol = let
    system = "x86_64-linux";
  in if system == "x86_64-linux" then "Linux AMD64"
     else if system == "aarch64-linux" then "Linux ARM64"
     else "Diğer";

  # ── 2. ASSERT ──────────────────────────────────────────────────────────
  # assert koşulu sağlanmazsa evaluation HATA verir
  # Konfigürasyon doğrulaması için mükemmel
  assertOrnek = let
    port = 8080;
  in assert port > 0 && port < 65536;
    "Port ${toString port} geçerli";

  # Birden fazla assert
  configValidation = let
    config = {
      ram = 32;
      cores = 8;
      gpu = "nvidia";
    };
  in assert config.ram >= 8;
     assert config.cores >= 2;
     assert builtins.elem config.gpu [ "nvidia" "amd" "intel" ];
     "Config geçerli: ${toString config.ram}GB RAM, ${toString config.cores} cores, ${config.gpu}";

  # ── 3. STRING İŞLEMLERİ ────────────────────────────────────────────────
  stringIslemleri = {
    # substring: kesme
    ilkUc = builtins.substring 0 3 "NixOS";  # → "Nix"

    # stringLength
    uzunluk = builtins.stringLength "hello";  # → 5

    # replaceStrings: değiştirme
    degistir = builtins.replaceStrings
      [ "foo" "bar" ] [ "FOO" "BAR" ]
      "foo and bar";  # → "FOO and BAR"

    # split: regex ile bölme
    bolunmus = builtins.split "," "a,b,c,d";
    # → [ "a" [ ] "b" [ ] "c" [ ] "d" ]
    # NOT: Araya regex match'leri de gelir, filter ile temizle

    # match: regex eşleştirme (null = eşleşmedi)
    eslesti = builtins.match "([0-9]+)" "42";       # → [ "42" ]
    eslesmedi = builtins.match "([0-9]+)" "hello";  # → null

    # concatStringsSep
    birlestir = builtins.concatStringsSep " | " [ "Nix" "Rust" "Linux" ];
    # → "Nix | Rust | Linux"
  };

  # ── 4. DOSYA İŞLEMLERİ ────────────────────────────────────────────────
  dosyaIslemleri = {
    # readFile: dosya oku (string olarak)
    # readDir: dizin içeriğini oku (set olarak)
    # pathExists: yol var mı?
    # NOT: Bu fonksiyonlar evaluation sırasında çalışır!

    # readDir örneği (mevcut dizini oku)
    # builtins.readDir . → { "01-values-and-types.nix" = "regular"; ... }

    # pathExists — conditional import için çok kullanışlı
    # if builtins.pathExists ./optional.nix then import ./optional.nix else {}
  };

  # ── 5. IMPORT ──────────────────────────────────────────────────────────
  # import: başka bir .nix dosyasını yükle ve evaluate et
  # NixOS konfigürasyonunun temel taşı!
  importKonsept = {
    # import ./file.nix      → dosyayı evaluate et
    # import ./file.nix { }  → fonksiyon ise argümanla çağır

    # Senin flake.nix'teki kullanım:
    # ./modules/kernel.nix → import eder
    # home-manager.users.zixar = import ./home.nix;
    ornek = "import, dosyayı Nix expression olarak yükler";
  };

  # ── 6. THROW ve ABORT ────────────────────────────────────────────────
  # Hata fırlatma
  hataOrnek = let
    checkGPU = gpu:
      if gpu == "nvidia" then "NVIDIA destekleniyor"
      else if gpu == "amd" then "AMD destekleniyor"
      else builtins.throw "Bilinmeyen GPU: ${gpu}";
  in checkGPU "nvidia";  # → "NVIDIA destekleniyor"
  # checkGPU "intel" → error: Bilinmeyen GPU: intel

  # ── 7. builtins.tryEval ────────────────────────────────────────────────
  # Hata yakalamak (try-catch benzeri)
  tryOrnek = {
    basarili = builtins.tryEval 42;
    # → { success = true; value = 42; }

    # throw'u yakala
    hatali = builtins.tryEval (builtins.throw "test hatası");
    # → { success = false; value = false; }
  };

  # ── 8. toJSON / fromJSON ───────────────────────────────────────────────
  jsonIslemleri = {
    toJson = builtins.toJSON {
      name = "zixar";
      packages = [ "nvim" "kitty" ];
    };
    # → "{\"name\":\"zixar\",\"packages\":[\"nvim\",\"kitty\"]}"

    fromJson = builtins.fromJSON ''{"x": 42, "y": "hello"}'';
    # → { x = 42; y = "hello"; }
  };

  # ── 9. HAFTA 1 TOPARLAMA ──────────────────────────────────────────────
  # Bu haftada öğrendiklerin:
  # ✅ Değerler: int, bool, string, path, null, list, set
  # ✅ Fonksiyonlar: lambda, currying, destructuring, defaults, ...
  # ✅ Setler: merge (//), deep access, mapAttrs, listToAttrs
  # ✅ Scope: let-in, with, inherit
  # ✅ Kontrol: if-then-else, assert, throw, tryEval
  # ✅ Builtins: map, filter, sort, json, string ops
  #
  # Haftaya: NixOS modül sistemi, overlay'lar, flake'ler!
  toparlama = "Hafta 1 tamamlandı! 🎉";

  # ══════════════════════════════════════════════════════════════════════
  # 📝 PRATİK ÖDEV (Hafta 1 Final)
  # ══════════════════════════════════════════════════════════════════════
  # 1. Bir "config validator" fonksiyon yaz:
  #    { port, host, ssl ? false } alıp assert'ler ile doğrulasın:
  #    - port 1-65535 arası
  #    - host boş string olmasın
  #    - ssl true ise port 443 olmalı
  #
  # 2. builtins.fromJSON ile bu JSON'ı parse et ve name field'ını al:
  #    '{"name": "Gigabyte Aero", "cpu": "Ryzen AI 7 350"}'
  #
  # 3. builtins.replaceStrings ile bir string'deki tüm "gruvbox"
  #    kelimelerini "miasma" ile değiştir
  odev = {
    # Buraya yaz!
  };
}
