# ============================================================================
# GÜN 11: NIX SHELL İLE RUST ORTAMI
# ============================================================================
# Nix + Rust = Mükemmel geliştirme ortamı. Reproducible, izole, hızlı.
# Bu derste nix develop ve nix shell ile Rust ortamı kuracağız.
#
# Komutlar: nix develop, cargo, rustc
# ============================================================================

{
  # ── 1. RUST NIX SHELL ──────────────────────────────────────────────────
  nixShellOrnek = ''
    # Hızlı Rust ortamı (geçici):
    nix shell nixpkgs#rustc nixpkgs#cargo

    # veya dev shell oluştur:
    # flake.nix'e devShells ekle
  '';

  # ── 2. FLAKE DEV SHELL ────────────────────────────────────────────────
  flakeDevShell = ''
    # Proje klasörüne flake.nix ekle:
    {
      inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
      };

      outputs = { self, nixpkgs }:
      let
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.''${system};
      in {
        devShells.''${system}.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            rustc
            cargo
            rust-analyzer    # LSP
            clippy           # Linter
            rustfmt          # Formatter
            pkg-config       # C kütüphaneleri için
            openssl          # Sık kullanılan dependency
          ];

          shellHook = '''
            echo "🦀 Rust dev ortamı hazır!"
            rustc --version
            cargo --version
          ''';

          RUST_BACKTRACE = "1";
          RUST_SRC_PATH = "''${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
        };
      };
    }
  '';

  # ── 3. İLK RUST PROJESİ ───────────────────────────────────────────────
  ilkProje = ''
    # 1. Dev shell'e gir
    nix develop

    # 2. Yeni proje oluştur
    cargo new hello-nix
    cd hello-nix

    # 3. Kodu düzenle (src/main.rs)
    fn main() {
        println!("Merhaba, Nix + Rust! 🦀");
    }

    # 4. Çalıştır
    cargo run

    # 5. Test et
    cargo test

    # Hot reload ile geliştir
    cargo watch -x run    # (cargo-watch gerekli)
  '';

  # ── 4. DIRENV ENTEGRASYONU ────────────────────────────────────────────
  direnvOrnek = ''
    # .envrc dosyası oluştur:
    echo "use flake" > .envrc
    direnv allow

    # Artık dizine girdiğinde otomatik olarak:
    # - Rust toolchain yüklenir
    # - Ortam değişkenleri ayarlanır
    # - Shell hook çalışır

    # Senin dotfiles'ında direnv zaten kurulu:
    # programs.direnv.enable = true;
    # programs.direnv.nix-direnv.enable = true;
  '';

  # ── 5. RUST TEMEL SÖZDİZİMİ ──────────────────────────────────────────
  rustBasics = ''
    // Değişkenler (immutable by default!)
    let x = 42;          // İmmutable — Nix gibi!
    let mut y = 10;      // Mutable (açıkça belirt)
    y += 1;

    // Tipler
    let i: i32 = 42;     // 32-bit integer
    let f: f64 = 3.14;   // 64-bit float (Nix'te yok!)
    let s: &str = "hello"; // String slice
    let s: String = String::from("hello"); // Owned string
    let b: bool = true;

    // Fonksiyonlar
    fn add(a: i32, b: i32) -> i32 {
        a + b  // Son expression return edilir (Nix gibi!)
    }

    // Nix vs Rust karşılaştırma:
    // Nix:  add = a: b: a + b;
    // Rust: fn add(a: i32, b: i32) -> i32 { a + b }
  '';

  # ══════════════════════════════════════════════════════════════════════
  # 📝 PRATİK ÖDEV
  # ══════════════════════════════════════════════════════════════════════
  # 1. nix shell nixpkgs#rustc nixpkgs#cargo ile geçici shell aç
  # 2. cargo new hello-nix && cd hello-nix && cargo run
  # 3. Bir proje klasörü oluştur, devShell'li flake.nix ekle
  # 4. nix develop ile shell'e gir, rustc --version kontrol et
  odev = "Nix + Rust geliştirme ortamını kur!";
}
