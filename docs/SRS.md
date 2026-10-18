# SRS - Mailboxh

Software Requirements Specification untuk aplikasi Mailboxh.

## 1. Pendahuluan

### 1.1 Tujuan

Dokumen ini mendefinisikan kebutuhan fungsional dan non-fungsional
aplikasi Mailboxh, aplikasi mobile katalog film sosial berbasis Flutter
dengan backend REST API Laravel dan database MySQL.

### 1.2 Ruang Lingkup

Aplikasi mencakup katalog film, pencatatan tontonan, watchlist, rating,
review, diary, lists, tags, four favourites, like, follow members,
komentar review, notifikasi in-app, dan activity feed, ditambah area
admin untuk mengelola katalog dan moderasi konten. Data film diinput
manual oleh admin.

### 1.3 Definisi

- REST API: arsitektur API berbasis HTTP.
- MVP: Minimum Viable Product.
- Role: nilai `user` atau `admin` pada kolom `users.role`.
- Soft delete: menandai baris tidak aktif lewat `deleted_at` tanpa
  menghapusnya.
- Otorisasi: dijaga di level aplikasi, bukan di level database.

### 1.4 Referensi

- docs/PROJECT_OVERVIEW.md
- docs/ARCHITECTURE.md
- docs/DATABASE_SCHEMA.md
- docs/API.md
- docs/UI_PAGES.md
- docs/DESIGN_SYSTEM.md

## 2. Deskripsi Umum

### 2.1 Gambaran Produk

Aplikasi mobile yang memungkinkan user mencari film, menandai film yang
sudah ditonton, membuat watchlist, memberi rating dan review, dan
melihat riwayat tontonan.

### 2.2 Fungsi Utama

- Autentikasi user.
- Penjelajahan katalog film yang dikelola admin.
- Pencatatan watched, diary, dan watchlist.
- Rating dan review.
- Lists kurasi movie.
- Tag pada entri diary.
- Four favourites di profil.
- Like terpisah dari rating.
- Follow antar member.
- Komentar pada review user lain.
- Notifikasi in-app dari interaksi sosial.
- Activity feed di beranda.
- Profil dan statistik user.
- Pengelolaan katalog, genre, dan user oleh admin.
- Moderasi review, list, dan tag oleh admin.
- Log aktivitas admin.

### 2.3 Karakteristik User

- User umum: penikmat film, tidak butuh keahlian teknis.
- Admin: pengelola katalog film. Satu orang untuk requirements tugas,
  sudah dibuat lewat seeder dan tidak dapat mendaftar lewat aplikasi.

### 2.4 Batasan

- Katalog film hanya berisi film yang sudah diinput admin. Tidak ada
  akses ke katalog film eksternal.
- Fitur sosial yang tersedia: follow, activity feed, like, komentar
  review, dan notifikasi in-app. Direct message dan mention tidak ada
  di MVP.
- Endpoint katalog film dapat dipanggil tanpa login. Halaman yang
  memakai katalog tetap butuh login karena memerlukan state user.
- Admin hanya dapat mengubah role user lain. Tidak dapat menghapus akun
  dan tidak dapat mengubah password user lain.
- Moderasi dibatasi pada penghapusan review, list, dan tag. Film tidak
  pernah dihapus fisik.
- Tanpa push notification. Notifikasi hanya tampil in-app lewat
  halaman notifikasi. Activity feed hanya dimuat saat aplikasi dibuka
  atau saat user menarik untuk refresh.
- Tanpa trailer dan tanpa streaming video.

### 2.5 Asumsi

- Admin menjaga kelengkapan katalog film.
- User memiliki koneksi internet.
- Backend dan database berjalan lokal melalui Laragon saat demo.

## 3. Aktor

- Guest: belum login. Dapat melihat katalog film dan genre saja.
- User: sudah login dengan role `user`. Dapat mengakses seluruh fitur
  user dan tidak dapat membuka endpoint admin.
- Admin: sudah login dengan role `admin`. Dapat mengakses seluruh fitur
  user ditambah area admin.
- Sistem: backend Laravel, database MySQL, dan penyimpanan file lokal.

## 4. Kebutuhan Fungsional

### 4.1 Auth

- FR-AUTH-01: User dapat register dengan nama, email, dan password.
- FR-AUTH-02: User dapat login dengan email dan password.
- FR-AUTH-03: User dapat logout.
- FR-AUTH-04: Sistem mengembalikan token setelah login berhasil.
- FR-AUTH-05: Token disimpan di secure storage perangkat.
- FR-AUTH-06: Sistem memeriksa sesi saat aplikasi dibuka dan mengarahkan
  user sesuai status login.

### 4.2 Katalog Film

- FR-CAT-01: User dapat melihat daftar film dengan urutan pilihan admin,
  yaitu terbaru, rating tertinggi, paling banyak ditonton, dan paling
  banyak masuk watchlist.
- FR-CAT-02: User dapat mencari film berdasarkan judul, minimal dua
  karakter.
- FR-CAT-03: User dapat menyaring daftar film berdasarkan satu atau
  beberapa genre.
- FR-CAT-04: Sistem menampilkan poster, judul, tahun rilis, dan rating
  rata-rata pada setiap kartu film.
- FR-CAT-05: Film yang sudah dinonaktifkan admin tidak muncul di katalog
  maupun di hasil pencarian.
- FR-CAT-06: Daftar film memakai pagination, bukan memuat seluruh
  katalog sekaligus.

### 4.3 Detail Film

- FR-DET-01: User dapat melihat detail film.
- FR-DET-02: Detail mencakup judul, judul asli, sinopsis, poster,
  backdrop, tanggal rilis, durasi, bahasa, negara, genre, cast, crew,
  rating rata-rata, dan jumlah review.
- FR-DET-03: Rating rata-rata dan jumlah review dihitung dari data user
  di aplikasi ini.
- FR-DET-04: Film yang sudah dinonaktifkan admin menampilkan halaman
  tidak tersedia bagi user, bukan crash.

### 4.4 Watchlist

- FR-WL-01: User dapat menambah film ke watchlist.
- FR-WL-02: User dapat menghapus film dari watchlist.
- FR-WL-03: User dapat melihat daftar watchlist.
- FR-WL-04: Film yang sama tidak dapat masuk watchlist lebih dari sekali.

### 4.5 Watched

- FR-WT-01: User dapat menandai film sebagai watched beserta tanggal
  tonton.
- FR-WT-02: User dapat membatalkan status watched.
- FR-WT-03: User dapat melihat daftar watched.
- FR-WT-04: User dapat mengubah tanggal tonton pada entri watched.
- FR-WT-05: Film yang sama tidak dapat tercatat sebagai watched lebih
  dari sekali.
- FR-WT-06: Menandai watched atau membuat entri diary menghapus film
  dari watchlist secara otomatis.

### 4.6 Rating dan Review

- FR-REV-01: User dapat memberi rating 1 sampai 5 bintang pada film.
- FR-REV-02: User dapat menulis review teks, bersifat opsional.
- FR-REV-03: User dapat mengubah rating dan review.
- FR-REV-04: User dapat menghapus rating dan review.
- FR-REV-05: Satu user hanya memiliki satu rating dan review per film.
- FR-REV-06: Rating dapat dibuat mandiri tanpa menulis review dan
  tanpa membuat entri diary.
- FR-REV-07: Melepas rating mandiri hanya menghapus bintang. Teks
  review tetap tersimpan bila ada.

### 4.7 Profil

- FR-PROF-01: User dapat melihat profil sendiri.
- FR-PROF-02: Profil menampilkan statistik total watched, watchlist, dan
  review.
- FR-PROF-03: Profil menampilkan daftar watchlist dan watched.
- FR-PROF-04: Profil memakai sub-tab Films, Diary, Reviews, Lists, Tags,
  dan Stats. Sub-tab Films menggabungkan watchlist dan watched.
- FR-PROF-05: Sub-tab Tags pada profil menampilkan statistik pemakaian
  tag, bukan form kelola tag.
- FR-PROF-06: Profil user lain hanya menampilkan data yang bersifat
  publik. Sub-tab Lists pada profil user lain hanya memuat list publik.

### 4.8 Diary

- FR-DIA-01: Diary menampilkan riwayat tontonan beserta tanggal, diurutkan
  dari yang terbaru.
- FR-DIA-02: Diary dapat difilter berdasarkan rentang tanggal.
- FR-DIA-03: Diary adalah tabel tersendiri. Entri diary menyimpan film,
  tanggal tonton, dan catatan. Entri ini tidak sama dengan tabel
  watched, yang hanya menandai status sudah ditonton.
- FR-DIA-04: Diary dapat menampilkan catatan opsional per entri
  tontonan.
- FR-DIA-05: User dapat menambah, mengubah, dan menghapus entri diary.
  Entri diary tidak memerlukan baris watched untuk film yang sama.
- FR-DIA-06: Satu film dapat memiliki banyak entri diary selama tanggal
  tonton berbeda. Entri dengan tanggal sama pada user dan film yang
  sama hanya boleh satu.

### 4.9 Onboarding dan Pengaturan

- FR-APP-01: Aplikasi menampilkan onboarding sekali pada pemakaian
  pertama.
- FR-APP-02: User dapat melewati onboarding.
- FR-APP-03: User dapat mengganti bahasa aplikasi antara Indonesia dan
  Inggris.
- FR-APP-04: Halaman pengaturan menampilkan versi aplikasi dan credit
  kepada pengelola katalog film.

### 4.10 Lists

- FR-LIST-01: User dapat membuat list dengan judul, deskripsi opsional,
  dan pengaturan publik atau privat.
- FR-LIST-02: User dapat mengubah dan menghapus list miliknya sendiri.
  List milik user lain tidak dapat diubah.
- FR-LIST-03: User dapat menambahkan film ke list miliknya dan
  menghapusnya dari list.
- FR-LIST-04: User dapat melihat daftar list miliknya beserta jumlah film
  di setiap list, serta daftar list publik milik user lain.
- FR-LIST-05: User dapat melihat isi list milik user lain selama list
  tersebut publik. List privat user lain tidak terlihat.
- FR-LIST-06: Film yang sama tidak dapat masuk satu list lebih dari
  sekali. Urutan film dalam list dapat diubah user.

### 4.11 Tags

- FR-TAG-01: User dapat membuat tag dengan nama unik di lingkup
  user tersebut. Perbandingan nama mengabaikan huruf besar dan kecil.
- FR-TAG-02: User dapat menghapus tag yang dimilikinya. Tag yang masih
  dipakai dilepas dari seluruh entri diary.
- FR-TAG-03: User dapat menempelkan lebih dari satu tag ke satu entri
  watched.
- FR-TAG-04: User dapat melepas tag dari satu entri watched tanpa
  menghapus tag itu sendiri.
- FR-TAG-05: Diary dapat difilter berdasarkan tag milik user tersebut.

### 4.12 Four Favourites

- FR-FAV-01: User dapat memilih maksimal empat film sebagai four
  favourites.
- FR-FAV-02: Setiap film menempati satu posisi dari 1 sampai 4, dan user
  dapat mengubah urutannya.
- FR-FAV-03: Empat film favourites ditampilkan di profil user, baik
  profil sendiri maupun profil user lain. Slot yang kosong ditampilkan
  sebagai tempat kosong, bukan disembunyikan.

### 4.13 Like

- FR-LIKE-01: User dapat memberikan like pada film, review, dan list.
- FR-LIKE-02: User dapat membatalkan like.
- FR-LIKE-03: Like berdiri sendiri dari rating bintang dan review. User
  dapat like film yang belum ia tonton atau beri rating, dan sebaliknya.
  Jumlah like per film ditampilkan pada detail film.
- FR-LIKE-04: Jumlah like review dan like list ditampilkan bersama
  review dan list. Like review dan like list membuat notifikasi untuk
  pemiliknya.

### 4.14 Follow Members

- FR-FOLLOW-01: User dapat mengikuti user lain.
- FR-FOLLOW-02: User dapat berhenti mengikuti user lain.
- FR-FOLLOW-03: User dapat melihat daftar follower dan daftar following,
  baik miliknya sendiri maupun milik user lain.
- FR-FOLLOW-04: User tidak dapat mengikuti dirinya sendiri. User dapat
  mengikuti tanpa perlu reciprocasi.

### 4.15 Activity Feed

- FR-FEED-01: Beranda menampilkan aktivitas user yang diikuti beserta
  aktivitas user sendiri.
- FR-FEED-02: Aktivitas yang ditampilkan mencakup watched, rating,
  review, like, pembuatan list, dan follow.
- FR-FEED-03: Feed dapat difilter berdasarkan jenis aktivitas dan
  dimuat lebih banyak saat user menarik ke bawah.
- FR-FEED-04: Beranda hanya menampilkan cuplikan activity feed paling
  atas. Halaman Feed menampilkan activity feed lengkap beserta filter.

### 4.16 Incoming Activity

- FR-INCOMING-01: User dapat melihat aktivitas yang masuk ke miliknya,
  yaitu pengikut baru dan like dari user lain pada film yang ada di list
  publik user tersebut.
- FR-INCOMING-02: Incoming activity diurutkan dari yang terbaru dan
  memuat nama pelaku, jenis aktivitas, dan film yang berkaitan.
- FR-INCOMING-03: User dapat membuka profil pelaku atau filmnya langsung
  dari halaman incoming activity. Komentar dan notifikasi tidak tampil
  di incoming activity karena keduanya punya halaman tersendiri.

### 4.17 Members

- FR-MEMBERS-01: User dapat mencari user lain berdasarkan nama.
- FR-MEMBERS-02: User dapat melihat status follow langsung pada hasil
  pencarian dan mengikuti user dari halaman tersebut.
- FR-MEMBERS-03: User sendiri tidak pernah muncul di hasil pencarian.
  Pengguna yang sudah diikuti tetap ditampilkan dengan status Diikuti.

### 4.18 Form Log

- FR-LOG-01: User dapat mencatat tontonan, rating, review, dan tag dalam
  satu form.
- FR-LOG-02: Semua isian pada form log bersifat opsional kecuali film.
  Field yang tidak diisi tidak membuat rating, review, maupun tag.
- FR-LOG-03: Penyimpanan form log bersifat atomik. Bila salah satu bagian
  gagal, tidak ada bagian yang tersimpan.
- FR-LOG-04: Tanggal tontonan dapat diisi manual pada form log.

### 4.19 Beranda

Beranda mengambil keenam section dalam satu permintaan.

- FR-HOME-01: Section Featured menampilkan film yang ditandai admin,
  maksimal lima film, dalam bentuk banner besar. Section ini boleh
  kosong.
- FR-HOME-02: Section Latest menampilkan sepuluh film yang paling baru
  diinput admin.
- FR-HOME-03: Section Top Rated menampilkan sepuluh film dengan rating
  rata-rata tertinggi dari film yang punya minimal satu review.
- FR-HOME-04: Section Most Watched menampilkan sepuluh film dengan jumlah
  entri watched terbanyak.
- FR-HOME-05: Section Most Watchlisted menampilkan sepuluh film dengan
  jumlah entri watchlist terbanyak.
- FR-HOME-06: Section Explore menampilkan sepuluh film pilihan acak dari
  katalog aktif.

### 4.20 Admin Dashboard

- FR-ADM-DASH-01: Admin dapat melihat ringkasan jumlah film aktif, jumlah
  film nonaktif, jumlah genre, jumlah user, jumlah review, jumlah list,
  dan jumlah tag.
- FR-ADM-DASH-02: Dashboard menampilkan film yang baru diinput dan
  aktivitas admin terbaru.
- FR-ADM-DASH-03: Semua angka dashboard dihitung ulang saat halaman
  dibuka dan tidak disimpan sebagai cache.

### 4.21 Admin Kelola Film

- FR-ADM-FILM-01: Admin dapat membuat film dengan judul, judul asli,
  sinopsis, tanggal rilis, durasi, bahasa, negara, cast, crew, genre, dan
  penanda featured.
- FR-ADM-FILM-02: Admin dapat mengupload poster dan backdrop sebagai
  file gambar. Poster maksimal 2 MB dan backdrop maksimal 4 MB dengan
  format jpg, jpeg, png, atau webp.
- FR-ADM-FILM-03: Admin dapat mengubah data film yang sudah ada.
- FR-ADM-FILM-04: Admin dapat menonaktifkan film. Film yang dinonaktifkan
  hilang dari katalog, pencarian, dan section beranda tanpa menghapus
  data watchlist, watched, diary, review, like, dan favourite milik user.
- FR-ADM-FILM-05: Admin dapat mengaktifkan kembali film yang
  dinonaktifkan.
- FR-ADM-FILM-06: Admin dapat menandai atau menghapus penanda featured.
  Maksimal lima film dapat featured agar section beranda tidak penuh.

### 4.22 Admin Kelola Genre

- FR-ADM-GENRE-01: Admin dapat membuat genre dengan nama dan slug yang
  unik.
- FR-ADM-GENRE-02: Admin dapat mengubah nama dan slug genre.
- FR-ADM-GENRE-03: Admin dapat menghapus genre. Film yang memakai genre
  tersebut kehilangan genre itu tanpa kehilangan filmnya.
- FR-ADM-GENRE-04: Slug yang sudah dipakai genre lain ditolak. Nama genre
  dibandingkan mengabaikan huruf besar dan kecil.

### 4.23 Admin Kelola User

- FR-ADM-USER-01: Admin dapat melihat daftar seluruh user beserta jumlah
  film yang they've masukkan.
- FR-ADM-USER-02: Admin dapat melihat detail satu user berupa profil,
  statistik, dan aktivitas terbaru.
- FR-ADM-USER-03: Admin dapat mengubah role user antara `user` dan
  `admin`.
- FR-ADM-USER-04: Admin tidak dapat menghapus akun dan tidak dapat
  mengubah password user lain. Admin juga tidak dapat menurunkan role
  dirinya sendiri agar tidak ada admin tersisa.

### 4.24 Admin Moderasi Review

- FR-ADM-REV-01: Admin dapat melihat seluruh review dengan filter film
  dan kata kunci.
- FR-ADM-REV-02: Admin dapat menghapus review yang melanggar.
- FR-ADM-REV-03: Film yang kehilangan seluruh review tidak lagi masuk
  section Top Rated.

### 4.25 Admin Moderasi List

- FR-ADM-LIST-01: Admin dapat melihat seluruh list dengan filter
  publik, privat, dan kata kunci.
- FR-ADM-LIST-02: Admin dapat menghapus list milik user.
- FR-ADM-LIST-03: Menghapus list tidak menghapus film di dalamnya dan
  tidak menyentuh like atau review pada film tersebut.

### 4.26 Admin Moderasi Tag

- FR-ADM-TAG-01: Admin dapat melihat seluruh tag beserta jumlah entri
  diary yang memakainya.
- FR-ADM-TAG-02: Admin dapat menghapus tag. Tag yang dihapus dilepas dari
  seluruh entri diary secara otomatis.
- FR-ADM-TAG-03: Admin dapat memfilter tag berdasarkan kata kunci.

### 4.27 Admin Log Aktivitas

- FR-ADM-LOG-01: Setiap tindakan admin yang mengubah data tercatat
  lengkap dengan pelaku, tindakan, jenis entitas, id entitas, dan
  keterangan.
- FR-ADM-LOG-02: Admin dapat melihat log aktivitas dengan filter admin
  dan jenis entitas, serta pagination. Admin tidak dapat menghapus log.

### 4.28 Komentar Review

- FR-COM-01: User dapat mengomentari review user lain dengan teks
  maksimal 1000 karakter.
- FR-COM-02: User dapat melihat daftar komentar pada satu review,
  diurutkan dari yang paling lama.
- FR-COM-03: User hanya dapat menghapus komentarnya sendiri. Menghapus
  review menghapus seluruh komentarnya.
- FR-COM-04: Pemilik review menerima notifikasi saat review-nya
  dikomentari, kecuali saat mengomentari review miliknya sendiri.

### 4.29 Notifikasi

- FR-NOTIF-01: User menerima notifikasi in-app saat review-nya disukai,
  review-nya dikomentari, list-nya disukai, atau ada user yang
  mengikuti.
- FR-NOTIF-02: User dapat melihat daftar notifikasi terbaru, menandai
  satu notifikasi sudah dibaca, dan menandai seluruh notifikasi sudah
  dibaca.
- FR-NOTIF-03: Notifikasi tidak pernah dibuat untuk tindakan user
  terhadap objek miliknya sendiri. Like film tidak membuat notifikasi.

## 5. Kebutuhan Non-Fungsional

### 5.1 Performa

- Waktu muat katalog maksimal 3 detik pada koneksi normal.
- Enam section beranda diambil dalam satu permintaan agar tidak ada enam
  round trip.
- Query agregat untuk Top Rated, Most Watched, dan Most Watchlisted
  memakai indeks yang sesuai dan tidak memuat seluruh tabel ke memori.
- Scroll daftar tetap mulus pada 200 item.

### 5.2 Keamanan

- Password di-hash dengan bcrypt, bawaan Laravel.
- Token sesi memakai Laravel Sanctum.
- Token disimpan di secure storage perangkat, bukan SharedPreferences
  polos.
- Endpoint admin dilindungi dua lapis: `auth:sanctum` dan
  `EnsureUserIsAdmin`.
- Role hanya bisa diubah lewat endpoint admin. Tidak ada parameter role
  pada form register.
- Validasi input di backend melalui FormRequest.
- Rate limit pada endpoint auth, endpoint tulis, dan endpoint admin.
- Upload gambar divalidasi tipe MIME dan ukuran, bukan hanya ekstensi.
- Tidak ada log data sensitif.

### 5.3 Usability

- UI konsisten dengan design token.
- Empty state, loading, dan error state selalu ada.
- Pesan error ramah, tidak menampilkan stack trace.

### 5.4 Kompatibilitas

- Android 8.0 ke atas.
- iOS 12 ke atas.
- Lebar layar minimal 360 px.

### 5.5 Lokalisasi

- String UI dwibahasa, Indonesia dan Inggris.
- Seluruh string lewat AppStrings, bukan hardcode.

### 5.6 Maintainability

- Layer: presentation, domain, data.
- Logika bisnis berada di domain.
- Kode mengikuti aturan di AGENTS.md dan PROTOCOL.md.

## 6. Use Case Utama

### 6.1 Register dan Login

1. User buka aplikasi.
2. Sistem memeriksa sesi.
3. User diarahkan ke onboarding bila pemakaian pertama.
4. User pilih register atau login.
5. User isi form.
6. Sistem validasi.
7. Sistem menyimpan token di secure storage.
8. User masuk ke halaman utama.

### 6.2 Cari Film dan Tambah ke Watchlist

1. User buka halaman katalog.
2. User ketik judul film.
3. Sistem menampilkan hasil dari katalog yang dikelola admin.
4. User tap film.
5. Sistem tampilkan detail.
6. User tap tombol Tambah ke Watchlist.
7. Sistem menyimpan ke database.

### 6.3 Tandai Watched dan Beri Review

1. User buka detail film.
2. User tap tombol Tandai Sudah Ditonton.
3. Sistem menyimpan entri watched dengan tanggal hari ini.
4. Entri itu otomatis muncul di diary.
5. User tap tombol Tulis Review.
6. User isi rating bintang dan review teks.
7. Sistem menyimpan.

### 6.4 Lihat Profil dan Statistik

1. User buka halaman profil.
2. Sistem menampilkan statistik dan daftar film.
3. User tap daftar untuk melihat detail.

### 6.5 Susun List Kurasi

1. User buka halaman Lists.
2. User tap tombol Buat List.
3. User isi judul, deskripsi, dan pilihan publik atau privat.
4. Sistem menyimpan list.
5. User cari film lewat search.
6. User tap film dan pilih Tambahkan ke List.
7. Sistem menyimpan film ke dalam list dengan urutan terakhir.
8. User buka detail list untuk mengubah urutan atau menghapus film.

### 6.6 Tandai Tag pada Diary

1. User buka halaman Diary.
2. User tap entri tontonan.
3. User pilih tag yang sudah ada atau membuat tag baru.
4. Sistem menempelkan tag ke entri watched.
5. User memakai filter tag untuk melihat entri yang memakai tag itu.

### 6.7 Isi Four Favourites

1. User buka profil sendiri.
2. User tap slot favourites yang kosong atau slot yang akan diganti.
3. User mencari film.
4. User memilih film.
5. Sistem menempatkannya pada posisi terpilih dan menggeser film
   sebelumnya ke slot kosong berikutnya.

### 6.8 Like Film

1. User buka detail film.
2. User tap tombol hati.
3. Sistem menyimpan like dan memperbarui jumlah like.
4. Tombol berubah menjadi keadaan sudah di-like.

### 6.9 Ikuti User dan Lihat Feed

1. User membuka profil user lain.
2. User tap tombol Ikuti.
3. Sistem menyimpan relasi follow.
4. User kembali ke Home.
5. Sistem menampilkan aktivitas user yang diikuti, diurutkan dari yang
   terbaru.
6. User menarik ke bawah untuk memuat lebih banyak aktivitas.

### 6.10 Catat Tontonan lewat Form Log

1. User membuka Form Log dari Home atau Detail Film.
2. User memilih film, tanggal tonton, rating, review, dan tag.
3. User tap Simpan.
4. Sistem menyimpan watched, rating, review, dan tag dalam satu
   transaksi.
5. Entri itu otomatis muncul di diary dan di feed.

### 6.11 Cari Member dan Baca Incoming Activity

1. User membuka halaman Members.
2. User mengetik sebagian nama user.
3. Sistem menampilkan hasil beserta status follow.
4. User mengikuti user dari hasil pencarian.
5. User membuka halaman Incoming Activity.
6. Sistem menampilkan pengikut baru dan like pada film di list publik
   user tersebut.

## 7. Matriks Kebutuhan ke Halaman dan Endpoint

| Kebutuhan | Halaman | Endpoint |
|---|---|---|
| FR-AUTH-01 | Register | POST /api/register |
| FR-AUTH-02 | Login | POST /api/login |
| FR-AUTH-03 | Profile | POST /api/logout |
| FR-AUTH-04 | Login | POST /api/login |
| FR-CAT-01 | Home | GET /api/home |
| FR-CAT-02 | Search | GET /api/movies dengan parameter q |
| FR-CAT-03 | Search | GET /api/movies dengan parameter genre_id |
| FR-CAT-04 | Search, Home | GET /api/movies, GET /api/home |
| FR-CAT-05 | Search, Detail | GET /api/movies |
| FR-CAT-06 | Search | GET /api/movies dengan parameter page |
| FR-DET-01 | Detail | GET /api/movies/{id} |
| FR-DET-02 | Detail | GET /api/movies/{id} |
| FR-DET-03 | Detail | GET /api/movies/{id} |
| FR-DET-04 | Detail | GET /api/movies/{id} |
| FR-WL-01 | Detail | POST /api/watchlist |
| FR-WL-02 | Watchlist | DELETE /api/watchlist/{movieId} |
| FR-WL-03 | Watchlist | GET /api/watchlist |
| FR-WT-01 | Detail | POST /api/watched |
| FR-WT-02 | Watched | DELETE /api/watched/{movieId} |
| FR-WT-03 | Watched | GET /api/watched |
| FR-WT-04 | Watched | PATCH /api/watched/{movieId} |
| FR-WT-06 | Detail, Form Log | POST /api/watched, POST /api/diary, POST /api/log |
| FR-REV-01 | Form Review | POST /api/reviews |
| FR-REV-03 | Form Review | PUT /api/reviews/{id} |
| FR-REV-04 | Detail | DELETE /api/reviews/{id} |
| FR-REV-06 | Detail | POST /api/movies/{id}/rate |
| FR-REV-07 | Detail | DELETE /api/movies/{id}/rate |
| FR-PROF-01 | Profile | GET /api/profile |
| FR-PROF-02 | Profile | GET /api/profile/stats |
| FR-PROF-03 | Profile | GET /api/watchlist, GET /api/watched |
| FR-PROF-04 | Profile | tanpa endpoint baru, gabungan endpoint yang sudah ada |
| FR-PROF-05 | Profile | GET /api/tags |
| FR-PROF-06 | Public Profile | GET /api/users/{userId}, GET /api/lists dengan user_id |
| FR-DIA-01 | Diary | GET /api/diary |
| FR-DIA-02 | Diary | GET /api/diary dengan parameter from dan to |
| FR-DIA-03 | Diary | GET /api/diary |
| FR-DIA-04 | Diary | POST /api/diary dengan field note |
| FR-DIA-05 | Diary | POST /api/diary, PUT /api/diary/{id}, DELETE /api/diary/{id} |
| FR-DIA-06 | Diary | POST /api/diary |
| FR-LIST-01 | Form List | POST /api/lists |
| FR-LIST-02 | Form List | PUT /api/lists/{id}, DELETE /api/lists/{id} |
| FR-LIST-03 | List Detail | POST /api/lists/{id}/items, DELETE /api/lists/{id}/items/{movieId} |
| FR-LIST-04 | Lists | GET /api/lists |
| FR-LIST-05 | List Detail | GET /api/lists/{id} |
| FR-LIST-06 | List Detail | POST /api/lists/{id}/items, PATCH /api/lists/{id}/items |
| FR-TAG-01 | Tags | POST /api/tags |
| FR-TAG-02 | Tags | DELETE /api/tags/{id} |
| FR-TAG-03 | Tags | POST /api/diary/{id}/tags |
| FR-TAG-04 | Tags | DELETE /api/diary/{id}/tags/{tagId} |
| FR-TAG-05 | Diary | GET /api/diary dengan parameter tag_id |
| FR-FAV-01 | Four Favourites | PUT /api/favorites |
| FR-FAV-02 | Four Favourites | PUT /api/favorites |
| FR-FAV-03 | Profile, Public Profile | GET /api/favorites, GET /api/users/{userId} |
| FR-LIKE-01 | Detail Film, Review, List Detail | POST /api/likes dengan body likeable_id dan likeable_type |
| FR-LIKE-02 | Detail Film, Review, List Detail | DELETE /api/likes dengan body likeable_id dan likeable_type |
| FR-LIKE-03 | Detail Film | GET /api/likes/{movieId} |
| FR-LIKE-04 | Review, List Detail | GET /api/reviews, GET /api/lists/{id} |
| FR-FOLLOW-01 | Public Profile | POST /api/follow/{userId} |
| FR-FOLLOW-02 | Public Profile | DELETE /api/follow/{userId} |
| FR-FOLLOW-03 | Followers, Following | GET /api/followers, GET /api/following |
| FR-FOLLOW-04 | Public Profile | POST /api/follow/{userId} |
| FR-FEED-01 | Home, Feed | GET /api/feed |
| FR-FEED-02 | Feed | GET /api/feed |
| FR-FEED-03 | Feed | GET /api/feed dengan parameter type dan page |
| FR-FEED-04 | Home, Feed | GET /api/feed dengan parameter limit |
| FR-INCOMING-01 | Incoming Activity | GET /api/activity/incoming |
| FR-INCOMING-02 | Incoming Activity | GET /api/activity/incoming |
| FR-INCOMING-03 | Incoming Activity | tanpa endpoint baru, navigasi ke Public Profile dan Detail Film |
| FR-MEMBERS-01 | Members | GET /api/members |
| FR-MEMBERS-02 | Members | GET /api/members, POST /api/follow/{userId} |
| FR-MEMBERS-03 | Members | GET /api/members |
| FR-LOG-01 | Form Log | POST /api/log |
| FR-LOG-02 | Form Log | POST /api/log |
| FR-LOG-03 | Form Log | POST /api/log |
| FR-LOG-04 | Form Log | POST /api/log |
| FR-HOME-01 | Home | GET /api/home |
| FR-HOME-02 | Home | GET /api/home |
| FR-HOME-03 | Home | GET /api/home |
| FR-HOME-04 | Home | GET /api/home |
| FR-HOME-05 | Home | GET /api/home |
| FR-HOME-06 | Home | GET /api/home |
| FR-ADM-DASH-01 | Admin Dashboard | GET /api/admin/dashboard |
| FR-ADM-DASH-02 | Admin Dashboard | GET /api/admin/dashboard |
| FR-ADM-DASH-03 | Admin Dashboard | GET /api/admin/dashboard |
| FR-ADM-FILM-01 | Admin Movie Form | POST /api/admin/movies |
| FR-ADM-FILM-02 | Admin Movie Form | POST /api/admin/movies multipart |
| FR-ADM-FILM-03 | Admin Movie Form | PUT /api/admin/movies/{id} |
| FR-ADM-FILM-04 | Admin Movies | DELETE /api/admin/movies/{id} |
| FR-ADM-FILM-05 | Admin Movies | DELETE /api/admin/movies/{id} |
| FR-ADM-FILM-06 | Admin Movies | POST /api/admin/movies/{id}/feature |
| FR-ADM-GENRE-01 | Admin Genre Form | POST /api/admin/genres |
| FR-ADM-GENRE-02 | Admin Genre Form | PUT /api/admin/genres/{id} |
| FR-ADM-GENRE-03 | Admin Genres | DELETE /api/admin/genres/{id} |
| FR-ADM-GENRE-04 | Admin Genre Form | POST /api/admin/genres, PUT /api/admin/genres/{id} |
| FR-ADM-USER-01 | Admin Users | GET /api/admin/users |
| FR-ADM-USER-02 | Admin User Detail | GET /api/admin/users/{id} |
| FR-ADM-USER-03 | Admin User Detail | PUT /api/admin/users/{id}/role |
| FR-ADM-USER-04 | Admin Users | tanpa endpoint, batasan di middleware dan service |
| FR-ADM-REV-01 | Admin Reviews | GET /api/admin/reviews |
| FR-ADM-REV-02 | Admin Reviews | DELETE /api/admin/reviews/{id} |
| FR-ADM-REV-03 | Home | GET /api/home |
| FR-ADM-LIST-01 | Admin Lists | GET /api/admin/lists |
| FR-ADM-LIST-02 | Admin Lists | DELETE /api/admin/lists/{id} |
| FR-ADM-LIST-03 | Admin Lists | tanpa endpoint, batasan di service |
| FR-ADM-TAG-01 | Admin Tags | GET /api/admin/tags |
| FR-ADM-TAG-02 | Admin Tags | DELETE /api/admin/tags/{id} |
| FR-ADM-TAG-03 | Admin Tags | GET /api/admin/tags dengan parameter q |
| FR-ADM-LOG-01 | Admin Audit Logs | tanpa endpoint, penulisan di AdminAuditService |
| FR-ADM-LOG-02 | Admin Audit Logs | GET /api/admin/audit-logs |
| FR-COM-01 | Comments | POST /api/reviews/{id}/comments |
| FR-COM-02 | Comments | GET /api/reviews/{id}/comments |
| FR-COM-03 | Comments | DELETE /api/comments/{id} |
| FR-COM-04 | Comments | POST /api/reviews/{id}/comments |
| FR-NOTIF-01 | Notifikasi | GET /api/notifications |
| FR-NOTIF-02 | Notifikasi | GET /api/notifications, PUT /api/notifications/{id}/read, PUT /api/notifications/read-all |
| FR-NOTIF-03 | Notifikasi | tanpa endpoint, batasan di NotificationService |
| FR-APP-01 | Onboarding | tanpa endpoint, flag lokal |
| FR-APP-04 | Settings | tanpa endpoint, teks dari AppStrings |

Catatan: entri diary adalah tabel `diary_entries` tersendiri. Endpoint
tulis diary adalah `POST /api/diary`, `PUT /api/diary/{id}`, dan
`DELETE /api/diary/{id}`. Entri diary diidentifikasi oleh id baris
`diary_entries`, dipakai pada endpoint tag.

Catatan: `GET /api/activity/incoming` tidak memakai tabel terpisah.
Backend menggabungkan aktivitas `followed` yang menunjuk user yang
sedang login dengan aktivitas `liked` pada film yang ada di list publik
user tersebut. Komentar review dan notifikasi tidak termasuk incoming
activity karena keduanya punya halaman tersendiri.

Catatan: seluruh endpoint `/api/admin/*` memakai dua middleware,
`auth:sanctum` dan `EnsureUserIsAdmin`. Request tanpa token menjawab
401 dan token valid dengan role `user` menjawab 403.