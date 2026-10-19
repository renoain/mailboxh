# AGENTS.md - Mailboxh

File instruksi utama untuk AI/agent. Wajib dibaca sebelum menulis kode
atau membuat file.

## 1. Konteks Produk

Mailboxh adalah aplikasi mobile katalog film sosial. User dapat mencatat
film yang sudah ditonton, membuat watchlist, diberi rating dan review,
serta melihat riwayat tontonan. Data film diinput manual oleh admin.

Fitur MVP:

- Auth (register, login, logout).
- Katalog film (trending, populer, search).
- Detail film.
- Watchlist.
- Watched.
- Rating dan review.
- Profil user.
- Diary.

Target user: penikmat film yang ingin mencatat dan membagikan tontonan.

## 2. Wajib Baca Sebelum Coding

- AGENTS.md (file ini)
- PROTOCOL.md
- docs/PROJECT_OVERVIEW.md
- docs/SRS.md
- docs/ARCHITECTURE.md
- docs/DATABASE_SCHEMA.md
- docs/API.md
- docs/UI_PAGES.md
- docs/DESIGN_SYSTEM.md
- CHANGELOG.md

## 3. Rules Modular

Aturan detail ada di folder .opencode/rules/. Wajib dibaca sesuai konteks:

- .opencode/rules/01-core.md
- .opencode/rules/02-coding.md
- .opencode/rules/03-design.md
- .opencode/rules/04-docs.md
- .opencode/rules/05-security.md
- .opencode/rules/06-testing.md

## 4. Aturan Cepat

- Komunikasi dalam Bahasa Indonesia.
- Nama variabel/class/file/folder dalam Bahasa Inggris.
- String UI via AppStrings (ID/EN). Widget berisi string dilarang const.
- Dilarang emoji di kode, komentar, dokumentasi, commit.
- Dilarang pemisah dekoratif di komentar kode.
- Komentar hanya yang penting saja. Jangan mengulang kode. Jangan
  menjelaskan hal yang sudah jelas dari nama variabel atau fungsi.
- Dilarang hardcode warna/spacing/radius, wajib token di frontend/lib/core/theme/.
- Dilarang menulis secret, wajib lewat .env.
- Semua file gambar/gambar poster yang di-upload admin disimpan di storage/app/public/. Jangan pernah menyimpan file gambar langsung ke dalam folder public/ tanpa melalui storage symlink.
- Setiap task selesai wajib update CHANGELOG.md di paling atas.
- Task yang mengubah struktur/token/arsitektur wajib update docs terkait
  pada task yang sama.
- Ikuti PROTOCOL.md untuk alur kerja.
- Ada keputusan penting atau konflik, tanya dulu, jangan berasumsi.

## 5. Tech Stack

- Framework: Flutter
- Bahasa: Dart
- State management: Riverpod
- Routing: go_router
- HTTP: dio
- Backend: Laravel (REST API)
- Database: MySQL
- Sumber data film: input manual oleh admin
- Icon: flutter_lucide
- Font: Manrope + Geist
- Local storage: shared_preferences
- Cache gambar: cached_network_image_ce
- Testing: flutter_test + mocktail

## 6. Arsitektur Singkat

- Layer: presentation, domain, data.
- Logic bisnis di domain (usecase), bukan di widget.
- Akses data di data (repository/datasource).
- Widget hanya memanggil provider/notifier.
- Provider per fitur di frontend/lib/features/<fitur>/presentation/providers/.
- Route di frontend/lib/core/router/app_router.dart.
- Token di frontend/lib/core/theme/.
- Konstanta di frontend/lib/core/constants/.
- Service di frontend/lib/core/services/.
- Utility di frontend/lib/core/utils/.
- Widget global di frontend/lib/core/widgets/.
- Flutter di frontend/, backend Laravel di backend/.
- Root hanya dokumentasi dan aturan. Tidak ada kode di root.
- Perintah Flutter dijalankan dari frontend/, perintah Artisan dari
  backend/.

## 7. Alur Kerja

1. Sebelum menulis kode, baca AGENTS.md, PROTOCOL.md, dan docs terkait.
2. Untuk fitur baru, ikuti pola create-feature.
3. Untuk halaman baru, ikuti pola create-screen.
4. Untuk komponen baru, ikuti pola create-component.
5. Setelah selesai, jalankan checklist verifikasi.
6. Update CHANGELOG.md.
7. Laporkan ke user: file yang dibuat/diubah, hasil verifikasi,
   rekomendasi task selanjutnya.

## 8. Aturan Verifikasi

Sebelum task dianggap selesai:

1. `cd frontend && flutter analyze` - OK / warning / error.
2. `cd frontend && flutter test` - OK / gagal / belum ditest.
3. `cd backend && php artisan test` - OK / gagal / belum ditest.
4. Task UI: screenshot terlampir.
5. CHANGELOG.md terupdate di paling atas.
6. Docs terkait terupdate jika ada perubahan struktur/token/arsitektur.
7. Tidak ada hardcode warna/spacing/radius.
8. Tidak ada logic bisnis di widget.
9. Tidak ada secret di kode.
10. Tidak ada emoji di kode/docs.
11. Dependency baru sudah dievaluasi.

## 9. Aturan Security

- Token sesi disimpan di secure storage, bukan SharedPreferences polos.
- APP_KEY dan password database disimpan di .env backend, tidak pernah di kode Flutter.
- Flutter hanya bicara ke backend Laravel, tidak pernah memanggil layanan film pihak ketiga.
- Rate limit endpoint auth dan endpoint tulis.
- Validasi input di backend (FormRequest).
- Dilarang log data sensitif (token, password).

## 10. Aturan Dependency Baru

- Setiap penambahan dependency wajib dievaluasi: tujuan, alternatif,
  pemeliharaan, lisensi, kompatibilitas, ukuran, dokumentasi.
- Wajib dicatat di CHANGELOG dan docs/ARCHITECTURE.md.
- Dependency tanpa rilis di atas 12 bulan DILARANG dipakai.
- Dependency dengan lisensi tidak aman DILARANG dipakai.