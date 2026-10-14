# PROJECT OVERVIEW - Mailboxh

## 1. Deskripsi

Mailboxh adalah aplikasi mobile katalog film sosial. User dapat mencari
film, mencatat film yang sudah ditonton, membuat watchlist, memberi
rating dan review, serta melihat riwayat tontonan.

Aplikasi ini adalah replikasi Letterboxd untuk keperluan UTS
Pemrograman Aplikasi Bergerak. Nama Mailboxh adalah plesetan dari
Letterboxd.

Data film tidak diambil dari layanan pihak ketiga. Film diinput manual
oleh admin melalui halaman admin di aplikasi yang sama.

## 2. Masalah yang Diselesaikan

- Pencatatan film yang ditonton masih manual dan tersebar.
- Sulit mengingat film apa saja yang sudah ditonton dan kapan.
- Tidak ada tempat terpusat untuk watchlist dan review pribadi.
- Aplikasi katalog film pihak ketiga memaksa pengguna]:: bergantung
  pada layanan luar dan sering tidak sinkron dengan data lokal.

## 3. Solusi

- Katalog film dikelola sendiri oleh admin, jadi data film dan Behavior
  aplikasi sepenuhnya milik aplikasi.
- Watchlist dan watched tersimpan per user.
- Rating dan review tersimpan per user.
- Diary menampilkan riwayat tontonan beserta tanggal dan tag pribadi.
- Lists dan four favourites membuat profil user punya kurasi pribadi.
- Like dan follow memberi sisi sosial tanpa perlu komentar.
- Activity feed di beranda menampilkan tontonan dan penilaian user yang
  diikuti.
- Profil menampilkan statistik, four favourites, dan daftar film user.
- Admin menjaga katalog, genre, dan moderasi konten lewat satu tempat.

## 4. Target User

- Penikmat film yang ingin mencatat tontonan.
- Pengguna yang suka memberi rating dan review.
- Pengguna yang ingin membuat watchlist terpusat.
- Pengguna yang ingin memamerkan selerai lewat lists dan four
  favourites.
- Admin pengelola katalog film, satu orang untuk requirements tugas.

## 5. Fitur MVP User

1. Auth (register, login, logout).
2. Katalog film (featured, latest, top rated, most watched, most
   watchlisted, explore) dengan pencarian dan filter genre.
3. Detail film (judul, sinopsis, poster, backdrop, cast, crew, bahasa,
   negara, genre, tanggal rilis, durasi, rating rata-rata, jumlah
   review).
4. Watchlist.
5. Watched.
6. Rating dan review.
7. Profil user (statistik, four favourites, sub-tab films, diary,
   reviews, lists, tags, dan stats).
8. Diary (riwayat tontonan dengan tanggal, catatan, dan tag).
9. Lists, daftar film kurasi milik user.
10. Tags, label pribadi pada entri diary.
11. Four Favourites, empat film favorit yang dipajang di profil.
12. Like, tanda suka pada film terpisah dari rating bintang.
13. Follow Members, mengikuti user lain, termasuk halaman Members untuk
    menemukan user dan halaman Incoming Activity untuk melihat
    pengikut baru.
14. Activity Feed, beranda aktivitas user yang diikuti, termasuk filter
    jenis aktivitas.

## 6. Fitur MVP Admin

Ada dua role, yaitu `user` dan `admin`. Admin accessing seluruh
endpoint berawalan `/api/admin`.

15. Dashboard Admin, ringkasan katalog, user, dan konten.
16. Kelola Film, tambah, ubah, hapus, dan tandai featured.
17. Kelola Genre, tambah, ubah, dan hapus genre.
18. Kelola User, lihat daftar user dan ubah role.
19. Moderasi Review, lihat dan hapus review.
20. Moderasi List, lihat dan hapus list.
21. Moderasi Tags, lihat dan hapus tag.
22. Log Aktivitas Admin, riwayat setiap tindakan admin.

Masuk ke area admin selalu lewat navigasi `go`, tidak pernah push. Route
guard di router memeriksa role sebelum halaman dibuka.

Fitur yang ditunda: trailer, komentar pada review, pro tier, journal,
notifikasi push, direct message.

## 7. Tech Stack

- Frontend: Flutter (Dart)
- State management: Riverpod
- Routing: go_router
- HTTP: dio
- Backend API: Laravel (REST)
- Database: MySQL
- Icon: flutter_lucide
- Font: Manrope + Geist
- Local storage: shared_preferences
- Penyimpanan token: flutter_secure_storage
- Cache gambar: cached_network_image_ce
- Pilih gambar: image_picker
- Logging: logger
- Testing: flutter_test + mocktail (frontend), PHPUnit (backend)

Guzzle tidak dipakai. Tidak ada lagi panggilan ke layanan film
pihak ketiga.

## 8. Sumber Data Film

Seluruh data film berasal dari database aplikasi sendiri.

| Aspek | Nilai |
|---|---|
| Sumber | Input manual oleh admin |
| Tabel | `movies` |
| Genre | Tabel `genres` dengan pivot `movie_genres` |
| Poster dan backdrop | File gambar yang diupload admin |
| Lokasi file | `storage/app/public/posters/` dan `storage/app/public/backdrops/` |
| URL gambar | `APP_URL` + `/storage/posters/<nama_file>` |

Batasan yang harus disadari:

- Katalog film hanya berisi film yang sudah diinput admin. Tidak ada
  akses ke ribuan film seperti pada layanan pihak ketiga.
- Admin bertanggung jawab menjaga kelengkapan katalog. Data seed bawaan
  berisi sepuluh film.
- Rating dan jumlah tontonan dihitung dari data user di aplikasi ini,
  bukan dari sumber eksternal.
- Film tidak pernah dihapus fisik. Admin menonaktifkan film dengan
  soft delete supaya data user tetap utuh.

Atribusi TMDB tidak lagi berlaku karena tidak ada data dari TMDB yang
dipakai. Blok atribusi dihapus dari aplikasi dan dari dokumen.

## 8. Istilah Domain

- Watched: film yang sudah ditonton user.
- Watchlist: film yang ingin ditonton user.
- Diary: entri tontonan milik user beserta tanggal, catatan, dan tag.
- Review: ulasan teks dan rating bintang.
- Rating: nilai 1 sampai 5 bintang.
- Like: tanda suka pada film, berdiri sendiri dari rating bintang.
- List: daftar film kurasi milik user, publik atau privat.
- Tag: label pribadi pada entri diary untuk penyaringan.
- Favourite: salah satu dari empat film favorit yang dipajang di profil.
- Follow: relasi user mengikuti user lain.
- Feed: daftar aktivitas user sendiri dan user yang diikuti.
- Incoming Activity: aktivitas yang masuk ke user berupa pengikut baru
  dan like pada film di list publik user tersebut.
- Members: halaman untuk menemukan user lain yang belum diikuti.
- Movie: film yang dikelola admin di tabel `movies`.
- Genre: kategori film yang dikelola admin di tabel `genres`.
- Cast: pemeran film, disimpan sebagai teks dipisah koma.
- Crew: production crew, disimpan sebagai teks dipisah koma.
- Featured: film yang ditandai admin lewat `movies.is_featured` dan
  tampil di section paling atas beranda.
- Moderasi: tindakan admin menghapus review, list, atau tag.
- Admin: user dengan role `admin` yang mengelola katalog dan konten.
- Role: nilai `user` atau `admin` pada kolom `users.role`.
- Soft delete: film ditandai tidak aktif lewat `deleted_at` tanpa
  menghapus baris dan tanpa merusak data user.

## 9. Status Project

- Versi: v0.1.0 (MVP, dalam pengembangan)
- Status: Setup dokumentasi
- Target rilis UTS: 20 Oktober 2026

## 10. Lingkungan Pengembangan

- Backend dan database berjalan lokal melalui Laragon.
- Backend berjalan di http://127.0.0.1:8000
- Android emulator memakai `http://10.0.2.2:8000/api`, bukan
  `127.0.0.1`. Device fisik memakai IP LAN laptop.
- Perintah Flutter dijalankan dari `frontend/`, perintah Artisan dari
  `backend/`. Root repo tidak menjalankan kode apa pun.
- PHP, Composer, dan MySQL berada di `C:\laragon\bin\` dengan nama
  folder berangka versi, sehingga tidak ada di PATH sistem. Perintah
  memakai path absolut atau PATH sementara.
- Flutter memakai `--dart-define=API_BASE_URL=...` untuk alamat backend,
  bukan file `.env`.
- `php artisan storage:link` wajib dijalankan supaya folder
  `storage/app/public` dapat diakses lewat `APP_URL`.
- Tidak ada lagi proses yang mengambil API key apa pun dari internet
  selain `composer` dan `pub`.

## 11. Struktur Repo

Repo memakai monorepo dengan dua folder terpisah.

```
mailboxh/
  frontend/    -> project Flutter
  backend/     -> project Laravel REST API
  docs/        -> dokumentasi
  .opencode/   -> rules, skills, agents, commands untuk AI
  README.md
  CHANGELOG.md
  AGENTS.md
  PROTOCOL.md
  .gitignore
```

Isi `frontend/`:

```
frontend/
  lib/
  test/
  pubspec.yaml
  android/
  ios/
  web/
  windows/
  linux/
  macos/
```

Isi `backend/`:

```
backend/
  app/
  routes/
  database/
  config/
  storage/
  .env
  .env.example
  composer.json
```

Pemisahan ini dipilih karena toolchain keduanya berbeda (`pubspec.yaml`
dan `composer.json`), perintah jalannya berbeda (`flutter run` dan
`php artisan`), dan saat penilaian UTS keduanya dinilai terpisah
padahal tetap satu repo.

Root hanya berisi dokumentasi, aturan AI, dan orkestrasi. Tidak ada
kode yang dijalankan dari root dan tidak ada `.env` di root.