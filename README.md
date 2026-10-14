# Mailboxh

Aplikasi mobile katalog film sosial. User dapat mencatat film yang sudah
ditonton, membuat watchlist, memberi rating dan review, serta melihat
riwayat tontonan. Data film diambil dari TMDB API.

## Status Project

- Versi: v0.1.0 (MVP, dalam pengembangan)
- Status: Setup fondasi
- Detail: lihat docs/PROJECT_OVERVIEW.md

## Tech Stack

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
- Testing: flutter_test + mocktail

## Struktur Repo

```
mailboxh/
  backend/     -> Laravel REST API
  lib/         -> Flutter app
  test/        -> unit dan widget test Flutter
  docs/        -> dokumentasi
  .opencode/   -> aturan, skill, agent untuk AI
  pubspec.yaml
  README.md
  CHANGELOG.md
  AGENTS.md
  PROTOCOL.md
```

Frontend berada di root repo. Backend Laravel berada di subfolder
`backend/`.

## Cara Menjalankan

### 1. Dapatkan API Key TMDB

1. Daftar di https://www.themoviedb.org
2. Verifikasi email.
3. Masuk ke Settings > API.
4. Ajukan API key, pilih tipe Developer.
5. Isi Application URL dengan http://localhost
6. Salin API Read Access Token (v4).

### 2. Setup Backend

```
cd backend
cp .env.example .env
composer install
php artisan key:generate
```

Isi `.env`:

```
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=mailboxh
DB_USERNAME=root
DB_PASSWORD=

TMDB_READ_TOKEN=isi_token_v4_kamu
TMDB_BASE_URL=https://api.themoviedb.org/3
TMDB_IMAGE_BASE_URL=https://image.tmdb.org/t/p/w500
```

Jalankan migrasi dan seeder:

```
php artisan migrate
php artisan db:seed
php artisan serve
```

### 3. Setup Frontend

```
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000/api
```

Untuk device fisik, ganti `10.0.2.2` dengan IP lokal laptop
(misal `192.168.1.10`).

### 4. Menjalankan Test

Backend:

```
cd backend
php artisan test
```

Frontend:

```
flutter analyze
flutter test
```

## Dokumentasi

- docs/PROJECT_OVERVIEW.md
- docs/SRS.md
- docs/ARCHITECTURE.md
- docs/DATABASE_SCHEMA.md
- docs/API.md
- docs/UI_PAGES.md
- docs/DESIGN_SYSTEM.md

## Atribusi

This product uses the TMDB API but is not endorsed or certified by TMDB.

## Lisensi

Proprietary. Belum dipublikasikan.