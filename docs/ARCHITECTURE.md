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
| HTTP client | Guzzle, bawaan Laravel | HTTP client bawaan framework |
| Testing | PHPUnit | Bawaan Laravel |

### 1.3 Sumber Data

| Komponen | Pilihan | Alasan |
|---|---|---|
| Penyimpanan gambar | Disk public Laravel | Poster dan backdrop diupload admin |

### 1.4 Yang Tidak Dipakai

| Komponen | Alasan |
|---|---|
| Supabase | Proyek memakai satu backend Laravel, tidak butuh BaaS kedua |
| json-server | Tidak ada mock server. Mock ada di test, bukan di runtime |
| Dummy datasource | Data film hanya dari tabel movies |
| `.env` di Flutter | Alamat backend lewat `--dart-define` |

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

Flutter berada di subfolder `frontend/`. Root repo tidak berisi kode
Flutter.

```
frontend/
  pubspec.yaml
  analysis_options.yaml
  lib/
    core/
      constants/
        app_assets.dart
        app_env.dart
        app_strings.dart
        app_values.dart
      error/
        app_exception.dart
      router/
        app_router.dart
      services/
        api_client.dart
        token_storage.dart
      theme/
        app_colors.dart
        app_elevation.dart
        app_motion.dart
        app_radius.dart
        app_spacing.dart
        app_theme.dart
        app_typography.dart
      utils/
        formatters.dart
        logger.dart
        validators.dart
      widgets/
        activity_item.dart
        app_button.dart
        app_text_field.dart
        chip_filter_row.dart
        empty_state.dart
        error_state.dart
        favourite_slot.dart
        follow_button.dart
        like_button.dart
        list_card.dart
        loading_indicator.dart
        movie_card.dart
        movie_list_item.dart
        movie_picker_sheet.dart
        rating_stars.dart
        section_header.dart
        tag_chip.dart
        user_card.dart
    features/
      auth/
        data/
          auth_repository.dart
        domain/
          auth_repository.dart
        presentation/
          auth_provider.dart
          login_page.dart
          register_page.dart
      catalog/
        data/
          movie_repository.dart
        domain/
          movie_repository.dart
        presentation/
          catalog_provider.dart
          home_page.dart
          search_page.dart
      detail/
        presentation/
          movie_detail_page.dart
      watchlist/
        data/
          watchlist_repository.dart
        domain/
          watchlist_repository.dart
        presentation/
          watchlist_page.dart
          watchlist_provider.dart
      watched/
        data/
          watched_repository.dart
        domain/
          watched_repository.dart
        presentation/
          watched_page.dart
          watched_provider.dart
      review/
        data/
          review_repository.dart
        domain/
          review_repository.dart
        presentation/
          review_form_page.dart
          review_provider.dart
      diary/
        data/
          diary_repository.dart
        domain/
          diary_repository.dart
        presentation/
          diary_page.dart
          diary_provider.dart
      lists/
        data/
          list_repository.dart
        domain/
          list_repository.dart
        presentation/
          list_detail_page.dart
          list_form_page.dart
          list_provider.dart
          lists_page.dart
      tags/
        data/
          tag_repository.dart
        domain/
          tag_repository.dart
        presentation/
          tag_provider.dart
      favorites/
        data/
          favorite_repository.dart
        domain/
          favorite_repository.dart
        presentation/
          favorites_edit_page.dart
          favorite_provider.dart
      like/
        data/
          like_repository.dart
        domain/
          like_repository.dart
        presentation/
          like_provider.dart
      follow/
        data/
          follow_repository.dart
        domain/
          follow_repository.dart
        presentation/
          follow_provider.dart
          followers_page.dart
          following_page.dart
      feed/
        data/
          feed_repository.dart
        domain/
          feed_repository.dart
        presentation/
          feed_page.dart
          feed_provider.dart
      log/
        data/
          log_repository.dart
        domain/
          log_repository.dart
        presentation/
          log_form_page.dart
          log_provider.dart
      members/
        data/
          member_repository.dart
        domain/
          member_repository.dart
        presentation/
          members_page.dart
          member_provider.dart
      profile/
        data/
          profile_repository.dart
        domain/
          profile_repository.dart
        presentation/
          profile_page.dart
          profile_provider.dart
      incoming/
        data/
          incoming_repository.dart
        domain/
          incoming_repository.dart
        presentation/
          incoming_page.dart
          incoming_provider.dart
      settings/
        presentation/
          settings_page.dart
      splash/
        presentation/
          splash_page.dart
      onboarding/
        presentation/
          onboarding_page.dart
    main.dart
  test/
    core/
      widgets/
    features/
```

Struktur ramping yang dipakai:

- Tidak ada folder `usecases/` per fitur. Perilaku yang perlu
  diabstrakkan lewat repository interface dan method di dalamnya.
- Tidak ada pemisahan folder `models/` dan `entities/`. Model di data
  sekaligus menjadi entity yang dipakai presentation.
- Tidak ada folder `datasources/`. Repository di data memanggil
  `api_client.dart` secara langsung.
- Tidak ada `presentation/widgets/` per fitur. Widget khusus fitur
  diletakkan di `frontend/lib/core/widgets/` kalau dipakai lebih dari
  satu halaman.
- Tidak ada `presentation/pages/` dan `presentation/providers/`. File
  halaman dan file provider duduk langsung di `presentation/`.
- Fitur kecil seperti `like`, `tags`, dan `favorites` tidak dipaksa
  punya halaman tersendiri. `tags` hanya punya provider karena tag
  dikelola lewat diary.
- Profile tidak dipecah jadi banyak file per sub-tab. Satu
  `profile_page.dart` dengan tab di dalamnya.

Batas ramping ini bukan bawaan layer. Kalau nanti butuh usecase,
datasource, atau halaman terpisah, tinggal tambah. Yang wajib dijaga
adalah arah dependensi, bukan jumlah folder.

Dua pengecualian yang tetap wajib:

- Setiap repository di `data/` wajib punya interface di `domain/` dengan
  nama file berbeda. Contohnya `domain/auth_repository.dart` berisi
  abstract class `AuthRepository`, dan `data/auth_repository.dart`
  berisi class `AuthRepositoryImpl`. Nama file boleh sama di dua folder
  berbeda selama nama class-nya berbeda, karena keduanya berada di
  library yang berbeda. Kalau sebuah file meng-import keduanya, gunakan
  prefix `as`.
- `like`, `follow`, dan `members` tetap punya folder `domain/`. Tanpa
  interface, repository di `data/` tidak punya kontrak dan presentation
  akan meng-import langsung ke data.

### 3.2 Backend

Struktur bawaan Laravel. Tidak ada modul domain custom.

```
backend/
  app/
    Http/
      Controllers/
        Api/
          AuthController.php
          MovieController.php
          WatchlistController.php
          WatchedController.php
          ReviewController.php
          ProfileController.php
          DiaryController.php
          ListController.php
          TagController.php
          FavoriteController.php
          LikeController.php
          FollowController.php
          FeedController.php
          IncomingActivityController.php
          MemberController.php
          LogController.php
      Requests/
      Resources/
      Traits/
        ApiResponse.php
    Models/
    Repositories/
    Services/
      ActivityLogger.php
  config/
    database.php
    services.php
    sanctum.php
  routes/
    api.php
    console.php
  database/
    factories/
    migrations/
    seeders/
    DatabaseSeeder.php
  public/
  resources/
  storage/
  tests/
    Feature/
    Unit/
  .env
  .env.example
  composer.json
  artisan
```

Peran class backend:

| Class | Peran |
|---|---|
| `MovieStatsService.php` | Menghitung rating rata-rata, jumlah review, watched, dan watchlist per film |
| `HomeService.php` | Membangun enam section beranda dalam satu transaksi baca |
| `AdminAuditService.php` | Satu-satunya kelas yang menulis tabel `admin_audit_logs` |
| `ActivityLogger.php` | Satu-satunya kelas yang menulis tabel `activities` |
| `EnsureUserIsAdmin.php` | Middleware yang menolak request dari user bukan admin |
| `ApiResponse.php` | Trait untuk format `{success, data}` dan `{success, message, errors}` |

`config/services.php` tidak lagi memuat token layanan film apa pun. Yang
dibaca dari `.env` hanya kredensial database dan `APP_URL`.

### 3.3 Area Admin

```
backend/app/
  Http/
    Controllers/
      Api/
      Api/Admin/
        AdminDashboardController.php
        AdminMovieController.php
        AdminGenreController.php
        AdminUserController.php
        AdminReviewController.php
        AdminListController.php
        AdminTagController.php
        AdminAuditLogController.php
    Middleware/
      EnsureUserIsAdmin.php
    Requests/
      Admin/
        StoreMovieRequest.php
        UpdateMovieRequest.php
        StoreGenreRequest.php
        UpdateGenreRequest.php
        UpdateUserRoleRequest.php
    Resources/
      AdminAuditLogResource.php
      GenreResource.php
      MovieResource.php
  Services/
    AdminAuditService.php
    HomeService.php
    MovieStatsService.php
```

Setiap controller admin yang mengubah data wajib memanggil
`AdminAuditService`. Setiap controller yang membaca film wajib memakai
`MovieStatsService` agar perhitungan agregat tidak ditulis ulang di
beberapa tempat.

### 3.4 Area Admin Frontend

```
frontend/lib/features/admin/
  data/
    admin_audit_repository.dart
    admin_dashboard_repository.dart
    admin_genre_repository.dart
    admin_list_repository.dart
    admin_movie_repository.dart
    admin_review_repository.dart
    admin_tag_repository.dart
    admin_user_repository.dart
  domain/
    admin_audit_repository.dart
    admin_dashboard_repository.dart
    admin_genre_repository.dart
    admin_list_repository.dart
    admin_movie_repository.dart
    admin_review_repository.dart
    admin_tag_repository.dart
    admin_user_repository.dart
  presentation/
    pages/
      admin_audit_logs_page.dart
      admin_dashboard_page.dart
      admin_genre_form_page.dart
      admin_genres_page.dart
      admin_list_page.dart
      admin_lists_page.dart
      admin_movie_form_page.dart
      admin_movies_page.dart
      admin_review_page.dart
      admin_reviews_page.dart
      admin_tag_page.dart
      admin_tags_page.dart
      admin_user_detail_page.dart
      admin_users_page.dart
    providers/
      admin_provider.dart
    widgets/
      admin_drawer.dart
      admin_shell.dart
      image_upload_field.dart
      movie_form_field.dart
```

Area admin memakai feature folder tersendiri. Tidak ada kode admin yang
disimpan di feature user, dan feature user tidak meng-import dari admin.

Widget `AdminShell` dan `AdminDrawer` hanya dipakai di area admin. Foto
tetap di `frontend/lib/core/widgets/`.

## 4. Routing (Frontend)

Daftar route:

| Path | Halaman | Query atau parameter |
|---|---|---|
| `/` | splash | |
| `/onboarding` | onboarding | |
| `/login` | login | |
| `/register` | register | |
| `/home` | tab utama: home, search, watchlist, profile | |
| `/feed` | activity feed lengkap dengan filter | `type` |
| `/activity/incoming` | incoming activity | `type` |
| `/members` | pencarian member | `q` |
| `/movie/:movieId` | detail film | |
| `/review/:movieId` | form rating dan review | |
| `/log` | form log | `movieId` opsional |
| `/watched` | daftar watched | |
| `/diary` | daftar diary | `from`, `to`, `tag_id` |
| `/profile` | profil sendiri | `tab` |
| `/user/:userId` | public profile | `tab` |
| `/lists` | daftar list | `user_id`, `scope` |
| `/lists/:listId` | isi list | |
| `/lists/new` | form list buat | |
| `/lists/:listId/edit` | form list ubah | |
| `/tags` | kelola tag | |
| `/favorites/edit` | edit four favourites | |
| `/followers` | daftar follower | `user_id` |
| `/following` | daftar following | `user_id` |
| `/settings` | pengaturan | |
| `/admin/dashboard` | dashboard admin | |
| `/admin/movies` | daftar film | `q`, `status` |
| `/admin/movies/new` | form film baru | |
| `/admin/movies/:movieId` | form film ubah | |
| `/admin/genres` | daftar genre | |
| `/admin/genres/new` | form genre baru | |
| `/admin/genres/:genreId` | form genre ubah | |
| `/admin/users` | daftar user | `q`, `role` |
| `/admin/users/:userId` | detail user | |
| `/admin/reviews` | moderasi review | `q`, `movie_id` |
| `/admin/lists` | moderasi list | `q`, `scope` |
| `/admin/tags` | moderasi tag | `q` |
| `/admin/audit-logs` | log aktivitas admin | `admin_id`, `entity` |

Parameter tanggal, filter, dan tab lewat query string, bukan path, supaya
halaman yang sama bisa dipakai ulang tanpa rebuild route.

Tab utama memakai `StatefulShellRoute.indexedStack`.

Kelompok route:

- Publik: splash, onboarding, login, register.
- Privat: home dan seluruh tabnya, feed, incoming, members, detail,
  review, log, watched, diary, profile, user, lists, tags, favorites,
  followers, following, settings.
- Admin: seluruh route berawalan `/admin/`. Route guard memeriksa role
  `admin` sebelum halaman dibuka. User dengan role `user` yang mencoba
  membuka route admin diarahkan ke `/home` beserta pesan, bukan ke
  halaman error.

Endpoint `GET /api/movies/*` tetap publik di backend walau halamannya
privat. Backend mengembalikan nilai netral untuk `liked`, `in_watchlist`,
dan `diary_entry_id` bila request tidak membawa token.

Masuk ke area admin selalu lewat navigasi `go` dari Settings. Tidak ada
push notification atau deep link yang membuka halaman admin.

Redirect:

- Belum login membuka route privat, arahkan ke login.
- Sudah login membuka login atau register, arahkan ke home.

## 5. Struktur Repo

```
mailboxh/
  frontend/    -> project Flutter
  backend/     -> project Laravel REST API
  docs/        -> dokumentasi
  .opencode/   -> rules, skills, agents, commands
  README.md
  CHANGELOG.md
  AGENTS.md
  PROTOCOL.md
  .gitignore
```

Repo memakai monorepo dengan dua folder terpisah. Pemisahan ini
memakai alasan berikut:

- Toolchain berbeda. Frontend memakai `pubspec.yaml` dan `flutter`,
  backend memakai `composer.json` dan `php artisan`.
- Perintah jalannya berbeda dan tidak saling memengaruhi.
- Saat penilaian UTS keduanya dinilai terpisah, padahal tetap satu repo
  dan satu version control.
- Folder `frontend/` dan `backend/` bisa diabaikan tooling yang hanya
  relevan untuk salah satu sisi, misalnya pencarian di `.gitignore` dan
  konfigurasi editor.

Root hanya berisi dokumentasi, aturan AI, dan orkestrasi. Tidak ada
kode yang dijalankan dari root dan tidak ada `.env` di root.

## 6. Penempatan File .env

| File | Ada | Isi |
|---|---|---|
| `backend/.env` | Wajib | Kredensial database, app key, konfigurasi upload |
| `backend/.env.example` | Wajib, di-commit | Sama seperti di atas tanpa nilai rahasia |
| `frontend/.env` | Tidak dipakai | Alamat backend dikirim lewat `--dart-define` |
| `.env` di root | Tidak ada | Tidak ada proses yang berjalan dari root |

Tidak ada lagi token layanan film pihak ketiga. Yang sensitif di
backend hanya kredensial database dan `APP_KEY`.

Alasan tidak memakai `.env` di Flutter:

- `flutter_dotenv` menambah dependency dan asset bundling tanpa
  manfaat yang sebanding untuk satu nilai konfigurasi.
- `--dart-define` berarti nilainya ikut ter-bundle ke binary dan
  terlihat saat build log. Untuk alamat backend lokal itu tidak
  masalah karena bukan secret.

Perintah menjalankan:

```
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000/api
```

Contoh isi `backend/.env`:

```
APP_NAME=Mailboxh
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_URL=http://127.0.0.1:8000

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=mailboxh
DB_USERNAME=root
DB_PASSWORD=

FILESYSTEM_DISK=public

DEMO_ADMIN_EMAIL=
DEMO_USER_EMAIL=
DEMO_USER_PASSWORD=
```

Perintah pendukung setelah migrate:

```
php artisan storage:link
php artisan migrate:fresh --seed
```

Nilai kosong wajib diisi user. Jangan pernah menulis nilai sebenarnya di
`docs/`, `README.md`, atau commit mana pun.

## 7. Alur Data

```
Flutter -> dio -> Laravel REST API -> MySQL
                          |
                          v
              storage/app/public (gambar)
```

- Flutter tidak pernah memanggil layanan film pihak ketiga.
- Flutter hanya bicara ke Laravel REST API.
- Semua data film dibaca dari tabel `movies` di MySQL.
- Laravel menulis file gambar ke `storage/app/public` saat admin
  mengupload poster atau backdrop.
- Flutter memuat gambar lewat `APP_URL` dan `cached_network_image_ce`.
- URL gambar dibentuk di backend pada `MovieResource`. Klien tidak
  menyusun URL dari path relatif.

Sequence saat admin menyimpan film:

1. Flutter mengirim `POST /api/admin/movies` dengan Content type
   `multipart/form-data`.
2. Laravel memvalidasi request pada `StoreMovieRequest`, termasuk tipe
   MIME dan ukuran file.
3. Laravel menyimpan file ke `storage/app/public/posters/` dan
   `storage/app/public/backdrops/`.
4. Laravel menyimpan path relatif ke kolom `poster_path` dan
   `backdrop_path`.
5. Laravel menulis satu baris ke `admin_audit_logs`.
6. Backend mengembalikan film dengan `poster_url` yang sudah berupa URL
   penuh.

Sequence saat user membuka detail film:

1. Flutter memanggil `GET /api/movies/{id}` dengan token bila ada.
2. Laravel memuat film, genre, rating rata-rata, dan jumlah tontonan.
3. Laravel mengembalikan `poster_url` dan `backdrop_url` dari `APP_URL`.
4. Flutter memuat gambar dengan cache gambar.
5. Film yang dinonaktifkan admin tidak dikembalikan dan menjawab 404.

## 8. Dependency

### 8.1 Frontend

| Paket | Peran |
|---|---|
| flutter_riverpod | State management |
| go_router | Routing dan route guard |
| dio | HTTP client |
| flutter_lucide | Ikon |
| cached_network_image_ce | Cache gambar poster dan backdrop |
| shared_preferences | Non-secret lokal, misal flag onboarding |
| flutter_secure_storage | Penyimpanan token sesi |
| image_picker | Pilih gambar dari galeri dan kamera di form admin |
| intl | Format tanggal dan angka |
| logger | Logging |

Entri `flutter_lucide`, `shared_preferences`, dan `image_picker`
tercantum di atas sebagai rencana, tetapi belum dipasang di
`frontend/pubspec.yaml` karena belum diimpor kode mana pun. Ketiganya
ditambahkan bersama fitur yang memakainya, dengan evaluasi tercatat
pada saat itu.

Evaluasi `image_picker`:

| Aspek | Nilai |
|---|---|
| Tujuan | Mengambil file gambar untuk diupload admin |
| Alternatif | `file_picker`, memilih dari penyimpanan saja |
| Pemeliharaan | Aktif, rilis baru dalam 12 bulan terakhir |
| Lisensi | Apache 2.0 |
| Kompatibilitas | Mendukung Android 8.0 ke atas dan iOS 12 ke atas |
| Ukuran | Sekitar 3 MB bersama dependensinya |
| Dokumentasi | Ada, dengan contoh untuk Android dan iOS |
| Konsekuensi | Memerlukan permission kamera di `AndroidManifest.xml` dan `Info.plist` |

Alasan memilih `image_picker` daripada `file_picker`: admin adalah
satu orang yang mengisi katalog saat menyiapkan data, dan mengambil foto
langsung dari kamera jauh lebih cepat daripada mencari file di folder
penyimpanan. `file_picker` juga bergaya Material lama yang tidak cocok
dengan tema aplikasi.

### 8.2 Backend

| Paket | Peran |
|---|---|
| laravel/framework | Framework REST |
| laravel/sanctum | Token auth |
| guzzlehttp/guzzle | HTTP client bawaan Laravel, dipakai untuk fetch dari halaman admin bila perlu |
| laravel/boost | Toolkit agent resmi Laravel, sumber guideline di `backend/AGENTS.md`, hanya require-dev |

Guzzle tidak lagi dipakai untuk memanggil layanan film. Paket ini tetap
bawaan Laravel dan tidak dihapus karena `Http` facade Laravel
menggunakannya di bawah hood.

Evaluasi `laravel/boost`:

| Aspek | Nilai |
|---|---|
| Tujuan | Menyediakan guideline agent yang akurat untuk codebase Laravel |
| Alternatif | Menulis `backend/AGENTS.md` manual tanpa toolkit |
| Pemeliharaan | Rilis resmi Laravel, v2.10.3 |
| Lisensi | MIT |
| Kompatibilitas | Sesuai versi Laravel dan PHP 8.5 yang dipakai |
| Ukuran | Hanya require-dev, tidak masuk build produksi |
| Dokumentasi | Ada di laravel.com/boost |

### 8.3 Yang Tidak Dipakai

| Komponen | Alasan |
|---|---|
| Supabase | Proyek memakai satu backend Laravel, tidak butuh BaaS kedua |
| json-server | Tidak ada mock server. Mock ada di test, bukan di runtime |
| Dummy datasource | Data film hanya dari tabel `movies` |
| `.env` di Flutter | Alamat backend lewat `--dart-define` |
| API key film eksternal | Katalog dikelola sendiri oleh admin |

### 8.4 Evaluasi Dependency

Setiap dependency baru wajib dievaluasi dari tujuan, alternatif,
pemeliharaan, lisensi, kompatibilitas, ukuran, dan dokumentasi, lalu
dicatat di CHANGELOG.md dan di dokumen ini.

- Rilis di atas 12 bulan tidak boleh dipakai.
- Lisensi di luar MIT, Apache, dan BSD tidak boleh dipakai.

## 9. Error Handling

- Tangkap error di layer data dan domain.
- Gunakan exception terstruktur.
- Tampilkan pesan ramah lewat AppStrings.
- Log memakai logger. Dilarang memakai print.
- Backend memakai format error konsisten `{success: false, message,
  errors}`.
- Jangan pernah menampilkan stack trace ke user.
- Kegagalan upload gambar pada form admin film tidak boleh membuang
  data teks yang sudah diisi user.

## 10. Caching

- Poster dan backdrop: `cached_network_image_ce` di Flutter.
- Data film: dibaca dari MySQL. Tidak ada cache film di luar database
  karena tidak ada lagi sumber eksternal yang perlu di-cache.
- Data aggregat seperti rating rata-rata dan jumlah tontonan: tidak
  disimpan di tabel dan tidak di-cache. Nilainya dihitung ulang saat
  query supaya tidak basi.
- Data user tidak di-cache di sisi server. Selalu dibaca dari database.
- Flag onboarding dan pilihan bahasa disimpan di `shared_preferences`.

## 11. Yang Dilarang

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
- Flutter memanggil layanan film pihak ketiga secara langsung.
- Token layanan pihak ketiga di kode Flutter.
- File `.env` di root repo.
- Menjalankan kode dari root repo.
- Penghapusan keras film. Film memakai soft delete lewat `deleted_at`.
- Penulisan langsung ke `admin_audit_logs` dari controller. Semua lewat
  `AdminAuditService`.
- Endpoint admin tanpa middleware `EnsureUserIsAdmin`.
- Role user diubah lewat form register.
