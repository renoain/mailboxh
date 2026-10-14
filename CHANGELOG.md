# CHANGELOG - Mailboxh

## [2026-10-14 22:09] - Perbaiki LogController dan AdminTagController Tambah 8 Test

Status: Selesai

File yang diubah:
- backend/app/Http/Controllers/Api/LogController.php (diedit, $tags jadi collection)
- backend/app/Http/Controllers/Api/Admin/AdminTagController.php (diedit, order diary_entries_count)
- backend/tests/Feature/LogTest.php (dibuat)
- backend/tests/Feature/AdminTagTest.php (dibuat)
- docs/TEST_RESULT.md (diedit)

Catatan:
- LogController memakai collect agar map pada tags valid, logika attach tidak berubah.
- AdminTagController mengurutkan diary_entries_count agar respons usage_count tetap ada.
- 8 test baru mencakup log dengan dan tanpa tags, 401 tanpa token, movie invalid, list dan hapus tag admin, urutan usage, dan 403 non admin.

Verifikasi:
- hasil linter/analyze: OK
- hasil test: OK (87 passed, 79 lama tambah 8 baru)

## [2026-10-14 22:10] - Batch Import Manual, Postman Collection, Sinkron Docs

Status: Selesai

File yang diubah:
- backend/docs/Mailboxh.postman_collection.json (dibuat)
- backend/docs/Mailboxh.postman_environment.json (dibuat)
- docs/DATABASE_SCHEMA.md (diedit, tabel migrasi disamakan dengan file asli)
- docs/API.md (diedit, perbaiki keterangan id diary)
- docs/TEST_RESULT.md (diedit, tambah batch import, Postman, clone manual)

Catatan:
- Batch import manual ke server live: created 2, unmatched 1, resolve jalan. Film uji dihapus, database kembali 10 film.
- Postman: 4 folder, 31 request, environment base_url token admin_token.
- Uji clone bersih dan push GitHub manual oleh user.

Verifikasi:
- hasil linter/analyze: OK
- hasil test: OK (79 passed, tidak berubah)

## [2026-10-14 22:05] - Perbaiki 2 Bug Produksi, Test Hijau 79 dari 79

Status: Selesai

File yang diubah:
- backend/app/Http/Traits/ApiResponse.php (diedit, $meta jadi nullable)
- backend/app/Http/Controllers/Api/Admin/AdminMovieController.php (diedit, perbaiki validated())

Catatan:
- Perbaikan atas persetujuan user setelah laporan 17 test gagal.
- Bug 1: signature success() diubah ke ?array $meta agar panggilan success($data, null, 201) valid.
- Bug 2: validated() memakai except() yang sudah array, hapus toArray dan get yang fatal.
- Hasil akhir: 79 test, 79 lolos, 0 gagal.

Verifikasi:
- hasil linter/analyze: OK
- hasil test: OK (79 passed)

## [2026-10-14 22:00] - Feature Test 19 File, Rate Limit, dan CORS

Status: Sedang dikerjakan (17 test gagal karena 2 bug produksi, menunggu keputusan)

File yang diubah:
- backend/tests/Feature/AuthTest.php (dibuat)
- backend/tests/Feature/MovieTest.php (dibuat)
- backend/tests/Feature/WatchlistTest.php (dibuat)
- backend/tests/Feature/WatchedTest.php (dibuat)
- backend/tests/Feature/ReviewTest.php (dibuat)
- backend/tests/Feature/DiaryTest.php (dibuat)
- backend/tests/Feature/ListTest.php (dibuat)
- backend/tests/Feature/TagTest.php (dibuat)
- backend/tests/Feature/FavoriteTest.php (dibuat)
- backend/tests/Feature/LikeTest.php (dibuat)
- backend/tests/Feature/FollowTest.php (dibuat)
- backend/tests/Feature/FeedTest.php (dibuat)
- backend/tests/Feature/ProfileTest.php (dibuat)
- backend/tests/Feature/AdminDashboardTest.php (dibuat)
- backend/tests/Feature/AdminMovieTest.php (dibuat)
- backend/tests/Feature/AdminGenreTest.php (dibuat)
- backend/tests/Feature/AdminUserTest.php (dibuat)
- backend/tests/Feature/AdminReviewTest.php (dibuat)
- backend/tests/Feature/AdminBatchImportTest.php (dibuat)
- backend/config/cors.php (dibuat)
- docs/TEST_RESULT.md (diedit)

Catatan:
- 79 test, 62 lolos, 17 gagal. Semua kegagalan berasal dari 2 bug produksi yang dilaporkan tanpa perbaikan sesuai instruksi.
- Bug 1: success($data, null, 201) menabrak array $meta, 500 di semua endpoint store (14 test).
- Bug 2: validated() memanggil toArray pada array di AdminMovieController, 500 pada tambah/edit/upload film (3 test).
- Rate limit auth 5 per menit per IP sudah aktif, test 429 lolos.
- CORS dibuat untuk development, production wajib ganti origins.

Verifikasi:
- hasil linter/analyze: OK (php -l cors.php lolos)
- hasil test: gagal (62 lolos, 17 gagal karena bug produksi)

## [2026-10-14 21:53] - Perbaiki Factory yang Error Sintaks dan Stub Kosong

Status: Selesai

File yang diubah:
- backend/database/factories/ActivityFactory.php (diedit)
- backend/database/factories/AdminAuditLogFactory.php (diedit)
- backend/database/factories/DiaryEntryFactory.php (diedit)
- backend/database/factories/DiaryTagFactory.php (diedit)
- backend/database/factories/FavoriteFactory.php (diedit)
- backend/database/factories/FollowFactory.php (diedit)
- backend/database/factories/GenreFactory.php (diedit)
- backend/database/factories/LikeFactory.php (diedit)
- backend/database/factories/ListItemFactory.php (diedit)
- backend/database/factories/MovieFactory.php (diedit)
- backend/database/factories/MovieListFactory.php (diedit)
- backend/database/factories/ReviewFactory.php (diedit)
- backend/database/factories/TagFactory.php (diedit)
- backend/database/factories/UserFactory.php (diedit)
- backend/database/factories/WatchedFactory.php (diedit)
- backend/database/factories/WatchlistFactory.php (diedit)

Catatan:
- 5 factory error sintaks fatal karena use statement memakai nama class bertanda hubung (admin-audit-log, diary-entry, diary-tag, list-item, movie-list). Diperbaiki ke nama class asli.
- 10 factory lain lolos parse tapi definition kosong, diisi sesuai kolom docs/DATABASE_SCHEMA.md dengan relasi via factory.
- UserFactory ditambah default role user dan state admin.
- Smoke test sementara 17 assert (satu create per model) lolos di sqlite in-memory, lalu dihapus agar suite tetap bersih.

Verifikasi:
- hasil linter/analyze: OK (php -l 16 file, 0 gagal)
- hasil test: OK (php artisan test, 2 passed; smoke test sementara 1 passed 17 assert sebelum dihapus)

## [2026-10-14 21:48] - Setup Database Sampai Siap Dipakai dan Verifikasi Endpoint

Status: Selesai

File yang diubah:
- backend/app/Models/Watched.php (diedit, tambah $table watched)
- backend/app/Models/Watchlist.php (diedit, tambah $table watchlist)
- backend/app/Services/MovieStatsService.php (diedit, query langsung ke model relasi)
- docs/TEST_RESULT.md (dibuat)

Catatan:
- Migrasi 21 file sukses, 26 tabel terbentuk di database mailboxh MySQL 8.0.30.
- Seeder sukses: 2 user, 6 genre, 10 film.
- Server jalan di http://127.0.0.1:8000 (background, pid 44200).
- Endpoint genres, movies, login, home, movies/1 semua 200.
- top_rated kosong karena belum ada review, sesuai spesifikasi.
- Genre Mystery ikut ter-seed karena satu film contoh memakainya.

Verifikasi:
- hasil linter/analyze: OK (endpoint movies/home sempat 500, diperbaiki, lalu 200)
- hasil test: belum ditest (php artisan test menyusul setelah factory diisi)

## [2026-10-14 21:41] - Lengkapi Backend Setup Database dan Batch Import Film

Status: Selesai

File yang diubah:
- backend/database/create_database.sql (dibuat)
- backend/database/README.md (dibuat)
- docs/SETUP_DATABASE.md (dibuat)
- backend/database/migrations/2026_10_14_* (di-rename ke 0001_01_01_000003 sampai 0001_01_01_000020, 18 file)
- backend/app/Http/Requests/*.php (diedit, 16 file ditulis ulang dari stub)
- backend/app/Http/Requests/Admin/*.php (diedit 5 file, dibuat StoreMovieBatchRequest.php)
- backend/app/Http/Middleware/EnsureUserIsAdmin.php (dibuat)
- backend/app/Services/MovieBatchImportService.php (dibuat)
- backend/app/Http/Controllers/Api/Admin/AdminMovieBatchController.php (dibuat)
- backend/routes/api.php (diedit, tambah movies/batch-import dan movies/batch-resolve)
- README.md (diedit, tambah Alur Kerja Tim dan Undang Collaborator)

Catatan:
- Migrasi di-rename paksa ke format 0001_01_01 sesuai permintaan user, menyimpang dari docs/DATABASE_SCHEMA.md Bagian 6. Aman karena database belum pernah di-migrate di Laragon baru dan folder backend/ belum masuk version control.
- Ditemukan 21 FormRequest hanya stub 8 baris tanpa class dan namespace rusak, ditulis ulang lengkap dengan aturan validasi sesuai docs/API.md.
- Ditemukan folder Middleware kosong padahal bootstrap/app.php mereferensikan EnsureUserIsAdmin, dibuat ulang dengan respons 403 format {success, message}.
- Trait ApiResponse tetap di App/Http/Traits dengan method success/failure, setara dengan success/error di prompt, tidak diubah agar 20 controller tidak rusak.
- Model, controller, service, seeder, dan .env.example sudah ada dan tidak ditulis ulang.
- Factory masih stub bawaan, diisi pada task testing terpisah.

Verifikasi:
- hasil linter/analyze: OK (php -l lolos 27 file, 0 gagal)
- hasil test: belum ditest (butuh MySQL Laragon jalan: php artisan migrate, db:seed, php artisan test)

## [2026-10-14 17:40] - Ganti TMDB dengan Katalog Film Milik Sendiri dan Tambah Area Admin

Status: Selesai

File yang diubah:
- CHANGELOG.md (diedit)
- AGENTS.md (diedit)
- PROTOCOL.md (diedit)
- README.md (diedit)
- frontend/pubspec.yaml (diedit)
- frontend/lib/core/constants/app_env.dart (diedit)
- frontend/lib/core/constants/app_strings.dart (diedit)
- frontend/lib/core/widgets/activity_item.dart (diedit)
- frontend/lib/core/widgets/favourite_slot.dart (diedit)
- frontend/lib/core/widgets/movie_card.dart (diedit)
- frontend/lib/core/widgets/movie_list_item.dart (diedit)
- backend/config/services.php (diedit)
- backend/.env.example (diedit)
- backend/app/Services/TmdbService.php (dihapus)
- docs/PROJECT_OVERVIEW.md (diedit)
- docs/SRS.md (diedit)
- docs/ARCHITECTURE.md (diedit)
- docs/DATABASE_SCHEMA.md (diedit)
- docs/API.md (diedit)
- docs/UI_PAGES.md (diedit)
- docs/DESIGN_SYSTEM.md (diedit)
- .opencode/rules/02-coding.md (diedit)
- .opencode/rules/03-design.md (diedit)
- .opencode/rules/05-security.md (diedit)
- .opencode/skills/verify-task/SKILL.md (diedit)
- .opencode/agents/security-auditor.md (diedit)

Catatan:
- Sumber data film berubah total. TMDB dibuang, tidak ada lagi token
  TMDB, tidak ada lagi atribusi TMDB. Film diinput manual oleh admin
  lewat area admin di aplikasi yang sama.
- Tiga keputusan diambil sebelum penulisan. Pertama, tabel
  `diary_entries` dikembalikan lagi sebagai tabel tersendiri,
  membatalkan FR-DIA-03 dan catatan pada entri 2026-10-14 14:40 dan
  15:30. Kedua, film memakai soft delete lewat kolom `deleted_at`
  supaya menghapus film tidak menghapus data watchlist, watched,
  diary, review, like, dan favourite milik semua user. Ketiga, upload
  gambar memakai `image_picker`.
- Konsekuensi produk yang harus disadari. Katalog film hanya berisi
  film yang sudah diinput admin. Seed bawaan berisi sepuluh film, bukan
  ribuan. Ini dicatat terbuka di `docs/PROJECT_OVERVIEW.md` bagian 8.
- DATABASE_SCHEMA: tabel `movies_cache` dihapus, diganti `movies`.
  Tabel `genres` dan `movie_genres` ditambahkan. Tabel
  `diary_entries` dan `admin_audit_logs` ditambahkan. Kolom `role`
  ditambahkan pada `users`, kolom `deleted_at` pada `movies`. Total 17
  tabel plus satu migration ubah kolom.
- Semua kolom `tmdb_id` diganti `movie_id` dengan foreign key ke
  `movies.id`. Ini perbaikan, karena film kini milik aplikasi sendiri
  sehingga integritas referensial bisa dijaga database.
- Radio agregat tidak disimpan sebagai kolom. Rating rata-rata, jumlah
  review, jumlah watched, dan jumlah watchlist dihitung ulang saat query
  supaya tidak bisa basi. `docs/DATABASE_SCHEMA.md` bagian 5 ditulis
  ulang. Enam query Home dan tiga
  query dashboard admin ditambahkan pada bagian 5.1 dan 5.2.
- DATABASE_SCHEMA bagian 6 ditulis ulang menjadi 18 migration.
- DATABASE_SCHEMA bagian 7 diganti dari Datasource TMDB menjadi
  Penyimpanan File Gambar, berisi lokasi disk, symlink, batas ukuran,
  format, dan cara membentuk URL.
- DATABASE_SCHEMA bagian 8 ditulis ulang. Password admin dan user demo
  dibaca dari `DEMO_ADMIN_EMAIL`, `DEMO_USER_EMAIL`, dan
  `DEMO_USER_PASSWORD`, tidak ditulis di seeder.
- API: bagian 3.2 ditulis ulang menjadi `GET /api/movies`,
  `GET /api/movies/{id}`, `GET /api/genres`, dan `GET /api/home`.
  Endpoint trending, popular, dan search dihapus karena tidak ada lagi
  sumber eksternal.
- API: `GET /api/home` mengembalikan enam section sekaligus. Featured
  maksimal lima film, lima section lain maksimal sepuluh.
- API: bagian 3.7 Diary kini punya endpoint tulis
  `POST /api/diary`, `PUT /api/diary/{id}`, dan `DELETE /api/diary/{id}`.
- API: bagian 3.18 Admin baru, 17 endpoint dengan request dan response
  contoh, termasuk upload multipart, toggle featured, restore film, dan
  perubahan role.
- API: `poster_url` dan `backdrop_url` sudah berupa URL penuh yang
  dibentuk backend dari `APP_URL`. Klien tidak menyusun URL dari path
  relatif.
- API: field `liked`, `in_watchlist`, dan `diary_entry_id` bernilai
  netral bila request tanpa token. Total endpoint kini 76.
- SRS: bagian 2.3 dan 2.4 ditulis ulang. Admin menjadi aktor keempat.
  Batasan tanpa fitur sosial dihapus, dan batasan admin ditambahkan.
- SRS: bagian 4.2 Katalog Film ditulis ulang jadi enam FR. Bagian 4.3
  Detail Film jadi empat FR. Bagian 4.8 Diary ditulis ulang jadi lima FR
  dan mengembalikan `diary_entries`.
- SRS: bagian 4.19 sampai 4.27 baru. Menambah 6 FR Home, 3 FR
  dashboard, 6 FR kelola film, 4 FR genre, 4 FR user, 3 FR review,
  3 FR list, 3 FR tag, dan 2 FR log audit. Total FR yang didefinisikan di bagian 4 adalah 86.
- SRS bagian 5.2 ditulis ulang. Endpoint admin dilindungi dua lapis,
  upload divalidasi tipe MIME bukan hanya ekstensi, dan role tidak bisa
  diisi lewat register.
- SRS: matriks kebutuhan diperbarui menjadi 106 baris dan memetakan setiap
  FR admin ke endpoint dan halaman.
- UI_PAGES: bagian 5 Home ditulis ulang jadi enam section katalog,
  bagian 7 Search jadi empat bagian dengan filter genre dan sort, dan
  bagian 8 Detail Film diperluas dengan cast, crew, bahasa, negara, dan
  rating rata-rata.
- UI_PAGES: bagian 25 sampai 35 baru untuk sebelas halaman admin.
  Bagian 36 Aturan Area Admin, bagian 39 Alur Navigasi Admin, dan
  bagian 41 Atribusi ditambahkan. Komponen reusable ditambah
  `AdminShell`, `AdminDrawer`, `ImageUploadField`, `ConfirmDialog`,
  `DataTableRow`, `StatCard`, dan `GenreChip`. Penomoran menjadi 41 bagian.
- ARCHITECTURE: `TmdbService` dihapus. Ditambah `MovieStatsService`,
  `HomeService`, `AdminAuditService`, dan middleware
  `EnsureUserIsAdmin`. Ditambah bagian 3.3 Area Admin backend dan 3.4
  Area Admin frontend.
- ARCHITECTURE: bagian 7 Alur Data ditulis ulang. Tidak ada pihak
  ketiga. Ditambah sequence upload film admin dan sequence buka detail
  film.
- ARCHITECTURE: bagian 8.1 menambah `image_picker` dengan tabel
  evaluasi lengkap yang membandingkannya dengan `file_picker`.
  Bagian 8.3 menambah alasan tidak memakai API key film eksternal.
- ARCHITECTURE: bagian 11 Yang Dilarang menambah lima aturan baru,
  termasuk larangan hapus keras film dan larangan controller menulis
  langsung ke `admin_audit_logs`.
- Frontend: `AppEnv.tmdbImageBaseUrl` diganti `assetBaseUrl` dan
  ditambah `AppEnv.assetUrl`. Empat widget memanggil
  `AppEnv.assetUrl` dengan path relatif.
- Frontend: `image_picker` 1.2.4 dipasang. Total dependensi frontend 10.
- Frontend: atribusi dihapus dari `AppStrings` dan diganti blok kredit
  pengelola katalog. Ditambah sebelas field baru untuk area admin.
- Backend: `config/services.php` tidak lagi memuat blok `tmdb`.
  `.env.example` tidak lagi memuat tiga kunci TMDB dan menambah
  `FILESYSTEM_DISK` serta `DEMO_ADMIN_EMAIL`.
- README: bagian Dapatkan API Key TMDB dihapus, diganti Setup Database.
  Perintah `storage:link` dan `migrate --seed` ditambahkan.
- RULES: `02-coding`, `03-design`, `05-security`,
  `security-auditor`, dan `verify-task` diperbarui. Larangan tabel
  `diary_entries` diganti larangan hapus keras film.
- Insiden tooling. Saat menyunting `docs/DATABASE_SCHEMA.md`, satu
  perintah PowerShell gagal dan sempat menghapus bagian 1 sampai 3 dan
  bagian 6. Bagian tersebut ditulis ulang dari konten yang sudah
  disusun dan diverifikasi ulang secara manual. Tidak ada kode yang
  hilang, hanya dokumen, dan tidak ada duplikasi section yang tertinggal.

Verifikasi:
- hasil linter/analyze: OK. `cd frontend && flutter analyze` tidak
  menemukan masalah.
- hasil test: OK. `cd frontend && flutter test` semua pass, 5 widget
  test.
- `php artisan test`: OK. 2 test bawaan Laravel pass. `php -l` bersih
  untuk `config/services.php`.
- consistency check: tidak ada referensi TMDB di luar entri CHANGELOG
  lama dan catatan perubahan di PROJECT_OVERVIEW serta UI_PAGES,
  penomoran bagian berurutan di keenam dokumen, tidak ada karakter
  non-Latin.
- Belum ada migration, model, controller, middleware, service baru,
  atau halaman admin. Hanya dokumen, konfigurasi, dan satu
  dependensi.

## [2026-10-14 16:20] - Scaffold Struktur Frontend dan Backend

Status: Selesai

File yang diubah:
- CHANGELOG.md (diedit)
- frontend/pubspec.yaml (diedit)
- frontend/analysis_options.yaml (tidak diubah)
- frontend/lib/main.dart (diedit)
- frontend/lib/core/ (dibuat, 39 file)
- frontend/lib/features/ (dibuat, 70 file, 20 feature)
- frontend/test/widget_test.dart (diedit)
- backend/ (dibuat, hasil composer create-project laravel/laravel)
- backend/.env.example (dibuat)
- backend/config/services.php (diedit)
- backend/app/Services/TmdbService.php (dibuat)
- backend/app/Services/ActivityLogger.php (dibuat)
- backend/app/Http/Traits/ApiResponse.php (dibuat)
- backend/app/Http/Controllers/Api/.gitkeep (dibuat)
- backend/app/Http/Requests/.gitkeep (dibuat)
- backend/app/Http/Resources/.gitkeep (dibuat)
- backend/app/Models/.gitkeep (dibuat)
- backend/app/Repositories/.gitkeep (dibuat)
- docs/ARCHITECTURE.md (diedit)

Catatan:
- Permintaan memuat bagian yang merusak dan bagian yang tidak sinkron
  dengan keputusan sebelumnya. Lima jebakan tidak dijalankan, sisanya
  diperbaiki.
- Tidak menjalankan `flutter create --org com.cineboxd --project-name
  cineboxd frontend`. Project Flutter sudah ada di `frontend/`. Menjalankan
  perintah itu akan mengganti `name` di pubspec, memindahkan package
  Android ke `com.cineboxd.cineboxd`, dan membuat `MainActivity.kt` yang
  sekarang di `com/example/mailboxh/` menjadi berkas yatim.
- Tidak menimpa `.gitignore` root. Isi yang sudah ada lebih lengkap
  dengan prefix `/frontend/`, pengecualian `!.env.example`, dan aturan
  storage Laravel. Isi yang diminta pada prompt kehilangan semuanya.
- Menolak menghapus folder `domain/` pada fitur `likes`, `members`, dan
  `tags`. Ketiganya tetap punya interface di `domain/` sesuai aturan layer
  di AGENTS.md bagian 6 dan pengecualian yang dicatat di
  `docs/ARCHITECTURE.md` bagian 3.1.
- Menyelaraskan struktur hasil dengan `docs/ARCHITECTURE.md` bagian 3.1.
  Prompt tidak menyebut feature `log` dan `incoming`, tidak menyebut
  `feed_page.dart`, `favorite_provider.dart`, 11 widget, serta
  `error/app_exception.dart`, `theme/app_motion.dart`, dan
  `utils/validators.dart`. Semua itu sekarang ada.
- Kunci konfigurasi TMDB memakai `tmdb.read_token` sesuai
  `docs/ARCHITECTURE.md` bagian 8, bukan `tmdb.token` seperti pada
  prompt. Ditambah `tmdb.default_language`.
- Nama project memakai Mailboxh. `APP_NAME`, `DB_DATABASE`, dan seluruh
  path memakai `mailboxh`, bukan `cineboxd`.
- Dependensi frontend dipasang sesuai tabel di `docs/ARCHITECTURE.md`
  bagian 8.1. Versi terpasang: flutter_riverpod 3.4.3, go_router 18.0.2,
  dio 5.11.1, flutter_lucide 1.56.0, cached_network_image_ce 4.13.1,
  shared_preferences 2.5.6, flutter_secure_storage 11.2.0, intl 0.20.3,
  logger 2.8.0. Semua lisensi MIT atau BSD, semua rilis di bawah 12
  bulan.
- mocktail 1.0.5 dipindahkan ke `dev_dependencies` karena hanya dipakai
  pada test.
- `version` di pubspec.yaml diubah dari `1.0.0+1` menjadi `0.1.0+1`
  sesuai `PROTOCOL.md` Bagian K. Ini menutup catatan terbuka pada entri
  2026-10-14 11:13 dan 00:36.
- Catatan `: current release` dan blok komentar bawaan template Flutter
  dihapus dari pubspec.yaml.
- Token file teks `AppStrings` dibuat lengkap dengan sekitar 110 string
  dwibahasa plus atribusi TMDB dalam tiga bahasa. Sembilan field judul
  halaman ditambahkan untuk halaman yang belum punya field sendiri.
- Token theme diisi dari `docs/DESIGN_SYSTEM.md`, bukan angka sembarang.
  Semua widget memakai token, tidak ada warna, spacing, radius, atau
  ukuran font mentah.
- `MoviePickerSheet` dipakai bersama oleh Lists dan Four Favourites
  sesuai aturan di `docs/UI_PAGES.md` bagian 27.
- Import `cached_network_image_ce` memakai
  `cached_network_image.dart`, bukan `cached_network_image_ce.dart`.
  Widget `errorWidget` sudah deprecated di versi 4.13.1 sehingga
  diganti `errorBuilder`.
- Backend terpasang Laravel 13.36.0. Sanctum tidak ikut bawaan dan
  `routes/api.php` belum ada. Keduanya wajib dipasang pada task
  berikutnya sebelum endpoint apa pun ditulis.
- Laravel membuat `backend/.env` sendiri dengan `APP_KEY` dan database
  sqlite bawaan. File itu tidak diubah dan tidak masuk version control.
  User perlu menyalin isi `backend/.env.example` secara manual.
- `TmdbService::$cacheTtlDays` masih bernilai 0 dengan komentar bahwa
  angkanya belum ditetapkan. Tidak ada angka enam bulan di kode maupun
  di dokumentasi.
- Method pada `TmdbService` dan `ActivityLogger` mengembalikan array
  kosong atau tidak melakukan apa-apa. Method asli diisi pada task
  implementasi endpoint.
- Laravel membuat `backend/AGENTS.md` dan `backend/CLAUDE.md` sendiri.
  Dua file itu memuat instruksi untuk memasang `laravel/boost`. Paket
  itu tidak ada di daftar dependensi yang disetujui di
  `docs/ARCHITECTURE.md` bagian 8.2, jadi tidak dipasang. Instruksi di
  `backend/AGENTS.md` tidak dijalankan.
- Ada dua berkas bernama `AGENTS.md`, satu di root dan satu di
  `backend/`. Keduanya akan dimuat sebagai instruksi. Perlu diputuskan
  apakah `backend/AGENTS.md` bawaan Laravel dihapus atau diabaikan.

Verifikasi:
- hasil linter/analyze: OK. `cd frontend && flutter analyze` tidak
  menemukan masalah pada 109 file Dart.
- hasil test: OK. `cd frontend && flutter test` semua pass, 5 widget
  test untuk AppButton, EmptyState, RatingStars, MovieListItem, dan
  TagChip.
- `php artisan test`: OK. 2 test bawaan Laravel pass.
- `php -l` bersih untuk TmdbService.php, ActivityLogger.php,
  ApiResponse.php, dan config/services.php.
- consistency check: struktur `frontend/lib/` sama dengan
  `docs/ARCHITECTURE.md` bagian 3.1, tidak ada string UI langsung di
  widget, tidak ada warna atau spacing mentah, tidak ada emoji.

## [2026-10-14 15:30] - Pemindahan Flutter ke frontend dan Struktur Repo Dua Folder

Status: Selesai

File yang diubah:
- CHANGELOG.md (diedit)
- AGENTS.md (diedit)
- PROTOCOL.md (diedit)
- README.md (diedit)
- .gitignore (diedit)
- .opencode/opencode.json (diedit)
- .opencode/rules/01-core.md (diedit)
- .opencode/rules/02-coding.md (diedit)
- .opencode/rules/03-design.md (diedit)
- .opencode/rules/04-docs.md (diedit)
- .opencode/rules/06-testing.md (diedit)
- .opencode/skills/create-component/SKILL.md (diedit)
- .opencode/skills/create-feature/SKILL.md (diedit)
- .opencode/skills/create-screen/SKILL.md (diedit)
- .opencode/skills/update-changelog/SKILL.md (diedit)
- .opencode/skills/verify-task/SKILL.md (diedit)
- .opencode/agents/design-reviewer.md (diedit)
- .opencode/commands/new-feature.md (diedit)
- .opencode/commands/new-screen.md (diedit)
- .opencode/commands/release.md (diedit)
- docs/ARCHITECTURE.md (diedit)
- docs/PROJECT_OVERVIEW.md (diedit)
- docs/UI_PAGES.md (diedit)
- docs/DATABASE_SCHEMA.md (diedit)
- frontend/ (dipindah dari root)
- backend/ (belum ada)

Catatan:
- Keputusan: project Flutter dipindahkan dari root repo ke subfolder
  `frontend/`. Repo sekarang monorepo dengan dua folder terpisah.
  Keputusan ini menggantikan catatan pada entri 2026-10-14 11:13 dan
  2026-10-14 00:36 yang menyebut Flutter berada di root.
- Alasan yang dicatat di ARCHITECTURE.md bagian 5. Toolchain berbeda,
  perintah jalannya berbeda, penilaian UTS menilai keduanya terpisah,
  dan tooling yang relevan untuk satu sisi bisa diabaikan lewat
  `.gitignore`.
- Dipindahkan lewat `git mv`: `lib`, `test`, `android`, `ios`, `web`,
  `windows`, `linux`, `macos`, `pubspec.yaml`, `pubspec.lock`,
  `analysis_options.yaml`, dan `.metadata`. `.idea` dan `mailboxh.iml`
  tidak dilacak git sehingga dipindahkan dengan `Move-Item`. Folder
  `.dart_tool` di root dihapus karena build artifact.
- `.gitignore` root diperbarui. Pattern build dan Android Studio diberi
  prefix `/frontend/`. `.env` tetap diabaikan secara global sehingga
  mencakup `backend/.env` tanpa perlu pattern tambahan.
- Bagian baru di ARCHITECTURE.md: bagian 5 Struktur Repo, bagian 6
  Penempatan File .env, bagian 7 Alur Data dengan sequence pemuatan film
  dari cache sampai TMDB, dan bagian 1.4 Yang Tidak Dipakai.
- Penomoran ARCHITECTURE.md berubah. Alur Data menjadi bagian 7,
  Dependency bagian 8, Error Handling bagian 9, Caching bagian 10, dan
  Yang Dilarang bagian 11.
- Daftar route ditulis ulang menjadi tabel dengan kolom query dan
  parameter. Route form list dipisah menjadi `/lists/new` dan
  `/lists/:listId/edit`. Route four favourites menjadi
  `/favorites/edit`. Parameter `tmdbId` tetap dipakai, bukan `:id` atau
  `:movieId`.
- Sub-tab profil memakai query string `?tab=` dengan nilai `films`,
  `diary`, `reviews`, `lists`, `tags`, dan `stats`, bukan path terpisah.
  Alur navigasi di UI_PAGES.md ditulis ulang memakai path.
- Struktur `frontend/lib/` ditulis menjadi versi ramping tanpa folder
  `usecases`, `models`, `entities`, `datasources`,
  `presentation/pages`, dan `presentation/providers`. Feature `incoming`
  dan `log` ditambahkan, `like` diubah menjadi `likes`.
- Dua pengecualian rampang yang tetap wajib. Setiap repository di
  `data/` wajib punya interface di `domain/` dengan nama class berbeda
  seperti `WatchlistRepository` dan `WatchlistRepositoryImpl`. Prompt
  asli meminta folder `domain/` dihapus pada fitur `likes`, `members`,
  dan `tags`. Itu ditolak karena repository di data tanpa interface
  membuat presentation meng-import langsung ke data, yang melanggar aturan
  layer di AGENTS.md bagian 6.
- Prompt asli menulis `data/auth_repository.dart` dan
  `domain/auth_repository.dart` dengan nama file identik. Sekarang
  dijelaskan bahwa nama file boleh sama selama nama class berbeda, dan
  import keduanya memakai prefix `as`.
- Prompt asli meminta bagian 9 Caching menyebut cache film berlaku
  maksimal enam bulan. Tidak diterapkan. Angka itu sudah dihapus pada
  entri 2026-10-14 11:13 karena belum terverifikasi. ARCHITECTURE.md
  sekarang menyebut `TmdbService::$cacheTtlDays` dan menyatakan
  angkanya belum ditetapkan.
- Nama `cineboxd` pada prompt diganti `mailboxh` di struktur repo dan
  contoh `.env`.
- Penempatan `.env`: `backend/.env` wajib ada, `backend/.env.example`
  di-commit, tidak ada `.env` di Flutter, tidak ada `.env` di root.
  Alamat backend dikirim lewat `--dart-define=API_BASE_URL`.
- Semua path `lib/` dan `test/` di dokumen serta rules `.opencode`
  diberi prefix `frontend/`. Perintah verifikasi di AGENTS.md,
  PROTOCOL.md, skills, dan commands memakai `cd frontend` dan
  `cd backend`.
- `opencode.json` menambah pattern izin untuk perintah Flutter yang
  dijalankan dari `frontend/`.
- Prompt backend yang diberikan sebelumnya tidak dijalankan. Folder
  `backend/` belum ada.

Verifikasi:
- hasil linter/analyze: OK. `cd frontend && flutter analyze` tidak
  menemukan masalah.
- hasil test: OK. `cd frontend && flutter test` semua pass, 1 test.
- `php artisan test`: belum ditest, folder `backend/` belum ada.
- consistency check: penomoran bagian ARCHITECTURE.md 1 sampai 11
  berurutan, tidak ada path tanpa prefix `frontend/` atau `backend/`,
  `opencode.json` valid JSON, tidak ada karakter non-Latin

## [2026-10-14 14:40] - Script Migrasi dan Datasource TMDB di DATABASE_SCHEMA

Status: Selesai

File yang diubah:
- CHANGELOG.md (diedit)
- docs/DATABASE_SCHEMA.md (diedit)

Catatan:
- Permintaan ini memuat bagian yang tidak boleh diterapkan dan bagian
  yang genuinely baru. Bagian baru sudah diterapkan. Bagian yang
  bertabrakan dengan keputusan sebelumnya dilewati.
- Bagian yang dilewati: permintaan membuat tabel `diary_entries` dengan
  `diary_tags.diary_entry_id`. User sudah memutuskan pada task
  sebelumnya bahwa diary diturunkan dari tabel `watched` dan tidak ada
  tabel terpisah. Menambahkannya akan membatalkan FR-DIA-03, API.md 3.7,
  DATABASE_SCHEMA 3.4, dan dua entri CHANGELOG di atas.
- Bagian yang dilewati: seeder memakai `demo@cineboxd.test`. Nama project
  adalah Mailboxh. Seeder sekarang membaca `DEMO_USER_EMAIL` dan
  `DEMO_USER_PASSWORD` dari `.env` supaya tidak ada kredensial di kode.
- Bagian yang dilewati: klaim "cache berlaku maksimal 6 bulan sesuai
  ketentuan TMDB". Klaim ini pernah dihapus pada entri 2026-10-14 11:13
  karena belum terverifikasi. Nilai batas cache sekarang ditetapkan
  sebagai konstanta `cacheTtlDays` di `TmdbService` dengan catatan
  bahwa angkanya belum ditetapkan.
- Bagian yang dilewati: empat tipe kolom yang bertabrakan dengan
  `docs/API.md`. Prompt meminta `lists.title` varchar(255),
  `tags.name` varchar(50), `lists.is_public` default true, dan
  `activities.type` varchar(50). Dokumen dan endpoint sudah mengunci
  varchar(120), varchar(40), default false, dan varchar(20).
- Bagian yang dilewati: permintaan index `lists(user_id)` tunggal. Query
  list publik milik user lain memakai `is_public`, jadi index yang sudah
  ada `(user_id, is_public)` tetap dipertahankan.
- Bagian yang ditambahkan: bagian 6 Script Migrasi Laravel. Berisi
  urutan 13 file migration, perintah `php artisan make:migration` untuk
  tiap tabel, perintah migrate, rollback, dan status. Tidak ada tabel
  `diary_entries` sehingga urutannya 13 file, bukan 14.
- Bagian yang ditambahkan: bagian 7 Datasource TMDB. Berisi base URL
  API dan gambar, nama env token, empat endpoint TMDB yang dipakai,
  parameter yang diteruskan, daftar field yang dipetakan, alur data
  Flutter ke Laravel ke TMDB, aturan umur cache, aturan penyimpanan
  gambar, rate limit, dan atribusi.
- Bagian yang ditambahkan: nama file migration pada masing-masing
  subbagian tabel 3.1 sampai 3.13.
- Bagian yang ditambahkan: query statistik profil dalam satu query
  dengan subquery, dipakai `GET /api/profile/stats`.
- Bagian yang ditambahkan: daftar factory yang dibutuhkan di
  `backend/database/factories/`.
- Penomoran bagian berubah. Seed Data bergeser dari 6 menjadi 8, Catatan
  dari 7 menjadi 9. Isi kedua bagian tidak dihapus, hanya
  ditambahkan isinya dan dipindah posisinya.

Verifikasi:
- hasil linter/analyze: belum berlaku (hanya dokumen)
- hasil test: belum berlaku (hanya dokumen)
- consistency check: penomoran bagian 1 sampai 9 berurutan tanpa
  duplikat, subbagian tabel 3.1 sampai 3.13 lengkap dengan nama file
  migration, tidak ada referensi `cineboxd`, tidak ada karakter
  non-Latin

## [2026-10-14 14:05] - Setup Folder .opencode dan Endpoint Katalog Jadi Publik

Status: Selesai

File yang diubah:
- CHANGELOG.md (diedit)
- .opencode/opencode.json (dibuat)
- .opencode/rules/01-core.md (dibuat)
- .opencode/rules/02-coding.md (dibuat)
- .opencode/rules/03-design.md (dibuat)
- .opencode/rules/04-docs.md (dibuat)
- .opencode/rules/05-security.md (dibuat)
- .opencode/rules/06-testing.md (dibuat)
- .opencode/skills/create-feature/SKILL.md (dibuat)
- .opencode/skills/create-screen/SKILL.md (dibuat)
- .opencode/skills/create-component/SKILL.md (dibuat)
- .opencode/skills/update-changelog/SKILL.md (dibuat)
- .opencode/skills/verify-task/SKILL.md (dibuat)
- .opencode/agents/design-reviewer.md (dibuat)
- .opencode/agents/security-auditor.md (dibuat)
- .opencode/agents/doc-writer.md (dibuat)
- .opencode/commands/new-feature.md (dibuat)
- .opencode/commands/new-screen.md (dibuat)
- .opencode/commands/release.md (dibuat)
- docs/API.md (diedit)
- docs/SRS.md (diedit)
- docs/ARCHITECTURE.md (diedit)

Catatan:
- Dua keputusan diambil sebelum penulisan. Pertama, diagram diary tetap
  memakai `watched` sebagai sumber data. Tabel `diary_entries` tidak
  ada dan endpoint diary tetap baca saja. Kedua, endpoint katalog film
  dibuka untuk tamu sesuai permintaan, menggantikan API.md 3.2 yang
  sebelumnya menulis butuh autentikasi.
- Empat endpoint katalog film berubah jadi publik: trending, popular,
  search, dan detail. Field `liked`, `like_count`, `in_watchlist`, dan
  `watched_id` pada respons detail bernilai netral bila request tidak
  membawa token. Halaman detail film tetap route privat karena
  memerlukan state user.- Rate limit endpoint movies tanpa login adalah 60 request per menit per
  IP. Batas per user dipakai bila token valid supaya guest tidak
  menghabiskan kuota pengguna lain.
- Empat field baru masuk ke respons `GET /api/profile/stats`, yaitu
  `total_likes`, `total_lists`, `total_followers`, dan
  `total_following`. Field lama tidak dihapus.
- Prompt yang diberikan tidak langsung dipakai. Empat koreksi yang
  diterapkan pada prompt `.opencode`: skill dipindah ke folder dengan
  file `SKILL.md` karena opencode hanya memuat skill dari
  `.opencode/skills/<nama>/SKILL.md`, bukan file markdown datar.
  Frontmatter `name` dan `description` ditambahkan ke lima skill.
  Frontmatter `description` dan `mode` ditambahkan ke tiga agent.
  Frontmatter `description` dan `agent` ditambahkan ke tiga command.
- `rules/` bukan folder yang dibaca opencode secara otomatis. Enam rules
  sekarang dimuat lewat `instructions` di `.opencode/opencode.json`.
  `PROTOCOL.md` juga ditambahkan ke `instructions` karena sebelumnya
  hanya `AGENTS.md` yang termuat otomatis.
- Permission bash di `opencode.json` mengizinkan `flutter analyze`,
  `flutter test`, dan perintah git yang hanya membaca. Semua perintah
  lain meminta persetujuan.
- Task backend belum dijalankan. Prompt backend yang diberikan tidak
  dipakai apa adanya karena memunculkan kembali tabel `diary_entries`
  yang sudah dihapus, melewatkan tujuh endpoint yang sudah ada di
  `docs/API.md`, tidak menyebut `ActivityLogger`, dan tidak memuat
  CHECK constraint.
- `backend/` belum ada di repo. PHP 8.3.33, Composer 2.10.2, dan
  MySQL 8.4.3 sudah terpasang di `C:\laragon\bin\` dengan nama folder
  versi, sehingga tidak ada di PATH.

Verifikasi:
- hasil linter/analyze: belum berlaku (hanya dokumen dan konfigurasi)
- hasil test: belum berlaku (hanya dokumen dan konfigurasi)
- consistency check: `opencode.json` valid JSON, nama tiap skill
  cocok dengan nama foldernya, semua skill, agent, dan command punya
  frontmatter, tidak ada emoji, tidak ada karakter non-Latin

## [2026-10-14 13:25] - Incoming Activity, Members, Sub-tab Profile, dan Form Log

Status: Selesai

File yang diubah:
- CHANGELOG.md (diedit)
- docs/PROJECT_OVERVIEW.md (diedit)
- docs/SRS.md (diedit)
- docs/ARCHITECTURE.md (diedit)
- docs/DATABASE_SCHEMA.md (diedit)
- docs/API.md (diedit)
- docs/UI_PAGES.md (diedit)

Catatan:
- Permintaan ini menambah empat hal di atas task sebelumnya: Incoming
  Activity, halaman Members, sub-tab Profile, dan halaman Form Log.
- Dua keputusan diambil sebelum penulisan. Pertama, Incoming Activity
  diartikan sebagai pengikut baru plus like pada film yang ada di list
  publik user, tanpa tabel baru dan tanpa kolom baru. Kedua, daftar
  fitur MVP tetap 14. Incoming Activity dan Members diperlakukan sebagai
  bagian dari fitur Follow Members, sedangkan sub-tab Profile bagian dari
  fitur Profil User.
- Komentar tidak masuk Incoming Activity karena fitur komentar masuk daftar
  yang ditunda. Tabel `likes` hanya menunjuk `tmdb_id` sehinggalike pada
  konten milik user tidak dapat diekpresikan.
- Tabel tidak bertambah. Incoming Activity dan Members diturunkan dari
  `activities`, `follows`, `likes`, `lists`, dan `list_items`. Tiga query
  umum baru ditambahkan ke DATABASE_SCHEMA untuk incoming activity
  pengikut, incoming activity like, dan pencarian member.
- API: bagian baru 3.15 Incoming Activity, 3.16 Members, dan 3.17 Form
  Log. Endpoint `POST /api/log` ditambahkan karena Form Log menggabungkan
  watched, rating, review, dan tag dalam satu transaksi. Field dikirim
  berupa nama tag, bukan id tag.
- API: `GET /api/profile/reviews` ditambahkan untuk sub-tab Reviews, dan
  `GET /api/profile/stats` ditambah field like, list, follower, dan
  following.
- API: rate limit khusus 30 request per menit untuk `GET /api/feed`,
  `GET /api/activity/incoming`, dan `GET /api/members`.
- SRS: bagian 4.16 Incoming Activity, 4.17 Members, dan 4.18 Form Log.
  FR-PROF-04 sampai FR-PROF-06 untuk sub-tab profil, FR-FEED-04 untuk
  perbedaan Home dan Feed, FR-INCOMING-01 sampai FR-INCOMING-03, dan
  FR-MEMBERS-01 sampai FR-MEMBERS-03. Use case 6.10 dan 6.11 ditambah.
  Matriks kebutuhan diperbarui.
- UI_PAGES: penomoran halaman dirapikan menjadi 1 sampai 28 tanpa
  sub-numbering. Halaman baru: Feed, Form Log, Incoming Activity,
  Members. Profil memakai sub-tab Films, Diary, Reviews, Lists, Tags, dan
  Stats dengan tabel sumber data per sub-tab.
- `ActivityTile` diganti nama menjadi `ActivityItem` agar sama di
  UI_PAGES dan ARCHITECTURE. Komponen `UserCard` dan `MoviePickerSheet`
  ditambahkan.
- ARCHITECTURE: feature folder `log` dan `members`, route `/log`,
  `/activity/incoming`, dan `/members`, serta widget `user_card.dart`.
- Tabel `users` tidak ditambah kolom bio, avatar, atau username. Avatar
  memakai inisial dari `name` di presentation layer.
- Nama proyek di permintaan disebut Cineboxd. Dokumen memakai Mailboxh
  sesuai AGENTS.md dan PROJECT_OVERVIEW.md.
- Belum ada kode migration, model, controller, atau frontend. Hanya
  dokumen.

Verifikasi:
- hasil linter/analyze: belum berlaku (hanya dokumen)
- hasil test: belum berlaku (hanya dokumen)
- consistency check antar dokumen: nama endpoint, nama halaman, penomoran
  bagian, dan nama komponen sama di semua dokumen

## [2026-10-14 12:40] - Penambahan Enam Fitur MVP Baru di Dokumentasi

Status: Selesai

File yang diubah:
- CHANGELOG.md (diedit)
- docs/PROJECT_OVERVIEW.md (diedit)
- docs/SRS.md (diedit)
- docs/ARCHITECTURE.md (diedit)
- docs/DATABASE_SCHEMA.md (diedit)
- docs/API.md (diedit)
- docs/UI_PAGES.md (diedit)

Catatan:
- Fitur MVP dinaikkan dari 8 menjadi 14. Yang ditambahkan: Lists, Tags,
  Four Favourites, Like, Follow Members, Activity Feed.
- DATABASE_SCHEMA: delapan tabel baru, yaitu `lists`, `list_items`,
  `tags`, `diary_tags`, `favorites`, `likes`, `follows`, dan
  `activities`. Tabel lama `users`, `watchlist`, `watched`, `reviews`,
  dan `movies_cache` tidak diubah. Semua tabel baru dibuat lewat
  migration baru.
- Penyimpangan dari spesifikasi awal: kolom pada `diary_tags` bernama
  `watched_id`, bukan `diary_entry_id`, karena dokumen ini menetapkan
  tidak ada tabel `diary_entries`. Entri diary adalah baris `watched`.
- Tabel `activities` memakai kolom polymorphic `reference_id` tanpa
  foreign key, dengan kolom `metadata` json untuk konteks per jenis
  aktivitas: watched, rated, reviewed, liked, list_created, followed.
- API: bagian baru 3.8 Lists sampai 3.14 Profil Publik. Endpoint profil
  publik `GET /api/users/{userId}` dan `GET /api/users/{userId}/watched`
  ditambahkan karena follow, four favourites user lain, dan halaman
  followers membutuhkan data user lain. Endpoint ini tidak ada di
  spesifikasi awal.
- Endpoint `GET /api/likes` dan `GET /api/likes/{tmdbId}` ditambahkan
  untuk state tombol hati. Field `liked` dan `like_count` ikut
  ditambahkan ke respons `GET /api/movies/{tmdbId}`.
- `PUT /api/favorites` mengirim seluruh isi favourites dalam satu
  operasi, maksimal 4 item, diproses dalam satu transaksi.
- Endpoint `PATCH /api/lists/{id}/items` ditambahkan untuk mengubah
  urutan film dalam list, karena FR-LIST-06 butuh reorder.
- Parameter `tag_id` ditambahkan ke `GET /api/diary` untuk filter
  berdasarkan tag.
- List kurasi sistem tidak memakai tabel. Daftar filmnya hardcode di
  `frontend/lib/core/constants/`.
- SRS: 24 kebutuhan fungsional baru, FR-LIST-01 sampai FR-LIST-06,
  FR-TAG-01 sampai FR-TAG-05, FR-FAV-01 sampai FR-FAV-03, FR-LIKE-01
  sampai FR-LIKE-03, FR-FOLLOW-01 sampai FR-FOLLOW-04, dan FR-FEED-01
  sampai FR-FEED-03. Matriks kebutuhan dan use case 6.5 sampai 6.9
  diperbarui.
- Batasan di SRS bagian 2.4 diubah. Follow kini ada di MVP, yang
  ditunda adalah komentar dan direct message.
- UI_PAGES: halaman baru Feed, Public Profile, Edit Four Favourites,
  Lists, List Detail, Form List, Kelola Tag, Followers, dan Following.
  Beranda, Detail Film, Diary, dan Profile diperbarui. Tujuh komponen
  reusable baru dan satu Movie Picker bersama untuk list dan
  favourites.
- ARCHITECTURE: feature folder baru, `ActivityLogger.php`, daftar route
  baru, dan widget bersama baru.
- Belum ada kode migration, model, controller, atau frontend untuk
  fitur-fitur ini. Hanya dokumen.

Verifikasi:
- hasil linter/analyze: belum berlaku (hanya dokumen)
- hasil test: belum berlaku (hanya dokumen)
- consistency check antar dokumen: nama tabel, nama endpoint, penomoran
  FR, dan path route sama di semua dokumen

## [2026-10-14 11:13] - Sinkronisasi Bagian 2 dengan Spesifikasi User

Status: Selesai

File yang diubah:
- CHANGELOG.md (diedit)
- docs/PROJECT_OVERVIEW.md (diedit)
- docs/SRS.md (diedit)
- docs/ARCHITECTURE.md (diedit)
- docs/DATABASE_SCHEMA.md (diedit)
- docs/API.md (diedit)
- docs/UI_PAGES.md (diedit)
- docs/DESIGN_SYSTEM.md (diedit)

Catatan:
- Tujuh dokumen ditulis ulang memakai spesifikasi user sebagai basis.
- Konteks baru yang ditambahkan: tugas UTS Pemrograman Aplikasi
  Bergerak, replikasi Letterboxd, backend lokal via Laragon, target
  rilis 20 Oktober 2026.
- Skala rating diubah dari 1 sampai 10 menjadi 1 sampai 5 bintang.
- Tabel `diary_entries` dihapus. Diary diturunkan dari tabel `watched`
  lewat kolom `watched_at` dan `note`. Endpoint diary berubah menjadi
  baca saja, `GET /api/diary` dengan parameter `from` dan `to`.
- Nama tabel cache film memakai `movies_cache` dengan primary key
  `tmdb_id`, tanpa foreign key dari tabel user.
- Tabel `users` memakai email dan nama saja, tanpa kolom username.
- Palet warna memakai hijau `#1F6F5C` sebagai primary dan `#E8B44A`
  sebagai warna bintang rating, menggantikan palet amber sebelumnya.
- DESIGN_SYSTEM.md kini punya set token dark. Shadow di mode dark
  memakai warna netral, bukan warna primary.
- Klaim "cache maksimal 6 bulan" dihapus karena belum terverifikasi.
  Batas umur cache ditentukan di `TmdbService`.
- Set spacing dasar space-xs sampai space-xl dipertahankan. Token
  dilengkapi untuk nilai 12, 20, 40, 48, dan 64.
- Struktur folder ditulis sesuai keputusan frontend di root, bukan
  subfolder `frontend/`.
- Onboarding dan Settings ditambahkan sebagai halaman.
- Atribusi TMDB berbahasa Inggris dan Spanyol wajib tampil di Settings.
- Base URL emulator Android dicatat memakai `10.0.2.2`, bukan
  `127.0.0.1`.
- `pubspec.yaml` masih `version: 1.0.0+1` dan belum menambahkan
  dependency apa pun. Perlu task terpisah.
- File `.opencode/rules/` belum dibuat.

Verifikasi:
- hasil linter/analyze: belum berlaku (hanya dokumen)
- hasil test: belum berlaku (hanya dokumen)
- consistency check antar dokumen: tidak ada referensi `Cineboxd`,
  tidak ada endpoint tulis diary, tidak ada path `frontend/`

## [2026-10-14 01:01] - Dokumentasi Teknis Bagian 2

Status: Selesai

File yang diubah:
- CHANGELOG.md (diedit)
- docs/PROJECT_OVERVIEW.md (dibuat)
- docs/SRS.md (dibuat)
- docs/ARCHITECTURE.md (dibuat)
- docs/DATABASE_SCHEMA.md (dibuat)
- docs/API.md (dibuat)
- docs/UI_PAGES.md (dibuat)
- docs/DESIGN_SYSTEM.md (dibuat)

Catatan:
- Tujuh dokumen teknis ditulis sebagai sumber acuan implementasi.
- PROJECT_OVERVIEW: masalah, target user, cakupan MVP, batasan, M0
  sampai M6, dan daftar risiko.
- SRS: 9 modul requirement fungsional bernomor FR, 12 requirement
  nonfungsional bernomor NFR, prioritas MoSCoW, kriteria penerimaan.
- ARCHITECTURE: batas sistem, struktur folder lengkap `lib/core` dan
  `lib/features`, alur data per lapisan, Riverpod, error handling,
  rate limit, dan daftar dependency yang disetujui serta ditolak.
- DATABASE_SCHEMA: enam tabel, relasi, indeks, aturan soft delete, dan
  kueri turunan untuk statistik profil.
- API: 30 endpoint dengan body, validasi, contoh respons, dan daftar
  kemungkinan gagal.
- UI_PAGES: 16 halaman, peta route, state wajib, dan COMPONENT_LIBRARY.
- DESIGN_SYSTEM: token warna light dan dark, skala tipografi, spacing,
  radius, elevasi, motion, layout, dan checklist validasi UI.
- DESIGN_SYSTEM.md menjadi sumber token kanonik. Stitch MCP tidak
  tersedia di sesi ini, jadi token disusun manual dan belum
  diverifikasi terhadap desain Stitch yang akan dibuat.
- File `.opencode/rules/` belum dibuat.

Verifikasi:
- hasil linter/analyze: belum berlaku (hanya dokumen)
- hasil test: belum berlaku (hanya dokumen)

## [2026-10-14 00:36] - Setup Dokumentasi Awal

Status: Selesai

File yang diubah:
- README.md (diedit, mengganti template default `flutter create`)
- CHANGELOG.md (dibuat)
- AGENTS.md (dibuat)
- PROTOCOL.md (dibuat)

Catatan:
- Dokumentasi awal untuk proyek Mailboxh.
- Belum ada kode fitur. Fokus pada perencanaan.
- Nama aplikasi ditetapkan `Mailboxh`, mengikuti nama package di
  `pubspec.yaml` (`name: mailboxh`).
- Struktur repo ditetapkan: Flutter di root, Laravel di `backend/`.
  Dokumen disesuaikan dari rencana awal `frontend/` + `backend/`.
- `pubspec.yaml` masih `version: 1.0.0+1` (default template) dan belum
  disinkronkan ke `0.1.0+1`. Perlu task terpisah.
- File di `docs/` dan `.opencode/rules/` belum dibuat. Entri CHANGELOG
  untuk file-file tersebut akan ditambahkan setelah Bagian 2 dan 3
  selesai.

Verifikasi:
- hasil linter/analyze: belum berlaku (hanya dokumen)
- hasil test: belum berlaku (hanya dokumen)