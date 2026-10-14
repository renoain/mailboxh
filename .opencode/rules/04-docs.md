# 04-docs

Aturan dokumentasi dan CHANGELOG.

## CHANGELOG

Setiap task selesai wajib menambahkan entri baru di paling atas
`CHANGELOG.md` dengan format `PROTOCOL.md` Bagian D:

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

- Entri lama tidak boleh diubah, dipindah, atau dihapus.
- Entri baru tidak boleh menggabungkan dua task berbeda.
- Status `Dibatalkan` tetap wajib menyertakan File yang diubah dan
  Verifikasi.

## Docs yang Harus Diperbarui

Task yang mengubah isi di bawah wajib update dokumen terkait pada task
yang sama, bukan ditunda.

| Perubahan | Dokumen |
|---|---|
| Fitur atau scope produk | `docs/PROJECT_OVERVIEW.md` |
| Kebutuhan fungsional | `docs/SRS.md` |
| Tabel, kolom, relasi, indeks | `docs/DATABASE_SCHEMA.md` |
| Endpoint, payload, respons, rate limit | `docs/API.md` |
| Halaman, navigasi, komponen reusable | `docs/UI_PAGES.md` |
| Layer, folder, route, dependency | `docs/ARCHITECTURE.md` |
| Token visual | `docs/DESIGN_SYSTEM.md` |

## Konsistensi

- Nama tabel, kolom, endpoint, route, dan FR harus sama persis di semua
  dokumen.
- Migration yang sudah dijalankan tidak boleh diedit. Perubahan struktur
  selalu lewat migration baru.
- Angka ajaib di dokumentasi, misalnya batas cache, tidak boleh ditulis
  tanpa sumber. Tentukan nilai tersebut di service, lalu dokumentasikan
  di dokumen yang relevan.
- Istilah domain mengikuti `docs/PROJECT_OVERVIEW.md` bagian Istilah
  Domain.

## Penulisan

- Bahasa Indonesia.
- Tanpa emoji.
- Markdown rapi, heading berurutan, tabel dengan baris pisah.
- Komentar dan catatan hanya bagian penting saja. Jangan mengulang
  isi dokumen lain.
- Path file ditulis relatif dari root repo dengan garis miring maju.
- Istilah teknis, nama class, nama endpoint, dan nama tabel tidak
  diterjemahkan.

## Aturan Proyek

- Nama project adalah Mailboxh. Jangan menulis Cineboxd di dokumen.
- Nama database adalah `mailboxh`.
- Base URL backend lokal ada di `docs/PROJECT_OVERVIEW.md` bagian
  Lingkungan Pengembangan.
