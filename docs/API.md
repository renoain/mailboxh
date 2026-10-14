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

#### GET /api/movies/trending

Butuh autentikasi.

Parameter query: `page`, `language`.

Response 200:

```json
{
  "success": true,
  "data": [
    {
      "tmdb_id": 123,
      "title": "Judul Film",
      "poster_path": "/abc.jpg",
      "release_date": "2024-01-01",
      "vote_average": 7.5
    }
  ]
}
```

#### GET /api/movies/popular

Butuh autentikasi. Bentuk respons sama seperti trending.

#### GET /api/movies/search

Butuh autentikasi.

Parameter query:

| Nama | Tipe | Keterangan |
|---|---|---|
| q | string | Wajib, minimal 2 karakter |
| page | integer | Opsional |

Response 200 sama seperti trending.

Kemungkinan gagal: 401, 422, 429.

#### GET /api/movies/{tmdbId}

Butuh autentikasi.

Response 200:

```json
{
  "success": true,
  "data": {
    "tmdb_id": 123,
    "title": "Judul Film",
    "original_title": "Original Title",
    "overview": "Sinopsis film.",
    "release_date": "2024-01-01",
    "poster_path": "/abc.jpg",
    "backdrop_path": "/def.jpg",
    "vote_average": 7.5,
    "genre_ids": [18, 28],
    "runtime": 120,
    "liked": true,
    "like_count": 42
  }
}
```

Kemungkinan gagal: 401, 404.

### 3.3 Watchlist

Seluruh endpoint butuh autentikasi.

#### GET /api/watchlist

Response 200: daftar film di watchlist user.

```json
{
  "success": true,
  "data": [
    {
      "tmdb_id": 123,
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
  "tmdb_id": 123
}
```

Response 201. Gagal dengan 409 bila film sudah ada di watchlist.

#### DELETE /api/watchlist/{tmdbId}

Response 200. Path memakai `tmdb_id`, bukan id baris lokal.

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
      "tmdb_id": 123,
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
  "tmdb_id": 123,
  "watched_at": "2026-10-14",
  "note": "Nonton bareng teman"
}
```

`watched_at` opsional. Bila tidak dikirim, backend memakai tanggal hari
ini. `note` opsional.

Response 201. Gagal dengan 409 bila film sudah tercatat sebagai watched.
Lihat FR-WT-05.

#### PATCH /api/watched/{tmdbId}

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

#### DELETE /api/watched/{tmdbId}

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
      "tmdb_id": 123,
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
  "tmdb_id": 123,
  "rating": 4,
  "content": "Bagus"
}
```

Validasi:

| Field | Aturan |
|---|---|
| tmdb_id | Wajib, integer |
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

#### GET /api/diary

Butuh autentikasi. Endpoint baca saja. Isinya diturunkan dari tabel
`watched`.

Parameter query:

| Nama | Tipe | Keterangan |
|---|---|---|
| from | date | Awal rentang tanggal, opsional |
| to | date | Akhir rentang tanggal, opsional |
| tag_id | integer | Filter satu tag milik user, opsional |

Response 200:

```json
{
  "success": true,
  "data": [
    {
      "watched_at": "2026-10-14",
      "items": [
        {
          "tmdb_id": 123,
          "title": "Judul Film",
          "poster_path": "/abc.jpg",
          "note": "Nonton bareng teman",
          "rating": 4,
          "content": "Bagus."
        }
      ]
    }
  ]
}
```

Kemungkinan gagal: 401, 422.

Tidak ada endpoint tulis diary. Menambah, mengubah, dan menghapus
entri diary dilakukan lewat endpoint watched.

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
    "items": [
      {
        "id": 21,
        "tmdb_id": 123,
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
  "tmdb_id": 123,
  "note": "Nonton ulang tiap tahun."
}
```

Validasi:

| Field | Aturan |
|---|---|
| tmdb_id | Wajib, integer |
| note | Opsional, teks maksimal 500 karakter |

`order_index` diisi otomatis oleh backend dari nilai terbesar yang ada.

Response 201. Film yang sudah ada di list tersebut menghasilkan 409.

Kemungkinan gagal: 401, 403, 404, 409, 422.

#### DELETE /api/lists/{id}/items/{tmdbId}

Response 200. Path memakai `tmdb_id`, bukan id baris `list_items`.

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
| order | Wajib, array id film TMDB yang sudah ada di list |

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

Menempelkan tag ke satu entri diary. `id` adalah id baris `watched`,
bukan tanggal tonton.

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
      "tmdb_id": 123,
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
      "tmdb_id": 123
    },
    {
      "position": 2,
      "tmdb_id": 456
    }
  ]
}
```

Validasi:

| Field | Aturan |
|---|---|
| items | Wajib, array maksimal 4 |
| items.position | Wajib, integer 1 sampai 4, unik dalam satu request |
| items.tmdb_id | Wajib, integer, unik dalam satu request |

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

Seluruh endpoint butuh autentikasi.

#### POST /api/likes

Request:

```json
{
  "tmdb_id": 123
}
```

Response 201:

```json
{
  "success": true,
  "data": {
    "tmdb_id": 123,
    "liked": true,
    "like_count": 42
  }
}
```

Kemungkinan gagal: 401, 422.

Catatan:

- Film yang sudah di-like menghasilkan 409.
- Like tidak membuat rating, tidak membuat review, dan tidak mengubah
  status watched.

#### DELETE /api/likes/{tmdbId}

Response 200 dengan bentuk data yang sama seperti `POST /api/likes`,
dengan `liked` bernilai false dan `like_count` terbaru.

Kemungkinan gagal: 401, 404.

#### GET /api/likes/{tmdbId}

State tombol hati untuk satu film.

Response 200:

```json
{
  "success": true,
  "data": {
    "tmdb_id": 123,
    "liked": true,
    "like_count": 42
  }
}
```

Kemungkinan gagal: 401.

#### GET /api/likes

Response 200: film yang di-like user, untuk state tombol hati di katalog.

```json
{
  "success": true,
  "data": [
    {
      "tmdb_id": 123,
      "title": "Judul Film",
      "poster_path": "/abc.jpg",
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
        "tmdb_id": 123,
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
        "tmdb_id": 123,
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
- Like dari user lain pada film yang ada di list publik user tersebut.

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
      "id": 91,
      "type": "followed",
      "actor": {
        "id": 3,
        "name": "Budi"
      },
      "target": {
        "tmdb_id": null,
        "title": null,
        "poster_path": null
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
- Komentar tidak termasuk. Fitur komentar ditunda.
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
  "tmdb_id": 123,
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
| tmdb_id | Wajib, integer |
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
      "tmdb_id": 123,
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
  entri yang sudah ada memakai `PATCH /api/watched/{tmdbId}`,
  `PUT /api/reviews/{id}`, dan endpoint tag.
- Endpoint ini menulis aktivitas `watched`, `rated`, dan `reviewed`
  sekaligus.

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
| `GET /api/feed` | 30 request per menit per user |
| `GET /api/activity/incoming` | 30 request per menit per user |
| `GET /api/members` | 30 request per menit per user |

Saat terlampaui, backend menjawab 429 dengan header `Retry-After`.

## 6. Aturan Implementasi

- Semua endpoint ditulis di `backend/routes/api.php`.
- Validasi input memakai FormRequest, bukan pengecekan manual di
  controller.
- Output memakai Resource agar bentuk JSON konsisten.
- Controller tidak memanggil TMDB secara langsung. Semua lewat
  `TmdbService`.
- Controller tidak memuat queryfilm milik user secara langsung. Semua
  lewat repository.
- Pesan error dalam Bahasa Indonesia dan tidak mengandung stack trace.
- Penulisan ke tabel `activities` dilakukan lewat satu service, bukan
  langsung di controller. Endpoint yang memicu aktivitas: watched,
  reviews, likes, lists, follow.
- Endpoint `PUT /api/favorites` memvalidasi jumlah item maksimal 4 dan
  memprosesnya dalam satu transaksi database.