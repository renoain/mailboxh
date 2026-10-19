# DESIGN SYSTEM - Mailboxh

Design token untuk aplikasi Mailboxh. Semua widget wajib merujuk ke
token di dokumen ini.

## 1. Prinsip

- Bersih, fokus pada poster film.
- Dominasi warna netral, satu warna aksen.
- Tipografi jelas.
- Spacing kelipatan 4.
- Anti-AI-slop: tidak ada gradient mencolok, shadow blur besar, atau
  dekorasi tanpa fungsi.

## 2. Color Tokens

### 2.1 Light

#### Primary

| Token | Hex | Kegunaan |
|---|---|---|
| color-primary | #1F6F5C | Tombol utama, aksen |
| color-primary-light | #2E8B72 | Hover, aktif |
| color-primary-dark | #0F4A3C | Pressed, teks gelap |

#### Secondary

| Token | Hex | Kegunaan |
|---|---|---|
| color-secondary | #E8B44A | Bintang rating |
| color-secondary-light | #F2C97A | Hover bintang |

#### Background

| Token | Hex | Kegunaan |
|---|---|---|
| color-bg | #F6F7F5 | Latar utama |
| color-bg-alt | #ECEFEA | Latar alternatif, input |

#### Surface

| Token | Hex | Kegunaan |
|---|---|---|
| color-surface | #FFFFFF | Card, sheet |
| color-surface-dim | #E3E7E0 | Skeleton, disabled |

#### Text

| Token | Hex | Kegunaan |
|---|---|---|
| color-text-primary | #1A1F1C | Teks utama |
| color-text-secondary | #5A635C | Teks sekunder |
| color-text-disabled | #9AA39C | Teks disabled |
| color-text-on-primary | #FFFFFF | Teks di atas primary |

#### Status

| Token | Hex | Kegunaan |
|---|---|---|
| color-success | #2E8B72 | Sukses |
| color-warning | #E8B44A | Peringatan |
| color-error | #BA1A1A | Gagal |
| color-info | #4A90E2 | Info |

#### Border

| Token | Hex | Kegunaan |
|---|---|---|
| color-border | #D6DCD3 | Border default |
| color-border-light | #E6EBE3 | Border ringan |
| color-outline | #717973 | Outline aktif |

### 2.2 Dark

#### Primary

| Token | Hex | Kegunaan |
|---|---|---|
| color-primary | #4FBFA3 | Tombol utama, aksen |
| color-primary-light | #6FD4B8 | Hover, aktif |
| color-primary-dark | #2C7D68 | Pressed, container |

#### Secondary

| Token | Hex | Kegunaan |
|---|---|---|
| color-secondary | #F0C05E | Bintang rating |
| color-secondary-light | #F7D58C | Hover bintang |

#### Background

| Token | Hex | Kegunaan |
|---|---|---|
| color-bg | #101412 | Latar utama |
| color-bg-alt | #171C1A | Latar alternatif, input |
| color-letterboxd-bg | #14181C | Latar tema profil Letterboxd |

#### Surface

| Token | Hex | Kegunaan |
|---|---|---|
| color-surface | #1A211E | Card, sheet |
| color-surface-dim | #232B27 | Skeleton, disabled |

#### Text

| Token | Hex | Kegunaan |
|---|---|---|
| color-text-primary | #E8EDEA | Teks utama |
| color-text-secondary | #A0ABA5 | Teks sekunder |
| color-text-disabled | #6E7873 | Teks disabled |
| color-text-on-primary | #06201A | Teks di atas primary |

#### Status

| Token | Hex | Kegunaan |
|---|---|---|
| color-success | #5FBF9E | Sukses |
| color-warning | #F0C05E | Peringatan |
| color-error | #F2726B | Gagal |
| color-info | #7FB6EE | Info |

#### Border

| Token | Hex | Kegunaan |
|---|---|---|
| color-border | #2C3632 | Border default |
| color-border-light | #232C28 | Border ringan |
| color-outline | #8A948E | Outline aktif |

## 3. Typography

Font Manrope untuk heading, Geist untuk body. Token nama sama di kedua
mode.

| Token | Font | Size | Weight | Line Height |
|---|---|---|---|---|
| headline-xl | Manrope | 32 | 700 | 40 |
| headline-lg | Manrope | 24 | 700 | 32 |
| headline-md | Manrope | 20 | 600 | 28 |
| headline-sm | Manrope | 18 | 600 | 24 |
| body-lg | Geist | 16 | 400 | 24 |
| body-md | Geist | 14 | 400 | 20 |
| body-sm | Geist | 12 | 400 | 16 |
| label-lg | Geist | 15 | 600 | 20 |
| label-md | Geist | 13 | 500 | 18 |
| label-sm | Geist | 11 | 600 | 14 |

## 4. Spacing

Set dasar dari spesifikasi awal adalah space-xs sampai space-xl. Token
lain melengkapi kebutuhan layout yang tidak terpuaskan oleh set dasar.

| Token | Value |
|---|---|
| space-xs | 4 |
| space-poster-gap | 6 |
| space-sm | 8 |
| space-md | 16 |
| space-lg | 24 |
| space-xl | 32 |
| space-2xs | 12 |
| space-3xs | 20 |
| space-2xl | 40 |
| space-3xl | 48 |
| space-4xl | 64 |

Semua nilai kelipatan 4, kecuali space-poster-gap (6px) khusus untuk Four Favourites rapat.

## 5. Border Radius

| Token | Value |
|---|---|
| radius-sm | 4 |
| radius-md | 8 |
| radius-lg | 12 |
| radius-xl | 16 |
| radius-2xl | 20 |
| radius-sheet | 32 |
| radius-full | 9999 |

## 6. Elevation

### 6.1 Light

| Token | Value |
|---|---|
| elevation-1 | 0 4px 20px rgba(31, 111, 92, 0.05) |
| elevation-2 | 0 8px 30px rgba(31, 111, 92, 0.12) |
| elevation-3 | 0 12px 24px rgba(31, 111, 92, 0.25) |

### 6.2 Dark

Shadow di mode dark memakai warna netral, bukan warna primary.

| Token | Value |
|---|---|
| elevation-1 | 0 4px 20px rgba(0, 0, 0, 0.40) |
| elevation-2 | 0 8px 30px rgba(0, 0, 0, 0.50) |
| elevation-3 | 0 12px 24px rgba(0, 0, 0, 0.60) |

## 7. Komponen Standar

### Button

- Primary: background color-primary, text color-text-on-primary, tinggi
  48, radius radius-lg.
- Secondary: background color-surface, border color-border, text
  color-primary.
- Disabled: background color-surface-dim, text color-text-disabled.

### Input

- Border color-border. Fokus color-outline dengan lebar 2.
- Background color-bg-alt.
- Border radius radius-md.

### Card

- Background color-surface.
- Border color-border-light 1.
- Elevation elevation-1.
- Border radius radius-lg.
- Padding space-md.

### Bottom Navigation

- Background color-surface.
- Selected color-primary.
- Unselected color-text-secondary.
- Ukuran ikon 24.
- Elevation elevation-2.
- Tinggi 64.

## 8. Aturan Anti-AI-Slop

- Maksimal 3 warna dominan per halaman.
- Tidak ada gradient mencolok. Gradient hanya untuk keterbacaan teks di
  atas gambar.
- Tidak ada shadow dengan blur lebih dari 30.
- Tidak ada border radius lebih dari 20 untuk card.
- Tidak ada dekorasi tanpa fungsi.
- Empty state, loading, dan error state wajib ada.

## 9. Aset

- Icon standar memakai flutter_lucide.
- Ikon custom berbentuk SVG.
- Nama file snake_case.
- Path aset lewat AppAssets, dilarang hardcode di widget.
- Poster dan backdrop diupload admin ke backend, lalu dimuat lewat URL dari APP_URL.
- Font Manrope dan Geist berada di assets/fonts/.

## 10. Aturan Pemakaian Token

- Gunakan AppColors, AppSpacing, AppRadius, AppTypography, AppElevation.
- Dilarang memakai Color(0xFF...) langsung di widget.
- Dilarang memakai EdgeInsets.all dengan angka langsung di widget.
- Dilarang memakai BorderRadius.circular dengan angka langsung di
  widget.
- Dilarang memakai fontSize langsung di widget.
- Widget hanya memilih nama token, bukan nilainya.

## 11. Checklist Validasi UI

Sebelum halaman dianggap selesai:

1. Maksimal 3 warna dominan.
2. Tidak ada gradient mencolok.
3. Blur shadow tidak lebih dari 30.
4. Semua warna dari token.
5. Semua spacing dari token dan kelipatan 4.
6. Semua radius dari token.
7. Semua ukuran font dari token.
8. Semua ikon dari flutter_lucide.
9. Ada hierarki visual yang jelas.
10. Ada state loading, kosong, dan error.
11. Target sentuh minimal 48x48.
12. String UI dari AppStrings, tersedia dalam ID dan EN.
13. Screenshot terlampir sebagai bukti.