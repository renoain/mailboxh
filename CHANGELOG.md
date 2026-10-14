# CHANGELOG - Mailboxh

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
  `lib/core/constants/`.
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