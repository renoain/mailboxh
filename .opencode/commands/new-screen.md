---
description: Buat halaman baru di Mailboxh dari nama halaman yang diberikan, lengkap dengan token, widget global, route, string ID dan EN, state wajib, test, dan CHANGELOG.
agent: build
---

Buat halaman baru bernama: $ARGUMENTS

Ikuti skill `create-screen` di `.opencode/skills/create-screen/`.

Langkah wajib:

1. Baca `docs/UI_PAGES.md`, `docs/DESIGN_SYSTEM.md`, dan
   `.opencode/rules/03-design.md`.
2. Pastikan halaman ini terdaftar di `docs/UI_PAGES.md`. Kalau belum,
   tambahkan di task yang sama.
3. Pakai komponen dari `frontend/lib/core/widgets/` sebelum membuat widget baru.
   Kalau memang butuh widget baru, buat dan daftarkan lewat skill
   `create-component`.
4. Semua nilai visual dari token. Semua teks dari `AppStrings` untuk
   Bahasa Indonesia dan Inggris.
5. Sertakan state loading, data, kosong, dan error secara eksplisit.
6. Tambahkan route di `frontend/lib/core/router/app_router.dart` sesuai kelompok
   publik atau privat.
7. Tulis widget test minimal untuk render, state kosong, dan state error.
8. Jalankan `cd frontend && flutter analyze` dan `cd frontend && flutter test`.
9. Update `docs/UI_PAGES.md` bila halaman atau navigasi berubah, dan
   `docs/ARCHITECTURE.md` bila route berubah.
10. Tambahkan entri `CHANGELOG.md` memakai skill `update-changelog`.
11. Ambil screenshot sebagai bukti dan laporkan ke user.

Tunggu konfirmasi sebelum task berikutnya.
