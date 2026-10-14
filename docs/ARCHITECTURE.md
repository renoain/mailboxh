# ARCHITECTURE - Mailboxh

## 1. Stack Teknologi

### 1.1 Frontend

| Komponen | Pilihan | Alasan |
|---|---|---|
| Framework | Flutter | Cross-platform, animasi kuat |
| Bahasa | Dart | Wajib untuk Flutter |
| State management | Riverpod | Testable, compile-safe |
| Routing | go_router | Deklaratif, mendukung deep link |
| HTTP | dio | Interceptor, cancel token, form data |
| Cache gambar | cached_network_image_ce | Aktif dipelihara, cepat |
| Icon | flutter_lucide | Line-art, konsisten |
| Font | Manrope + Geist | Sesuai DESIGN_SYSTEM.md |
| Penyimpanan token | flutter_secure_storage | Token sesi tidak disimpan polos |
| Logging | logger | Menggantikan print |

### 1.2 Backend

| Komponen | Pilihan | Alasan |
|---|---|---|
| Framework | Laravel | REST API, ekosistem matang |
| Auth | Laravel Sanctum | Token-based, ringan |
| Database | MySQL | Relasional, sesuai kebutuhan tugas |
| HTTP client | Guzzle, bawaan Laravel | Untuk memanggil TMDB |
| Testing | PHPUnit | Bawaan Laravel |

### 1.3 Sumber Data

| Komponen | Pilihan | Alasan |
|---|---|---|
| API film | TMDB | Gratis, poster lengkap, rate limit longgar |

## 2. Layer Architecture (Frontend)

Feature-first dengan clean architecture ringan.

### 2.1 Layer

1. Presentation: widget, halaman, provider Riverpod.
2. Domain: entity, repository interface, usecase.
3. Data: model, datasource, repository implementation.

### 2.2 Aturan Dependency

- Presentation bergantung ke Domain.
- Data bergantung ke Domain.
- Domain tidak bergantung ke layer mana pun.
- Presentation tidak boleh bergantung langsung ke Data.

## 3. Struktur Folder

### 3.1 Frontend

Flutter berada di root repo, bukan di subfolder `frontend/`.

```
lib/
  core/
    constants/
    error/
    l10n/
      app_strings.dart
    network/
      dio_client.dart
      api_exception.dart
    router/
      app_router.dart
    services/
      secure_storage_service.dart
    theme/
      app_colors.dart
      app_typography.dart
      app_spacing.dart
      app_radius.dart
      app_elevation.dart
      app_motion.dart
      app_theme.dart
    utils/
      formatters/
      validators/
    widgets/
      app_button.dart
      app_text_field.dart
      activity_item.dart
      chip_filter_row.dart
      empty_state.dart
      error_state.dart
      favourite_slot.dart
      follow_button.dart
      like_button.dart
      list_card.dart
      loading_state.dart
      movie_card.dart
      movie_list_item.dart
      movie_picker_sheet.dart
      rating_stars.dart
      section_header.dart
      tag_chip.dart
      user_card.dart
  features/
    auth/
    catalog/
    detail/
    watchlist/
    watched/
    review/
    profile/
    diary/
    lists/
    tags/
    favorites/
    like/
    follow/
    feed/
    log/
    members/
      data/
        datasources/
        models/
        repositories/
      domain/
        entities/
        repositories/
        usecases/
      presentation/
        pages/
        widgets/
        providers/
  main.dart
```

Feature `diary` sampai `members` memakai struktur folder yang sama seperti
`auth`. Hanya `diary` yang ditunjukkan rinci sebagai contoh.

### 3.2 Backend

```
backend/app/
  Http/
    Controllers/
      Api/
    Requests/
    Resources/
    Middleware/
  Models/
  Services/
    TmdbService.php
    ActivityLogger.php
  Repositories/
backend/routes/
  api.php
backend/database/
  migrations/
  seeders/
```

`ActivityLogger.php` dipakai setiap endpoint yang menulis ke tabel
`activities`. Controller tidak boleh insert ke tabel itu langsung.

## 4. Routing (Frontend)

Daftar route:

- `/` splash
- `/onboarding`
- `/login`
- `/register`
- `/home` tab: home, search, watchlist, profile
- `/feed` activity feed lengkap dengan filter
- `/activity/incoming` incoming activity
- `/members` pencarian member
- `/movie/:tmdbId` detail film
- `/review/:tmdbId` form rating dan review
- `/log` form log, opsional `/log/:tmdbId`
- `/watched` daftar watched
- `/diary` daftar diary
- `/profile`
- `/user/:userId` public profile
- `/lists` daftar list
- `/lists/:listId` isi list
- `/lists/form` buat dan ubah list
- `/tags` kelola tag
- `/favorites` edit four favourites
- `/followers` daftar follower
- `/following` daftar following
- `/settings`

Tab utama memakai `StatefulShellRoute.indexedStack`.

Kelompok route:

- Publik: splash, onboarding, login, register.
- Privat: home dan seluruh tabnya, feed, incoming, members, detail,
  review, log, watched, diary, profile, user, lists, tags, favorites,
  followers, following, settings.

Redirect:

- Belum login membuka route privat, arahkan ke login.
- Sudah login membuka login atau register, arahkan ke home.

## 5. Alur Data

```
Flutter -> dio -> Laravel REST API -> MySQL
                          |
                          v
                      TMDB API
```

- Flutter tidak pernah bicara langsung ke TMDB.
- Laravel menjadi proxy sekaligus cache.
- API key TMDB hanya ada di Laravel.

## 6. Dependency

### 6.1 Frontend

- flutter_riverpod
- go_router
- dio
- flutter_lucide
- cached_network_image_ce
- shared_preferences
- flutter_secure_storage
- intl
- logger

### 6.2 Backend

- laravel/framework
- laravel/sanctum
- guzzlehttp/guzzle

### 6.3 Evaluasi Dependency

Setiap dependency baru wajib dievaluasi dari tujuan, alternatif,
pemeliharaan, lisensi, kompatibilitas, ukuran, dan dokumentasi, lalu
dicatat di CHANGELOG.md dan di dokumen ini.

## 7. Error Handling

- Tangkap error di layer data dan domain.
- Gunakan exception terstruktur.
- Tampilkan pesan ramah lewat AppStrings.
- Log memakai logger. Dilarang memakai print.
- Backend memakai format error konsisten `{success: false, message,
  errors}`.
- Jangan pernah menampilkan stack trace ke user.

## 8. Caching

- Poster film: cached_network_image_ce.
- Data film dari TMDB: cache di tabel `movies_cache`. Umur cache
  ditentukan di `TmdbService`, bukan di migration dan bukan angka
  hardcode.
- Data user tidak di-cache di sisi server. Selalu dibaca dari database.
- Flag onboarding disimpan di shared_preferences.

## 9. Yang Dilarang

- Logika bisnis di widget.
- Akses data langsung dari widget.
- Hardcode warna, spacing, radius, dan ukuran font.
- Hardcode string UI.
- Hardcode path aset.
- print di produksi.
- Secret di kode.
- Emoji di kode, komentar, dan dokumentasi.
- Pemisah dekoratif di komentar.
- Duplikasi widget.
- Import lintas layer yang melanggar aturan.
- Dependency tanpa evaluasi.