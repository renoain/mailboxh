# 05-security

Aturan keamanan frontend dan backend.

## Autentikasi

- Backend memakai Laravel Sanctum dengan token bearer.
- Token sesi disimpan di `flutter_secure_storage`, bukan
  `SharedPreferences` polos.
- `SharedPreferences` hanya untuk data nonrahasia, misalnya flag
  onboarding dan pilihan bahasa.
- Logout menghapus token dari secure storage dan memaksa aplikasi ke
  halaman login.

## API Key

- Tidak ada token layanan film pihak ketiga. Yang sensitif di backend hanya
  `APP_KEY` dan kredensial database.
- `APP_KEY` dan password database tidak pernah masuk ke kode Flutter,
  konfigurasi build, atau
  dokumentasi publik.
- Flutter hanya bicara ke backend Laravel, tidak pernah langsung ke
  layanan pihak ketiga.
- Alamat backend dikirim lewat `--dart-define=API_BASE_URL`, bukan
  ditulis permanen di kode.

## Validasi

- Validasi input berada di backend pada FormRequest.
- Validasi tidak hanya di frontend. Frontend validating adalah kenyamanan
  UX, bukan kontrol keamanan.
- Aturan yang ditegakkan:

  | Data | Aturan |
  |---|---|
  | `movie_id` | Wajib, integer |
  | `rating` | Wajib atau opsional sesuai endpoint, integer 1 sampai 5 |
  | `position` favourites | Integer 1 sampai 4, unik per user |
  | `watched_at` | Tanggal, tidak boleh di masa depan |
  | `order` list item | Array `movie_id` yang sudah ada di list |
  | Nama tag | 1 sampai 40 karakter, unik case-insensitive per user |
  | Judul list | 1 sampai 120 karakter |
  | `content` review | Maksimal 5000 karakter |

- Otorisasi dicek di level aplikasi, bukan di level database. Backend
  selalu memeriksa kepemilikan resource sebelum mengubah atau menghapus.

## Rate Limit

| Kelompok | Batas |
|---|---|
| Endpoint auth | 5 request per menit per IP |
| Endpoint tulis | 60 request per menit per user |
| Endpoint baca | 120 request per menit per user |
| Endpoint movies tanpa login | 60 request per menit per IP |
| Feed, incoming activity, members | 30 request per menit per user |

## Password

- Password di-hash dengan bcrypt bawaan Laravel.
- Password demo pada seeder dibaca dari `.env`, bukan ditulis di kode.
- Nilai default pada `.env.example` harus kosong, bukan kredensial asli.

## Logging

- Dilarang log token, password, `APP_KEY`, dan isi `.env`.
- Allowed log: nama endpoint, status HTTP, durasi, dan user id.
- Log memakai logger, tidak boleh `print` atau `dd`.
- Error dari backend tidak pernah menampilkan stack trace ke user.

## Repository

- `.env` tidak boleh masuk ke version control.
- `.env.example` wajib ada dan berisi seluruh kunci yang dibutuhkan,
  dengan nilai kosong untuk yang sensitif.
- File `.env`, `auth.json`, `*.pem`, dan `*.key` tidak boleh di-commit.
