---
description: Lepas rilis Mailboxh untuk versi yang diberikan. Menjalankan verifikasi penuh dari frontend dan backend, bump versi di frontend/pubspec.yaml, memastikan CHANGELOG dan docs konsisten, lalu membuat tag git.
agent: build
---

Lepas rilis versi: $ARGUMENTS

Ikuti skill `verify-task` di `.opencode/skills/verify-task/`.

## Langkah

1. Pastikan versi yang diminta sesuai format semver MAJOR.MINOR.PATCH dan
   sesuai aturan versi di `PROTOCOL.md` Bagian K.
2. Jalankan `cd frontend && flutter analyze`. Harus 0 error.
3. Jalankan `cd frontend && flutter test`. Harus semua pass.
4. Jalankan `cd backend && php artisan test`. Harus semua pass. Kalau
   folder `backend/` belum ada, hentikan dan tanya user.
5. Periksa `CHANGELOG.md`. Rilis harus punya entri versi yang
   dibedakan dari task biasa, memuat ringkasan perubahan versi tersebut.
6. Periksa dokumen di `docs/`. Semua perubahan pada periode rilis ini
   harus sudah terdokumentasi.
7. Ubah `version` di `frontend/pubspec.yaml` ke versi yang diminta dengan format
   `MAJOR.MINOR.PATCH+BUILD`.
8. Tampilkan `git status`, `git diff`, dan `git log --oneline -10`.
   Pastikan tidak ada file sensitif, `.env`, atau `auth.json` yang akan
   ikut ter-commit.
9. Minta konfirmasi user sebelum membuat commit dan tag. Jangan commit
   tanpa perintah eksplisit.
10. Setelah disetujui, commit dengan format `PROTOCOL.md` Bagian I dan
    buat tag `v<version>`.

## Laporkan

- Hasil tiap perintah verifikasi.
- Perubahan versi di `frontend/pubspec.yaml`.
- Commit dan tag yang dibuat, atau alasannya belum dibuat.
- Gap yang tersisa sebelum rilis dianggap selesai.
