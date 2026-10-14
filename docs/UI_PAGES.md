# UI PAGES - Mailboxh

Daftar halaman aplikasi. Detail visual ada di Stitch. Dokumen ini hanya
struktur, alur, dan komponen.

## 1. Splash

- Tujuan: cek sesi, redirect.
- Elemen: logo, nama aplikasi.
- Aksi:
  - Ke Onboarding bila pemakaian pertama.
  - Ke Login bila belum login.
  - Ke Home bila sudah login.
- State: loading, error.

## 2. Onboarding

- Tujuan: pengantar fitur.
- Elemen: 3 slide, tombol Lanjut, tombol Lewati.
- State: slide pertama, slide tengah, slide terakhir.
- Aksi: ke Login setelah selesai atau dilewati.
- Penanda selesai disimpan di shared_preferences dengan key
  `has_seen_onboarding`.

## 3. Login

- Tujuan: masuk akun.
- Elemen: field email, field password, tombol Masuk, link ke Register.
- State: kosong, validasi, loading, error, sukses.

## 4. Register

- Tujuan: buat akun.
- Elemen: field nama, field email, field password, konfirmasi password,
  tombol Daftar.
- State: kosong, validasi, loading, error, sukses.

## 5. Home

- Tujuan: beranda dengan enam section katalog dan cuplikan activity
  feed.
- Elemen, dari atas ke bawah:
  - Search bar.
  - Section Featured, banner besar dengan maksimal lima film yang
    ditandai admin. Section ini boleh kosong dan menampilkan ajakan ke
    admin lewat empty state.
  - Section Latest, horizontal list poster.
  - Section Top Rated, horizontal list poster.
  - Section Most Watched, horizontal list poster.
  - Section Most Watchlisted, horizontal list poster.
  - Section Explore, grid film pilihan acak.
  - Section Feed, maksimal lima aktivitas terbaru dengan tombol Lihat
    Semua menuju halaman Feed.
- State: loading, data, kosong, katalog kosong, error.
  - Katalog kosong punya tombol Jelajahi Member agar halaman tidak
    kosong.
  - Section Featured yang kosong tidak menampilkan judul section. Section
    lain yang kosong menampilkan judul dengan pesan singkat.
- Aksi: tap film ke Detail, tap search bar ke Search, tap aktivitas ke
  film atau Public Profile, tap Lihat Semua ke Feed, tap Lihat Semua
  section ke Search dengan sort yang sesuai.
- Sumber data: satu endpoint `GET /api/home` untuk enam section katalog,
  dan `GET /api/feed` dengan batas lima item untuk bagian feed.
- Catatan: keenam section katalog diambil dalam satu permintaan. Halaman
  tidak melakukan enam request terpisah.

## 6. Feed

- Tujuan: activity feed lengkap beserta filter jenis aktivitas.
- Elemen:
  - Chip filter: Semua, Ditonton, Dinilai, Direview, Disukai, List baru,
    Follow.
  - Daftar aktivitas: nama pelaku, kalimat aktivitas, judul film,
    poster, jam relatif.
- State: loading, data, kosong, filter kosong, error.
- Aksi: tap aktivitas ke Detail Film atau Public Profile, tarik ke bawah
  untuk memuat lebih banyak, ubah filter.
- Sumber data: endpoint `GET /api/feed`.

## 7. Search

- Tujuan: cari dan saring katalog film.
- Elemen:
  - Search bar untuk judul film.
  - Chip genre yang bisa multi-pilih.
  - Chip pengurutan: Terbaru, Judul, Tanggal rilis, Rating.
  - Daftar hasil.
- State: belum ada query, searching, hasil, tidak ditemukan, katalog
  kosong, filter tidak menghasilkan hasil, error.
- Aksi: tap film ke Detail, ubah genre, ubah pengurutan, tarik ke bawah
  untuk halaman berikutnya.
- Sumber data: endpoint `GET /api/movies`.
- Catatan: katalog hanya berisi film yang sudah diinput admin. State
  katalog kosong perlu copy yang berbeda dari state tidak ditemukan,
  karena yang satu berarti fitur jalan dan yang lain berarti admin belum
  mengisi data.

## 8. Detail Film

- Tujuan: lihat detail film dan aksi.
- Elemen, dari atas ke bawah:
  - Backdrop dengan judul, tahun, dan durasi di atasnya. Poster berada
    di sisi kiri menindih sebagian backdrop.
  - Badge genre yang bisa diketuk ke Search dengan filter genre itu.
  - Baris aksi: Tambah ke Watchlist, Tandai Sudah Ditonton, dan tombol
    hati Like dengan jumlah like.
  - Sinopsis.
  - Panel informasi: bahasa, negara, rating rata-rata, jumlah review,
    jumlah watched, dan jumlah watchlist.
  - Section Cast berupa daftar nama pemeran.
  - Section Crew berupa daftar nama crew.
  - Section review user bila ada, dengan tombol Tulis Review.
- State: loading, data, error, film tidak ditemukan, poster kosong,
  backdrop kosong, sinopsis kosong, sudah di watchlist, sudah ditonton,
  sudah di-like, film sudah dinonaktifkan admin.
- Aksi: tambah watchlist, tandai watched, like atau batalkan like,
  tulis review, ubah review, buka Form Log, ketuk genre ke Search.
- Catatan:
  - Poster dan backdrop kosong menampilkan placeholder dari token, bukan
    gambar rusak.
  - Cast dan crew adalah teks dipisah koma. Tampil sebagai chip yang
    bisa dibungkus ke beberapa baris, bukan tabel.
  - Film yang dinonaktifkan admin menampilkan empty state Film tidak
    tersedia, bukan halaman error.
  - Rating rata-rata berasal dari data review user di aplikasi ini.

## 9. Form Review

- Tujuan: beri rating dan review.
- Elemen: rating bintang 1 sampai 5, field review teks, tombol Simpan.
- State: kosong, validasi, loading, error, sukses.
- Catatan: bila review untuk film ini sudah ada, form diisi dengan data
  yang tersimpan dan memakai endpoint ubah.

## 10. Form Log

- Tujuan: mencatat tontonan beserta rating, review, dan tag dalam satu
  form.
- Elemen:
  - Field film, dapat diisi lewat search atau dari film yang sedang
    dibuka di Detail Film.
  - Field tanggal tonton dengan pilihan hari ini.
  - Field catatan tonton.
  - Rating bintang 1 sampai 5 dan field review teks.
  - Input tag dengan pilihan tag yang sudah ada dan pembuatan tag baru.
  - Tombol Simpan.
- State: kosong, validasi, loading, error, sukses, film sudah
  tercatat.
- Aksi: simpan, batal.
- Catatan: field rating, review, tag, dan catatan bersifat opsional.
  Bila film sudah tercatat sebagai watched, form menampilkan pesan dan
  menawarkan untuk membuka form ubah entri yang sudah ada.

## 11. Watchlist

- Tujuan: daftar film yang ingin ditonton.
- Elemen: grid atau list poster, judul, tahun.
- State: loading, data, kosong, error.
- Aksi: tap ke Detail, hapus dari watchlist dengan konfirmasi.

## 12. Watched

- Tujuan: daftar film yang sudah ditonton.
- Elemen: grid atau list poster, judul, tahun, tanggal tonton.
- State: loading, data, kosong, error.
- Aksi: tap ke Detail, ubah tanggal, hapus dengan konfirmasi.

## 13. Diary

- Tujuan: riwayat tontonan.
- Elemen:
  - Filter rentang tanggal.
  - Filter tag berupa chip dari tag milik user, bisa multi-pilih.
  - Daftar entri berisi poster, judul, tanggal, catatan, tag, rating, dan
    cuplikan review.
- State: loading, data, kosong, filter tag tidak menghasilkan hasil,
  error.
- Aksi: tap ke Detail, ubah entri, hapus entri, tambah tag pada entri,
  hapus tag dari entri, tap chip tag untuk menyaring.
- Sumber data: endpoint `GET /api/diary`. Menambah, mengubah, dan
  menghapus dilakukan lewat endpoint watched, bukan endpoint diary.
  Tag pada entri dikelola lewat endpoint tag.

## 14. Profile

- Tujuan: profil user sendiri.
- Elemen:
  - Nama dan email.
  - Empat slot Four Favourites dengan tombol ubah.
  - Baris ringkas: jumlah watched, watchlist, review, like, follower,
    dan following.
  - Sub-tab: Films, Diary, Reviews, Lists, Tags, Stats.
- Isi sub-tab:

  | Sub-tab | Isi | Sumber data |
  |---|---|---|
  | Films | Watchlist dan Watched | `GET /api/watchlist`, `GET /api/watched` |
  | Diary | Riwayat tontonan beserta tag | `GET /api/diary` |
  | Reviews | Review milik user dengan urutan terbaru atau rating | `GET /api/profile/reviews` |
  | Lists | List milik user | `GET /api/lists` |
  | Tags | Nama tag dan jumlah pemakaian, tanpa form tambah | `GET /api/tags` |
  | Stats | Angka watched, watchlist, review, like, list, follower, following | `GET /api/profile/stats` |

- Menu: Edit Four Favourites, Kelola Tag, Followers, Following,
  Members, Pengaturan, Logout.
- State: loading, data, error, sub-tab kosong, sub-tab error.
- Aksi: ganti sub-tab, ubah four favourites, buka tiap sub-tab.
- Catatan: sub-tab dimuat saat pertama kali dibuka, lalu state-nya
  disimpan agar pindah sub-tab tidak memuat ulang.

## 15. Public Profile

- Tujuan: profil user lain.
- Elemen:
  - Nama dan tanggal bergabung.
  - Tombol Ikuti atau Diikuti, tombol Followers dan Following.
  - Empat slot Four Favourites user tersebut, tanpa tombol ubah.
  - Baris ringkas statistik user tersebut.
  - Sub-tab: Films, Diary, Reviews, Lists, Tags, Stats.
- State: loading, data, error, user tidak ditemukan, profil sendiri.
- Aksi: follow, unfollow, ganti sub-tab, buka tiap sub-tab.
- Catatan:
  - Sub-tab Lists hanya memuat list publik user tersebut.
  - Tombol Ikuti disembunyikan bila yang dibuka adalah profil sendiri.

## 16. Four Favourites

- Tujuan: memilih dan mengurutkan empat film favorit.
- Elemen:
  - Empat slot bernomor 1 sampai 4.
  - Tombol ganti pada setiap slot, tombol hapus pada slot terisi.
  - Picker film dengan search.
- State: loading, sebagian terisi, penuh, picking, searching, tidak
  ditemukan, error.
- Aksi: pilih film ke slot, ganti isi slot, hapus isi slot, simpan.

## 17. Lists

- Tujuan: daftar list milik user sendiri dan list publik user lain.
- Elemen:
  - Tab List Saya dan List Publik.
  - Kartu list: judul, deskripsi ringkas, jumlah film, penanda privat
    atau publik.
  - Tombol Buat List.
- State: loading, data, kosong, kosong pada tab aktif, error.
- Aksi: tap list ke List Detail, buat list baru, ubah list, hapus list
  dengan konfirmasi.

## 18. List Detail

- Tujuan: isi sebuah list.
- Elemen:
  - Judul, deskripsi, pemilik, jumlah film, penanda privat atau publik.
  - Daftar film dengan poster, judul, tahun, catatan, urutan.
  - Tombol Tambah Film, tombol Ubah, tombol Hapus List.
- State: loading, data, kosong, error, list privat user lain, bukan
  pemilik.
- Aksi: tap film ke Detail Film, ubah urutan film, hapus film dari list,
  ubah list, hapus list.
- Catatan: tombol Ubah dan Hapus List hanya tampil bila pengguna adalah
  pemilik list.

## 19. Form List

- Tujuan: membuat atau mengubah list.
- Elemen: field judul, field deskripsi, switch publik atau privat,
  tombol Simpan.
- State: kosong, validasi, loading, error, sukses.
- Catatan: mode ubah diisi dari data list yang dipilih, memakai endpoint
  yang sama dengan form buat.

## 20. Tags

- Tujuan: melihat, membuat, dan menghapus tag pribadi.
- Elemen:
  - Field tambah tag.
  - Daftar tag dengan jumlah entri diary yang memakainya.
  - Tombol hapus per tag dengan konfirmasi.
- State: loading, data, kosong, validasi, error, sukses.
- Aksi: buat tag, hapus tag, tap tag untuk menyaring diary.
- Sumber data: endpoint `GET /api/tags` dan `POST /api/tags`.

## 21. Incoming Activity

- Tujuan: melihat aktivitas yang masuk ke user sendiri.
- Elemen:
  - Chip filter: Semua, Pengikut Baru, Disukai di List.
  - Daftar aktivitas: nama pelaku, kalimat aktivitas, film terkait,
    jam relatif.
- State: loading, data, kosong, filter kosong, error.
- Aksi: tap aktivitas ke Public Profile atau Detail Film, ubah filter.
- Sumber data: endpoint `GET /api/activity/incoming`.
- Catatan: aksi like dan unfollow dari halaman ini memakai endpoint yang
  sama seperti halaman Public Profile.

## 22. Members

- Tujuan: menemukan user lain untuk diikuti.
- Elemen:
  - Search bar untuk nama user.
  - Daftar hasil berupa UserCard: avatar inisial, nama, jumlah
    follower, tombol Ikuti atau Diikuti.
- State: belum ada query, searching, hasil, tidak ditemukan, kosong,
  error.
- Aksi: ketik query, tap user ke Public Profile, follow atau unfollow
  langsung dari baris hasil.
- Sumber data: endpoint `GET /api/members`.

## 23. Followers dan Following

- Tujuan: melihat relasi follow.
- Elemen:
  - Tab Followers dan Following.
  - Baris user: avatar inisial, nama, tombol Ikuti atau Diikuti.
- State: loading, data, kosong, error, tab kosong.
- Aksi: tap baris ke Public Profile, follow atau unfollow langsung dari
  baris.

## 24. Settings

- Tujuan: pengaturan aplikasi.
- Elemen: pilih bahasa ID atau EN, tentang aplikasi, blok kredit
  pengelola katalog, versi aplikasi, logout.
- State: tersimpan.
- Catatan: user dengan role `admin` melihat tambahan menu `Masuk ke
  Admin` di halaman ini.

## 25. Admin Dashboard

- Tujuan: ringkasan kondisi aplikasi bagi admin.
- Elemen:
  - Kartu statistik: film aktif, film nonaktif, genre, user, admin,
    review, list, tag.
  - Daftar film yang baru diinput.
  - Daftar aktivitas admin terbaru.
  - Daftar film paling banyak ditonton.
- State: loading, data, kosong, error.
- Sumber data: endpoint `GET /api/admin/dashboard`.
- Aksi: tap kartu ke halaman terkait, tap film ke Admin Movie Form, tap
  aktivitas ke entitas yang diubah.

## 26. Admin Movies

- Tujuan: daftar film untuk dikelola admin.
- Elemen:
  - Search bar judul film.
  - Chip status: Semua, Aktif, Dinonaktifkan.
  - Baris film: poster, judul, tahun, jumlah genre, penanda featured,
    waktu input.
  - Tombol Tambah Film.
- State: loading, data, kosong, katalog kosong, error, filter kosong.
- Aksi: tap film ke Admin Movie Form, tandai featured, nonaktifkan,
  pulihkan, hapus permanen dengan konfirmasi ganda.
- Catatan: film yang dinonaktifkan masih tampil dengan badge, supaya
  admin bisa memulihkannya.

## 27. Admin Movie Form

- Tujuan: menambah atau mengubah data film.
- Elemen:
  - Field judul, judul asli, sinopsis, tanggal rilis, durasi.
  - Field bahasa dan negara.
  - Field cast dan crew berupa teks dipisah koma.
  - `ImageUploadField` untuk poster dan backdrop, dengan pratinjau,
    tombol pilih, tombol ganti, dan tombol hapus gambar.
  - Chip genre multi-pilih.
  - Switch featured.
  - Tombol Simpan dan tombol Hapus Film.
- State: kosong, validasi, memilih gambar, mengunggah, loading, error,
  sukses, gagal simpan.
- Aksi: pilih gambar dari galeri atau kamera, hapus gambar, pilih genre,
  simpan, hapus dengan konfirmasi.
- Catatan:
  - Maksimal lima film featured. Switch featured menolak permintaan kelima dan
    menampilkan pesan dari server.
  - Field gambar bersifat opsional. Film tanpa poster tetap bisa
    disimpan.
  - Gagal mengunggah gambar tidak membuang data teks yang sudah diisi.

## 28. Admin Genres

- Tujuan: daftar genre.
- Elemen:
  - Baris genre: nama, slug, jumlah film.
  - Tombol Tambah Genre.
- State: loading, data, kosong, error.
- Aksi: tap genre ke Admin Genre Form, hapus genre dengan konfirmasi.

## 29. Admin Genre Form

- Tujuan: menambah atau mengubah genre.
- Elemen: field nama, field slug dengan pratinjau slug otomatis, tombol
  Simpan.
- State: kosong, validasi, slug bentrok, loading, error, sukses.
- Catatan: slug bisa dikosongkan dan dibangkitkan backend dari nama.

## 30. Admin Users

- Tujuan: daftar user.
- Elemen:
  - Search bar nama atau email.
  - Chip filter role.
  - Baris user: avatar inisial, nama, email, role, jumlah film di
    watchlist dan watched.
- State: loading, data, kosong, error, filter kosong.
- Aksi: tap user ke Admin User Detail.

## 31. Admin User Detail

- Tujuan: melihat dan mengubah satu user.
- Elemen: nama, email, tanggal bergabung, statistik, aktivitas terbaru,
  selector role.
- State: loading, data, error, user tidak ditemukan, role sendiri.
- Catatan: selector role untuk admin sendiri dinonaktifkan dengan pesan
  alasan. Admin tidak dapat menurunkan role dirinya sendiri.

## 32. Admin Reviews

- Tujuan: moderasi review.
- Elemen:
  - Search bar.
  - Chip filter rating dan film.
  - Baris review: nama user, judul film, rating, cuplikan isi, waktu.
- State: loading, data, kosong, error, filter kosong.
- Aksi: hapus review dengan konfirmasi.
- Catatan: menghapus review langsung mengubah nilai Top Rated.

## 33. Admin Lists

- Tujuan: moderasi list.
- Elemen:
  - Search bar.
  - Chip filter publik dan privat.
  - Baris list: judul, pemilik, jumlah film, publik atau privat, waktu.
- State: loading, data, kosong, error, filter kosong.
- Aksi: hapus list dengan konfirmasi.
- Catatan: menghapus list tidak menghapus film, review, atau like.

## 34. Admin Tags

- Tujuan: moderasi tag.
- Elemen:
  - Search bar nama tag.
  - Baris tag: nama, pemilik, jumlah entri diary yang memakainya.
- State: loading, data, kosong, error, filter kosong.
- Aksi: hapus tag dengan konfirmasi.
- Catatan: menghapus tag melepasnya dari seluruh entri diary.

## 35. Admin Audit Logs

- Tujuan: melihat riwayat tindakan admin.
- Elemen:
  - Chip filter jenis entitas.
  - Chip filter admin.
  - Baris log: waktu, nama admin, tindakan, jenis entitas, keterangan
    ringkas.
- State: loading, data, kosong, error, filter kosong.
- Catatan: tidak ada aksi hapus atau ubah. Halaman ini hanya baca.

## 36. Aturan Area Admin

- Area admin memakai `AdminShell`, satu kerangka dengan `AdminDrawer` di
  sisi kiri.
- `AdminDrawer` berisi delapan tautan sesuai delapan fitur admin, plus
  tombol Kembali ke Beranda.
- Rute admin diawali `/admin/` dan dijaga route guard yang memeriksa
  role. Guard mengembalikan user ke `/home` beserta pesan, tidak pernah
  ke halaman error.
- Halaman admin tidak pernah dibuka lewat push notification atau deep
  link dari luar. Satu-satunya cara masuk adalah navigasi `go` dari
  Settings atau dari `AdminShell`.
- Login sebagai admin tetap lewat halaman Login yang sama. Tidak ada
  form login terpisah.
- Maksimal tiga warna dominan per halaman admin, sama seperti halaman
  user. Tidak ada gaya khusus yang membedakan area admin secara warna.

## 37. Komponen Reusable

| Komponen | Peran |
|---|---|
| MovieCard | Poster, judul, tahun |
| MovieListItem | Poster kecil, judul, tahun, subtitle |
| RatingStars | Bintang 1 sampai 5, mode baca dan mode input |
| LikeButton | Ikon hati, jumlah like, mode aktif dan mode nonaktif |
| FollowButton | Tombol Ikuti dan Diikuti |
| TagChip | Nama tag, bisa dipilih dan bisa dilepas |
| ListCard | Judul list, deskripsi ringkas, jumlah film, penanda privasi |
| ActivityItem | Pelaku, kalimat aktivitas, film terkait, jam relatif |
| UserCard | Avatar inisial, nama, jumlah follower, tombol follow |
| FavouriteSlot | Satu slot favourites, terisi atau kosong |
| SectionHeader | Judul section dengan aksi opsional |
| ChipFilterRow | Deretan chip filter untuk feed, incoming, tag, dan genre |
| MoviePickerSheet | Picker film dengan search, dipakai bersama |
| GenreChip | Nama genre, bisa dipilih |
| StatCard | Angka besar dengan label dan ikon |
| ImageUploadField | Pilih, pratinjau, ganti, dan hapus gambar |
| ConfirmDialog | Dialog konfirmasi dengan judul, pesan, dan dua aksi |
| DataTableRow | Baris data admin dengan aksi di kanan |
| EmptyState | Ikon, judul, pesan, aksi |
| LoadingIndicator | Indikator dengan pesan opsional |
| ErrorState | Pesan dan tombol coba lagi |
| PrimaryButton | Aksi utama |
| SecondaryButton | Aksi sekunder |
| CustomTextField | Input dengan label dan error |
| CustomAppBar | App bar dengan aksi |
| AdminShell | Kerangka area admin dengan drawer dan app bar |
| AdminDrawer | Menu delapan fitur admin |

`ActivityTile` sebelumnya ditulis, sekarang bernama `ActivityItem`.
`PrimaryButton` dan `SecondaryButton` diimplementasikan sebagai satu
komponen `AppButton` dengan enum varian.

## 38. Alur Navigasi Utama

```
/ -> /onboarding -> /login -> /home
/home -> /search -> /movie/:movieId
/home -> /home -> /movie/:movieId
/home -> /feed -> /movie/:movieId
/home -> /feed -> /user/:userId
/home -> /movie/:movieId -> /review/:movieId
/home -> /movie/:movieId -> /log?movieId
/home -> /log
/home -> /watchlist -> /movie/:movieId
/home -> /profile -> /diary -> /movie/:movieId
/home -> /profile -> /tags -> /diary
/home -> /profile -> /favorites/edit
/home -> /profile -> /followers -> /user/:userId
/home -> /profile -> /following -> /user/:userId
/home -> /profile -> /members -> /user/:userId
/home -> /profile -> /activity/incoming -> /user/:userId
/home -> /profile -> /lists -> /lists/:listId -> /movie/:movieId
/home -> /profile -> /lists -> /lists/new
/home -> /profile -> /lists -> /lists/:listId/edit
/home -> /profile -> /settings
/home -> /settings -> /admin/dashboard
/user/:userId -> /followers -> /user/:userId
```

## 39. Alur Navigasi Admin

```
/admin/dashboard
/admin/dashboard -> /admin/movies
/admin/movies -> /admin/movies/new
/admin/movies -> /admin/movies/:movieId
/admin/movies -> /admin/genres
/admin/genres -> /admin/genres/new
/admin/genres -> /admin/genres/:genreId
/admin/movies -> /admin/users
/admin/users -> /admin/users/:userId
/admin/movies -> /admin/reviews
/admin/movies -> /admin/lists
/admin/movies -> /admin/tags
/admin/movies -> /admin/audit-logs
/admin/* -> /home
```

Seluruh perpindahan di dalam area admin memakai `context.go`, bukan
`context.push`, supaya tombol kembali sistem tidak menumpuk halaman
admin di atas satu sama lain.

Sub-tab profil memakai query string `?tab=`, bukan path terpisah, supaya
halaman yang sama dipakai ulang untuk profil sendiri dan profil user
lain. Nilai yang dipakai: `films`, `diary`, `reviews`, `lists`, `tags`,
`stats`.

## 40. Aturan Layar

- Semua string dari AppStrings. Widget tidak boleh punya string const
  berisi teks yang tampil ke user.
- Semua nilai warna, spacing, radius, dan ukuran font dari token.
- Setiap halaman punya state loading, kosong, dan error.
- Target sentuh minimal 48x48.
- Maksimal tiga warna dominan per halaman.
- Setiap halaman yang butuh login mengandalkan penjaga route, bukan
  pemeriksaan manual di dalam build.
- Tombol Like tidak memakai warna rating bintang. Warna state aktif
  mengikuti token warna primary.
- Empat slot favourites selalu empat, termasuk yang kosong. Layout tidak
  boleh berubah saat isinya bertambah.
- Picker film untuk list dan favourites memakai satu komponen
  `MoviePickerSheet`, bukan dua implementasi berbeda.
- Avatar user memakai inisial dari `name`, bukan gambar. Tidak ada
  aset avatar yang perlu dimuat.
- Sub-tab profil tidak boleh memuat lebih dari satu endpoint per
  perpindahan tab.
- ActivityItem dipakai bersama oleh Feed, Incoming Activity, dan Home.

## 41. Atribusi

Tidak ada lagi atribusi TMDB. Data film sepenuhnya milik aplikasi dan
diinput admin.

Blok kredit wajib tampil di halaman Settings:

> Katalog film dikelola oleh admin Mailboxh. Data film diinput manual
> dan bukan berasal dari layanan film pihak ketiga.

Bahasa Inggris:

> Movie catalogue is maintained by the Mailboxh admin. Film data is
> entered manually and does not come from any third-party film service.

Halaman Settings juga menampilkan versi aplikasi. Tidak ada logo atau
nama layanan film pihak ketiga di mana pun dalam aplikasi.