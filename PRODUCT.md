# Product

<!-- impeccable:product-schema 1 -->

## Platform

adaptive

## Stack

Flutter (Cross-platform Android & iOS)

## Users

- **Dai, Khatib, dan Asatidz:** Penceramah dan pengajar yang membutuhkan persiapan materi khutbah, manajemen jadwal mimbar, latihan vokal, dan teleprompter digital saat tampil berdakwah.
- **Seluruh Umat Muslim:** Masyarakat Muslim luas yang menjalankan ibadah sehari-hari (Al-Qur'an, waktu sholat & hitung mundur, arah kiblat, tasbih digital, zakat, puasa, dan panduan masjid).

## Product Purpose

MimbarApp hadir sebagai platform komprehensif bagi seluruh umat Muslim dalam beribadah sehari-hari, sekaligus menjadi asisten modern bagi para pendakwah dalam menyusun naskah dan menyampaikan khutbah dengan percaya diri melalui teleprompter digital.

## Positioning

Aplikasi ibadah all-in-one inklusif untuk seluruh umat Muslim yang secara unik memadukan fitur pendukung ibadah personal dengan perangkat kerja profesional dakwah (Smart Teleprompter, Voice Matcher, dan Bank Naskah Khutbah).

## Operating Context

- **Di atas Mimbar / Podium:** Penggunaan saat berdiri berkhutbah (mode teleprompter hands-free, kontras tinggi, teks besar, bebas distraksi).
- **Di Rumah / Perjalanan:** Membaca Al-Qur'an, memeriksa jadwal sholat, mencari arah kiblat, dan menghitung zakat harian.
- **Ruang Persiapan Khutbah:** Penyusunan draf khutbah, latihan vokal (*practice speech*), dan penjadwalan agenda dakwah.

## Capabilities and Constraints

- **Asisten Khutbah:** Tulis naskah, teleprompter cerdas dengan deteksi suara (`speech_to_text`), latihan vokal, dan perpustakaan naskah khutbah.
- **Ibadah Harian:** Jadwal sholat akurat, kompas kiblat (`flutter_qiblah`), tilawah Al-Qur'an & target hafalan, tasbih digital, kalkulator zakat, dan kalender puasa.
- **Teknis:** Bekerja optimal di Android dan iOS dengan layout responsif adaptif, wakelock (`wakelock_plus`) agar layar tidak mati saat khutbah, serta performa offline yang tangguh.

## Brand Commitments

- **Identitas Visual:** Nuansa *Islamic Elegance* — Forest Green (`#003527`, `#064E3B`), aksen Warm Gold / Amber, latar belakang bersih bertingkat, dan ornamen masjid subtil.
- **Tipografi:** Harmoni antara tipografi teks modern sans-serif latin dan kaligrafi Arab yang nyaman dibaca (*Uthmani/Amiri*).
- **Tone of Voice:** Menenangkan, khidmat, memuliakan ibadah, profesional, dan bersahabat bagi seluruh kalangan umat.

## Evidence on Hand

- Implementasi layar beranda di `lib/features/dashboard/screens/unified_home_screen.dart`
- Layar fitur ibadah: Al-Qur'an, Kiblat, Tasbih, Zakat, Jadwal Sholat
- Layar fitur khutbah: Teleprompter, Naskah, Voice Teleprompter Controller di `lib/features/khutbah/`

## Product Principles

1. **Khidmat & Bebas Distraksi:** Tampilan mengutamakan ketenangan dan kenyamanan mata saat beribadah maupun saat berdiri di mimbar.
2. **Inklusif untuk Seluruh Umat:** Navigasi intuitif yang ramah digunakan oleh pemula hingga asatidz senior.
3. **Keandalan Tinggi Saat Beraksi:** Fitur teleprompter dan pembacaan Al-Qur'an harus responsif, minim jeda, dan tidak mengganggu jalannya ibadah.
4. **Elegan & Proporsional:** Menggunakan estetika visual Islami kontemporer tanpa elemen ornamen berlebihan.
