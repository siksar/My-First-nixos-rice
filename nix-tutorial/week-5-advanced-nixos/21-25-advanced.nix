# ============================================================================
# GÜN 21-25: İLERİ NixOS
# ============================================================================
# Kendi modüllerini yaz, NixOS VM testleri, secrets yönetimi, CI/CD, paketleme.
# Her bölüm ~30dk.
# ============================================================================

{
  # ═══════════════════════════════════════════════════════════════════════
  # GÜN 21: KENDİ NixOS MODÜLÜNü YAZ
  # ═══════════════════════════════════════════════════════════════════════
  gun21_custom_modules = ''
    # modules/my-service.nix
    { config, lib, pkgs, ... }:

    with lib;

    let
      cfg = config.services.myService;
    in {
      # OPTIONS: Kullanıcıya sunulan ayarlar
      options.services.myService = {
        enable = mkEnableOption "My custom service";

        port = mkOption {
          type = types.port;
          default = 8080;
          description = "Port to listen on";
        };

        logLevel = mkOption {
          type = types.enum [ "debug" "info" "warn" "error" ];
          default = "info";
          description = "Log verbosity level";
        };

        package = mkOption {
          type = types.package;
          default = pkgs.my-tool;
          description = "Package to use";
        };
      };

      # CONFIG: Options enable edildiğinde ne yapılır
      config = mkIf cfg.enable {
        # Systemd service oluştur
        systemd.services.myService = {
          description = "My Custom Service";
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];
          serviceConfig = {
            ExecStart = "''${cfg.package}/bin/my-tool --port ''${toString cfg.port} --log ''${cfg.logLevel}";
            Restart = "on-failure";
            DynamicUser = true;  # Güvenlik: izole user
          };
        };

        # Firewall port aç
        networking.firewall.allowedTCPPorts = [ cfg.port ];
      };
    }

    # Kullanım (configuration.nix'te):
    # services.myService.enable = true;
    # services.myService.port = 9090;
  '';

  # ═══════════════════════════════════════════════════════════════════════
  # GÜN 22: NixOS VM TESTLERİ
  # ═══════════════════════════════════════════════════════════════════════
  gun22_vm_tests = ''
    # NixOS'un killer feature'ı: VM içinde otomatik test

    # tests/my-service-test.nix:
    { pkgs, ... }:
    pkgs.nixosTest {
      name = "my-service-test";

      nodes = {
        server = { config, pkgs, ... }: {
          imports = [ ../modules/my-service.nix ];
          services.myService = {
            enable = true;
            port = 8080;
          };
        };

        client = { ... }: {
          # Boş — sadece server'a bağlanacak
        };
      };

      testScript = '''
        server.start()
        server.wait_for_unit("myService.service")
        server.wait_for_open_port(8080)

        # Servisin çalıştığını doğrula
        client.succeed("curl -f http://server:8080/health")

        # Loglara bak
        server.succeed("journalctl -u myService | grep 'Started'")
      ''';
    }

    # Çalıştır: nix build .#checks.x86_64-linux.my-service-test
    # Bu bir QEMU VM başlatır, testi çalıştırır, sonuç döndürür!
  '';

  # ═══════════════════════════════════════════════════════════════════════
  # GÜN 23: SECRETS YÖNETİMİ
  # ═══════════════════════════════════════════════════════════════════════
  gun23_secrets = ''
    # PROBLEM: Nix store world-readable → secret koyma!
    # ÇÖZÜM: agenix veya sops-nix

    # === AGENIX ===
    # 1. age-keygen -o ~/.config/sops/age/keys.txt
    # 2. Şifre oluştur: agenix -e secrets/wifi-password.age
    # 3. Kullan:
    age.secrets.wifiPassword = {
      file = ../secrets/wifi-password.age;
      owner = "root";
      mode = "0400";
    };

    # === SOPS-NIX ===
    # YAML/JSON tabanlı, çoklu key desteği
    sops.secrets."my-api-key" = {
      sopsFile = ./secrets/api.yaml;
      owner = "my-service";
    };

    # Her iki araç da:
    # - Şifreleri git'e commit edebilirsin (encrypted)
    # - Deployment sırasında decrypt edilir
    # - Store'da açık metin ASLA tutulmaz
  '';

  # ═══════════════════════════════════════════════════════════════════════
  # GÜN 24: CI/CD WITH NIX
  # ═══════════════════════════════════════════════════════════════════════
  gun24_cicd = ''
    # GitHub Actions ile Nix CI/CD

    # .github/workflows/ci.yml:
    name: CI
    on: [push, pull_request]
    jobs:
      check:
        runs-on: ubuntu-latest
        steps:
        - uses: actions/checkout@v4
        - uses: DeterminateSystems/nix-installer-action@main
        - uses: DeterminateSystems/magic-nix-cache-action@main
        - run: nix flake check

      build:
        runs-on: ubuntu-latest
        steps:
        - uses: actions/checkout@v4
        - uses: DeterminateSystems/nix-installer-action@main
        - uses: DeterminateSystems/magic-nix-cache-action@main
        - run: nix build

    # magic-nix-cache: Build cache → sonraki CI'lar çok hızlı!
  '';

  # ═══════════════════════════════════════════════════════════════════════
  # GÜN 25: PAKETLEME VE NIXPKGS PR
  # ═══════════════════════════════════════════════════════════════════════
  gun25_packaging = ''
    # Kendi paketini nixpkgs'e gönder!

    # 1. Fork: github.com/NixOS/nixpkgs
    # 2. Branch: my-new-package
    # 3. Paket dosyası:
    #    pkgs/by-name/my/my-tool/package.nix  (yeni format)

    { lib, rustPlatform, fetchFromGitHub }:
    rustPlatform.buildRustPackage rec {
      pname = "my-tool";
      version = "1.0.0";
      src = fetchFromGitHub { ... };
      cargoHash = "sha256-...";
      meta = { maintainers = with lib.maintainers; [ zixar ]; };
    }

    # 4. Test: nix build .#my-tool
    # 5. PR aç ve review bekle
    # Tebrikler — artık Nix maintainer'ısın! 🎉
  '';

  # ══════════════════════════════════════════════════════════════════════
  # 📝 PRATİK ÖDEV (Hafta 5 Final)
  # ══════════════════════════════════════════════════════════════════════
  # 1. Kendi NixOS modülünü yaz: basit bir systemd timer
  # 2. nixos.wiki/wiki/NixOS:Extend ve nixos.wiki/wiki/NixOS_Testing oku
  # 3. age-keygen ile bir anahtar oluştur, agenix'i dene
  odev = "Artık NixOS'u genişletebilirsin!";
}
