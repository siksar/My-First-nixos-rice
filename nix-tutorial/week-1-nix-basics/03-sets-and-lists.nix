# ============================================================================
# GÜN 3: SETLER VE LİSTELER (Sets & Lists Deep Dive)
# ============================================================================
# Attribute set'ler Nix'in kalbidir. NixOS konfigürasyonu tamamen set'lerden
# oluşur. Bu derste set'lerin ileri kullanımını öğreneceğiz.
#
#   nix eval -f 03-sets-and-lists.nix
# ============================================================================

{
  # ── 1. SET BİRLEŞTİRME (Merge) ────────────────────────────────────────
  # // operatörü ile iki set birleştirilir. Sağdaki kazanır (override).
  mergeOrnek = let
    defaults = { theme = "dark"; font = "mono"; size = 12; };
    override = { size = 14; color = "orange"; };
  in defaults // override;
  # → { theme = "dark"; font = "mono"; size = 14; color = "orange"; }
  # size: 12 → 14 oldu, color eklendi

  # ── 2. DERİN ERİŞİM ───────────────────────────────────────────────────
  deepAccess = let
    config = {
      services = {
        nginx = {
          enable = true;
          port = 80;
        };
      };
    };
  in {
    port = config.services.nginx.port;        # → 80
    enabled = config.services.nginx.enable;   # → true
  };

  # ── 3. GÜVENLİ ERİŞİM (or) ───────────────────────────────────────────
  # Olmayan key'e erişim hata verir. `or` ile varsayılan belirle:
  safeAccess = let
    data = { name = "zixar"; };
  in {
    var = data.name or "bilinmiyor";        # → "zixar"
    yok = data.email or "belirtilmemiş";    # → "belirtilmemiş"
  };

  # ── 4. NESTED SET UPDATE ───────────────────────────────────────────────
  # // sadece yüzeysel birleştirme yapar (shallow merge)!
  shallowProblem = let
    a = { x = { y = 1; z = 2; }; };
    b = { x = { y = 99; }; };          # DİKKAT: z kaybolur!
  in a // b;  # → { x = { y = 99; }; }  — z gitti!

  # Çözüm: recursiveUpdate
  deepMerge = let
    a = { x = { y = 1; z = 2; }; };
    b = { x = { y = 99; }; };
  in builtins.foldl' (acc: x: acc // x) {} [
    a b  # Basit demo — gerçekte lib.recursiveUpdate kullan
  ];

  # ── 5. LİSTE İŞLEMLERİ ────────────────────────────────────────────────
  listeIslemleri = let
    nums = [ 5 3 8 1 7 2 ];
  in {
    # map: her elemana fonksiyon uygula
    doubled = builtins.map (x: x * 2) nums;   # → [ 10 6 16 2 14 4 ]

    # filter: koşula uyanları seç
    buyukler = builtins.filter (x: x > 4) nums;  # → [ 5 8 7 ]

    # sort: sırala
    sirali = builtins.sort (a: b: a < b) nums;  # → [ 1 2 3 5 7 8 ]

    # elem: listede var mı?
    varMi = builtins.elem 3 nums;  # → true

    # length
    uzunluk = builtins.length nums;  # → 6

    # concatLists: liste listesini düzleştir
    duz = builtins.concatLists [ [ 1 2 ] [ 3 4 ] [ 5 ] ];  # → [ 1 2 3 4 5 ]

    # genList: index tabanlı liste üret
    generated = builtins.genList (i: i * i) 5;  # → [ 0 1 4 9 16 ]
  };

  # ── 6. LİSTEDEN SET'E, SET'TEN LİSTEYE ────────────────────────────────
  donusumler = {
    # listToAttrs: [{name; value}] → set
    setYap = builtins.listToAttrs [
      { name = "a"; value = 1; }
      { name = "b"; value = 2; }
    ];  # → { a = 1; b = 2; }

    # attrNames + attrValues: set → listeler
    keys = builtins.attrNames { z = 3; a = 1; m = 2; };  # → [ "a" "m" "z" ]
    vals = builtins.attrValues { a = 1; b = 2; };         # → [ 1 2 ]
  };

  # ── 7. mapAttrs: SET ÜZERİNDE MAP ─────────────────────────────────────
  mapAttrsOrnek = builtins.mapAttrs
    (name: value: "key=${name}, val=${toString value}")
    { x = 1; y = 2; z = 3; };
  # → { x = "key=x, val=1"; y = "key=y, val=2"; z = "key=z, val=3"; }

  # ── 8. GERÇEK DÜNYA ÖRNEĞİ ────────────────────────────────────────────
  # NixOS konfigürasyonunda paketleri filtreleme
  gercekDunya = let
    paketler = [
      { name = "firefox"; category = "browser"; }
      { name = "kitty"; category = "terminal"; }
      { name = "neovim"; category = "editor"; }
      { name = "brave"; category = "browser"; }
      { name = "helix"; category = "editor"; }
    ];
    browsers = builtins.filter (p: p.category == "browser") paketler;
    browserNames = builtins.map (p: p.name) browsers;
  in browserNames;  # → [ "firefox" "brave" ]

  # ══════════════════════════════════════════════════════════════════════
  # 📝 PRATİK ÖDEV
  # ══════════════════════════════════════════════════════════════════════
  # 1. İki config set oluştur (defaults ve overrides), // ile birleştir
  # 2. [ 1 2 3 ... 10 ] listesini builtins.genList ile üret
  # 3. builtins.filter ile sadece tek sayıları filtrele
  # 4. builtins.listToAttrs ile [ "kitty" "nvim" "yazi" ] listesini
  #    { kitty = true; nvim = true; yazi = true; } set'ine çevir
  odev = {
    # Buraya yaz!
  };
}
