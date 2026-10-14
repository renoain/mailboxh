---
name: verify-task
description: Use before reporting any completed task in Mailboxh to the user. Runs flutter analyze, flutter test, and php artisan test, then checks the change against the project rules: no hardcoded colors, spacing, or radius, no business logic in widgets, no secrets, no emoji, no const UI strings, CHANGELOG updated, and related docs updated.
---

# Verify Task

Checklist verifikasi sebelum lapor ke user. Ikuti `PROTOCOL.md` Bagian L
dan `AGENTS.md` bagian 8.

## Langkah 1: Perintah

Jalankan berurutan. Jangan lanjut ke langkah berikutnya kalau satu gagal.

```
cd frontend && flutter analyze
cd frontend && flutter test
cd backend && php artisan test
```

Catat hasil tiap perintah: OK, warning, atau error. Bila folder
`backend/` belum ada, tulis `belum ditest (backend belum ada)` dan
laporkan itu sebagai gap yang tersisa.

## Langkah 2: Aturan Kode

Periksa file yang berubah pada task ini saja.

- Tidak ada `Color(0xFF` di widget.
- Tidak ada angka mentah pada `EdgeInsets`, `padding`, `margin`, atau
  `BorderRadius.circular`.
- Tidak ada angka mentah pada `fontSize`, `height`, atau `letterSpacing`.
- Tidak ada `Colors.blue` atau warna Material langsung di widget.
- Tidak ada `print`, `debugPrint`, atau `dd`.
- Tidak ada emoji di kode, komentar, dan dokumentasi.
- Tidak ada pemisah dekoratif di komentar.
- Tidak ada `const` string berisi teks yang tampil ke user di widget.
- Tidak ada token, password, atau API key di kode.
- Tidak ada logika bisnis di widget.
- Widget tidak memanggil repository atau Dio secara langsung.
- Setiap file punya header komentar satu baris, setiap class punya doc
  comment satu baris.
- Tidak ada kode duplikat.
- Tidak ada dependency baru tanpa evaluasi di `docs/ARCHITECTURE.md`.

## Langkah 3: Backend

- Validasi memakai FormRequest.
- Endpoint privat memakai middleware `auth:sanctum`.
- Endpoint publik tidak membocorkan data user.
- Otorisasi kepemilikan resource dicek sebelum ubah atau hapus.
- Penulisan ke `activities` lewat `ActivityLogger`.
- Tabel `users` tidak punya kolom bio, avatar, atau username.
- Film memakai soft delete lewat `deleted_at`, tidak ada `delete` keras.
- `.env` tidak masuk version control dan `.env.example` ada.

## Langkah 4: Dokumentasi

- Entri `CHANGELOG.md` baru ada di paling atas dengan format Bagian D.
- Entri lama tidak berubah.
- Docs yang relevan sudah diperbarui pada task yang sama:

  | Perubahan | Dokumen |
  |---|---|
  | Fitur atau scope | `docs/PROJECT_OVERVIEW.md` |
  | Kebutuhan fungsional | `docs/SRS.md` |
  | Tabel atau kolom | `docs/DATABASE_SCHEMA.md` |
  | Endpoint atau payload | `docs/API.md` |
  | Halaman atau navigasi | `docs/UI_PAGES.md` |
  | Layer, folder, route, dependency | `docs/ARCHITECTURE.md` |
  | Token visual | `docs/DESIGN_SYSTEM.md` |

- Nama tabel, kolom, endpoint, route, dan FR konsisten di semua dokumen.

## Langkah 5: Screenshot

Task UI wajib menyertakan screenshot sebagai bukti. Tanpa screenshot,
task UI belum selesai.

## Laporkan ke User

Setelah checklist selesai, lapor sesuai `PROTOCOL.md` Bagian N:

- File dibuat atau diubah.
- Hasil analyze.
- Hasil test.
- Error atau gap yang tersisa.
- Rekomendasi task selanjutnya.

Tunggu konfirmasi sebelum lanjut ke task berikutnya.
