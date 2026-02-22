# ============================================================================
# GÜN 2: FONKSİYONLAR (Functions)
# ============================================================================
# Nix fonksiyonel bir dildir — fonksiyonlar birinci sınıf vatandaştır.
# Her fonksiyon TEK parametre alır (currying ile çoklu parametre yapılır).
#
#   nix eval -f 02-functions.nix
# ============================================================================

{
  # ── 1. TEMEL FONKSİYON ─────────────────────────────────────────────────
  # Nix'te fonksiyon: parametre: gövde
  # "Lambda" gibi düşün, isimsiz fonksiyon
  double = x: x * 2;

  # Kullanım: (x: x * 2) 5 → 10
  doubleResult = (x: x * 2) 5;

  # ── 2. İSİMLİ FONKSİYONLAR ────────────────────────────────────────────
  # let-in ile isimlendirme
  greetResult = let
    greet = name: "Merhaba, ${name}!";
  in greet "zixar";  # → "Merhaba, zixar!"

  # ── 3. CURRYING (Çoklu Parametre) ─────────────────────────────────────
  # Nix'te her fonksiyon tek parametre alır
  # Ama fonksiyon döndüren fonksiyon ile çoklu parametre simüle edilir
  add = a: b: a + b;

  # Bu aslında şu demek: add = a: (b: a + b);
  addResult = (a: b: a + b) 3 4;  # → 7

  # Partial application (kısmi uygulama)
  add5 = (a: b: a + b) 5;  # Artık sadece b bekliyor
  add5Result = ((a: b: a + b) 5) 3;  # → 8

  # ── 4. ATTRIBUTE SET PARAMETRESİ ───────────────────────────────────────
  # En çok kullanılan pattern! NixOS modülleri hep böyle çalışır.
  greetFull = { name, age }: "Ben ${name}, ${toString age} yaşındayım.";
  greetFullResult = ({ name, age }: "Ben ${name}, ${toString age} yaşındayım.") {
    name = "zixar";
    age = 25;
  };

  # ── 5. DEFAULT DEĞERLER ────────────────────────────────────────────────
  # ? ile varsayılan değer atanabilir
  connectResult = let
    connect = { host, port ? 8080 }: "Connecting to ${host}:${toString port}";
  in {
    varsayilan = connect { host = "localhost"; };  # port=8080 kullanılır
    ozel = connect { host = "localhost"; port = 443; };
  };

  # ── 6. VARIADIC ARGS (...) ────────────────────────────────────────────
  # ... ile ekstra argümanlar kabul edilir (ignore edilir)
  # NixOS modüllerinde HER YERDE görürsün: { config, pkgs, ... }:
  flexibleResult = let
    onlyNeed = { name, ... }: "Sadece ${name} lazım!";
  in onlyNeed { name = "zixar"; age = 25; hobby = "coding"; };

  # ── 7. @PATTERN ────────────────────────────────────────────────────────
  # Set'i hem destructure hem de komple yakala
  atPatternResult = let
    info = args@{ name, age, ... }:
      "${name} (${toString age}) - keys: ${toString (builtins.attrNames args)}";
  in info { name = "zixar"; age = 25; lang = "tr"; };

  # ── 8. ÖNEMLİ BUILTINS FONKSİYONLAR ──────────────────────────────────
  builtinOrnekler = {
    # map: listeye fonksiyon uygula
    mapped = builtins.map (x: x * 2) [ 1 2 3 4 ];  # → [ 2 4 6 8 ]

    # filter: listeyi filtrele
    filtered = builtins.filter (x: x > 2) [ 1 2 3 4 5 ];  # → [ 3 4 5 ]

    # foldl': reduce/accumulate (soldan sağa)
    toplam = builtins.foldl' (acc: x: acc + x) 0 [ 1 2 3 4 5 ];  # → 15

    # toString: sayıyı stringe çevir
    numStr = builtins.toString 42;  # → "42"

    # attrNames: set'in key listesi
    keys = builtins.attrNames { z = 1; a = 2; m = 3; };  # → [ "a" "m" "z" ] (sıralı!)

    # attrValues: set'in value listesi
    vals = builtins.attrValues { a = 10; b = 20; };  # → [ 10 20 ]

    # hasAttr: key var mı?
    var = builtins.hasAttr "name" { name = "zixar"; };  # → true

    # concatStringsSep: stringleri birleştir
    joined = builtins.concatStringsSep ", " [ "Nix" "Rust" "Linux" ];
  };

  # ── 9. FONKSİYON KOMPOZİSYONU ─────────────────────────────────────────
  # Fonksiyonları zincirle
  pipelineResult = let
    double = x: x * 2;
    increment = x: x + 1;
    negate = x: -x;

    # Compose: f(g(x))
    result = negate (increment (double 5));  # → -(5*2+1) = -11
  in result;

  # ══════════════════════════════════════════════════════════════════════
  # 📝 PRATİK ÖDEV
  # ══════════════════════════════════════════════════════════════════════
  # 1. Bir `capitalize` fonksiyon yaz: string alıp ilk harfi büyük yap
  #    İpucu: builtins.substring ve lib.toUpper kullan (veya sadece mantığı düşün)
  # 2. `{ name, distro ? "NixOS", wm ? "Hyprland" }` parametreli fonksiyon yaz
  #    "name uses distro with wm" formatında string döndürsün
  # 3. builtins.map kullanarak [ 1 2 3 4 5 ] listesinin karelerini al
  # 4. builtins.filter ile sadece çift sayıları filtrele
  odev = {
    # Buraya yaz!
    kareler = builtins.map (x: x * x) [ 1 2 3 4 5 ];
  };
}
