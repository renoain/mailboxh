---
name: update-changelog
description: Use when finishing any task in Mailboxh that created, edited, or deleted files. Adds a new entry at the top of CHANGELOG.md following PROTOCOL.md section D with Status, File yang diubah, Catatan, and Verifikasi, without touching older entries.
---

# Update Changelog

Menambahkan entri `CHANGELOG.md` di paling atas.

## Kapan

Setiap task yang menyentuh file. Termasuk task dokumentasi, task
dokumentasi saja, task refactor, dan task yang dibatalkan.

## Format

Format ini berasal dari `PROTOCOL.md` Bagian D:

```
## [YYYY-MM-DD HH:MM] - Nama Task

Status: Selesai / Sedang dikerjakan / Dibatalkan

File yang diubah:
- path/file.ext (dibuat / diedit / dihapus)

Catatan:
- catatan singkat

Verifikasi:
- hasil linter/analyze: OK / warning / error
- hasil test: OK / gagal / belum ditest
```

- Tanggal memakai waktu lokal saat task selesai.
- Nama task bentuk imperatif singkat dalam Bahasa Indonesia.
- Hanya satu status. Jangan menulis dua status sekaligus.

## Aturan Penulisan

- Entri baru ditempatkan di paling atas, tepat setelah baris judul.
- Entri lama tidak boleh diubah, dipindah, dihapus, atau diurutkan ulang.
- Daftar File yang diubah harus lengkap dan akurat. Tandai `dibuat`,
  `diedit`, atau `dihapus` per file.
- Catatan memuat keputusan penting dan penyimpangan dari permintaan
  awal, bukan ringkasan panjang setiap file.
- Verifikasi mencatat hasil yang benar-benar dijalankan, bukan yang
  diperkirakan. Tulis `belum ditest` atau `belum berlaku` bila
  memang tidak dijalankan.
- Tanpa emoji. Tanpa pemisah dekoratif.
- Satu entri untuk satu task. Jangan menggabungkan dua task berbeda
  dalam satu entri.

## Verifikasi

Sebelum menulis entri, jalankan:

```
cd frontend && flutter analyze
cd frontend && flutter test
cd backend && php artisan test
```

Task dokumentasi saja tidak menjalankan ketiga perintah. Tulis `belum
berlaku (hanya dokumen)` pada baris verifikasi.

Setelah menulis, periksa ulang bahwa entri lama di bawahnya tidak
berubah.
