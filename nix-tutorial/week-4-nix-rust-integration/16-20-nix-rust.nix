# ============================================================================
# GÜN 16-20: NIX + RUST ENTEGRASYONU
# ============================================================================
# Nix ile Rust projelerini build etmek, paketlemek ve dağıtmak.
# buildRustPackage, crane, dev shells, cross-compilation, testing.
#
# Her bölüm ~30dk'lık çalışma.
# ============================================================================

{
  # ═══════════════════════════════════════════════════════════════════════
  # GÜN 16: buildRustPackage
  # ═══════════════════════════════════════════════════════════════════════
  gun16_buildRustPackage = ''
    # Nix ile Rust paketi oluşturmanın temel yolu

    # my-tool/default.nix:
    { lib, rustPlatform, fetchFromGitHub }:

    rustPlatform.buildRustPackage rec {
      pname = "my-tool";
      version = "0.1.0";

      src = fetchFromGitHub {
        owner = "zixar";
        repo = "my-tool";
        rev = "v''${version}";
        hash = "sha256-AAAA...";
      };

      cargoHash = "sha256-BBBB...";  # Cargo.lock hash

      meta = with lib; {
        description = "Benim Rust aracım";
        homepage = "https://github.com/zixar/my-tool";
        license = licenses.mit;
        maintainers = [ ];
      };
    }

    # Hash bulma komutu:
    # nix-prefetch-url --unpack https://github.com/...
    # veya hash = lib.fakeHash; ile build et, hata mesajından kopyala
  '';

  # ═══════════════════════════════════════════════════════════════════════
  # GÜN 17: CRANE İLE INCREMENTAL BUILDS
  # ═══════════════════════════════════════════════════════════════════════
  gun17_crane = ''
    # Crane: Hızlı, incremental Rust builds for Nix
    # buildRustPackage her seferinde sıfırdan build eder
    # Crane dependency cache'i kullanır → çok daha hızlı

    {
      inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        crane.url = "github:ipetkov/crane";
        crane.inputs.nixpkgs.follows = "nixpkgs";
      };

      outputs = { self, nixpkgs, crane }:
      let
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.''${system};
        craneLib = crane.mkLib pkgs;

        # Sadece Rust dosyalarını filtrele (gereksiz dosyalar build'i bozmasın)
        src = craneLib.cleanCargoSource ./.;

        # Önce dependency'leri build et (cache'lenir!)
        cargoArtifacts = craneLib.buildDepsOnly { inherit src; };

        # Sonra sadece senin kodunu build et (çok hızlı!)
        my-tool = craneLib.buildPackage {
          inherit src cargoArtifacts;
        };
      in {
        packages.''${system}.default = my-tool;

        devShells.''${system}.default = craneLib.devShell {
          packages = with pkgs; [ rust-analyzer clippy ];
        };
      };
    }
  '';

  # ═══════════════════════════════════════════════════════════════════════
  # GÜN 18: DEV SHELLS VE DİRENV
  # ═══════════════════════════════════════════════════════════════════════
  gun18_devshells = ''
    # Gelişmiş dev shell — extern crate'ler için
    devShells.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        # Rust toolchain
        rustc cargo rust-analyzer clippy rustfmt cargo-watch

        # C dependencies (openssl, sqlite, etc.)
        pkg-config openssl sqlite

        # Geliştirme araçları
        just           # Makefile alternatifi
        cargo-edit     # cargo add, cargo rm
        cargo-expand   # Macro expansion
        cargo-flamegraph # Profiling
      ];

      # Linker optimizasyonu
      RUSTFLAGS = "-C link-arg=-fuse-ld=mold";

      # Daha iyi hata mesajları
      RUST_BACKTRACE = "1";
      RUST_LOG = "debug";
    };

    # .envrc: use flake
    # direnv allow
    # → Klasöre girdiğinde otomatik dev environment!
  '';

  # ═══════════════════════════════════════════════════════════════════════
  # GÜN 19: CROSS-COMPILATION
  # ═══════════════════════════════════════════════════════════════════════
  gun19_cross = ''
    # Nix ile farklı platformlara build et
    # x86_64-linux'tan aarch64-linux'a (ARM) cross-compile

    packages.aarch64-linux.default =
      (import nixpkgs { system = "aarch64-linux"; })
      .callPackage ./default.nix { };

    # veya pkgsCross kullan:
    let
      pkgsArm = import nixpkgs {
        system = "x86_64-linux";
        crossSystem = {
          config = "aarch64-unknown-linux-gnu";
        };
      };
    in pkgsArm.callPackage ./default.nix { }

    # MUSL static build (dependency-free binary):
    # pkgs.pkgsStatic.callPackage ./default.nix { }
  '';

  # ═══════════════════════════════════════════════════════════════════════
  # GÜN 20: NIX + RUST TEST PATTERNS
  # ═══════════════════════════════════════════════════════════════════════
  gun20_testing = ''
    # 1. Cargo testleri Nix build'de otomatik çalışır
    #    buildRustPackage { doCheck = true; }  # Varsayılan

    # 2. Nix check ile flake doğrulama
    checks.''${system} = {
      my-tool-clippy = craneLib.cargoClippy {
        inherit src cargoArtifacts;
        cargoClippyExtraArgs = "--all-targets -- -Dwarnings";
      };

      my-tool-fmt = craneLib.cargoFmt { inherit src; };

      my-tool-tests = craneLib.cargoTest {
        inherit src cargoArtifacts;
      };
    };

    # 3. CI/CD'de: nix flake check
    #    Bu tüm checks'i çalıştırır
  '';

  # ══════════════════════════════════════════════════════════════════════
  # 📝 PRATİK ÖDEV (Hafta 4 Final)
  # ══════════════════════════════════════════════════════════════════════
  # 1. mkdir ~/Projects/nix-rust-demo && cd ~/Projects/nix-rust-demo
  # 2. cargo init
  # 3. Basit bir CLI tool yaz (argparse ile)
  # 4. flake.nix ekle (crane veya buildRustPackage ile)
  # 5. nix build && ./result/bin/my-tool
  # 6. nix flake check
  odev = "Kendi Rust projen Nix-native olarak build edilebilir!";
}
