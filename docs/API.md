# API - Mailboxh

Dokumentasi REST API Laravel untuk aplikasi Mailboxh.

Base URL:

```
http://127.0.0.1:8000/api
```

Untuk Android emulator gunakan `http://10.0.2.2:8000/api`. Untuk device
fisik gunakan IP LAN laptop. Alamat ini dikirim ke aplikasi lewat
`--dart-define=API_BASE_URL`.

## 1. Format Respons

Sukses:

```json
{
  "success": true,
  "data": {}
}
```

Error:

```json
{
  "success": false,
  "message": "Pesan error",
  "errors": {}
}
```

## 2. Autentikasi

- Memakai Laravel Sanctum.
- Setelah login, server mengembalikan token.
- Token dikirim pada header `Authorization: Bearer <token>`.
- Endpoint yang butuh autentikasi ditandai pada judul bagian.

## 3. Endpoint

### 3.1 Auth

#### POST /api/register

Tidak butuh autentikasi.

Request:

```json
{
  "name": "Budi",
  "email": "budi@example.com",
  "password": "password123",
  "password_confirmation": "password123"
}
```

Response 201:

```json
{
  "success": true,
  "data": {
    "user": {
      "id": 1,
      "name": "Budi",
      "email": "budi@example.com"
    },
    "token": "1|abc..."
  }
}
```

Kemungkinan gagal: 409, 422, 429.

#### POST /api/login

Tidak butuh autentikasi.

Request:

```json
{
  "email": "budi@example.com",
  "password": "password123"
}
```

Response 200:

```json
{
  "success": true,
  "data": {
    "user": {
      "id": 1,
      "name": "Budi",
      "email": "budi@example.com"
    },
    "token": "2|def..."
  }
}
```

Kemungkinan gagal: 401, 422, 429.

#### POST /api/logout

Butuh autentikasi.

Response 200:

```json
{
  "success": true,
  "data": null
}
```

Kemungkinan gagal: 401.

#### GET /api/me

Butuh autentikasi. Dipakai saat splash untuk memeriksa sesi.

Response 200:

```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "Budi",
    "email": "budi@example.com"
  }
}
```

Kemungkinan gagal: 401.

### 3.2 Katalog Film

Seluruh endpoint pada bagian ini tidak butuh autentikasi. Endpoint ini
boleh dipanggil tamu.

Konsekuensi untuk respons:

- Field `liked`, `in_watchlist`, dan `diary_entry_id` hanya diisi bila
  request membawa token yang valid. Tanpa token, field tersebut bernilai
  netral.
- Film yang dinonaktifkan admin tidak pernah dikembalikan.
- Halaman detail film tetap berada di route privat karena memerlukan
  state user. Endpoint film's tetap publik.

#### GET /api/movies

Daftar film dengan pencarian, filter genre, dan pengurutan.

Parameter query:

| Nama | Tipe | Keterangan |
|---|---|---|
| q | string | Pencarian judul, minimal 2 karakter, opsional |
| genre_id | integer | Filter satu genre, opsional |
| sort | string | `title`, `release_date`, `latest`, `rating`, opsional |
| page | integer | Opsional, 20 item per halaman |

Response 200:

```json
{
  "success": true,
  "data": [
    {
      "id": 12,
      "title": "Judul Film",
      "original_title": "Original Title",
      "overview": "Sinopsis film.",
      "release_date": "1994-01-01",
      "poster_url": "http://127.0.0.1:8000/storage/posters/8f3a1c.jpg",
      "backdrop_url": null,
      "runtime": 120,
      "language": "en",
      "country": "United States",
      "cast": "Nama Satu, Nama Dua",
      "crew": "Nama Sutradara",
      "genres": [
        { "id": 1, "name": "Drama", "slug": "drama" }
      ],
      "average_rating": 4.3,
      "review_count": 17,
      "liked": false,
      "in_watchlist": false,
      "diary_entry_id": null
    }
  ],
  "meta": {
    "page": 1,
    "per_page": 20,
    "total": 12
  }
}
```

`poster_url` dan `backdrop_url` sudah berupa URL penuh yang dibentuk
backend dari `APP_URL`. Klien tidak menyusun URL sendiri.

Kemungkinan gagal: 422, 429.

#### GET /api/movies/{id}

Response 200:

```json
{
  "success": true,
  "data": {
    "id": 12,
    "title": "Judul Film",
    "original_title": "Original Title",
    "overview": "Sinopsis film.",
    "release_date": "1994-01-01",
    "poster_url": "http://127.0.0.1:8000/storage/posters/8f3a1c.jpg",
    "backdrop_url": null,
    "runtime": 120,
    "language": "en",
    "country": "United States",
    "cast": "Nama Satu, Nama Dua",
    "crew": "Nama Sutradara",
    "genres": [
      { "id": 1, "name": "Drama", "slug": "drama" }
    ],
    "average_rating": 4.3,
    "review_count": 17,
    "watched_count": 48,
    "watchlist_count": 12,
    "like_count": 93,
    "liked": false,
    "in_watchlist": false,
    "watched_at": null,
    "diary_entry_id": null
  }
}
```

Kemungkinan gagal: 404, 429.

Catatan:

- Film yang dinonaktifkan admin menjawab 404, bukan 403. User tidak
  perlu tahu bahwa film itu pernah ada.
- `average_rating` bernilai null bila film belum punya review.

#### GET /api/genres

Daftar genre beserta jumlah film aktif per genre.

Tidak butuh autentikasi.

Response 200:

```json
{
  "success": true,
  "data": [
    { "id": 1, "name": "Drama", "slug": "drama", "movie_count": 4 }
  ]
}
```

Kemungkinan gagal: 429.

#### GET /api/home

Butuh autentikasi. Satu permintaan untuk enam section beranda.

Response 200:

```json
{
  "success": true,
  "data": {
    "featured": [
      { "id": 12, "title": "Judul Film", "poster_url": "http://...", "overview": "...", "average_rating": 4.3 }
    ],
    "latest": [
      { "id": 12, "title": "Judul Film", "poster_url": "http://...", "release_date": "1994-01-01", "average_rating": 4.3 }
    ],
    "top_rated": [
      { "id": 12, "title": "Judul Film", "poster_url": "http://...", "average_rating": 4.6, "review_count": 25 }
    ],
    "most_watched": [
      { "id": 12, "title": "Judul Film", "poster_url": "http://...", "watched_count": 48 }
    ],
    "most_watchlisted": [
      { "id": 12, "title": "Judul Film", "poster_url": "http://...", "watchlist_count": 12 }
    ],
    "explore": [
      { "id": 12, "title": "Judul Film", "poster_url": "http://...", "release_date": "1994-01-01" }
    ]
  }
}
```

Kemungkinan gagal: 401, 429.

Batas jumlah item:

| Section | Jumlah |
|---|---|
| featured | 5 |
| latest | 10 |
| top_rated | 10 |
| most_watched | 10 |
| most_watchlisted | 10 |
| explore | 10 |

Catatan:

- `featured` boleh berisi array kosong bila admin belum menandai film.
- `top_rated` hanya berisi film dengan minimal satu review.
- Keenam query dijalankan di dalam satu transaksi baca.
### 3.3 Watchlist

Seluruh endpoint butuh autentikasi.

#### GET /api/watchlist

Response 200: daftar film di watchlist user.

```json
{
  "success": true,
  "data": [
    {
      "movie_id": 123,
      "title": "Judul Film",
      "poster_path": "/abc.jpg",
      "release_date": "2024-01-01",
      "added_at": "2026-10-14T08:00:00Z"
    }
  ]
}
```

#### POST /api/watchlist

Request:

```json
{
  "movie_id": 123
}
```

Response 201. Gagal dengan 409 bila film sudah ada di watchlist.

#### DELETE /api/watchlist/{movieId}

Response 200. Path memakai `movie_id`, bukan id baris lokal.

Kemungkinan gagal: 401, 404.

### 3.4 Watched

Seluruh endpoint butuh autentikasi.

#### GET /api/watched

Response 200: daftar film yang sudah ditonton.

```json
{
  "success": true,
  "data": [
    {
      "movie_id": 123,
      "title": "Judul Film",
      "poster_path": "/abc.jpg",
      "release_date": "2024-01-01",
      "watched_at": "2026-10-14",
      "note": "Nonton bareng teman"
    }
  ]
}
```

#### POST /api/watched

Request:

```json
{
  "movie_id": 123,
  "watched_at": "2026-10-14",
  "note": "Nonton bareng teman"
}
```

`watched_at` opsional. Bila tidak dikirim, backend memakai tanggal hari
ini. `note` opsional.

Response 201. Gagal dengan 409 bila film sudah tercatat sebagai watched.
Bila film masih ada di watchlist, baris watchlist dihapus otomatis.
Lihat FR-WT-05.

#### PATCH /api/watched/{movieId}

Request:

```json
{
  "watched_at": "2026-10-15",
  "note": "Revisi catatan"
}
```

Field yang dapat diubah hanya `watched_at` dan `note`. Rating dan review
diubah lewat endpoint reviews.

Response 200.

#### DELETE /api/watched/{movieId}

Response 200. Menghapus entri ini juga menghapus tampilannya dari diary.

Kemungkinan gagal: 401, 404.

### 3.5 Review

Seluruh endpoint butuh autentikasi.

#### GET /api/reviews

Response 200: daftar review milik user.

```json
{
  "success": true,
  "data": [
    {
      "id": 7,
      "movie_id": 123,
      "title": "Judul Film",
      "poster_path": "/abc.jpg",
      "rating": 4,
      "content": "Bagus.",
      "updated_at": "2026-10-14T09:00:00Z"
    }
  ]
}
```

#### POST /api/reviews

Request:

```json
{
  "movie_id": 123,
  "rating": 4,
  "content": "Bagus"
}
```

Validasi:

| Field | Aturan |
|---|---|
| movie_id | Wajib, integer |
| rating | Wajib, integer 1 sampai 5 |
| content | Opsional, teks |

Response 201. Bila user sudah punya review untuk film yang sama, backend
mengembalikan 409 dan aplikasi memakai `PUT` untuk memperbarui.

#### PUT /api/reviews/{id}

Request:

```json
{
  "rating": 5,
  "content": "Sangat bagus"
}
```

Response 200. Hanya pemilik review yang boleh mengubah.

#### DELETE /api/reviews/{id}

Response 200. Hanya pemilik review yang boleh menghapus.

Kemungkinan gagal: 401, 403, 404.

#### POST /api/movies/{id}/rate

Menyimpan atau mengubah rating bintang tanpa membuat entri diary.
Path memakai id film.

Request:

```json
{
  "rating": 4
}
```

Validasi:

| Field | Aturan |
|---|---|
| rating | Wajib, integer 1 sampai 5 |

Response 201 berisi review milik user untuk film tersebut. Bila user
belum punya review, baris `reviews` dibuat dengan `content` null. Bila
film masih ada di watchlist, baris watchlist dihapus otomatis.

Kemungkinan gagal: 401, 404, 422.

#### DELETE /api/movies/{id}/rate

Menghapus rating milik user untuk film tersebut. Entri diary tidak
tersentuh.

Response 200.

Kemungkinan gagal: 401, 404.

### 3.6 Profil

Seluruh endpoint butuh autentikasi.

#### GET /api/profile

Response 200: data user.

```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "Budi",
    "email": "budi@example.com"
  }
}
```

#### GET /api/profile/stats

Response 200:

```json
{
  "success": true,
  "data": {
    "total_watched": 10,
    "total_watchlist": 5,
    "total_reviews": 8,
    "average_rating": 3.8,
    "total_likes": 24,
    "total_lists": 3,
    "total_followers": 12,
    "total_following": 8
  }
}
```

Endpoint ini juga melayani sub-tab Stats pada halaman profil.

#### GET /api/profile/reviews

Sub-tab Reviews pada halaman profil. Bentuk respons sama seperti
`GET /api/reviews`.

Parameter query: `page`, `sort` dengan nilai `recent` atau `rating`.

Kemungkinan gagal: 401.

Catatan:

- Sub-tab Films memakai `GET /api/watchlist` dan `GET /api/watched`.
- Sub-tab Diary memakai `GET /api/diary`.
- Sub-tab Lists memakai `GET /api/lists`.
- Sub-tab Tags memakai `GET /api/tags`.
- Sub-tab Stats memakai `GET /api/profile/stats`.
- Tidak ada endpoint khusus untuk menggabungkan seluruh sub-tab.
  Aplikasi memanggil endpoint yang dibutuhkan per sub-tab.

### 3.7 Diary

Seluruh endpoint butuh autentikasi. Diary adalah tabel `diary_entries`
yang tersendiri, bukan turunan dari `watched`.

#### GET /api/diary

Endpoint baca dengan pengelompokan per tanggal.

Parameter query:

| Nama | Tipe | Keterangan |
|---|---|---|
| from | date | Awal rentang tanggal, opsional |
| to | date | Akhir rentang tanggal, opsional |
| tag_id | integer | Filter satu tag milik user, opsional |
| page | integer | Opsional |

Response 200:

```json
{
  "success": true,
  "data": [
    {
      "watched_date": "2026-10-14",
      "items": [
        {
          "id": 31,
          "movie": {
            "id": 12,
            "title": "Judul Film",
            "poster_url": "http://127.0.0.1:8000/storage/posters/8f3a1c.jpg",
            "release_date": "1994-01-01"
          },
          "note": "Nonton bareng teman",
          "tags": [
            { "id": 3, "name": "rewatch" }
          ],
          "rating": 4,
          "content": "Bagus."
        }
      ]
    }
  ]
}
```

Kemungkinan gagal: 401, 422.

#### POST /api/diary

Request:

```json
{
  "movie_id": 12,
  "watched_date": "2026-10-14",
  "note": "Nonton bareng teman"
}
```

Validasi:

| Field | Aturan |
|---|---|
| movie_id | Wajib, integer, exists di movies yang tidak dihapus |
| watched_date | Opsional, tanggal, default hari ini |
| note | Opsional, teks maksimal 1000 karakter |

Response 201 dengan entri yang tersimpan.

Kemungkinan gagal: 401, 409, 422.

Catatan:

- Entri diary boleh berulang untuk film yang sama selama `watched_date`
  berbeda. Kombinasi `(user_id, movie_id, watched_date)` harus unik, jadi
  entri dengan tanggal sama menghasilkan 409.
- Bila film masih ada di watchlist, baris watchlist dihapus otomatis.
- Endpoint ini tidak membuat baris `watched`. Endpoint `POST /api/log`
  membuat keduanya sekaligus.
- Tag dilepas lewat `POST /api/diary/{id}/tags`.

#### PUT /api/diary/{id}

Request:

```json
{
  "watched_date": "2026-10-15",
  "note": "Revisi catatan"
}
```

Field `movie_id` tidak dapat diubah. Pindahkan entri dengan menghapus
dan membuat ulang bila film perlu diganti.

Response 200.

Kemungkinan gagal: 401, 403, 404, 422.

#### DELETE /api/diary/{id}

Response 200. Menghapus entri ini juga melepas seluruh tag yang menempel
padanya.

Kemungkinan gagal: 401, 403, 404.

### 3.8 Lists

Seluruh endpoint butuh autentikasi.

#### GET /api/lists

Menampilkan list milik user yang sedang login. Endpoint ini juga dipakai
untuk melihat list milik user lain yang publik.

Parameter query:

| Nama | Tipe | Keterangan |
|---|---|---|
| user_id | integer | Pilihan. ID user pemilik list. Default user sendiri |
| page | integer | Opsional |

Response 200:

```json
{
  "success": true,
  "data": [
    {
      "id": 5,
      "user_id": 1,
      "title": "Klasik 90an",
      "description": "Film yang shredded di masa kecil.",
      "is_public": true,
      "item_count": 12,
      "likes_count": 3,
      "is_liked": false,
      "can_edit": true,
      "created_at": "2026-10-14T08:00:00Z"
    }
  ]
}
```

Kemungkinan gagal: 401, 403, 422.

Catatan:

- List privat milik user lain tidak dikembalikan. Backend menjawab 403
  bila `user_id` menunjuk ke list privat yang bukan milik pemanggil.
- `item_count` membuat halaman daftar list tidak perlu request tambahan.
- `likes_count` dan `is_liked` memakai relasi polymorphic `likes`.

#### POST /api/lists

Request:

```json
{
  "title": "Klasik 90an",
  "description": "Film yang shredded di masa kecil.",
  "is_public": true
}
```

Validasi:

| Field | Aturan |
|---|---|
| title | Wajib, string 1 sampai 120 karakter |
| description | Opsional, teks maksimal 1000 karakter |
| is_public | Opsional, boolean, default false |

Response 201 dengan bentuk list seperti pada `GET /api/lists`. Setiap
pembuatan list menulis satu baris `activities` dengan type
`list_created`.

#### GET /api/lists/{id}

Response 200 berisi detail list beserta isinya.

```json
{
  "success": true,
  "data": {
    "id": 5,
    "user_id": 1,
    "owner_name": "Budi",
    "title": "Klasik 90an",
    "description": "Film yang shredded di masa kecil.",
    "is_public": true,
    "can_edit": true,
    "item_count": 12,
    "likes_count": 3,
    "is_liked": false,
    "items": [
      {
        "id": 21,
        "movie_id": 123,
        "title": "Judul Film",
        "poster_path": "/abc.jpg",
        "release_date": "1994-01-01",
        "note": "Nonton ulang tiap tahun.",
        "order_index": 0
      }
    ]
  }
}
```

Catatan:

- `can_edit` bernilai true hanya untuk pemilik list.
- `can_edit` bernilai false bila pemanggil bukan pemilik. Backend tidak
  mengirim `is_public` bila nilainya false.

Kemungkinan gagal: 401, 403, 404.

#### PUT /api/lists/{id}

Request:

```json
{
  "title": "Klasik 90an Revisi",
  "description": "Deskripsi baru.",
  "is_public": false
}
```

Field yang tidak dikirim tidak berubah. Response 200. Hanya pemilik list
yang boleh mengubah.

Kemungkinan gagal: 401, 403, 404, 422.

#### DELETE /api/lists/{id}

Response 200. Isi list terhapus mengikuti list. Hanya pemilik list yang
boleh menghapus.

Kemungkinan gagal: 401, 403, 404.

#### POST /api/lists/{id}/items

Request:

```json
{
  "movie_id": 123,
  "note": "Nonton ulang tiap tahun."
}
```

Validasi:

| Field | Aturan |
|---|---|
| movie_id | Wajib, integer |
| note | Opsional, teks maksimal 500 karakter |

`order_index` diisi otomatis oleh backend dari nilai terbesar yang ada.

Response 201. Film yang sudah ada di list tersebut menghasilkan 409.

Kemungkinan gagal: 401, 403, 404, 409, 422.

#### DELETE /api/lists/{id}/items/{movieId}

Response 200. Path memakai `movie_id`, bukan id baris `list_items`.

Kemungkinan gagal: 401, 403, 404.

#### PATCH /api/lists/{id}/items

Mengubah urutan film dalam list.

Request:

```json
{
  "order": [456, 123, 789]
}
```

Validasi:

| Field | Aturan |
|---|---|
| order | Wajib, array id film yang sudah ada di list |

Backend menulis ulang `order_index` sesuai urutan yang dikirim, dimulai
dari 0.

Response 200 dengan `items` dalam urutan baru.

Kemungkinan gagal: 401, 403, 404, 422.

### 3.9 Tags

Seluruh endpoint butuh autentikasi.

#### GET /api/tags

Response 200: daftar tag milik user beserta jumlah pemakaian.

```json
{
  "success": true,
  "data": [
    {
      "id": 3,
      "name": " rewatch",
      "usage_count": 5
    }
  ]
}
```

Kemungkinan gagal: 401.

#### POST /api/tags

Request:

```json
{
  "name": "rewatch"
}
```

Validasi:

| Field | Aturan |
|---|---|
| name | Wajib, string 1 sampai 40 karakter |

Nama tag dibandingkan case-insensitive. Tag dengan nama yang sudah ada
milik user yang sama menghasilkan 409, bukan membuat duplikat.

Response 201 dengan tag yang sudah tersimpan.

Kemungkinan gagal: 401, 409, 422.

#### DELETE /api/tags/{id}

Response 200. Tag yang masih dipakai dilepas dari seluruh entri diary
secara otomatis lewat cascade.

Kemungkinan gagal: 401, 404.

#### POST /api/diary/{id}/tags

Menempelkan tag ke satu entri diary. `id` adalah id baris
`diary_entries`, bukan tanggal tonton.

Request:

```json
{
  "tag_id": 3
}
```

Response 201. Entri diary yang sama tidak bisa memakai tag yang sama dua
kali, hasilnya 409.

Kemungkinan gagal: 401, 404, 409, 422.

#### DELETE /api/diary/{id}/tags/{tagId}

Melepas tag dari satu entri diary tanpa menghapus tag itu sendiri.

Response 200.

Kemungkinan gagal: 401, 404.

### 3.10 Four Favourites

Seluruh endpoint butuh autentikasi.

#### GET /api/favorites

Response 200: Empat film favorit user sendiri, sudah terisi posisi.

```json
{
  "success": true,
  "data": [
    {
      "position": 1,
      "movie_id": 123,
      "title": "Judul Film",
      "poster_path": "/abc.jpg",
      "release_date": "1994-01-01"
    }
  ]
}
```

Kemungkinan gagal: 401.

#### PUT /api/favorites

Request mengirim seluruh isi favourites dalam satu operasi.

```json
{
  "items": [
    {
      "position": 1,
      "movie_id": 123
    },
    {
      "position": 2,
      "movie_id": 456
    }
  ]
}
```

Validasi:

| Field | Aturan |
|---|---|
| items | Wajib, array maksimal 4 |
| items.position | Wajib, integer 1 sampai 4, unik dalam satu request |
| items.movie_id | Wajib, integer, unik dalam satu request |

Response 200 dengan isi favourites terbaru. Endpoint ini menggantikan
isi lama, jadi user dapat mengurangi jumlah favourites dari empat menjadi
nol. Film yang tidak lagi diposisikan dilepas dari tabel `favorites`.

Kemungkinan gagal: 401, 422.

Catatan:

- Endpoint ini dipakai oleh halaman profil user lain, halaman followers,
  dan halaman following.
- Favourites user lain dibaca dari endpoint ini. Tidak ada endpoint
  terpisah untuk favourites user lain.
- Daftar list dan watched user lain diambil dari `GET /api/lists` dan
  `GET /api/users/{userId}/watched`.

### 3.11 Likes

Seluruh endpoint butuh autentikasi. Tabel `likes` polymorphic, sehingga
satu endpoint melayani like pada film, review, dan list.

`likeable_type` memakai nama class penuh:

| Nilai | Target |
|---|---|
| `App\Models\Movie` | Film |
| `App\Models\Review` | Review |
| `App\Models\MovieList` | List |

#### POST /api/likes

Request:

```json
{
  "likeable_id": 7,
  "likeable_type": "App\\Models\\Review"
}
```

Validasi:

| Field | Aturan |
|---|---|
| likeable_id | Wajib, integer |
| likeable_type | Wajib, string, salah satu class di atas |

Response 201:

```json
{
  "success": true,
  "data": {
    "likeable_id": 7,
    "likeable_type": "App\\Models\\Review",
    "liked": true,
    "like_count": 42
  }
}
```

Kemungkinan gagal: 401, 404, 409, 422.

Catatan:

- Target yang sudah di-like menghasilkan 409.
- Target yang tidak ditemukan menghasilkan 404.
- Like pada review membuat notifikasi `like_review` untuk pemilik review.
- Like pada list membuat notifikasi `like_list` untuk pemilik list.
- Like tidak membuat rating, tidak membuat review, dan tidak mengubah
  status watched.

#### DELETE /api/likes

Like dilepas lewat body, bukan path.

Request:

```json
{
  "likeable_id": 7,
  "likeable_type": "App\\Models\\Review"
}
```

Response 200 dengan bentuk data yang sama seperti `POST /api/likes`,
dengan `liked` bernilai false dan `like_count` terbaru.

Kemungkinan gagal: 401, 404, 422.

#### GET /api/likes

Response 200: daftar yang di-like user, untuk state tombol hati.

```json
{
  "success": true,
  "data": [
    {
      "id": 9,
      "likeable_id": 123,
      "likeable_type": "App\\Models\\Movie",
      "likeable": {
        "id": 123,
        "title": "Judul Film",
        "poster_path": "/abc.jpg"
      },
      "liked_at": "2026-10-14T08:00:00Z"
    }
  ]
}
```

Kemungkinan gagal: 401.

### 3.12 Follow

Seluruh endpoint butuh autentikasi.

#### POST /api/follow/{userId}

Menjalankan follow. Path memakai id user yang diikuti.

Response 200:

```json
{
  "success": true,
  "data": {
    "user_id": 2,
    "is_following": true,
    "follower_count": 12
  }
}
```

Kemungkinan gagal: 401, 404, 409.

Catatan:

- User tidak dapat mengikuti dirinya sendiri, hasilnya 422.
- Mengikuti user yang sudah diikuti menghasilkan 409.
- Endpoint ini idempoten dari sisi tampilan: tombol sudah aktif sehingga
  aplikasi tidak memanggilnya dua kali.
- Follow membuat notifikasi `follow` untuk user yang diikuti.

#### DELETE /api/follow/{userId}

Response 200 dengan bentuk data yang sama, `is_following` bernilai
false.

Kemungkinan gagal: 401, 404.

#### GET /api/followers

Daftar user yang mengikuti user yang sedang login.

Parameter query: `page`.

Response 200:

```json
{
  "success": true,
  "data": [
    {
      "id": 2,
      "name": "Sari",
      "is_following": true,
      "followed_at": "2026-10-14T08:00:00Z"
    }
  ]
}
```

Kemungkinan gagal: 401.

#### GET /api/following

Daftar user yang diikuti user yang sedang login. Bentuk respons sama
seperti `GET /api/followers`.

Kemungkinan gagal: 401.

### 3.13 Activity Feed

#### GET /api/feed

Butuh autentikasi. Berisi aktivitas user sendiri dan user yang diikuti.

Parameter query:

| Nama | Tipe | Keterangan |
|---|---|---|
| page | integer | Opsional |
| type | string | Opsional, filter satu nilai type |

Nilai `type`: `watched`, `rated`, `reviewed`, `liked`, `list_created`,
`followed`.

Response 200:

```json
{
  "success": true,
  "data": [
    {
      "id": 88,
      "type": "watched",
      "actor": {
        "id": 2,
        "name": "Sari"
      },
      "reference_id": 31,
      "metadata": {
        "movie_id": 123,
        "watched_at": "2026-10-14"
      },
      "created_at": "2026-10-14T08:00:00Z"
    }
  ]
}
```

Kemungkinan gagal: 401, 422.

Catatan:

- Backend menggabungkan aktivitas user sendiri dan user yang diikuti,
  lalu mengurutkan satu kali dari yang terbaru.
- Aktivitas yang baris asalunya sudah terhapus tidak dikembalikan.
- Jumlah item per halaman tetap 20.

### 3.14 Profil Publik

Seluruh endpoint butuh autentikasi.

#### GET /api/users/{userId}

Response 200: profil user lain beserta status follow dari sudut pandang
user yang sedang login.

```json
{
  "success": true,
  "data": {
    "id": 2,
    "name": "Sari",
    "created_at": "2026-08-02T10:00:00Z",
    "is_following": true,
    "is_self": false,
    "follower_count": 40,
    "following_count": 12,
    "stats": {
      "total_watched": 210,
      "total_watchlist": 30,
      "total_reviews": 45,
      "average_rating": 3.9
    },
    "favorites": [
      {
        "position": 1,
        "movie_id": 123,
        "title": "Judul Film",
        "poster_path": "/abc.jpg"
      }
    ]
  }
}
```

Kemungkinan gagal: 401, 404.

Catatan:

- Email user lain tidak pernah dikembalikan.
- Endpoint ini dipakai oleh halaman profil user lain, halaman followers,
  dan halaman following.
- Daftar list dan watched user lain diambil dari `GET /api/lists` dan
  `GET /api/users/{userId}/watched`.

#### GET /api/users/{userId}/watched

Watched milik user lain yang publik. Bentuk respons sama seperti
`GET /api/watched`.

Parameter query: `page`, `from`, `to`.

Kemungkinan gagal: 401, 404.

### 3.15 Incoming Activity

#### GET /api/activity/incoming

Butuh autentikasi. Menampilkan aktivitas yang masuk ke user yang sedang
login.

Isi endpoint:

- Pengikut baru, dari aktivitas dengan type `followed` yang menunjuk
  user tersebut.
- Like dari user lain pada list publik user tersebut.

Parameter query:

| Nama | Tipe | Keterangan |
|---|---|---|
| page | integer | Opsional |
| type | string | Opsional, `followed` atau `liked` |

Response 200:

```json
{
  "success": true,
  "data": [
    {
      "id": null,
      "type": "liked",
      "actor": {
        "id": 3,
        "name": "Budi"
      },
      "target": {
        "list_id": 5,
        "title": "Klasik 90an"
      },
      "created_at": "2026-10-14T08:00:00Z"
    }
  ]
}
```

Kemungkinan gagal: 401, 422.

Catatan:

- Tidak ada tabel baru. Endpoint ini query gabungan dan mengurutkan satu
  kali dari yang terbaru.
- Komentar tidak termasuk.
- Aktivitas lama yang menunjuk list yang sudah berubah menjadi privat
  tidak lagi muncul.

### 3.16 Members

#### GET /api/members

Butuh autentikasi. Mencari user lain untuk diikuti.

Parameter query:

| Nama | Tipe | Keterangan |
|---|---|---|
| q | string | Wajib, minimal 2 karakter |
| page | integer | Opsional |

Response 200:

```json
{
  "success": true,
  "data": [
    {
      "id": 3,
      "name": "Budi",
      "is_following": false,
      "follower_count": 12
    }
  ]
}
```

Kemungkinan gagal: 401, 422.

Catatan:

- User yang sedang login tidak pernah dikembalikan.
- User yang sudah diikuti tetap dikembalikan dengan `is_following`
  bernilai true.
- Avatar tidak dikirim. Inisial avatar dibentuk di presentation layer
  dari huruf pertama `name`.

### 3.17 Form Log

#### POST /api/log

Butuh autentikasi. Mencatat tontonan beserta rating, review, dan tag
dalam satu operasi.

Request:

```json
{
  "movie_id": 123,
  "watched_at": "2026-10-14",
  "note": "Nonton bareng teman",
  "rating": 4,
  "content": "Bagus.",
  "tags": ["rewatch", "nonton bareng"]
}
```

Validasi:

| Field | Aturan |
|---|---|
| movie_id | Wajib, integer |
| watched_at | Opsional, tanggal, default hari ini |
| note | Opsional, teks maksimal 1000 karakter |
| rating | Opsional, integer 1 sampai 5 |
| content | Opsional, teks maksimal 5000 karakter |
| tags | Opsional, array nama tag maksimal 10 |

Response 201:

```json
{
  "success": true,
  "data": {
    "watched": {
      "id": 31,
      "movie_id": 123,
      "watched_at": "2026-10-14",
      "note": "Nonton bareng teman"
    },
    "review": {
      "id": 7,
      "rating": 4,
      "content": "Bagus."
    },
    "tags": [
      {
        "id": 3,
        "name": "rewatch"
      }
    ]
  }
}
```

Kemungkinan gagal: 401, 409, 422.

Catatan:

- Seluruh operasi berjalan dalam satu transaksi database. Bila satu
  bagian gagal, tidak ada bagian yang tersimpan.
- `tags` berisi nama tag, bukan id. Tag yang belum ada dibuat otomatis.
  Tag dengan nama yang sudah ada dipakai kembali.
- Film yang sudah tercatat sebagai watched menghasilkan 409. Edit
  entri yang sudah ada memakai `PATCH /api/watched/{movieId}`,
  `PUT /api/reviews/{id}`, dan endpoint tag.
- Endpoint ini menulis aktivitas `watched`, `rated`, dan `reviewed`
  sekaligus.

### 3.18 Admin

Seluruh endpoint pada bagian ini memakai dua middleware, yaitu
`auth:sanctum` lalu `EnsureUserIsAdmin`. Request tanpa token menjawab
401. Token valid dengan role `user` menjawab 403.

Bentuk respons identik dengan endpoint user. Tindakan yang mengubah data
selalu menulis satu baris ke `admin_audit_logs`.

Batas umum:

| Aturan | Nilai |
|---|---|
| Rate limit | 60 request per menit per admin |
| Batas featured | 5 film |
| Batas upload poster | 2 MB |
| Batas upload backdrop | 4 MB |
| Format gambar | jpg, jpeg, png, webp |

#### GET /api/admin/dashboard

Response 200:

```json
{
  "success": true,
  "data": {
    "stats": {
      "active_movies": 10,
      "deleted_movies": 1,
      "total_genres": 5,
      "total_users": 2,
      "total_admins": 1,
      "total_reviews": 8,
      "total_lists": 3,
      "total_tags": 4
    },
    "latest_movies": [
      {
        "id": 12,
        "title": "Judul Film",
        "is_featured": true,
        "created_at": "2026-10-14T08:00:00Z"
      }
    ],
    "recent_admin_activity": [
      {
        "id": 5,
        "admin_name": "Admin",
        "action": "create",
        "entity": "movie",
        "entity_id": 12,
        "detail": "{\"title\":\"Judul Film\"}",
        "created_at": "2026-10-14T08:00:00Z"
      }
    ],
    "top_watched": [
      { "id": 12, "title": "Judul Film", "watched_count": 48 }
    ]
  }
}
```

Kemungkinan gagal: 401, 403.

#### GET /api/admin/movies

Daftar film termasuk yang sudah dinonaktifkan.

Parameter query:

| Nama | Tipe | Keterangan |
|---|---|---|
| q | string | Pencarian judul, opsional |
| status | string | `active` atau `deleted`, opsional |
| page | integer | Opsional |

Response 200 memakai `MovieResource` dengan tambahan `is_featured` dan
`deleted_at`.

#### POST /api/admin/movies

Content type `multipart/form-data`.

Request:

| Field | Tipe | Aturan |
|---|---|---|
| title | string | Wajib, maksimal 255 |
| original_title | string | Opsional, maksimal 255 |
| overview | text | Opsional |
| release_date | date | Opsional |
| poster | file | Opsional, image, mimes jpg jpeg png webp, maksimal 2048 KB |
| backdrop | file | Opsional, image, mimes jpg jpeg png webp, maksimal 4096 KB |
| runtime | integer | Opsional, minimal 1 |
| language | string | Opsional, maksimal 10 |
| country | string | Opsional, maksimal 100 |
| cast | string | Opsional, nama dipisah koma |
| crew | string | Opsional, nama dipisah koma |
| is_featured | boolean | Opsional, default false |
| genres | array | Opsional, id genre yang sudah ada |
| genres.* | integer | Harus exists di tabel genres |

Contoh payload curl:

```
curl -X POST http://127.0.0.1:8000/api/admin/movies \
  -H "Authorization: Bearer TOKEN" \
  -F "title=Judul Film" \
  -F "release_date=1994-01-01" \
  -F "runtime=120" \
  -F "cast=Nama Satu, Nama Dua" \
  -F "genres[]=1" \
  -F "genres[]=2" \
  -F "poster=@poster.jpg"
```

Response 201 dengan film yang tersimpan. `poster_url` dan
`backdrop_url` sudah berupa URL penuh.

Kemungkinan gagal: 401, 403, 422, 429.

Catatan:

- Field gambar yang tidak dikirim tidak mengubah gambar yang sudah ada.
- Untuk menghapus gambar, kirim `poster_clear` atau `backdrop_clear`
  bernilai boolean `true`.
- Berkas gambar disimpan di `storage/app/public/posters/` dan
  `storage/app/public/backdrops/`. `php artisan storage:link` wajib
  dijalankan lebih dulu.

#### PUT /api/admin/movies/{id}

Sama seperti `POST /api/admin/movies`, dengan Content type
`multipart/form-data`. Field yang tidak dikirim tidak berubah.

Response 200.

Kemungkinan gagal: 401, 403, 404, 422.

#### DELETE /api/admin/movies/{id}

Menonaktifkan film dengan mengisi kolom `deleted_at`. Baris tidak
dihapus dan data user tetap utuh.

Response 200:

```json
{
  "success": true,
  "data": {
    "id": 12,
    "deleted_at": "2026-10-14T09:00:00Z"
  }
}
```

Kemungkinan gagal: 401, 403, 404.

Catatan:

- Film yang sudah dinonaktifkan bisa dipulihkan dengan
  `POST /api/admin/movies/{id}/restore`.
- Endpoint ini tidak menghapus file gambar.

#### POST /api/admin/movies/{id}/feature

Menyalakan atau mematikan penanda featured.

Request:

```json
{
  "is_featured": true
}
```

Response 200 dengan film terbaru.

Kemungkinan gagal: 401, 403, 404, 409.

Catatan:

- Menyalakan featured ketika sudah ada lima film featured menghasilkan
  409. Admin harus mematikan salah satu lebih dulu.
- Film yang dinonaktifkan tidak bisa ditandai featured.

#### POST /api/admin/movies/{id}/restore

Mengembalikan film yang dinonaktifkan ke katalog.

Response 200.

Kemungkinan gagal: 401, 403, 404.

#### GET /api/admin/genres

Response 200 memakai `GenreResource` dengan tambahan `movie_count`.

#### POST /api/admin/genres

Request:

```json
{
  "name": "Action",
  "slug": "action"
}
```

Response 201.

Kemungkinan gagal: 401, 403, 409, 422.

Catatan:

- `slug` boleh dikosongkan. Backend membutakannya dari `name` bila
  tidak dikirim.
- `name` dibandingkan case-insensitive. `action` dan `Action`
  menghasilkan 409.

#### PUT /api/admin/genres/{id}

Sama seperti `POST /api/admin/genres`. Response 200.

Kemungkinan gagal: 401, 403, 404, 409, 422.

#### DELETE /api/admin/genres/{id}

Melepas genre dari seluruh film tanpa menghapus filmnya.

Response 200.

Kemungkinan gagal: 401, 403, 404.

Catatan:

- Genre yang masih dipakai film tidak dihapus dari tabel `genres`.
  Endpoint ini hanya menghapus baris `movie_genres`.
- Untuk benar-benar menghapus genre, hapus film-filmnya lebih dulu.
  Endpoint ini sengaja tidak menyediakan penghapusan keras.

#### GET /api/admin/users

Daftar seluruh user.

Parameter query: `q`, `role`, `page`.

Response 200:

```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "Admin",
      "email": "admin@mailboxh.test",
      "role": "admin",
      "movie_count": 10,
      "joined_at": "2026-10-01T08:00:00Z"
    }
  ]
}
```

Kemungkinan gagal: 401, 403.

#### GET /api/admin/users/{id}

Response 200 memakai `UserResource` dengan tambahan `stats`, `recent_activity`,
dan `is_self`.

Kemungkinan gagal: 401, 403, 404.

#### PUT /api/admin/users/{id}/role

Request:

```json
{
  "role": "admin"
}
```

Validasi: `role` wajib, harus bernilai `user` atau `admin`.

Response 200.

Kemungkinan gagal: 401, 403, 404, 422.

Catatan:

- Admin tidak dapat menurunkan role dirinya sendiri dari `admin`.
  Percobaan itu menghasilkan 422 supaya tidak ada admin tersisa tanpa
  sengaja.
- Endpoint ini satu-satunya yang boleh mengubah `users.role`.
- Password user tidak dapat diubah lewat endpoint ini.

#### GET /api/admin/reviews

Daftar seluruh review.

Parameter query: `q`, `movie_id`, `rating`, `page`.

Response 200 memakai `ReviewResource` dengan tambahan `movie` dan
`user_name`.

Kemungkinan gagal: 401, 403.

#### DELETE /api/admin/reviews/{id}

Menghapus review. Baris `reviews` terhapus dan aktivitas `rated` atau
`reviewed` yang menunjuknya disembunyikan dari feed.

Response 200.

Kemungkinan gagal: 401, 403, 404.

#### GET /api/admin/lists

Daftar seluruh list.

Parameter query: `q`, `scope` dengan nilai `public` atau `private`, `page`.

Response 200 memakai `ListResource` dengan tambahan `owner_name`.

#### DELETE /api/admin/lists/{id}

Menghapus list milik user beserta seluruh `list_items`. Film di
dalamnya, review, dan like tidak tersentuh.

Response 200.

Kemungkinan gagal: 401, 403, 404.

#### GET /api/admin/tags

Daftar seluruh tag milik seluruh user.

Parameter query: `q`, `user_id`, `page`.

Response 200 memakai `TagResource` dengan tambahan `user_name` dan
`usage_count`.

#### DELETE /api/admin/tags/{id}

Menghapus tag. Tag dilepas dari seluruh entri diary secara otomatis
lewat cascade.

Response 200.

Kemungkinan gagal: 401, 403, 404.

#### GET /api/admin/audit-logs

Parameter query:

| Nama | Tipe | Keterangan |
|---|---|---|
| admin_id | integer | Filter admin, opsional |
| entity | string | Filter jenis entitas, opsional |
| page | integer | Opsional |

Response 200 memakai `AdminAuditLogResource`.

```json
{
  "success": true,
  "data": [
    {
      "id": 5,
      "admin": { "id": 1, "name": "Admin" },
      "action": "update",
      "entity": "movie",
      "entity_id": 12,
      "detail": "{\"title\":\"Judul Lama\"}",
      "created_at": "2026-10-14T09:00:00Z"
    }
  ]
}
```

Kemungkinan gagal: 401, 403.

Catatan:

- Log tidak punya endpoint hapus. Riwayat audit tidak boleh dihapus dari
  aplikasi.
- `detail` berisi JSON ringkasan perubahan, bukan dump baris utuh.
  Password dan token tidak pernah masuk ke sini.

### 3.19 Komentar

Seluruh endpoint butuh autentikasi.

#### GET /api/reviews/{id}/comments

Response 200: daftar komentar pada review.

```json
{
  "success": true,
  "data": [
    {
      "id": 4,
      "review_id": 7,
      "user_id": 2,
      "user_name": "Sari",
      "content": "Setuju.",
      "created_at": "2026-10-14T08:00:00Z"
    }
  ]
}
```

Kemungkinan gagal: 401, 404.

#### POST /api/reviews/{id}/comments

Request:

```json
{
  "content": "Setuju."
}
```

Validasi:

| Field | Aturan |
|---|---|
| content | Wajib, string maksimal 1000 karakter |

Response 201 dengan komentar yang tersimpan. Komentar membuat notifikasi
`comment_review` untuk pemilik review.

Kemungkinan gagal: 401, 404, 422.

#### DELETE /api/comments/{id}

Response 200. Hanya pemilik komentar atau admin yang boleh menghapus.

Kemungkinan gagal: 401, 403, 404.

### 3.20 Notifikasi

Seluruh endpoint butuh autentikasi dan hanya melihat notifikasi milik
user yang sedang login.

#### GET /api/notifications

Response 200:

```json
{
  "success": true,
  "data": [
    {
      "id": 12,
      "type": "like_review",
      "reference_id": 9,
      "is_read": false,
      "actor": {
        "id": 3,
        "name": "Budi"
      },
      "created_at": "2026-10-14T08:00:00Z"
    }
  ]
}
```

`type` berisi `like_review`, `comment_review`, `follow`, atau `like_list`.

Kemungkinan gagal: 401.

#### PUT /api/notifications/{id}/read

Menandai satu notifikasi sebagai sudah dibaca.

Response 200:

```json
{
  "success": true,
  "data": {
    "id": 12,
    "is_read": true
  }
}
```

Kemungkinan gagal: 401, 404.

#### PUT /api/notifications/read-all

Menandai seluruh notifikasi user sebagai sudah dibaca.

Response 200:

```json
{
  "success": true,
  "data": {
    "updated": 3
  }
}
```

Kemungkinan gagal: 401.

## 4. Kode Error

| Kode | Arti |
|---|---|
| 200 | Sukses |
| 201 | Dibuat |
| 400 | Request tidak valid |
| 401 | Belum login atau token salah |
| 403 | Tidak punya akses |
| 404 | Data tidak ditemukan |
| 409 | Data bentrok |
| 422 | Validasi gagal |
| 429 | Terlalu banyak request |
| 500 | Error server |

Aturan:

- `message` ditulis dalam Bahasa Indonesia dan aman ditampilkan.
- Detail teknis tidak pernah masuk ke `message`.
- Kunci `errors` memakai nama field yang sama dengan payload request.

## 5. Rate Limit

| Kelompok Endpoint | Batas |
|---|---|
| Endpoint auth | 5 request per menit per IP |
| Endpoint tulis | 60 request per menit per user |
| Endpoint baca | 120 request per menit per user |
| Endpoint movies tanpa login | 60 request per menit per IP |
| Endpoint admin | 60 request per menit per admin |
| `GET /api/feed` | 30 request per menit per user |
| `GET /api/activity/incoming` | 30 request per menit per user |
| `GET /api/members` | 30 request per menit per user |
| `GET /api/notifications` | 30 request per menit per user |

Endpoint movies memakai batas per IP bila request tidak membawa token,
dan batas per user bila token valid. Guest tidak boleh menghabiskan kuota
pengguna lain.

Saat terlampaui, backend menjawab 429 dengan header `Retry-After`.

## 6. Aturan Implementasi

- Semua endpoint ditulis di `backend/routes/api.php`.
- Route publik memakai middleware `guest` untuk yang berbasis IP, dan
  `throttle:movies` untuk endpoint movies tanpa login.
- Validasi input memakai FormRequest, bukan pengecekan manual di
  controller.
- Output memakai Resource agar bentuk JSON konsisten.
- Controller tidak memanggil layanan film eksternal. Semua lewat
  repository dan service di dalam aplikasi.
- Controller tidak memuat queryfilm milik user secara langsung. Semua
  lewat repository.
- Pesan error dalam Bahasa Indonesia dan tidak mengandung stack trace.
- Penulisan ke tabel `activities` dilakukan lewat satu service, bukan
  langsung di controller. Endpoint yang memicu aktivitas: watched,
  reviews, likes, lists, follow.
- Penulisan ke tabel `notifications` dilakukan lewat `NotificationService`,
  bukan langsung di controller. Endpoint yang memicu notifikasi: like
  review, like list, komentar, dan follow. Notifikasi tidak dibuat bila
  pelaku dan penerima adalah user yang sama.
- Penulisan ke tabel `admin_audit_logs` dilakukan lewat
  `AdminAuditService`. Setiap controller admin yang mengubah data wajib
  memanggilnya.
- Penulisan yang harus atomik memakai satu database transaction.
  `POST /api/log`, `PUT /api/favorites`, dan `PUT /api/admin/movies/{id}`
  termasuk yang wajib.
