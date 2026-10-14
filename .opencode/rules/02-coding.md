# 02-coding

Konvensi kode frontend dan backend.

## Layer

1. Presentation: widget, halaman, provider Riverpod.
2. Domain: entity, repository interface, usecase.
3. Data: model, datasource, repository implementation.

Aturan dependensi:

- Presentation bergantung ke Domain.
- Data bergantung ke Domain.
- Domain tidak bergantung ke layer mana pun.
- Presentation tidak boleh bergantung langsung ke Data.

Struktur folder ramping yang dipakai:

- Tidak ada folder `usecases/`. Perilaku yang perlu diabstrakkan
  lewat repository interface dan method di dalamnya.
- Tidak ada pemisahan `models/` dan `entities/`. Model di data
  sekaligus dipakai presentation sebagai entity.
- Tidak ada folder `datasources/`. Repository di data memanggil
  `api_client.dart` langsung.
- Tidak ada `presentation/pages/` dan `presentation/providers/`. File
  halaman dan provider duduk di `presentation/`.
- Widget khusus fitur yang dipakai lebih dari satu halaman pindah ke
  `frontend/lib/core/widgets/`.

Wajib ada walau strukturnya ramping:

- Setiap repository di `data/` punya interface di `domain/`. Nama class
  berbeda, misalnya `WatchlistRepository` dan `WatchlistRepositoryImpl`.
- Folder `domain/` tidak boleh dihapus hanya karena fitur kecil.

## Larangan

- Logika bisnis di widget dilarang.
- Akses data langsung dari widget dilarang.
- Import lintas layer yang melanggar aturan dependensi dilarang.
- Angka ajaib tanpa nama konstanta dilarang.

## Naming

Semua path ditulis relatif dari root repo dengan prefix `frontend/` atau
`backend/`. Contohnya `frontend/lib/core/theme/app_colors.dart` dan
`backend/app/Http/Controllers/Api/MovieController.php`.

| Objek | Aturan | Contoh |
|---|---|---|
| File dan folder | snake_case | `movie_card.dart`, `app_router.dart` |
| Class | PascalCase | `MovieCard`, `WatchlistRepository` |
| Method dan variabel | camelCase | `buildContext`, `fetchTrending` |
| Provider | camelCase diakhiri Provider | `watchlistProvider` |
| Notifier State | camelCase diakhiri State | `WatchlistState` |
| Kolom database | snake_case | `watched_at` |
| Konstanta | screaming snake case | `maxListItems` |
| Model JSON key | snake_case | `movie_id` |

`List` adalah keyword reserved di PHP, sehingga model Eloquent untuk
tabel `lists` bernama `ListModel` dan di-query lewat `$user->lists()`.

## Urutan Import Dart

1. `dart:` SDK.
2. Paket pihak ketiga.
3. Paket dan folder project.

Pemisah baris kosong satu baris di antara setiap kelompok. Import
sekelompok diurutkan secara alfabetis.

## Urutan Import PHP

1. `declare(strict_types=1);`
2. Namespace.
3. Use statement, diurutkan secara alfabetis.
4. Class.

Gunakan `declare(strict_types=1)` di setiap file PHP.

## Backend

- PSR-12 adalah standar formatting.
- Validasi input memakai FormRequest, bukan pengecekan manual di
  controller.
- Output JSON memakai Resource agar bentuk konsisten.
- Controller tidak memanggil layanan film eksternal. Semua lewat
  repository dan service di dalam aplikasi.
- Controller tidak menulis ke tabel `activities` secara langsung. Semua
  lewat `ActivityLogger`.
- Query film milik user tidak dimuat di controller. Semua lewat
  repository.
- Penulisan yang harus atomik memakai satu database transaction.
- Nama route memakai snake_case dan plural, misalnya `lists`,
  `list_items`.

## Dependency

Setiap dependency baru wajib dievaluasi dari tujuan, alternatif,
pemeliharaan, lisensi, kompatibilitas, ukuran, dan dokumentasi, lalu
dicatat di `CHANGELOG.md` dan `docs/ARCHITECTURE.md`.

- Rilis di atas 12 bulan tidak boleh dipakai.
- Lisensi di luar MIT, Apache, dan BSD tidak boleh dipakai.
