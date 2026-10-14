# 03-design

Aturan visual untuk halaman dan komponen.

## Sumber Token

`docs/DESIGN_SYSTEM.md` adalah sumber token kanonik. Implementasi
mengambil nilai dari:

| Token | File |
|---|---|
| Warna | `frontend/lib/core/theme/app_colors.dart` |
| Tipografi | `frontend/lib/core/theme/app_typography.dart` |
| Spacing | `frontend/lib/core/theme/app_spacing.dart` |
| Radius | `frontend/lib/core/theme/app_radius.dart` |
| Elevasi | `frontend/lib/core/theme/app_elevation.dart` |
| Motion | `frontend/lib/core/theme/app_motion.dart` |

Dilarang di dalam widget:

- `Color(0xFF...)`
- `EdgeInsets.all(...)` dengan angka mentah
- `BorderRadius.circular(...)` dengan angka mentah
- `fontSize`, `fontWeight`, dan `height` dengan angka mentah
- Nilai warna dan spacing dari `Colors.*` atau `colorScheme` langsung

## Tipografi

- Font heading memakai Manrope.
- Font body memakai Geist.
- Gunakan token yang sudah ada. Menambah token baru wajib update
  `docs/DESIGN_SYSTEM.md` pada task yang sama.

## Ikon dan Aset

- Ikon standar memakai `flutter_lucide`.
- Ikon custom berupa SVG, nama file snake_case.
- Path aset lewat `AppAssets`, tidak boleh ditulis langsung di widget.
- Poster dan backdrop diupload admin ke backend, lalu dimuat lewat URL dari
  `APP_URL`.
- Avatar user memakai inisial dari `name`. Tidak ada aset avatar.

## Checklist Anti-AI-Slop

- Maksimal tiga warna dominan per halaman.
- Tidak ada gradient mencolok.
- Tidak ada shadow dengan blur besar.
- Border radius memakai token.
- Spacing kelipatan 4.
- Setiap elemen punya hierarki visual yang jelas.
- Empty state, loading state, dan error state selalu ada di setiap
  halaman.

## Layout

- Target sentuh minimal 48x48.
- Layout tidak boleh bergeser saat jumlah data berubah. Contohnya empat
  slot favourites selalu empat termasuk yang kosong.
- Pemilih film untuk list dan favourites memakai satu komponen
  `MoviePickerSheet`.

## State

- Setiap halaman punya state loading, data, kosong, dan error.
- Pesan error memakai string dari `AppStrings` dan tidak menampilkan
  stack trace.
- Nilai theme dibaca lewat `context` dan `Theme.of`, bukan instance
  global.
