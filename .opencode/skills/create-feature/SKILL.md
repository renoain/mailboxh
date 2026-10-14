---
name: create-feature
description: Use when adding a new feature to Mailboxh that spans data, domain, and presentation layers, such as lists, tags, favorites, likes, follow, or feed. Walks through entity, repository interface, usecase, model, datasource, repository implementation, provider, page, route, and test in the correct layer order.
---

# Create Feature

Membuat fitur baru di Mailboxh. Ikuti urutan ini, jangan melompat ke
presentation sebelum domain selesai.

## Prasyarat

Baca lebih dulu:

- `AGENTS.md` bagian 6 dan 7.
- `docs/ARCHITECTURE.md` bagian 2 dan 3.
- `docs/SRS.md` untuk FR fitur yang dikerjakan.
- `.opencode/rules/02-coding.md`.

Pastikan FR untuk fitur ini sudah ada di `docs/SRS.md`. Kalau belum,
tanyakan ke user lebih dulu.

## Urutan Layer

### 1. Domain

Buat folder `frontend/lib/features/<fitur>/domain/`.

Entity di `entities/`. Entity adalah data murni tanpa JSON, tanpa
Dio, tanpa Flutter.

Repository interface di `repositories/`. Interface hanya berisi
nama method dan tipe, tanpa implementasi.

Usecase di `usecases/`. Satu usecase satu aksi. Logika bisnis hanya
ada di sini.

Usecase yang wajib ada per fitur:

- Ambil daftar.
- Ambil detail.
- Tambah atau ubah.
- Hapus, bila fitur punya hapus.
- Toggle atau aksi khusus, bila ada.

### 2. Data

Buat folder `frontend/lib/features/<fitur>/data/`.

Model di `models/`. Model adalah representasi JSON dengan
`fromJson` dan `toJson` atau `fromEntity`. Model boleh punya
`toEntity()` untuk mengubah ke entity.

Datasource di `datasources/`. Satu file per endpoint group.
Datasource memakai Dio client yang sudah ada, bukan instance Dio
baru.

Repository implementation di `repositories/`. File implementing
repository interface dari domain. Di sinilah pemetaan model ke
entity dan pemanggilan datasource.

Data layer tidak boleh meng-import Domain atau presentation.

### 3. Presentation

Buat folder `frontend/lib/features/<fitur>/presentation/`.

Provider di `providers/`. Satu provider per sumber data. Gunakan
`AsyncNotifier` untuk yang butuh fetch dan `AsyncNotifier` atau
`Notifier` untuk state UI sederhana.

State class di file terpisah bila state punya lebih dari dua field.

Halaman di `pages/`. Satu file per halaman. Halaman hanya memanggil
provider, tidak memanggil repository.

Widget khusus fitur di `widgets/`. Widget yang dipakai lintas fitur
pindah ke `frontend/lib/core/widgets/`.

### 4. Route

Tambahkan route di `frontend/lib/core/router/app_router.dart`. Letakkan di
kelompok privat kecuali fitur memang untuk tamu.

Parameter route named, bukan positional, untuk path yang punya
beberapa segmen.

### 5. String

Tambahkan seluruh string baru ke `AppStrings` untuk Bahasa Indonesia
dan Inggris sekaligus. Jangan menambahkan hanya satu bahasa.

### 6. Test

Buat test di `frontend/test/features/<fitur>/`.

- Usecase di domain diuji dengan repository palsu.
- Model diuji untuk pemetaan JSON.
- Provider diuji dengan repository yang di-override.
- Halaman diuji dengan render minimal dan interaksi utama.

## Backend

Kalau fitur butuh endpoint baru, buat di `backend/` dengan urutan:

1. Migration.
2. Model Eloquent beserta relasi.
3. Factory dan seeder bila perlu.
4. FormRequest.
5. Resource.
6. Controller.
7. Route di `backend/routes/api.php`.
8. Feature test.
9. Dokumentasi di `docs/API.md` dan `docs/DATABASE_SCHEMA.md`.

Penulisan ke `activities` lewat `ActivityLogger`, bukan insert langsung.

## Setelah Selesai

- Jalankan `flutter analyze`, `flutter test`, `php artisan test`.
- Update `docs/SRS.md` bila ada FR yang berubah.
- Update `docs/ARCHITECTURE.md` bila ada folder, route, atau dependency
  baru.
- Tambahkan entri `CHANGELOG.md` memakai skill `update-changelog`.
- Jalankan skill `verify-task` sebelum lapor ke user.
