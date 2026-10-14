# PROTOCOL.md - Mailboxh

Protokol kerja project. Wajib dibaca sebelum bekerja di project ini.

## Bagian A: Prinsip Umum

- Protokol ini mengikat. Aturan yang bertentangan dengan file ini
  dimenangkan oleh protokol.
- Bahasa komunikasi: Bahasa Indonesia.
- Bahasa kode: Bahasa Inggris.
- String UI: dwibahasa ID/EN via AppStrings.
- Tidak ada emoji di kode, komentar, dokumentasi, commit.
- Tidak ada secret di kode. Semua lewat .env.
- Tanya sebelum berasumsi pada keputusan penting.

## Bagian B: Struktur Dokumen

Di root:
- README.md
- CHANGELOG.md
- AGENTS.md
- PROTOCOL.md

Di docs/:
- PROJECT_OVERVIEW.md
- SRS.md
- ARCHITECTURE.md
- DATABASE_SCHEMA.md
- API.md
- UI_PAGES.md
- DESIGN_SYSTEM.md

Di .opencode/rules/:
- 01-core.md
- 02-coding.md
- 03-design.md
- 04-docs.md
- 05-security.md
- 06-testing.md

## Bagian C: Kriteria Dependency Baru

1. Tujuan jelas.
2. Minimal 1 alternatif dievaluasi.
3. Pemeliharaan aktif (rilis di bawah 12 bulan).
4. Lisensi aman (MIT, Apache, BSD).
5. Kompatibel dengan versi Flutter/Dart/Laravel.
6. Ukuran tidak membebani.
7. Dokumentasi cukup.

## Bagian D: Format CHANGELOG

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

Entri baru di paling atas. Dilarang mengubah entri lama.

## Bagian E: Checklist Anti-AI-Slop (UI)

- Maksimal 3 warna dominan per halaman.
- Tidak ada gradient mencolok.
- Tidak ada shadow blur besar.
- Border radius pakai token.
- Tipografi pakai token.
- Spacing kelipatan 4.
- Setiap elemen punya hierarki visual.
- Empty state, loading, error state selalu ada.

## Bagian F: Alur Desain ke Kode

1. Desain di Stitch.
2. Pastikan token ada di DESIGN_SYSTEM.md.
3. Implementasi widget pakai token.
4. Komponen reusable masuk COMPONENT_LIBRARY (bagian UI_PAGES.md).
5. Validasi UI terhadap checklist anti-AI-slop.
6. Screenshot sebagai bukti.

## Bagian G: Manajemen Aset

- Icon standar pakai flutter_lucide.
- Ikon custom dalam SVG.
- Nama file snake_case.
- Path aset lewat AppAssets, dilarang hardcode di widget.
- Poster dan backdrop diupload admin ke backend, lalu dimuat lewat URL dari APP_URL.

## Bagian H: Security dan Validasi

- Auth pakai Laravel Sanctum.
- Token sesi di secure storage.
- APP_KEY dan password database hanya di backend.
- Validasi input di backend (FormRequest).
- Rate limit endpoint sensitif.
- Tidak log data sensitif.

## Bagian I: Format Commit

`<type>(<scope>): <subject>`

Type: feat, fix, docs, refactor, chore, test, style.
Scope: auth, catalog, detail, watchlist, watched, review, profile,
diary, core, infra, docs.

Subject maks 72 karakter, imperatif, Bahasa Inggris, tanpa emoji.

## Bagian J: Error Handling dan Logging

- Tangkap error di data/domain.
- Tampilkan pesan ramah via AppStrings.
- Log pakai logger, dilarang print().
- Dilarang log data sensitif.

## Bagian K: Versioning

- Semver: MAJOR.MINOR.PATCH.
- Rilis MVP: v0.1.0.
- Setiap rilis lolos flutter analyze, flutter test, php artisan test.
  Perintah Flutter dijalankan dari `frontend/`, perintah Artisan dari
  `backend/`.

## Bagian L: Checklist Verifikasi

- `cd frontend && flutter analyze`: 0 error.
- `cd frontend && flutter test`: semua pass.
- `cd backend && php artisan test`: semua pass.
- CHANGELOG.md updated.
- Docs terkait diperbarui.
- String UI dwibahasa.
- Tidak ada emoji.
- Tidak ada hardcode.
- Tidak ada secret.

## Bagian M: Anti-AI-Slop untuk Kode

- Setiap file .dart dan .php punya header komentar 1 baris.
- Setiap class punya doc comment 1 baris.
- Komentar hanya kalau perlu. Jangan mengulang kode. Jangan menjelaskan
  yang sudah jelas.
- Dilarang komentar bertele-tele.
- Dilarang pemisah dekoratif di komentar.
- Dilarang kode hasil generate yang tidak dipahami.
- Dilarang duplikasi kode.
- Dilarang hardcode nilai ajaib.
- Layer harus benar.

## Bagian N: Handoff

Setelah task, laporkan:
- File dibuat/ubah.
- Hasil pub get / composer install.
- Hasil analyze.
- Hasil test.
- Error tersisa.
- Rekomendasi task selanjutnya.

Tunggu konfirmasi sebelum lanjut.

## Bagian O: Aturan Dependency Baru

- Lolos Bagian C.
- Dicatat di CHANGELOG.
- Dicatat di docs/ARCHITECTURE.md.
- Jika diganti, update ketiga dokumen.