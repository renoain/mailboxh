# Mailboxh

Aplikasi mobile katalog film sosial. User dapat mencatat film yang sudah
ditonton, membuat watchlist, memberi rating dan review, serta melihat
riwayat tontonan. Data film diinput manual oleh admin.

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
- Sumber data film: input manual oleh admin
- Icon: flutter_lucide
- Font: Manrope + Geist
- Local storage: shared_preferences
- Cache gambar: cached_network_image_ce
- Testing: flutter_test + mocktail

## Struktur Repo

```
mailboxh/
  frontend/    -> project Flutter
  backend/     -> project Laravel REST API
  docs/        -> dokumentasi
  .opencode/   -> rules, skill, agent untuk AI
  README.md
  CHANGELOG.md
  AGENTS.md
  PROTOCOL.md
```

Flutter berada di subfolder `frontend/`, Laravel di subfolder `backend/`.
Root hanya berisi dokumentasi dan aturan. Perintah Flutter dijalankan dari
`frontend/`, perintah Artisan dari `backend/`.

## Cara Menjalankan

### 1. Setup Database

Buat database MySQL bernama `mailboxh` di Laragon atau HeidiSQL.

```
create database mailboxh character set utf8mb4 collate utf8mb4_unicode_ci;
```

Tidak ada API key yang perlu didapat. Katalog film dikelola sendiri
dan diisi lewat halaman admin.

### 2. Setup Backend

```
cd backend
cp .env.example .env
composer install
php artisan key:generate
```

Isi `.env`:

```
APP_URL=http://127.0.0.1:8000

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=mailboxh
DB_USERNAME=root
DB_PASSWORD=

FILESYSTEM_DISK=public

DEMO_ADMIN_EMAIL=admin@mailboxh.test
DEMO_USER_EMAIL=demo@mailboxh.test
DEMO_USER_PASSWORD=password123
```

Jalankan symlink gambar, migrasi, dan seeder:

```
php artisan storage:link
php artisan migrate --seed
php artisan serve
```

### 3. Setup Frontend

```
cd frontend
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000/api --dart-define=ASSET_BASE_URL=http://10.0.2.2:8000
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
cd frontend
flutter analyze
flutter test
```

## Alur Kerja Tim

### Setup Awal

1. Clone repo:
   ```
   git clone https://github.com/username/mailboxh.git
   cd mailboxh
   ```
2. Ikuti docs/SETUP_DATABASE.md untuk setup backend.
3. Setup frontend sesuai bagian Cara Menjalankan di atas.

### Kerja Harian

1. Tarik update terbaru:
   ```
   git pull origin main
   ```
2. Buat branch untuk fitur:
   ```
   git checkout -b feat/nama-fitur
   ```
3. Kerjakan, commit dengan format PROTOCOL.md Bagian I.
4. Push branch:
   ```
   git push origin feat/nama-fitur
   ```
5. Buka Pull Request di GitHub.
6. Tunggu review, lalu merge ke main.
7. Setelah merge, tarik update:
   ```
   git checkout main
   git pull origin main
   ```

### Kalau Ada Migrasi Baru

```
cd backend
git pull
php artisan migrate
```

### Kalau Mau Reset Database

```
php artisan migrate:fresh --seed
```

### Aturan Commit

Format: `type(scope): subject`

Type: feat, fix, docs, refactor, chore, test, style.

Scope: auth, home, movies, watchlist, watched, review, diary,
lists, tags, favorites, likes, follow, feed, members, profile,
settings, admin, core, infra, docs.

Subject maks 72 karakter, imperatif, Bahasa Inggris, tanpa emoji.

### Undang Collaborator

Pemilik repo:

1. Buka repo di GitHub.
2. Settings > Collaborators > Add people.
3. Masukkan username atau email rekan.
4. Rekan terima invite lewat email atau notifikasi GitHub.
5. Setelah menerima, rekan bisa clone dan push langsung ke repo.

Rekan tim:

1. Terima invite di email atau GitHub.
2. Clone repo: `git clone <url-repo>`.
3. Ikuti docs/SETUP_DATABASE.md.

## Dokumentasi

- docs/PROJECT_OVERVIEW.md
- docs/SRS.md
- docs/ARCHITECTURE.md
- docs/DATABASE_SCHEMA.md
- docs/API.md
- docs/UI_PAGES.md
- docs/DESIGN_SYSTEM.md

## Atribusi

Katalog film dikelola oleh admin Mailboxh. Data film diinput manual
dan bukan berasal dari layanan film pihak ketiga.

English:

> Movie catalogue is maintained by the Mailboxh admin. Film data is
> entered manually and does not come from any third-party film service.

## Lisensi

Proprietary. Belum dipublikasikan.