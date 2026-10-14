# 01-core

Aturan inti yang berlaku di seluruh project Mailboxh.

## Bahasa

- Komunikasi dengan user memakai Bahasa Indonesia.
- Nama variabel, class, method, file, dan folder memakai Bahasa Inggris.
- String UI dwibahasa Indonesia dan Inggris lewat `AppStrings` di
  `frontend/lib/core/l10n/app_strings.dart`. Widget dilarang punya `const` string
  berisi teks yang tampil ke user.
- Pesan error dari backend ditulis dalam Bahasa Indonesia dan aman
  ditampilkan. Detail teknis tidak boleh masuk ke `message`.

## Larangan

- Tidak ada emoji di kode, komentar, dokumentasi, dan pesan commit.
- Tidak ada pemisah dekoratif di komentar. Garis horizontal, blok asteris,
  dan emoji pada komentar dilarang.
- Tidak ada secret di kode. Semua nilai sensitif lewat `.env`.
- Tidak ada `print` di produksi. Gunakan logger.
- Tidak ada kode hasil generate yang tidak dipahami.

## Komentar

- Komentar hanya untuk hal penting. Jangan mengulang kode.
- Jangan menjelaskan hal yang sudah jelas dari nama variabel atau
  fungsi.
- Setiap file `.dart` dan `.php` punya header komentar satu baris yang
  menjelaskan tanggung jawab file.
- Setiap class punya doc comment satu baris.
- Komentar bertele-tele dan kode duplikat dilarang.

## Keputusan

- Tanya user sebelum mengambil keputusan penting atau saat ada konflik
  antar dokumen. Jangan berasumsi.
- Konflik antar dokumen diselesaikan dengan bertanya, bukan dengan
  menebak mana dokumen yang benar.

## Sumber Acuan

- `AGENTS.md` untuk konteks produk dan aturan cepat.
- `PROTOCOL.md` untuk protokol kerja.
- `docs/ARCHITECTURE.md` untuk layer dan struktur folder.
- `docs/DESIGN_SYSTEM.md` untuk token visual.

## Git

Format commit mengikuti `PROTOCOL.md` Bagian I:

```
<type>(<scope>): <subject>
```

Type: `feat`, `fix`, `docs`, `refactor`, `chore`, `test`, `style`.

Scope: `auth`, `catalog`, `detail`, `watchlist`, `watched`, `review`,
`profile`, `diary`, `lists`, `tags`, `favorites`, `like`, `follow`,
`feed`, `log`, `members`, `core`, `infra`, `docs`.

Subject maksimal 72 karakter, bentuk imperatif, Bahasa Inggris, tanpa
emoji.

Commit hanya dilakukan atas permintaan eksplisit user.
