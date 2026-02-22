# ============================================================================
# GÜN 26-30: CAPSTONE PROJE
# ============================================================================
# Son hafta: Öğrendiğin her şeyi birleştir.
# Bir Rust CLI tool yaz, Nix ile paketle, NixOS modülü olarak serve et.
#
# Proje: "nix-sysinfo" — Sistem bilgisi raporlayan Rust CLI + NixOS service
# ============================================================================

{
  # ═══════════════════════════════════════════════════════════════════════
  # GÜN 26: PROJE YAPISI
  # ═══════════════════════════════════════════════════════════════════════
  gun26_setup = ''
    # Proje: nix-sysinfo
    # CPU, GPU, RAM, disk kullanımını raporlayan Rust CLI + NixOS timer

    mkdir -p ~/Projects/nix-sysinfo
    cd ~/Projects/nix-sysinfo

    # Yapı:
    # nix-sysinfo/
    # ├── flake.nix           ← Nix flake (build + dev shell + module)
    # ├── flake.lock
    # ├── Cargo.toml
    # ├── src/
    # │   ├── main.rs         ← CLI entry point
    # │   ├── cpu.rs          ← CPU bilgileri
    # │   ├── gpu.rs          ← GPU bilgileri
    # │   └── memory.rs       ← RAM/disk bilgileri
    # ├── nix/
    # │   ├── package.nix     ← Nix paket tanımı
    # │   └── module.nix      ← NixOS modül (systemd timer)
    # └── tests/
    #     └── integration.nix ← NixOS VM testi

    cargo init
  '';

  # ═══════════════════════════════════════════════════════════════════════
  # GÜN 27: CLI TOOL GELİŞTİRME
  # ═══════════════════════════════════════════════════════════════════════
  gun27_cli = ''
    // Cargo.toml:
    [package]
    name = "nix-sysinfo"
    version = "0.1.0"
    edition = "2021"

    [dependencies]
    clap = { version = "4", features = ["derive"] }
    serde = { version = "1", features = ["derive"] }
    serde_json = "1"
    sysinfo = "0.31"

    // src/main.rs:
    use clap::Parser;
    use sysinfo::System;

    #[derive(Parser)]
    #[command(name = "nix-sysinfo")]
    #[command(about = "NixOS system information tool")]
    struct Args {
        /// Output format (text, json, nix)
        #[arg(short, long, default_value = "text")]
        format: String,

        /// Show CPU info
        #[arg(long)]
        cpu: bool,

        /// Show memory info
        #[arg(long)]
        memory: bool,

        /// Show all info
        #[arg(short, long)]
        all: bool,
    }

    fn main() {
        let args = Args::parse();
        let mut sys = System::new_all();
        sys.refresh_all();

        if args.all || args.cpu {
            println!("CPU: {}", sys.cpus().first().map(|c| c.brand()).unwrap_or("Unknown"));
            println!("Cores: {}", sys.cpus().len());
        }

        if args.all || args.memory {
            println!("RAM: {:.1} GB / {:.1} GB",
                sys.used_memory() as f64 / 1_073_741_824.0,
                sys.total_memory() as f64 / 1_073_741_824.0);
        }
    }
  '';

  # ═══════════════════════════════════════════════════════════════════════
  # GÜN 28: SYSTEMD SERVICE + NixOS MODULE
  # ═══════════════════════════════════════════════════════════════════════
  gun28_service = ''
    # nix/module.nix:
    { config, lib, pkgs, ... }:

    with lib;

    let cfg = config.services.nix-sysinfo;
    in {
      options.services.nix-sysinfo = {
        enable = mkEnableOption "nix-sysinfo reporting";
        interval = mkOption {
          type = types.str;
          default = "hourly";
          description = "How often to run the report";
        };
        outputPath = mkOption {
          type = types.str;
          default = "/var/log/sysinfo";
          description = "Output directory";
        };
      };

      config = mkIf cfg.enable {
        systemd.services.nix-sysinfo = {
          description = "System Info Reporter";
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "''${cfg.package}/bin/nix-sysinfo --all --format json > ''${cfg.outputPath}/report-$(date +%Y%m%d_%H%M).json";
          };
        };

        systemd.timers.nix-sysinfo = {
          wantedBy = [ "timers.target" ];
          timerConfig.OnCalendar = cfg.interval;
        };
      };
    }
  '';

  # ═══════════════════════════════════════════════════════════════════════
  # GÜN 29: FLAKE TEMPLATES
  # ═══════════════════════════════════════════════════════════════════════
  gun29_templates = ''
    # Kendi flake template'ini oluştur!
    # Yeni projeler için başlangıç noktası

    # flake.nix'e ekle:
    templates = {
      rust-cli = {
        path = ./templates/rust-cli;
        description = "Rust CLI tool with Nix build";
      };
      rust-service = {
        path = ./templates/rust-service;
        description = "Rust service with NixOS module";
      };
    };

    # Kullanım:
    # nix flake init --template github:zixar/nix-templates#rust-cli
    # → Hazır proje yapısı!
  '';

  # ═══════════════════════════════════════════════════════════════════════
  # GÜN 30: BİTİRME VE REVIEW
  # ═══════════════════════════════════════════════════════════════════════
  gun30_graduation = ''
    🎓 TEBRİKLER! 30 günlük eğitimi tamamladın!

    ═══ ÖĞRENME YOLCULUĞUN ═══

    Hafta 1: Nix Dili ✅
    → Değerler, fonksiyonlar, set'ler, scope yönetimi

    Hafta 2: NixOS Patterns ✅
    → Modüller, overlay'lar, flake'ler, Home Manager

    Hafta 3: Rust Temelleri ✅
    → Ownership, traits, error handling, generics

    Hafta 4: Nix + Rust ✅
    → buildRustPackage, crane, dev shells, testing

    Hafta 5: İleri NixOS ✅
    → Custom modules, VM tests, secrets, CI/CD

    Hafta 6: Capstone ✅
    → Tam bir Rust + NixOS projesi

    ═══ SONRAKI ADIMLAR ═══

    1. ~/dotfiles/ yapını geliştir — yeni modüller ekle
    2. nixpkgs'e bir paket gönder (PR)
    3. Rust CLI tool'larını Nix ile paketle
    4. NixOS VM testleri yaz
    5. Toplulukla paylaş: discourse.nixos.org

    "The Nix way is the right way." 🧊
  '';

  # ══════════════════════════════════════════════════════════════════════
  # 📝 FINAL ÖDEV
  # ══════════════════════════════════════════════════════════════════════
  # nix-sysinfo projesini tamamla:
  # 1. cargo init && src/main.rs yaz
  # 2. flake.nix ekle (crane ile build)
  # 3. NixOS module yaz (systemd timer)
  # 4. nix build && nix flake check
  # 5. ~/dotfiles/configuration.nix'e import et
  # 6. nixos-rebuild switch → Servisinin çalıştığını gör!
  odev = "Artık Nix + Rust ustasısın! 🦀🧊";
}
