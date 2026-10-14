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

- Tujuan: beranda katalog dan cuplikan activity feed.
- Elemen:
  - Search bar di atas.
  - Section Feed, maksimal lima aktivitas terbaru dengan tombol Lihat
    Semua yang menuju halaman Feed.
  - Section Trending, horizontal list poster.
  - Section Populer, horizontal list poster.
- State: loading, data, kosong, error.
  - Feed kosong punya tombol Jelajahi Member agar section tidak kosong.
- Aksi: tap film ke Detail, tap search bar ke Search, tap aktivitas ke
  film atau Public Profile, tap Lihat Semua ke Feed.

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

- Tujuan: cari film.
- Elemen: search bar, daftar hasil pencarian.
- State: belum ada query, searching, hasil, tidak ditemukan, error.
- Aksi: tap film ke Detail.

## 8. Detail Film

- Tujuan: lihat detail film dan aksi.
- Elemen:
  - Backdrop dan poster.
  - Judul, tahun, durasi, rating TMDB.
  - Sinopsis.
  - Tombol Tambah ke Watchlist.
  - Tombol Tandai Sudah Ditonton.
  - Tombol hati Like dengan jumlah like. Letak di bawah judul, terpisah
    dari blok rating bintang.
  - Section review user bila ada.
  - Tombol Tulis Review.
- State: loading, data, error, film tidak ditemukan, sudah di watchlist,
  sudah ditonton, sudah di-like.
- Aksi: tambah watchlist, tandai watched, like atau batalkan like,
  tulis review, ubah review, buka Form Log.

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
- Elemen: pilih bahasa ID atau EN, tentang aplikasi, blok atribusi
  TMDB, logout.
- State: tersimpan.

## 25. Komponen Reusable

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
| ChipFilterRow | Deretan chip filter untuk feed, incoming, dan tag |
| MoviePickerSheet | Picker film dengan search, dipakai bersama |
| EmptyState | Ikon, judul, pesan, aksi |
| LoadingIndicator | Indikator dengan pesan opsional |
| ErrorState | Pesan dan tombol coba lagi |
| PrimaryButton | Aksi utama |
| SecondaryButton | Aksi sekunder |
| CustomTextField | Input dengan label dan error |
| CustomAppBar | App bar dengan aksi |

`ActivityTile` sebelumnya ditulis, sekarang bernama `ActivityItem`.

## 26. Alur Navigasi Utama

```
Splash -> Onboarding -> Login -> Home
Home -> Search -> Detail
Home -> Feed -> Detail
Home -> Feed -> Public Profile
Home -> Detail -> Form Review
Home -> Detail -> Form Log
Home -> Form Log
Home -> Watchlist -> Detail
Home -> Profile -> Tags -> Diary
Home -> Profile -> Four Favourites
Home -> Profile -> Followers -> Public Profile
Home -> Profile -> Following -> Public Profile
Home -> Profile -> Members -> Public Profile
Home -> Profile -> Incoming Activity -> Public Profile
Home -> Profile -> Lists -> List Detail -> Detail
Home -> Profile -> Diary -> Detail
Home -> Profile -> Settings
Public Profile -> Followers -> Public Profile
```

## 27. Aturan Layar

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

## 28. Atribusi TMDB

Blok atribusi wajib tampil di aplikasi, minimal di halaman Settings.
Teks mengikuti bahasa yang sedang dipakai.

Bahasa Inggris:

> This product uses the TMDB API but is not endorsed or certified by
> TMDB.

Bahasa Spanjol:

> Este producto utiliza la API de TMDB pero no está avalado ni
> certificado por TMDB.