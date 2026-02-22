# ============================================================================
# GÜN 12-15: RUST DERİN DALİŞ (Ownership → Traits)
# ============================================================================
# Bu dosya 4 günlük Rust konularını tek yerde toplar.
# Her bölüm ~30dk'lık çalışma içerir.
#
# cargo new rust-practice && cd rust-practice ile proje oluştur
# Her bölümü src/main.rs'e yapıştır ve cargo run ile test et
# ============================================================================

{
  # ═══════════════════════════════════════════════════════════════════════
  # GÜN 12: OWNERSHIP VE BORROWING
  # ═══════════════════════════════════════════════════════════════════════
  gun12_ownership = ''
    // Rust'ın en önemli konsepti: bellek güvenliği DERLEME ZAMANINDA

    fn main() {
        // OWNERSHIP: Her değerin tek bir sahibi var
        let s1 = String::from("hello");
        let s2 = s1;    // s1'in sahipliği s2'ye GEÇTİ (move)
        // println!("{}", s1);  // HATA! s1 artık geçersiz

        // CLONE: Derin kopya
        let s3 = String::from("world");
        let s4 = s3.clone();  // Bağımsız kopya
        println!("{} {}", s3, s4);  // İkisi de geçerli

        // BORROWING: Referans ile ödünç al
        let s5 = String::from("merhaba");
        let len = string_length(&s5);  // &s5 = ödünç ver
        println!("{} uzunluğu: {}", s5, len);  // s5 hâlâ geçerli!

        // MUTABLE BORROW: Değiştirilebilir referans
        let mut s6 = String::from("hello");
        add_world(&mut s6);
        println!("{}", s6);  // "hello world"

        // KURAL: Aynı anda ya 1 mutable YA DA N immutable referans
        // İkisi birden YASAK (data race prevention)
    }

    fn string_length(s: &String) -> usize { s.len() }
    fn add_world(s: &mut String) { s.push_str(" world"); }

    // Nix karşılaştırma:
    // Nix'te her şey immutable → ownership sorun değil
    // Rust'ta mutability var → ownership gerekli
  '';

  # ═══════════════════════════════════════════════════════════════════════
  # GÜN 13: STRUCTS VE ENUMS
  # ═══════════════════════════════════════════════════════════════════════
  gun13_structs_enums = ''
    // STRUCT: Özel veri tipi (Nix'teki attribute set gibi)
    #[derive(Debug)]
    struct Config {
        hostname: String,
        port: u16,
        ssl: bool,
    }

    impl Config {
        // Constructor (associated function)
        fn new(hostname: &str, port: u16) -> Self {
            Config {
                hostname: hostname.to_string(),
                port,
                ssl: port == 443,
            }
        }

        // Method
        fn url(&self) -> String {
            let proto = if self.ssl { "https" } else { "http" };
            format!("{}://{}:{}", proto, self.hostname, self.port)
        }
    }

    // ENUM: Olası değerler kümesi (çok güçlü!)
    #[derive(Debug)]
    enum PowerProfile {
        Gaming { gpu_clock: u32, wattage: u32 },
        Balanced,
        Saver { max_brightness: u8 },
    }

    impl PowerProfile {
        fn describe(&self) -> &str {
            match self {
                PowerProfile::Gaming { .. } => "🎮 Gaming Mode",
                PowerProfile::Balanced => "⚡ Balanced",
                PowerProfile::Saver { .. } => "🔋 Battery Saver",
            }
        }
    }

    fn main() {
        let cfg = Config::new("localhost", 8080);
        println!("{}: {}", cfg.hostname, cfg.url());

        let profile = PowerProfile::Gaming {
            gpu_clock: 2400,
            wattage: 100,
        };
        println!("Profile: {}", profile.describe());

        // Pattern matching (Nix'teki if-then-else'in güçlü versiyonu)
        match profile {
            PowerProfile::Gaming { gpu_clock, wattage } =>
                println!("GPU: {}MHz, Power: {}W", gpu_clock, wattage),
            PowerProfile::Balanced =>
                println!("Balanced mode"),
            PowerProfile::Saver { max_brightness } =>
                println!("Saver: max bright {}%", max_brightness),
        }
    }

    // Nix karşılaştırma:
    // Nix:  config = { hostname = "localhost"; port = 8080; };
    // Rust: Config::new("localhost", 8080)
    // Fark: Rust'ta tip güvenliği var!
  '';

  # ═══════════════════════════════════════════════════════════════════════
  # GÜN 14: HATA YÖNETİMİ (Result & Option)
  # ═══════════════════════════════════════════════════════════════════════
  gun14_error_handling = ''
    use std::fs;
    use std::num::ParseIntError;

    // OPTION: Değer var mı yok mu? (null yerine)
    fn find_user(id: u32) -> Option<String> {
        match id {
            1 => Some("zixar".to_string()),
            _ => None,
        }
    }

    // RESULT: Başarılı mı hatalı mı?
    fn parse_port(s: &str) -> Result<u16, ParseIntError> {
        s.parse::<u16>()
    }

    fn main() {
        // Option kullanımı
        match find_user(1) {
            Some(name) => println!("Kullanıcı: {}", name),
            None => println!("Bulunamadı"),
        }

        // if let: Kısa yol
        if let Some(name) = find_user(1) {
            println!("Merhaba {}", name);
        }

        // unwrap_or: Varsayılan değer (Nix'teki `or` gibi!)
        let user = find_user(99).unwrap_or("bilinmiyor".to_string());

        // Result + ? operatörü
        match parse_port("8080") {
            Ok(port) => println!("Port: {}", port),
            Err(e) => println!("Hata: {}", e),
        }

        // ? operatörü ile hata propagation
        // fn read_config() -> Result<String, std::io::Error> {
        //     let content = fs::read_to_string("config.toml")?;
        //     Ok(content)
        // }
    }

    // Nix karşılaştırma:
    // Nix:  data.name or "bilinmiyor"
    // Rust: data.name.unwrap_or("bilinmiyor")
    // Nix:  builtins.tryEval (throw "hata")
    // Rust: parse_port("abc")  → Err(...)
  '';

  # ═══════════════════════════════════════════════════════════════════════
  # GÜN 15: TRAITS VE GENERICS
  # ═══════════════════════════════════════════════════════════════════════
  gun15_traits = ''
    // TRAIT: Paylaşılan davranış tanımı (interface gibi)
    trait Configurable {
        fn to_nix(&self) -> String;
        fn validate(&self) -> bool { true }  // Varsayılan implementasyon
    }

    struct KernelConfig {
        version: String,
        modules: Vec<String>,
    }

    impl Configurable for KernelConfig {
        fn to_nix(&self) -> String {
            format!(
                "boot.kernelPackages = pkgs.linuxPackages_{};",
                self.version.replace('.', "_")
            )
        }

        fn validate(&self) -> bool {
            !self.version.is_empty() && !self.modules.is_empty()
        }
    }

    // GENERIC: Tip parametresi (her tip için çalışır)
    fn first<T>(list: &[T]) -> Option<&T> {
        list.first()
    }

    // Trait bound: "T Configurable implement etmeli"
    fn generate_config<T: Configurable>(item: &T) -> String {
        if item.validate() {
            item.to_nix()
        } else {
            "# Invalid config".to_string()
        }
    }

    fn main() {
        let kernel = KernelConfig {
            version: "6.18".to_string(),
            modules: vec!["kvm-amd".to_string(), "gigabyte-wmi".to_string()],
        };

        println!("{}", generate_config(&kernel));
        // → "boot.kernelPackages = pkgs.linuxPackages_6_18;"

        let nums = vec![10, 20, 30];
        println!("İlk: {:?}", first(&nums));  // Some(10)
    }

    // Nix karşılaştırma:
    // Nix'te trait yok — duck typing (set'e uygun key varsa çalışır)
    // Rust'ta trait = derleme zamanında garanti
  '';

  # ══════════════════════════════════════════════════════════════════════
  # 📝 PRATİK ÖDEV (Hafta 3 Final)
  # ══════════════════════════════════════════════════════════════════════
  # 1. Bir PowerProfile enum yaz: Gaming, Balanced, Saver
  #    her birine wattage field ekle, match ile yazdır
  # 2. Config dosyası okuyan fonksiyon yaz: Result<Config, io::Error>
  # 3. NixConfig trait yaz: to_nix() metodu, KernelConfig için implement et
  # 4. ~/dotfiles/home/wrappers.nix'teki script'leri Rust'a çevir (düşün)
  odev = "Rust temellerini öğrendin — Nix ile birleştirmeye hazırsın!";
}
