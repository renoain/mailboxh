---
name: create-component
description: Use when adding a reusable widget to Mailboxh, whether global in frontend/lib/core/widgets or feature-scoped in frontend/lib/features/<fitur>/presentation/widgets. Covers token-only styling, AppStrings usage, sizing for 48x48 touch targets, doc comments, a widget test, and registering the component in the UI_PAGES reusable component table.
---

# Create Component

Membuat widget reusable.

## Decide Lokasi

| Kondisi | Lokasi |
|---|---|
| Dipakai di dua feature atau lebih | `frontend/lib/core/widgets/` |
| Hanya dipakai satu feature | `frontend/lib/features/<fitur>/presentation/widgets/` |
| Hanya membungkus state satu halaman | Tetap di `pages/`, bukan widget terpisah |

Widget yang ì‚¬ê±´nya akan dipakai ulang di masa depan tetap di feature
aja sampai ada pemakai kedua. Jangan membuat abstraksi generik
berlebihan di awal.

## Isi

### Header dan Doc Comment

Satu baris header komentar di atas file, satu baris doc comment di atas
class. Isi dengan tanggung jawab widget, bukan mengulang nama class.

```dart
/// Menampilkan slot four favourites dengan aksi ganti dan hapus.
class FavouriteSlot extends StatelessWidget {
```

### Constructor

- `const` constructor kalau semua field final.
- Field yang dipakai banyak tempat jadikan `required`.
- Field dengan nilai default yang masuk akal jadikan optional dengan
  named parameter. Jangan pakai nilai posisional nullable.

### Styling

Semua nilai dari token:

```dart
padding: const EdgeInsets.all(AppSpacing.md),
decoration: BoxDecoration(
  color: theme.colorScheme.surfaceContainerHighest,
  borderRadius: BorderRadius.circular(AppRadius.md),
),
```

Dilarang angka mentah untuk spacing, radius, warna, dan ukuran font.
Lihat `.opencode/rules/03-design.md`.

### Ukuran

- Target sentuh minimal 48x48. Kalau elemen visual lebih kecil,
  bungkus dengan `SizedBox` atau `IconButton` dengan ukuran minimum.
- Widget accept `constraints` atau `crossAxisAlignment` bila dipakai
  di dalam row dan column, supaya tidak mengasumsikan lebar layar.

### String

Semua teks dari `AppStrings`, termasuk `tooltip` dan `semanticsLabel`.
Tidak boleh ada `const` string yang tampil ke user.

### Akses Data

Widget tidak boleh memanggil repository atau provider kecuali memang
disebutkan sebagai dependency. Widget presentasi boleh membaca provider
lewat `ref.watch`, tetapi operasi ke server harus lewat method
provider.

### Logic

Logic bisnis di widget dilarang. Widget memilih state tampilan seperti
`isLiked ? A : B` boleh. Widget menghitung `items.where(...).length`
sebagai bagian dari filtering tampilan boleh. Widget memanggil usecase
atau menerapkan aturan domain tidak boleh.

## Test

`frontend/test/core/widgets/nama_widget_test.dart` atau
`frontend/test/features/<fitur>/presentation/widgets/nama_widget_test.dart`.

Minimal:

- Render dengan data contoh tanpa melempar exception.
- Render ulang dengan data berbeda untuk memastikan reacting terhadap
  perubahan input.
- Render dalam `MediaQuery` sempit untuk memastikan tidak overflow.

Widget test memakai `MaterialApp` dengan theme aplikasi, bukan
`MaterialApp` default, supaya token ikut teruji.

## Dokumentasi

Daftarkan widget di tabel Komponen Reusable pada `docs/UI_PAGES.md`
dengan kolom Peran satu baris. Kalau widget memakai token baru,
update `docs/DESIGN_SYSTEM.md`.

## Setelah Selesai

- `cd frontend && flutter analyze` 0 error.
- `cd frontend && flutter test` semua pass.
- Tambahkan entri `CHANGELOG.md` memakai skill `update-changelog`.
