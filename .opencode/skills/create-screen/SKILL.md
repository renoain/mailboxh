---
name: create-screen
description: Use when adding a new page or screen to the Mailboxh Flutter app, such as List Detail, Incoming Activity, Members, Form Log, or Followers. Covers token-only styling, global widget reuse, route registration, bilingual AppStrings entries, required empty/loading/error states, and a minimal render widget test.
---

# Create Screen

Membuat halaman baru di Mailboxh.

## Prasyarat

Baca lebih dulu:

- `docs/UI_PAGES.md` untuk struktur halaman dan aturan layar.
- `docs/DESIGN_SYSTEM.md` untuk token.
- `.opencode/rules/03-design.md`.
- `.opencode/rules/05-security.md` untuk route privat.

Pastikan halaman ini sudah terdaftar di `docs/UI_PAGES.md`. Kalau belum,
tambahkan sekalian di task yang sama.

## Lokasi

`frontend/lib/features/<fitur>/presentation/pages/nama_halaman.dart`.

Nama file snake_case. Nama class PascalCase tanpa suffix `Page` bila
hanya dipakai sebagai Scaffold, atau dengan suffix `Page` bila sudah
menjadi pola di feature tersebut. Ikuti pola yang sudah ada di folder
tersebut, jangan campur dua gaya dalam satu feature.

## Isi Halaman

### App bar

Pakai `CustomAppBar` dari `frontend/lib/core/widgets/`. Jangan buat AppBar
baru per halaman.

### State

Setiap halaman punya empat state yang eksplisit:

- Loading: `LoadingIndicator`.
- Data: isi halaman.
- Kosong: `EmptyState` dengan judul, pesan, dan aksi bila ada.
- Error: `ErrorState` dengan tombol coba lagi.

State loading dan error tidak boleh digabung. Jangan pernah
menampilkan halaman kosong tanpa penjelasan saat request gagal.

### Token

Semua nilai visual dari token:

- `AppSpacing` untuk jarak.
- `AppRadius` untuk sudut.
- `AppTypography` untuk teks.
- `AppColors` atau `Theme.of(context).colorScheme` untuk warna.
- `AppElevation` untuk bayangan.

Dilarang `EdgeInsets` dengan angka mentah, `BorderRadius.circular`
dengan angka mentah, `Color(0xFF...)`, dan `fontSize` langsung.

### Widget

Pakai komponen dari `frontend/lib/core/widgets/` sebelum membuat yang baru.

- Teks panjang memakai komponen yang sudah ada, bukan `Text` langsung
  dengan `maxLines` tanpa batas.
- Film memakai `MovieCard` atau `MovieListItem`.
- Pemilih film memakai `MoviePickerSheet`.
- Filter berupa chip memakai `ChipFilterRow`.
- Item aktivitas memakai `ActivityItem`.
- Row user memakai `UserCard`.

### Aksi

Aksi yang mengubah data memanggil provider, bukan repository. Setelah
sukses, provider yang invalidate sudah harus mengembalikan state baru.

Aksi yang menghapus selalu memakai dialog konfirmasi.

## String

Tambahkan setiap string ke `AppStrings` untuk Indonesia dan Inggris.
Widget tidak boleh punya `const` string berisi teks yang tampil ke user,
termasuk di `TextStyle`, `labelText`, `hintText`, `semanticsLabel`, dan
`tooltip`.

## Route

Tambahkan di `frontend/lib/core/router/app_router.dart`.

- Halaman yang butuh login masuk kelompok privat dan mengandalkan route
  guard. Jangan cek token di dalam `build`.
- Halaman dengan parameter memakai path parameter dan `state.pathParameters`.
- Update bagian Routing di `docs/ARCHITECTURE.md`.

## Test

`frontend/test/features/<fitur>/presentation/pages/nama_halaman_test.dart`.

Minimal:

- Render halaman dengan provider di-override dan data contoh.
- Pastikan tidak melempar exception.
- Pastikan state kosong tampil saat data kosong.
- Pastikan state error tampil saat provider bererror.

Test tidak boleh bergantung pada jaringan, waktu sistem, atau font yang
dimuat dari aset.

## Setelah Selesai

- `cd frontend && flutter analyze` 0 error.
- `cd frontend && flutter test` semua pass.
- Screenshot sebagai bukti untuk task UI, dan dilaporkan ke user.
- Update `docs/UI_PAGES.md` bila halaman baru atau navigasi berubah.
- Tambahkan entri `CHANGELOG.md` memakai skill `update-changelog`.
