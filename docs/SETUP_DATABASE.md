# Setup Database Mailboxh

Panduan lengkap setup database MySQL dari clone sampai siap dites.

## 1. Prasyarat

- Laragon 6 dengan MySQL aktif.
- Composer terinstal.
- PHP 8.2 ke atas.
- Flutter SDK untuk frontend.
- VSCode.

## 2. Langkah Setelah Clone

```
git clone https://github.com/username/mailboxh.git
cd mailboxh/backend
cp .env.example .env
composer install
php artisan key:generate
```

Isi `.env` minimal:

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

Buat database:

```
mysql -u root -e "SOURCE database/create_database.sql;"
```

Atau buka HeidiSQL dan jalankan isi `backend/database/create_database.sql`.

Jalankan migrasi, seeder, dan symlink:

```
php artisan migrate
php artisan db:seed
php artisan storage:link
php artisan serve
```

## 3. Setup Frontend

```
cd frontend
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000/api
```

Untuk device fisik ganti `10.0.2.2` dengan IP LAN laptop.

## 4. Verifikasi

```
php artisan migrate:status
mysql -u root -e "USE mailboxh; SHOW TABLES;"
```

Cek lewat phpMyAdmin di Laragon bahwa database `mailboxh` berisi 18 tabel plus tabel bawaan.

Cek endpoint:

```
curl http://127.0.0.1:8000/api/home -H "Authorization: Bearer TOKEN"
```

Tanpa token endpoint `/movies` dan `/genres` tetap bisa dibuka.

## 5. Kalau Ada Migrasi Baru dari Repo

```
cd backend
git pull origin main
php artisan migrate
php artisan migrate:status
```

Jangan edit migration yang sudah berstatus `Ran`. Perubahan struktur selalu lewat migration baru.

## 6. Reset Database

```
php artisan migrate:fresh --seed
```

## 7. Troubleshooting

- `Unknown database`: buat ulang database dengan `create_database.sql`.
- `Access denied`: samakan kredensial di `.env` dengan Laragon.
- `Connection refused`: Start All di Laragon, pastikan MySQL hijau.
- `php tidak dikenali`: pakai Terminal Laragon atau tambahkan PHP ke PATH.

## 8. Ringkasan untuk Anggota Tim Baru

1. Instal Laragon 6 lalu tekan Start All.
2. Clone repo dan ikuti bagian 2 di atas.
3. Setup frontend sesuai bagian 3.
4. Verifikasi sesuai bagian 4.
5. Kerja harian di branch fitur, commit sesuai PROTOCOL Bagian I.
