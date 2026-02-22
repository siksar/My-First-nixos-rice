# 🧊 Nix & Rust Eğitim Sistemi

> **Süre**: 30 gün | **Günlük**: ~30 dakika | **Seviye**: Sıfırdan İleri

Her dosya kendi başına çalışan bir Nix ifadesidir. `nix eval` veya `nix repl` ile deneyin.

## 🗓️ Yol Haritası

| Hafta | Konu | Dosyalar |
|-------|------|----------|
| **1** | Nix Dili Temelleri | `week-1-nix-basics/01..05` |
| **2** | NixOS Patterns | `week-2-nixos-patterns/06..10` |
| **3** | Rust Temelleri (Nix ile) | `week-3-rust-fundamentals/11..15` |
| **4** | Nix + Rust Entegrasyonu | `week-4-nix-rust-integration/16..20` |
| **5** | İleri NixOS | `week-5-advanced-nixos/21..25` |
| **6** | Capstone Proje | `week-6-capstone/26..30` |

## 🚀 Nasıl Kullanılır

```bash
# Bir dersi evaluate et
nix eval -f ~/dotfiles/nix-tutorial/week-1-nix-basics/01-values-and-types.nix

# Etkileşimli çalış
nix repl
:l ~/dotfiles/nix-tutorial/week-1-nix-basics/01-values-and-types.nix

# Tüm dosyaları kontrol
for f in ~/dotfiles/nix-tutorial/**/*.nix; do
  nix-instantiate --parse "$f" > /dev/null 2>&1 && echo "✓ $f" || echo "✗ $f"
done
```

## 📌 Kurallar

1. **Her gün sadece 1 dosya** — Kavramları sindirin
2. **`nix repl` kullanın** — Kodu mutlaka deneyin
3. **Ödevleri yapın** — Her dosyanın sonundaki pratik kısmını tamamlayın
4. **Dotfiles referans** — Gerçek örnekler `~/dotfiles/` içinde
