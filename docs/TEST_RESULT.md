# Hasil Setup Database Mailboxh

## Waktu Setup

Tanggal: 2026-10-14 21:48

## Waktu Uji Feature

Tanggal: 2026-10-14 22:00

## Environment

- PHP: 8.3.33 (Laragon, `php-8.3.33-Win32-vs16-x64`)
- Laravel: 13.36.0
- MySQL: 8.0.30 (Laragon, `mysql-8.0.30-winx64`)
- Database: `mailboxh` (utf8mb4_unicode_ci)
- Test database: sqlite in-memory (phpunit.xml)

## Feature Test

Total: 87 test, lolos 87, gagal 0. File test: 21 di
`backend/tests/Feature/` (19 sebelumnya ditambah LogTest dan
AdminTagTest).
`backend/tests/Feature/` (Auth, Movie, Watchlist, Watched,
Review, Diary, List, Tag, Favorite, Like, Follow, Feed,
Profile, AdminDashboard, AdminMovie, AdminGenre, AdminUser,
AdminReview, AdminBatchImport).

17 kegagalan berasal dari 2 bug produksi, bukan dari test:

1. 14 test gagal karena `ApiResponse::success()` memakai
   parameter `array $meta = []` tetapi seluruh endpoint store
   memanggil `success($data, null, 201)`. Hasilnya TypeError
   dan respons 500. Terdampak: register, watchlist, watched,
   reviews, diary, lists, list item, tags, attach tag, likes,
   admin genres, admin batch import.
2. 3 test gagal karena `AdminMovieController::validated()`
   memanggil `->toArray()` pada hasil `->except()` yang sudah
   berupa array. Hasilnya 500 pada tambah, edit, dan upload
   poster film. Terdampak: `POST /api/admin/movies`,
   `PUT /api/admin/movies/{id}`.

Kode produksi belum diubah menunggu keputusan user.

## Rate Limit

Aktif di `AppServiceProvider`: auth 5 per menit per IP, tulis 60
per menit per user, baca 120 per menit, movies 60, social 30,
admin 60. Test `AuthTest::test_rate_limit_login` (10x login,
respons terakhir 429) lolos.

## CORS

`backend/config/cors.php` dibuat: paths `api/*`, methods dan
headers wildcard, origins wildcard untuk development,
supports_credentials true. Production wajib mengganti origins
ke domain spesifik.

## Migrasi

Status: sukses. 21 file migrasi berstatus Ran:

- 000000 users, 000001 cache, 000002 jobs (bawaan)
- 000003 movies, 000004 genres, 000005 movie_genres
- 000006 watchlist, 000007 watched, 000008 diary_entries
- 000009 reviews, 000010 lists, 000011 list_items
- 000012 tags, 000013 diary_tags, 000014 favorites
- 000015 likes, 000016 follows, 000017 activities
- 000018 admin_audit_logs, 000019 add_role_to_users
- 000020 personal_access_tokens

Tabel terbentuk: 26 (20 tabel aplikasi plus cache_locks,
failed_jobs, job_batches, migrations, password_reset_tokens,
sessions bawaan Laravel).

## Data Seed

- users: 2 (admin@mailboxh.test role admin, demo@mailboxh.test
  role user)
- genres: 6 (Action, Drama, Comedy, Horror, Romance, Mystery.
  Mystery ikut dibuat karena satu film contoh memakainya)
- movies: 10 film contoh

## Endpoint yang Diuji

| Endpoint | Status |
|---|---|
| GET /api/genres (tanpa token) | 200 |
| GET /api/movies (tanpa token) | 200, 10 film |
| POST /api/login admin | 200, token diterima |
| GET /api/home (dengan token) | 200, enam section |
| GET /api/movies/1 (tanpa token) | 200 |

Isi home: featured 3, latest 10, top_rated 0 (belum ada review,
sesuai spesifikasi minimal 1 review), most_watched 10,
most_watchlisted 10, explore 10.

## Error yang Ditemukan dan Diperbaiki

1. Model `Watched` dan `Watchlist` tidak punya properti `$table`,
   sehingga query memakai `watcheds` dan `watchlists` yang tidak
   ada. Diperbaiki dengan `$table = 'watched'` dan
   `$table = 'watchlist'`.
2. `MovieStatsService` memanggil relasi lewat Builder
   (`Movie::whereKey()->reviews()`), menghasilkan error
   `Call to undefined method Builder::reviews()`. Diperbaiki
   dengan query langsung ke model `Review`, `Watched`, dan
   `Watchlist`.
3. `ApiResponse::success()` memakai `array $meta` tetapi seluruh
   endpoint store memanggil `success($data, null, 201)`.
   Diperbaiki menjadi `?array $meta`.
4. `AdminMovieController::validated()` memanggil `toArray()` dan
   `get()` pada hasil yang salah tipe. Diperbaiki memakai array
   dari `except()` dan akses array untuk previous_title.
5. `LogController::store()` memanggil `->map()` pada array `$tags`.
   Diperbaiki memakai collection.
6. `AdminTagController::index()` mengurutkan `usage_count` yang
   bukan kolom. Diperbaiki mengurutkan `diary_entries_count`
   agar respons `usage_count` tetap ada lewat `whenCounted`.

## Yang Belum Diuji

- Endpoint tulis (watchlist, watched, reviews, diary, lists, tags,
  favorites, likes, follow, log) dan seluruh endpoint admin.
- `php artisan test` (factory masih stub bawaan).
- Upload poster dan backdrop lewat endpoint admin.
- Batch import dan batch resolve.

## Batch Import Manual

Diuji ke server live dengan zip berisi movies.json (2 film) dan
folder posters:

- Film dengan `poster_filename` cocok: tersimpan dengan poster.
- Film dengan `poster_filename` hilang: tersimpan, masuk
  `unmatched`.
- Laporan: created 2, failed 0, unmatched 1, errors kosong.
- `POST /api/admin/movies/batch-resolve` dengan mapping manual:
  poster terpasang. Dua film uji dihapus lagi, database kembali
  10 film.

## Postman

- `backend/docs/Mailboxh.postman_collection.json`: 4 folder
  (Auth, Movies, User, Admin), 31 request, memakai
  `{{base_url}}` dan `{{token}}`/`{{admin_token}}` beserta contoh
  body dan catatan kebutuhan token.
- `backend/docs/Mailboxh.postman_environment.json`: base_url,
  token, admin_token.

## Uji Clone Bersih dan Push (Manual oleh User)

- Clone ke folder baru lalu ikuti docs/SETUP_DATABASE.md.
- Pastikan `.env` tidak ikut commit, lalu push dan invite
  collaborator sesuai README bagian Alur Kerja Tim.
