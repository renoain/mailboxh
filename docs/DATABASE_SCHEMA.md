# DATABASE SCHEMA - Mailboxh

Skema database MySQL untuk aplikasi Mailboxh.

## 1. Prinsip

- Semua tabel berada di database `mailboxh`.
- Primary key `bigint` auto increment untuk tabel lokal.
- Tabel `movies_cache` memakai `tmdb_id` integer sebagai primary key.
- Timestamp `created_at` dan `updated_at` mengikuti bawaan Laravel.
- Naming snake_case, tabel berbentuk plural.
- Foreign key ke `users` memakai on delete cascade.
- Tidak ada foreign key ke `movies_cache`. Film di TMDB bisa berubah,
  sehingga referensi hanya lewat nilai `tmdb_id`.
- Tidak ada tabel diary. Diary diturunkan dari tabel `watched`.
- Fitur lists, tags, favourites, likes, follow, dan feed memakai tabel
  baru. Tabel lama tidak diubah, hanya ditambah.

## 2. Entity Relationship

```
users
  |
  +--> watchlist
  +--> watched --> diary_tags <-- tags
  +--> reviews
  +--> lists --> list_items
  +--> favorites
  +--> likes
  +--> activities
  +--> follows (follower_id, following_id)

movies_cache (berdiri sendiri, direferensikan lewat tmdb_id)
```

Kolom `reference_id` pada tabel `activities` tidak memakai foreign key
karena nilainya bisa menunjuk ke beberapa tabel berbeda.

## 3. Tabel

### 3.1 users

Bawaan Laravel dengan kolom tambahan.

| Kolom | Tipe | Constraint | Keterangan |
|---|---|---|---|
| id | bigint | PK, auto increment | |
| name | varchar(255) | not null | Nama user |
| email | varchar(255) | unique, not null | Email |
| password | varchar(255) | not null | Hash bcrypt |
| remember_token | varchar(100) | nullable | Bawaan Laravel |
| created_at | timestamp | nullable | |
| updated_at | timestamp | nullable | |

### 3.2 movies_cache

Cache data film dari TMDB. Bukan input manual.

| Kolom | Tipe | Constraint | Keterangan |
|---|---|---|---|
| tmdb_id | integer | PK | Id film di TMDB |
| title | varchar(255) | not null | Judul |
| original_title | varchar(255) | nullable | Judul asli |
| overview | text | nullable | Sinopsis |
| release_date | date | nullable | Tanggal rilis |
| poster_path | varchar(255) | nullable | Path poster TMDB |
| backdrop_path | varchar(255) | nullable | Path backdrop TMDB |
| vote_average | decimal(3,1) | nullable | Rating TMDB |
| genre_ids | json | nullable | Daftar id genre |
| runtime | integer | nullable | Durasi menit |
| cached_at | timestamp | not null | Waktu cache |

Index:

- `title` untuk pencarian judul.
- `release_date` untuk pengurutan.

Catatan:

- Batas umur cache ditentukan di `TmdbService`, bukan di migration.
- `poster_path` dan `backdrop_path` disimpan relatif. URL penuh dibentuk
  dari `TMDB_IMAGE_BASE_URL`.

### 3.3 watchlist

Film yang ingin ditonton user.

| Kolom | Tipe | Constraint | Keterangan |
|---|---|---|---|
| id | bigint | PK, auto increment | |
| user_id | bigint | FK users, cascade, not null | |
| tmdb_id | integer | not null | Id film TMDB |
| created_at | timestamp | nullable | |
| updated_at | timestamp | nullable | |

Unique: `(user_id, tmdb_id)`.

### 3.4 watched

Film yang sudah ditonton user. Tabel ini juga menjadi sumber data diary.

| Kolom | Tipe | Constraint | Keterangan |
|---|---|---|---|
| id | bigint | PK, auto increment | |
| user_id | bigint | FK users, cascade, not null | |
| tmdb_id | integer | not null | Id film TMDB |
| watched_at | date | not null | Tanggal tonton |
| note | text | nullable | Catatan opsional untuk diary |
| created_at | timestamp | nullable | |
| updated_at | timestamp | nullable | |

Unique: `(user_id, tmdb_id)`.

Index: `(user_id, watched_at)` untuk urutan diary.

Catatan:

- Tidak ada tabel `diary_entries`. Kolom `note` di tabel ini berfungsi
  sebagai catatan diary per entri tontonan.
- Mengubah atau menghapus baris di tabel ini langsung mengubah isi diary.

### 3.5 reviews

Rating dan review user untuk film.

| Kolom | Tipe | Constraint | Keterangan |
|---|---|---|---|
| id | bigint | PK, auto increment | |
| user_id | bigint | FK users, cascade, not null | |
| tmdb_id | integer | not null | Id film TMDB |
| rating | tinyint | not null | Nilai 1 sampai 5 |
| content | text | nullable | Isi review teks |
| created_at | timestamp | nullable | |
| updated_at | timestamp | nullable | |

Unique: `(user_id, tmdb_id)`.

Catatan:

- Rating wajib diisi karena review tanpa rating tidak disimpan pada MVP.
- Gunakan CHECK constraint agar rating selalu di rentang 1 sampai 5.

### 3.6 lists

Daftar film kurasi milik user.

| Kolom | Tipe | Constraint | Keterangan |
|---|---|---|---|
| id | bigint | PK, auto increment | |
| user_id | bigint | FK users, cascade, not null | Pemilik list |
| title | varchar(120) | not null | Judul list |
| description | text | nullable | Deskripsi list |
| is_public | boolean | not null, default false | true bila dapat dilihat user lain |
| created_at | timestamp | nullable | |
| updated_at | timestamp | nullable | |

Index: `(user_id, is_public)` untuk daftar list publik dan list pribadi.

Catatan:

- `title` dibatasi 120 karakter agar konsisten di tampilan.
- List kurasi sistem tidak disimpan di tabel ini. Daftar filmnya
  hardcode di `lib/core/constants/`.
- Hapus list berarti semua `list_items` ikut terhapus lewat cascade.

### 3.7 list_items

Film yang menjadi anggota sebuah list.

| Kolom | Tipe | Constraint | Keterangan |
|---|---|---|---|
| id | bigint | PK, auto increment | |
| list_id | bigint | FK lists, cascade, not null | List induk |
| tmdb_id | integer | not null | Id film TMDB |
| note | text | nullable | Catatan singkat di dalam list |
| order_index | integer | not null, default 0 | Urutan manual |
| created_at | timestamp | nullable | |
| updated_at | timestamp | nullable | |

Unique: `(list_id, tmdb_id)`.

Index: `(list_id, order_index)` untuk urutan isi list.

Catatan:

- `order_index` diisi otomatis dari nilai terbesar saat film ditambahkan,
  lalu dapat diubah lewat halaman detail list.
- Tabel ini tidak memakai `updated_at` pada MVP karena isi list tidak
  pernah diedit. Kolom tetap disediakan oleh migration Laravel.

### 3.8 tags

Label pribadi milik user untuk entri watched pada diary.

| Kolom | Tipe | Constraint | Keterangan |
|---|---|---|---|
| id | bigint | PK, auto increment | |
| user_id | bigint | FK users, cascade, not null | Pemilik tag |
| name | varchar(40) | not null | Nama tag |
| created_at | timestamp | nullable | |
| updated_at | timestamp | nullable | |

Unique: `(user_id, name)`.

Catatan:

- Bandingkan nama tag secara case-insensitive dengan collation
  `utf8mb4_unicode_ci`, sehingga `Sci-Fi` dan `sci-fi` dianggap sama.
- Tag tidak dipakai ulang antar user. Tiap user punya tag sendiri.

### 3.9 diary_tags

Penghubung tag ke entri watched. Diary diturunkan dari `watched`, jadi
kolom ini menunjuk ke `watched.id`.

| Kolom | Tipe | Constraint | Keterangan |
|---|---|---|---|
| id | bigint | PK, auto increment | |
| watched_id | bigint | FK watched, cascade, not null | Entri tontonan |
| tag_id | bigint | FK tags, cascade, not null | Tag yang ditempel |
| created_at | timestamp | nullable | |

Unique: `(watched_id, tag_id)`.

Index: `(tag_id)` untuk filter diary berdasarkan tag.

Catatan:

- Nama kolom `watched_id`, bukan `diary_entry_id`, karena tidak ada
  tabel `diary_entries`.
- Menghapus entri watched otomatis melepas tag pada entri itu.

### 3.10 favorites

Empat film favorit yang dipajang di profil user.

| Kolom | Tipe | Constraint | Keterangan |
|---|---|---|---|
| id | bigint | PK, auto increment | |
| user_id | bigint | FK users, cascade, not null | Pemilik |
| tmdb_id | integer | not null | Id film TMDB |
| position | tinyint | not null | Posisi 1 sampai 4 |
| created_at | timestamp | nullable | |
| updated_at | timestamp | nullable | |

Unique: `(user_id, position)` dan `(user_id, tmdb_id)`.

Catatan:

- CHECK constraint pada `position` membatasi nilai 1 sampai 4.
- Menyimpan film di posisi yang sudah terpakai memindahkan film lama di
  posisi tersebut ke posisi paling akhir yang kosong.
- Film boleh berada di watchlist, watched, like, dan favourites
  sekaligus. Tabel-tabel ini berdiri sendiri.

### 3.11 likes

Tanda suka pada film, terpisah dari rating bintang.

| Kolom | Tipe | Constraint | Keterangan |
|---|---|---|---|
| id | bigint | PK, auto increment | |
| user_id | bigint | FK users, cascade, not null | Pemberi like |
| tmdb_id | integer | not null | Id film TMDB |
| created_at | timestamp | nullable | |
| updated_at | timestamp | nullable | |

Unique: `(user_id, tmdb_id)`.

Index: `(tmdb_id)` untuk menghitung jumlah like per film.

Catatan:

- Like tidak memengaruhi rating dan tidak membuat review.
- User dapat like film yang belum pernah ia tonton atau beri rating.

### 3.12 follows

Relasi mengikuti antar user.

| Kolom | Tipe | Constraint | Keterangan |
|---|---|---|---|
| id | bigint | PK, auto increment | |
| follower_id | bigint | FK users, cascade, not null | User yang mengikuti |
| following_id | bigint | FK users, cascade, not null | User yang diikuti |
| created_at | timestamp | nullable | |
| updated_at | timestamp | nullable | |

Unique: `(follower_id, following_id)`.

Index: `(following_id)` untuk daftar follower.

Catatan:

- CHECK constraint melarang `follower_id` sama dengan `following_id`.
- User tidak dapat mengikuti dirinya sendiri.
- Dua user dapat saling mengikuti.

### 3.13 activities

Catatan aktivitas user untuk activity feed.

| Kolom | Tipe | Constraint | Keterangan |
|---|---|---|---|
| id | bigint | PK, auto increment | |
| user_id | bigint | FK users, cascade, not null | Pemilik aktivitas |
| type | varchar(20) | not null | watched, rated, reviewed, liked, list_created, followed |
| reference_id | bigint | nullable | Id baris pada tabel asal |
| metadata | json | nullable | Konteks tambahan, lihat tabel di bawah |
| created_at | timestamp | nullable | |
| updated_at | timestamp | nullable | |

Index: `(user_id, created_at)` untuk feed satu user dan untuk purge.

Nilai kolom `type`:

| Type | Kapan ditulis | reference_id | metadata |
|---|---|---|---|
| watched | User menandai film ditonton | `watched.id` | tmdb_id, watched_at |
| rated | User menyimpan rating | `reviews.id` | tmdb_id, rating |
| reviewed | User menulis review | `reviews.id` | tmdb_id, excerpt |
| liked | User like film | `likes.id` | tmdb_id |
| list_created | User membuat list | `lists.id` | title, is_public |
| followed | User mengikuti user lain | `follows.id` | following_name |

Catatan:

- Tabel ini hanya ditulis oleh backend. Aplikasi tidak pernah insert
  langsung ke tabel ini.
- Tidak ada foreign key pada `reference_id` karena nilainya polymorphic
  dan baris asal boleh terhapus. Aktivitas yang menunjuk baris terhapus
  disembunyikan saat feed dibangun.
- `metadata` tidak pernah berisi data sensitif.

## 4. Relasi

- users satu ke banyak watchlist.
- users satu ke banyak watched.
- users satu ke banyak reviews.
- users satu ke banyak lists.
- users satu ke banyak tags.
- users satu ke banyak favorites.
- users satu ke banyak likes.
- users satu ke banyak activities.
- users banyak ke banyak users lewat follows.
- lists satu ke banyak list_items.
- watched banyak ke banyak tags lewat diary_tags.
- movies_cache direferensikan oleh nilai `tmdb_id` pada watchlist,
  watched, reviews, list_items, favorites, dan likes, tanpa foreign key
  constraint.

Perubahan tabel lama:

- `users` tidak berubah.
- `watchlist` tidak berubah.
- `watched` tidak berubah. Kolom `note` tetap dipakai sebagai catatan
  diary.
- `reviews` tidak berubah. Rating dan review tetap terpisah dari like.
- `movies_cache` tidak berubah.

## 5. Query Umum

Total watched user:

```sql
select count(*) from watched where user_id = ?;
```

Rata-rata rating user:

```sql
select avg(rating) from reviews where user_id = ?;
```

Watched urut tanggal terbaru:

```sql
select * from watched where user_id = ?
order by watched_at desc;
```

Watched dalam rentang tanggal, untuk diary:

```sql
select * from watched
where user_id = ? and watched_at between ? and ?
order by watched_at desc;
```

Gabungan watched dengan judul film dan review milik user yang sama:

```sql
select w.watched_at, w.note, m.tmdb_id, m.title, m.poster_path, r.rating, r.content
from watched w
left join movies_cache m on m.tmdb_id = w.tmdb_id
left join reviews r on r.user_id = w.user_id and r.tmdb_id = w.tmdb_id
where w.user_id = ?
order by w.watched_at desc;
```

Catatan: rating dan review teks berasal dari tabel `reviews`, bukan dari
`watched`.

Diary dengan tag, untuk filter berdasarkan tag:

```sql
select w.watched_at, w.note, m.tmdb_id, m.title, m.poster_path,
       group_concat(t.name order by t.name) as tags
from watched w
join movies_cache m on m.tmdb_id = w.tmdb_id
left join diary_tags dt on dt.watched_id = w.id
left join tags t on t.id = dt.tag_id
where w.user_id = ?
  and (? is null or exists (
    select 1 from diary_tags dt2
    join tags t2 on t2.id = dt2.tag_id
    where dt2.watched_id = w.id and t2.id = ?
  ))
group by w.id, m.tmdb_id
order by w.watched_at desc;
```

Isi sebuah list dengan judul film:

```sql
select li.order_index, li.note, m.tmdb_id, m.title, m.poster_path
from list_items li
left join movies_cache m on m.tmdb_id = li.tmdb_id
where li.list_id = ?
order by li.order_index asc;
```

Favourites user, urut posisi:

```sql
select f.position, m.tmdb_id, m.title, m.poster_path
from favorites f
left join movies_cache m on m.tmdb_id = f.tmdb_id
where f.user_id = ?
order by f.position asc;
```

List publik milik user lain:

```sql
select l.id, l.title, l.description, count(li.id) as item_count
from lists l
left join list_items li on li.list_id = l.id
where l.user_id = ? and l.is_public = true
group by l.id
order by l.created_at desc;
```

Feed aktivitas user yang diikuti:

```sql
select a.type, a.reference_id, a.metadata, a.created_at
from activities a
join follows f on f.following_id = a.user_id
where f.follower_id = ?
  and a.created_at >= ?
order by a.created_at desc
limit 30;
```

Jumlah like per film:

```sql
select tmdb_id, count(*) as like_count
from likes
where tmdb_id = ?
group by tmdb_id;
```

Incoming activity bagian pengikut baru:

```sql
select u.id as actor_id, u.name as actor_name,
       a.created_at, a.metadata->>'following_name' as following_name
from activities a
join users u on u.id = a.user_id
where a.type = 'followed'
  and a.reference_id in (select id from follows where following_id = ?)
  and a.user_id <> ?
order by a.created_at desc
limit 30;
```

Incoming activity bagian like pada film di list publik user:

```sql
select u.id as actor_id, u.name as actor_name,
       a.created_at, a.metadata->>'tmdb_id' as tmdb_id,
       m.title, m.poster_path
from activities a
join users u on u.id = a.user_id
join likes l on l.user_id = a.user_id
join list_items li on li.tmdb_id = l.tmdb_id
join lists ls on ls.id = li.list_id and ls.is_public = true
left join movies_cache m on m.tmdb_id = l.tmdb_id
where a.type = 'liked'
  and ls.user_id = ?
  and a.user_id <> ?
group by u.id, u.name, a.created_at, a.metadata, m.title, m.poster_path
order by a.created_at desc
limit 30;
```

Pencarian member:

```sql
select u.id, u.name,
       exists (
         select 1 from follows f
         where f.follower_id = ? and f.following_id = u.id
       ) as is_following
from users u
where u.id <> ? and u.name like ?
order by u.name asc
limit 20;
```

Feed hanya menampilkan aktivitas user sendiri dan user yang diikuti.
Backend menggabungkan kedua sumber lalu mengurutkan satu kali.

Catatan:

- Tidak ada tabel untuk incoming activity maupun untuk member. Keduanya
  diturunkan dari `activities`, `follows`, `likes`, `lists`, dan
  `list_items`.
- Pencarian member memakai `like` pada kolom `users.name`. Bookmark
  `%` ditambahkan pada application layer, bukan di migration.
- Avatar tidak disimpan. Inisial untuk avatar diambil dari huruf pertama
  `users.name` di presentation layer.

## 6. Seed Data

Seeder membuat:

- Satu user demo untuk keperluan demo UTS.
- Entri `movies_cache` tidak di-seed. Data terisi otomatis saat film
  pertama kali diakses.
- Tag demo, favourites, dan satu list publik untuk mengisi tampilan awal
  halaman profil.

## 7. Catatan

- Data film dari TMDB disimpan di `movies_cache` dengan batas umur yang
  ditentukan di service.
- Poster tidak disimpan sebagai file lokal, hanya `poster_path`.
- URL poster dibentuk dari `TMDB_IMAGE_BASE_URL` ditambah `poster_path`.
- Migration yang sudah dijalankan tidak boleh diedit. Perubahan struktur
  selalu lewat migration baru.
- Tabel `lists`, `list_items`, `tags`, `diary_tags`, `favorites`,
  `likes`, `follows`, dan `activities` dibuat lewat migration baru.
  Tabel lama tidak diubah.
- Aktivitas lama di tabel `activities` dapat dipangkas lewat artisan
  command terjadwal. Tidak ada soft delete pada tabel baru.
- Tabel `users` tidak ditambah kolom bio, avatar, atau username pada
  MVP. Ketiganya diturunkan dari `name`.
