# ============================================================================
# GÜN 4: LET, WITH, INHERIT
# ============================================================================
# Nix'in scope (kapsam) yönetimi: let-in, with, inherit.
# Bu üç yapı NixOS konfigürasyonlarında sürekli karşına çıkacak.
#
#   nix eval -f 04-let-with-inherit.nix
# ============================================================================

{
  # ── 1. LET-IN ──────────────────────────────────────────────────────────
  # Yerel değişken tanımlama. let içindeki isimler sadece in bloğunda geçerli.
  letOrnek = let
    x = 10;
    y = 20;
    toplam = x + y;
  in "Toplam: ${toString toplam}";  # → "Toplam: 30"

  # İç içe let
  icIceLet = let
    a = 5;
  in let
    b = a * 2;
  in a + b;  # → 15

  # let ile fonksiyon tanımlama
  letFonksiyon = let
    square = x: x * x;
    cube = x: x * x * x;
  in {
    kare5 = square 5;   # → 25
    kup3 = cube 3;      # → 27
  };

  # ── 2. WITH ────────────────────────────────────────────────────────────
  # Bir set'in tüm key'lerini scope'a getirir (JavaScript'teki `with` gibi)
  withOrnek = let
    colors = {
      bg = "#222222";
      fg = "#c2c2b0";
      accent = "#FF8C00";
    };
  in with colors; {
    # bg, fg, accent artık doğrudan erişilebilir
    tema = "bg=${bg}, fg=${fg}, accent=${accent}";
  };

  # NixOS'ta en çok gördüğün pattern:
  # home.packages = with pkgs; [ firefox kitty neovim ];
  # Bu, her paketin başına pkgs. yazmaktan kurtarır

  # ── 3. WITH SCOPE ÖNCELİĞİ ─────────────────────────────────────────────
  # with scope'taki isimler, mevcut let/arg isimlerinden DÜŞÜK önceliklidir
  withOncelik = let
    x = "local";        # Bu kazanır!
    scope = { x = "from-scope"; y = "only-scope"; };
  in with scope; {
    xDeger = x;          # → "local" (let kazandı)
    yDeger = y;          # → "only-scope" (sadece with'te var)
  };

  # ── 4. INHERIT ─────────────────────────────────────────────────────────
  # Dış scope'tan isimleri set'e "miras al" — kopyala/yapıştır yerine
  inheritOrnek = let
    name = "zixar";
    version = "1.0";
    description = "NixOS Config";
  in {
    # Uzun yol:
    # name = name;
    # version = version;

    # Kısa yol (inherit):
    inherit name version description;
    # → { name = "zixar"; version = "1.0"; description = "NixOS Config"; }
  };

  # ── 5. INHERIT (FROM) ─────────────────────────────────────────────────
  # Başka bir set'ten inherit
  inheritFrom = let
    systemConfig = {
      hostname = "gigabyte-aero";
      timezone = "Europe/Istanbul";
      locale = "en_US.UTF-8";
    };
  in {
    inherit (systemConfig) hostname timezone;
    # → { hostname = "gigabyte-aero"; timezone = "Europe/Istanbul"; }
    # locale dahil DEĞİL — sadece seçtiklerin gelir
  };

  # ── 6. GERÇEK NixOS ÖRNEĞİ ────────────────────────────────────────────
  # Senin dotfiles'ındaki gerçek pattern:
  gercekOrnek = let
    colors = {
      base00 = "#222222";
      base05 = "#c2c2b0";
      base09 = "#FF8C00";
    };
  in {
    # Stylix'teki gibi base16 kullanımı:
    stylix = {
      inherit (colors) base00 base05 base09;
    };

    # with kullanımı — paket listeleri:
    packages = with { a = "firefox"; b = "kitty"; c = "neovim"; }; [
      a b c
    ];
  };

  # ── 7. LET vs WITH KARŞILAŞTIRMA ──────────────────────────────────────
  karsilastirma = {
    # let: açık tanımlama, tip güvenli, IDE desteği
    letYolu = let
      x = 42;
    in x;

    # with: kısa yazım, büyük set'ler için ideal
    # Dezavantaj: hangi ismin nereden geldiği belirsiz olabilir
    withYolu = with { x = 42; }; x;

    # Genel kural:
    # - Birkaç değişken → let
    # - Büyük set (pkgs gibi) → with
    # - Set'e kopyalama → inherit
  };

  # ══════════════════════════════════════════════════════════════════════
  # 📝 PRATİK ÖDEV
  # ══════════════════════════════════════════════════════════════════════
  # 1. let ile Miasma renk paleti tanımla (bg, fg, orange, green, gold)
  # 2. with kullanarak bu renkleri bir "tema" set'inde kullan
  # 3. inherit ile renkleri farklı bir set'e aktar
  # 4. ~/dotfiles/modules/stylix.nix dosyasını aç ve base16Scheme'in
  #    nasıl let/with/inherit kullandığını incele
  odev = {
    # Buraya yaz!
  };
}
