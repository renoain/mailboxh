---
description: Buat fitur baru di Mailboxh dari nama fitur yang diberikan, lengkap dengan domain, data, presentation, route, test, docs, dan CHANGELOG.
agent: build
---

Buat fitur baru bernama: $ARGUMENTS

Ikuti skill `create-feature` di `.opencode/skills/create-feature/`.

Langkah wajib:

1. Pastikan FR untuk fitur ini sudah ada di `docs/SRS.md`. Kalau belum,
   tanyakan ke user sebelum melanjutkan.
2. Baca `docs/ARCHITECTURE.md`, `docs/SRS.md`, `docs/API.md`, dan
   `.opencode/rules/02-coding.md`.
3. Kerjakan berurutan dari domain, lalu data, lalu presentation, lalu
   route, lalu string, lalu test.
4. Kalau fitur butuh endpoint baru, kerjakan sisi backend juga:
   migration, model, FormRequest, Resource, controller, route, dan
   feature test.
5. Jalankan `cd frontend && flutter analyze`, `cd frontend && flutter test`, dan `cd backend && php artisan test`.
6. Update dokumen terkait sesuai `.opencode/rules/04-docs.md`.
7. Tambahkan entri `CHANGELOG.md` di paling atas memakai skill
   `update-changelog`.
8. Jalankan skill `verify-task` sebelum lapor.

Lapor ke user berisi file yang dibuat, hasil verifikasi, dan gap yang
tersisa. Tunggu konfirmasi sebelum task berikutnya.
