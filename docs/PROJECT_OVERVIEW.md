# PROJECT OVERVIEW - Mailboxh

## 1. Deskripsi

Mailboxh adalah aplikasi mobile katalog film sosial. User dapat mencatat
film yang sudah ditonton, membuat watchlist, memberi rating dan review,
serta melihat riwayat tontonan. Data film diambil dari TMDB API.

Aplikasi ini adalah replikasi Letterboxd untuk keperluan UTS
Pemrograman Aplikasi Bergerak. Nama Mailboxh adalah plesetan dari
Letterboxd.

## 2. Masalah yang Diselesaikan

- Pencatatan film yang ditonton masih manual dan tersebar.
- Sulit mengingat film apa saja yang sudah ditonton dan kapan.
- Tidak ada tempat terpusat untuk watchlist dan review pribadi.

## 3. Solusi

- Katalog film dari TMDB, jadi tidak perlu input manual.
- Watchlist dan watched tersimpan per user.
- Rating dan review tersimpan per user.
- Diary menampilkan riwayat tontonan beserta tanggal dan tag pribadi.
- Lists dan four favourites membuat profil user punya kurasi pribadi.
- Like dan follow memberi sisi sosial tanpa perlu komentar.
- Activity feed di beranda menampilkan tontonan dan penilaian user
  yang diikuti.
- Profil menampilkan statistik, four favourites, dan daftar film user.

## 4. Target User

- Penikmat film yang ingin mencatat tontonan.
- Pengguna yang suka memberi rating dan review.
- Pengguna yang ingin membuat watchlist terpusat.
- Pengguna yang ingin memamerkan selerai lewat lists dan four
  favourites.

## 5. Fitur MVP

1. Auth (register, login, logout).
2. Katalog film (trending, populer, search) dari TMDB.
3. Detail film (judul, sinopsis, poster, tanggal rilis, rating TMDB).
4. Watchlist.
5. Watched.
6. Rating dan review.
7. Profil user (statistik, four favourites, sub-tab films, diary,
   reviews, lists, tags, dan stats).
8. Diary (riwayat tontonan dengan tanggal dan tag).
9. Lists, daftar film kurasi milik user dan list kurasi sistem.
10. Tags, label pribadi pada entri diary.
11. Four Favourites, empat film favorit yang dipajang di profil.
12. Like, tanda suka pada film terpisah dari rating bintang.
13. Follow Members, mengikuti user lain, termasuk halaman Members untuk
    menemukan user dan halaman Incoming Activity untuk melihat
    pengikut baru.
14. Activity Feed, beranda aktivitas user yang diikuti, termasuk filter
    jenis aktivitas.

Fitur yang ditunda: trailer, komentar pada review, pro tier, journal,
notifikasi push, direct message.

## 6. Tech Stack

- Frontend: Flutter (Dart)
- State management: Riverpod
- Routing: go_router
- HTTP: dio
- Backend API: Laravel (REST)
- Database: MySQL
- Sumber data film: TMDB API
- Icon: flutter_lucide
- Font: Manrope + Geist
- Local storage: shared_preferences
- Cache gambar: cached_network_image_ce
- Testing: flutter_test + mocktail (frontend), PHPUnit (backend)

## 7. Sumber Data

- TMDB API (The Movie Database).
- Base URL: https://api.themoviedb.org/3
- Base URL gambar: https://image.tmdb.org/t/p/w500
- Auth: API Read Access Token (v4), disimpan di `.env` backend.
- Atribusi wajib di aplikasi:

  > Este producto utiliza la API de TMDB pero no está avalado ni
  > certificado por TMDB.

  English version:

  > This product uses the TMDB API but is not endorsed or certified by
  > TMDB.

## 8. Istilah Domain

- Watched: film yang sudah ditonton user.
- Watchlist: film yang ingin ditonton user.
- Diary: tampilan riwayat tontonan yang diturunkan dari data watched.
- Review: ulasan teks dan rating bintang.
- Rating: nilai 1 sampai 5 bintang.
- Like: tanda suka pada film, berdiri sendiri dari rating bintang.
- List: daftar film kurasi milik user, publik atau privat.
- Tag: label pribadi pada entri watched untuk penyaringan diary.
- Favourite: salah satu dari empat film favorit yang dipajang di profil.
- Like: tanda suka pada film, berdiri sendiri dari rating bintang.
- Follow: relasi user mengikuti user lain.
- Feed: daftar aktivitas user sendiri dan user yang diikuti.
- Incoming Activity: aktivitas yang masuk ke user berupa pengikut baru
  dan like pada film di list publik user tersebut.
- Members: halaman untuk menemukan user lain yang belum diikuti.
- TMDB: The Movie Database, sumber data film.

## 9. Status Project

- Versi: v0.1.0 (MVP, dalam pengembangan)
- Status: Setup dokumentasi
- Target rilis UTS: 20 Oktober 2026

## 10. Lingkungan Pengembangan

- Backend dan database berjalan lokal melalui Laragon.
- Backend berjalan di http://127.0.0.1:8000
- Android emulator memakai `http://10.0.2.2:8000/api`, bukan
  `127.0.0.1`. Device fisik memakai IP LAN laptop.

## 11. Struktur Repo

```
mailboxh/
  backend/     -> Laravel REST API
  lib/         -> Flutter app
  test/        -> unit dan widget test Flutter
  docs/        -> dokumentasi
  .opencode/   -> aturan untuk AI agent
  pubspec.yaml
  README.md
  CHANGELOG.md
  AGENTS.md
  PROTOCOL.md
```

Frontend berada di root repo. Backend Laravel berada di subfolder
`backend/`.