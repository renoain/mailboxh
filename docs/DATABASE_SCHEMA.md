# DATABASE SCHEMA - Mailboxh

Skema database MySQL untuk aplikasi Mailboxh.

## 1. Prinsip

- Semua tabel berada di database `mailboxh`.
- Primary key `bigint` auto increment untuk seluruh tabel. Tidak ada lagi
  primary key dari sumber luar.
- Timestamp `created_at` dan `updated_at` mengikuti bawaan Laravel.
- Naming snake_case, tabel berbentuk plural.
- Foreign key ke `users` memakai on delete cascade.
- Film berada di tabel `movies` dan dimiliki aplikasi sendiri. Semua
  tabel yang menunjuk film memakai `movie_id` foreign key ke
  `movies.id`.
- Film memakai soft delete lewat kolom `deleted_at`. Film yang dinonaktifkan
  hilang dari katalog tanpa menghapus baris dan tanpa merusak data user.
- `diary_entries` adalah tabel tersendiri. Entri diary bukan baris
  `watched`, melainkan catatan tontonan milik user.
- Cast dan crew disimpan sebagai teks dipisah koma pada kolom `movies.cast`
  dan `movies.crew`. Tidak ada tabel cast atau crew.
- Admin adalah user dengan nilai `role` bernilai `admin` pada tabel
  `users`. Tidak ada tabel admin terpisah.

## 2. Entity Relationship

```
users
  |
  +--> watchlist --------+
  +--> watched ----------+--> movies (soft delete)
  +--> diary_entries ----+      |
  +--> reviews ----------+      +--> movie_genres <-- genres
  +--> lists --> list_items -----+
  +--> favorites --------+
  +--> likes ------------+
  +--> activities
  +--> follows (follower_id, following_id)
  +--> admin_audit_logs (admin_id)

diary_entries --> diary_tags <-- tags
```

Kolom `reference_id` pada tabel `activities` tidak memakai foreign key
karena nilainya bisa menunjuk ke beberapa tabel berbeda.

## 3. Tabel

### 3.1 users

Bawaan Laravel dengan kolom tambahan.

Migration: `0001_01_01_000000_create_users_table.php`, sudah ada dari
`composer create-project`.

| Kolom | Tipe | Constraint | Keterangan |
|---|---|---|---|
| id | bigint | PK, auto increment | |
| name | varchar(255) | not null | Nama user |
| email | varchar(255) | unique, not null | Email |
| password | varchar(255) | not null | Hash bcrypt |
| role | enum('user', 'admin') | not null, default 'user' | Role user |
| remember_token | varchar(100) | nullable | Bawaan Laravel |
| created_at | timestamp | nullable | |
| updated_at | timestamp | nullable | |

Kolom `role` ditambahkan lewat migration terpisah setelah tabel
pertama kali dibuat. Kolom ini tidak boleh diisi lewat form register.
Endpoint yang boleh mengubahnya hanya `PUT /api/admin/users/{id}/role`.

### 3.2 movies

Katalog film. Semua data diinput manual oleh admin.

Migration: `2026_10_14_000001_create_movies_table.php`.

| Kolom | Tipe | Constraint | Keterangan |
|---|---|---|---|
| id | bigint | PK, auto increment | |
| title | varchar(255) | not null | Judul |
| original_title | varchar(255) | nullable | Judul asli |
| overview | text | nullable | Sinopsis |
| release_date | date | nullable | Tanggal rilis |
| poster_path | varchar(255) | nullable | Path file poster relatif |
| backdrop_path | varchar(255) | nullable | Path file backdrop relatif |
| runtime | integer | nullable | Durasi menit |
| language | varchar(10) | nullable | Kode bahasa, contoh en |
| country | varchar(100) | nullable | Negara produksi |
| cast | text | nullable | Nama pemeran, dipisah koma |
| crew | text | nullable | Nama crew, dipisah koma |
| is_featured | boolean | not null, default false | Tampil di section Featured |
| deleted_at | timestamp | nullable | Soft delete |
| created_at | timestamp | nullable | |
| updated_at | timestamp | nullable | |

Index:

- `(is_featured, deleted_at)` untuk query Featured.
- `(deleted_at, created_at)` untuk Latest.
- `title` untuk pencarian judul.
- `release_date` untuk pengurutan.

Catatan:

- Soft delete memakai trait `SoftDeletes` di model `Movie`. Semua query
  katalog otomatis menambahkan `where deleted_at is null`.
- File poster disimpan di `storage/app/public/posters/` dan backdrop di
  `storage/app/public/backdrops/`. Kolom path menyimpan nilai relatif
  seperti `posters/abc.jpg`.
- URL penuh dibentuk di backend dari `APP_URL`, lalu dikirim ke klien.
  Backend mengembalikan `poster_url` dan `backdrop_url` yang sudah jadi.
- `vote_average` tidak ada di tabel ini. Rating rata-rata dihitung dari
  tabel `reviews` saat query, bukan disimpan.
- CHECK constraint pada `runtime` membatasi nilai minimal 1.
- Maksimal lima film featured. Aturan ini ditegakkan di service, bukan
  di database.

### 3.3 genres

Kategori film yang dikelola admin.

Migration: `2026_10_14_000002_create_genres_table.php`.

| Kolom | Tipe | Constraint | Keterangan |
|---|---|---|---|
| id | bigint | PK, auto increment | |
| name | varchar(50) | unique, not null | Nama genre |
| slug | varchar(50) | unique, not null | Slug untuk URL dan filter |
| created_at | timestamp | nullable | |
| updated_at | timestamp | nullable | |

Catatan:

- Nama dibandingkan case-insensitive lewat collation `utf8mb4_unicode_ci`,
  sehingga `Action` dan `action` dianggap sama.
- Slug wajib lowercase dan hanya berisi huruf, angka, dan tanda hubung.
- Genre awal dari seeder: Action, Drama, Comedy, Horror, Romance.

### 3.4 movie_genres

Pivot antara film dan genre.

Migration: `2026_10_14_000003_create_movie_genres_table.php`.

| Kolom | Tipe | Constraint | Keterangan |
|---|---|---|---|
| movie_id | bigint | FK movies, cascade, not null | |
| genre_id | bigint | FK genres, cascade, not null | |

Primary key: `(movie_id, genre_id)`.

Kolom `id` tidak ada. Tabel pivot memakai komposit primary key.

Catatan:

- Menghapus film atau genre melepas seluruh baris pivot secara otomatis.
- Satu film boleh punya beberapa genre. Satu genre boleh dipakai banyak
  film.

### 3.5 watchlist

Film yang ingin ditonton user.

Migration: `2026_10_14_000004_create_watchlist_table.php`.

| Kolom | Tipe | Constraint | Keterangan |
|---|---|---|---|
| id | bigint | PK, auto increment | |
| user_id | bigint | FK users, cascade, not null | |
| movie_id | bigint | FK movies, cascade, not null | |
| created_at | timestamp | nullable | |
| updated_at | timestamp | nullable | |

Unique: `(user_id, movie_id)`.

Index: `(movie_id)` untuk query Most Watchlisted.

### 3.6 watched

Film yang sudah ditonton user.

Migration: `2026_10_14_000005_create_watched_table.php`.

| Kolom | Tipe | Constraint | Keterangan |
|---|---|---|---|
| id | bigint | PK, auto increment | |
| user_id | bigint | FK users, cascade, not null | |
| movie_id | bigint | FK movies, cascade, not null | |
| watched_at | date | not null | Tanggal tonton |
| created_at | timestamp | nullable | |
| updated_at | timestamp | nullable | |

Unique: `(user_id, movie_id)`.

Index: `(user_id, watched_at)` untuk urutan riwayat tontonan.
Index: `(movie_id)` untuk query Most Watched.

Catatan:

- Kolom `note` tidak ada di tabel ini. Catatan tontonan berada di
  `diary_entries.note`.
- Menghapus film secara fisik menghapus baris di tabel ini karena
  `movies.id` memakai on delete cascade. Soft delete tidak menyentuh
  tabel ini.

### 3.7 diary_entries

Catatan tontonan milik user beserta tanggal dan catatan.

Migration: `0001_01_01_000008_create_diary_entries_table.php`, lalu
`0001_01_01_000022_update_diary_entries_unique.php`.

| Kolom | Tipe | Constraint | Keterangan |
|---|---|---|---|
| id | bigint | PK, auto increment | |
| user_id | bigint | FK users, cascade, not null | |
| movie_id | bigint | FK movies, cascade, not null | |
| watched_date | date | not null | Tanggal tonton |
| note | text | nullable | Catatan opsional |
| created_at | timestamp | nullable | |
| updated_at | timestamp | nullable | |

Unique: `(user_id, movie_id, watched_date)`.

Index: `(user_id, watched_date)` untuk urutan diary.
Index: `movie_id` untuk menagih film yang tidak ada di watchlist.

Catatan:

- Tabel ini terpisah dari `watched`. `watched` menandai status sudah
  ditonton, `diary_entries` menyimpan catatan tontonannya.
- Entri diary boleh berulang untuk `movie_id` yang sama selama
  `watched_date` berbeda. User dapat mencatat tontonan ulang film yang
  sama pada tanggal berbeda.
- Entri diary boleh dibuat tanpa baris `watched` yang sesuai. Endpoint
  `POST /api/log` membuat keduanya sekaligus.
- `watched_id` tidak ada di tabel ini. Relasi ke `watched` dijaga di
  application layer, bukan dengan foreign key.

### 3.8 reviews

Rating dan review user untuk film.

Migration: `0001_01_01_000009_create_reviews_table.php`.

| Kolom | Tipe | Constraint | Keterangan |
|---|---|---|---|
| id | bigint | PK, auto increment | |
| user_id | bigint | FK users, cascade, not null | |
| movie_id | bigint | FK movies, cascade, not null | |
| rating | tinyint | not null | Nilai 1 sampai 5 |
| content | text | nullable | Isi review teks, boleh kosong |
| created_at | timestamp | nullable | |
| updated_at | timestamp | nullable | |

Unique: `(user_id, movie_id)`.

Index: `(movie_id)` untuk query Top Rated.

Catatan:

- Rating wajib diisi karena review tanpa rating tidak disimpan pada MVP.
- `content` boleh null supaya rating berdiri sendiri tanpa teks review.
  Endpoint `POST /api/movies/{id}/rate` membuat baris dengan `content`
  null tanpa membuat entri diary.
- Gunakan CHECK constraint agar rating selalu di rentang 1 sampai 5.
- Film yang kehilangan seluruh review tidak lagi masuk Top Rated.

### 3.9 lists

Daftar film kurasi milik user.

Migration: `2026_10_14_000008_create_lists_table.php`.

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
- List kurasi sistem tidak disimpan di tabel ini dan tidak ada lagi
  setelah sumber data eksternal dihapus.
- Hapus list berarti semua `list_items` ikut terhapus lewat cascade.

### 3.10 list_items

Film yang menjadi anggota sebuah list.

Migration: `2026_10_14_000009_create_list_items_table.php`.

| Kolom | Tipe | Constraint | Keterangan |
|---|---|---|---|
| id | bigint | PK, auto increment | |
| list_id | bigint | FK lists, cascade, not null | List induk |
| movie_id | bigint | FK movies, cascade, not null | |
| note | text | nullable | Catatan singkat di dalam list |
| order_index | integer | not null, default 0 | Urutan manual |
| created_at | timestamp | nullable | |
| updated_at | timestamp | nullable | |

Unique: `(list_id, movie_id)`.

Index: `(list_id, order_index)` untuk urutan isi list.

Catatan:

- `order_index` diisi otomatis dari nilai terbesar saat film ditambahkan,
  lalu dapat diubah lewat halaman detail list.
- Tabel ini memakai `timestamps()` penuh. Isi list tetap bisa diedit
  pada kolom `note` tanpa mengubah urutan.

### 3.11 tags

Label pribadi milik user untuk entri diary.

Migration: `2026_10_14_000010_create_tags_table.php`.

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
### 3.12 diary_tags

Penghubung tag ke entri diary.

Migration: `2026_10_14_000011_create_diary_tags_table.php`.

| Kolom | Tipe | Constraint | Keterangan |
|---|---|---|---|
| id | bigint | PK, auto increment | |
| diary_entry_id | bigint | FK diary_entries, cascade, not null | Entri diary |
| tag_id | bigint | FK tags, cascade, not null | Tag yang ditempel |
| created_at | timestamp | nullable | |

Unique: `(diary_entry_id, tag_id)`.

Index: `(tag_id)` untuk filter diary berdasarkan tag.

Catatan:

- Menghapus entri diary otomatis melepas tag pada entri itu.
- Menghapus tag melepas tag dari seluruh entri diary.

### 3.13 favorites

Empat film favorit yang dipajang di profil user.

Migration: `2026_10_14_000012_create_favorites_table.php`.

| Kolom | Tipe | Constraint | Keterangan |
|---|---|---|---|
| id | bigint | PK, auto increment | |
| user_id | bigint | FK users, cascade, not null | Pemilik |
| movie_id | bigint | FK movies, cascade, not null | |
| position | tinyint | not null | Posisi 1 sampai 4 |
| created_at | timestamp | nullable | |
| updated_at | timestamp | nullable | |

Unique: `(user_id, position)` dan `(user_id, movie_id)`.

Catatan:

- CHECK constraint pada `position` membatasi nilai 1 sampai 4.
- Menyimpan film di posisi yang sudah terpakai memindahkan film lama di
  posisi tersebut ke posisi paling akhir yang kosong.
- Film boleh berada di watchlist, watched, diary, like, dan favourites
  sekaligus. Tabel-tabel ini berdiri sendiri.

### 3.14 likes

Tanda suka polymorphic pada film, review, atau list, terpisah dari
rating bintang.

Migration: `0001_01_01_000015_create_likes_table.php`, lalu
`0001_01_01_000021_change_likes_to_polymorphic.php`.

| Kolom | Tipe | Constraint | Keterangan |
|---|---|---|---|
| id | bigint | PK, auto increment | |
| user_id | bigint | FK users, cascade, not null | Pemberi like |
| likeable_id | bigint | not null | ID target |
| likeable_type | varchar(255) | not null | Class target |
| created_at | timestamp | nullable | |
| updated_at | timestamp | nullable | |

Unique: `(user_id, likeable_id, likeable_type)`.

Index: `(likeable_type, likeable_id)` untuk menghitung jumlah like.

`likeable_type` berisi `App\Models\Movie`, `App\Models\Review`, atau
`App\Models\MovieList`.

Catatan:

- Like tidak memengaruhi rating dan tidak membuat review.
- User dapat like film yang belum pernah ia tonton atau beri rating.
- Like pada review dan list membuat baris `notifications`.
- Relasi didefinisikan lewat `morphMany` di model `Movie`, `Review`,
  dan `MovieList`, serta `morphTo` di model `Like`.

### 3.15 follows

Relasi mengikuti antar user.

Migration: `2026_10_14_000014_create_follows_table.php`.

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

### 3.16 activities

Catatan aktivitas user untuk activity feed.

Migration: `2026_10_14_000015_create_activities_table.php`.

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
| watched | User menandai film ditonton | `watched.id` | movie_id, watched_at |
| rated | User menyimpan rating | `reviews.id` | movie_id, rating |
| reviewed | User menulis review | `reviews.id` | movie_id, excerpt |
| liked | User like film | `likes.id` | movie_id |
| list_created | User membuat list | `lists.id` | title, is_public |
| followed | User mengikuti user lain | `follows.id` | following_name |

Catatan:

- Tabel ini hanya ditulis oleh backend. Aplikasi tidak pernah insert
  langsung ke tabel ini.
- Tidak ada foreign key pada `reference_id` karena nilainya polymorphic
  dan baris asal boleh terhapus. Aktivitas yang menunjuk baris terhapus
  disembunyikan saat feed dibangun.
- `metadata` tidak pernah berisi data sensitif.
- Aktivitas admin tidak ditulis ke tabel ini. Tindakan admin dicatat di
  `admin_audit_logs` supaya tidak bocor ke feed user.

### 3.17 admin_audit_logs

Riwayat setiap tindakan admin yang mengubah data.

Migration: `2026_10_14_000016_create_admin_audit_logs_table.php`.

| Kolom | Tipe | Constraint | Keterangan |
|---|---|---|---|
| id | bigint | PK, auto increment | |
| admin_id | bigint | FK users, cascade, not null | Admin pelaku |
| action | varchar(50) | not null | Nama tindakan, lihat tabel di bawah |
| entity | varchar(50) | not null | Jenis entitas, lihat tabel di bawah |
| entity_id | bigint | nullable | Id baris yang diubah |
| detail | text | nullable | Ringkasan perubahan |
| created_at | timestamp | nullable | |
| updated_at | timestamp | nullable | |

Index: `(admin_id, created_at)` untuk daftar log per admin.
Index: `(entity, created_at)` untuk filter per jenis entitas.

Nilai kolom `entity`:

| Entity | Dipakai saat |
|---|---|
| movie | Tambah, ubah, hapus, atau tandai featured film |
| genre | Tambah, ubah, atau hapus genre |
| user | Ubah role user |
| review | Hapus review |
| list | Hapus list |
| tag | Hapus tag |

Catatan:

- Tabel ini hanya ditulis oleh `AdminAuditService`. Controller admin
  tidak boleh insert langsung.
- Admin tidak dapat menghapus baris di tabel ini. Tidak ada endpoint
  hapus dan tidak ada soft delete.
- `detail` menyimpan JSON berisi ringkasan perubahan, bukan dump seluruh
  baris. Jangan pernah menaruh password atau token di sini.
- `updated_at` tetap ada karena migration memakai `timestamps()`, walau
  log tidak pernah diubah.
### 3.18 comments

Komentar pada review milik user lain.

Migration: `0001_01_01_000023_create_comments_table.php`.

| Kolom | Tipe | Constraint | Keterangan |
|---|---|---|---|
| id | bigint | PK, auto increment | |
| review_id | bigint | FK reviews, cascade, not null | Review induk |
| user_id | bigint | FK users, cascade, not null | Penulis komentar |
| content | text | not null | Isi komentar, maksimal 1000 karakter |
| created_at | timestamp | nullable | |
| updated_at | timestamp | nullable | |

Index: `(review_id)` untuk daftar komentar per review.

Catatan:

- Menghapus review menghapus seluruh komentarnya lewat cascade.
- Komentar membuat notifikasi `comment_review` untuk pemilik review.
- Hanya pemilik komentar atau admin yang boleh menghapus komentar.

### 3.19 notifications

Notifikasi sosial untuk user penerima.

Migration: `0001_01_01_000024_create_notifications_table.php`.

| Kolom | Tipe | Constraint | Keterangan |
|---|---|---|---|
| id | bigint | PK, auto increment | |
| user_id | bigint | FK users, cascade, not null | Penerima notifikasi |
| actor_id | bigint | FK users, cascade, not null | Pelaku tindakan |
| type | varchar(40) | not null | Lihat tabel di bawah |
| reference_id | bigint | nullable | Id like, komentar, atau follow |
| is_read | boolean | not null, default false | Status sudah dibaca |
| created_at | timestamp | nullable | |
| updated_at | timestamp | nullable | |

Index: `(user_id, is_read)` untuk daftar notifikasi belum dibaca.

Nilai kolom `type`:

| Type | Dipicu saat |
|---|---|
| like_review | User lain me-like review |
| comment_review | User lain berkomentar pada review |
| follow | User lain mulai mengikuti |
| like_list | User lain me-like list |

Catatan:

- Tabel ini hanya ditulis oleh `NotificationService`.
- Tidak ada notifikasi bila pelaku dan penerima adalah user yang sama.
- Notifikasi tidak pernah dihapus oleh user. `is_read` diubah lewat
  endpoint notifikasi.

## 4. Relasi

- users satu ke banyak watchlist.
- users satu ke banyak watched.
- users satu ke banyak diary_entries.
- users satu ke banyak reviews.
- users satu ke banyak lists.
- users satu ke banyak tags.
- users satu ke banyak favorites.
- users satu ke banyak likes.
- users satu ke banyak activities.
- users satu ke banyak admin_audit_logs sebagai admin.
- users satu ke banyak notifications sebagai penerima dan sebagai pelaku.
- users banyak ke banyak users lewat follows, dengan alias `followers`
  dan `following`.
- movies satu ke banyak watchlist, watched, diary_entries, reviews,
  list_items, dan favorites.
- movies satu ke banyak likes lewat morphMany `likeable`.
- movies satu ke banyak movie_genres.
- genres satu ke banyak movie_genres.
- movies banyak ke banyak genres lewat movie_genres.
- lists satu ke banyak list_items dan likes lewat morphMany `likeable`.
- list_items satu ke banyak movies.
- reviews satu ke banyak comments dan likes lewat morphMany `likeable`.
- diary_entries banyak ke banyak tags lewat diary_tags.

Perubahan terhadap skema sebelumnya:

- Tabel `movies_cache` dihapus, diganti `movies` yang diinput admin.
- Semua kolom `tmdb_id` diganti `movie_id` dengan foreign key ke
  `movies.id`.
- Tabel `diary_entries` ditambahkan kembali sebagai tabel tersendiri.
- Unique `diary_entries` diubah dari `(user_id, movie_id)` menjadi
  `(user_id, movie_id, watched_date)` agar tontonan ulang bisa dicatat.
- Tabel `likes` diubah dari khusus film menjadi polymorphic dengan
  `likeable_id` dan `likeable_type`.
- Tabel `comments` ditambahkan untuk komentar pada review.
- Tabel `notifications` ditambahkan untuk notifikasi sosial.
- Tabel `genres` dan `movie_genres` ditambahkan.
- Tabel `admin_audit_logs` ditambahkan.
- Kolom `role` ditambahkan pada `users`.
- Kolom `deleted_at` ditambahkan pada `movies` untuk soft delete.
## 5. Query Umum

Semua query di bawah hanya menyentuh film yang belum dinonaktifkan.
Pola `where movies.deleted_at is null` tidak ditulis ulang setiap kali
karena dipakai lewat global scope `SoftDeletes` di model `Movie`.

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

Diary dengan tag, untuk filter berdasarkan tag:

```sql
select d.id, d.watched_date, d.note, m.id as movie_id, m.title, m.poster_path,
       group_concat(t.name order by t.name) as tags
from diary_entries d
join movies m on m.id = d.movie_id
left join diary_tags dt on dt.diary_entry_id = d.id
left join tags t on t.id = dt.tag_id
where d.user_id = ?
  and (? is null or exists (
    select 1 from diary_tags dt2
    join tags t2 on t2.id = dt2.tag_id
    where dt2.diary_entry_id = d.id and t2.id = ?
  ))
group by d.id, m.id
order by d.watched_date desc;
```

Isi sebuah list dengan judul film:

```sql
select li.order_index, li.note, m.id as movie_id, m.title, m.poster_path
from list_items li
join movies m on m.id = li.movie_id
where li.list_id = ?
order by li.order_index asc;
```

Favourites user, urut posisi:

```sql
select f.position, m.id as movie_id, m.title, m.poster_path
from favorites f
join movies m on m.id = f.movie_id
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
order by a.created_at desc
limit 30;
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
       a.created_at, a.metadata->>'movie_id' as movie_id,
       m.title, m.poster_path
from activities a
join users u on u.id = a.user_id
join likes l on l.user_id = a.user_id
join list_items li on li.movie_id = l.movie_id
join lists ls on ls.id = li.list_id and ls.is_public = true
join movies m on m.id = l.movie_id
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

Statistik profil lengkap dalam satu query:

```sql
select
  (select count(*) from watched where user_id = ?) as total_watched,
  (select count(*) from watchlist where user_id = ?) as total_watchlist,
  (select count(*) from diary_entries where user_id = ?) as total_diary,
  (select count(*) from reviews where user_id = ?) as total_reviews,
  (select round(avg(rating), 1) from reviews where user_id = ?) as average_rating,
  (select count(*) from likes where user_id = ?) as total_likes,
  (select count(*) from lists where user_id = ?) as total_lists,
  (select count(*) from follows where following_id = ?) as total_followers,
  (select count(*) from follows where follower_id = ?) as total_following;
```

Subquery dipakai agar tidak perlu join silang yang menggandakan baris.
Endpoint `GET /api/profile/stats` memakai bentuk ini.

### 5.1 Query Home

Keenam section memakai satu service, `HomeService`. Masing-masing
mengambil maksimal sepuluh film kecuali Featured yang lima.

Featured, film yang ditandai admin:

```sql
select m.id, m.title, m.poster_path, m.overview,
       avg(r.rating) as average_rating, count(r.id) as review_count
from movies m
left join reviews r on r.movie_id = m.id
where m.is_featured = true and m.deleted_at is null
group by m.id
order by m.created_at desc
limit 5;
```

Latest, film yang paling baru diinput admin:

```sql
select m.id, m.title, m.poster_path, m.release_date,
       avg(r.rating) as average_rating, count(r.id) as review_count
from movies m
left join reviews r on r.movie_id = m.id
where m.deleted_at is null
group by m.id
order by m.created_at desc
limit 10;
```

Top Rated, hanya film dengan minimal satu review:

```sql
select m.id, m.title, m.poster_path, m.release_date,
       round(avg(r.rating), 2) as average_rating, count(r.id) as review_count
from movies m
join reviews r on r.movie_id = m.id
where m.deleted_at is null
group by m.id, m.id
having count(r.id) > 0
order by average_rating desc, review_count desc
limit 10;
```

Most Watched:

```sql
select m.id, m.title, m.poster_path, m.release_date,
       count(w.id) as watched_count
from movies m
join watched w on w.movie_id = m.id
where m.deleted_at is null
group by m.id
order by watched_count desc
limit 10;
```

Most Watchlisted:

```sql
select m.id, m.title, m.poster_path, m.release_date,
       count(wl.id) as watchlist_count
from movies m
join watchlist wl on wl.movie_id = m.id
where m.deleted_at is null
group by m.id
order by watchlist_count desc
limit 10;
```

Explore, pilihan acak dari katalog aktif:

```sql
select m.id, m.title, m.poster_path, m.release_date
from movies m
where m.deleted_at is null
order by rand()
limit 10;
```

Catatan:

- `rand()` dipakai karena katalog kecil. Pada katalog besar, section
  Explore diganti dengan pengurutan deterministik memakai offset-acak
  yang disimpan di sisi klien.
- Keenam query dijalankan di dalam satu transaksi baca agar snapshot
  data konsisten.
- Rated dan watched dihitung ulang setiap request. Tidak ada kolom
  denormalisasi yang bisa basi.

### 5.2 Query Dashboard Admin

Semua angka dihitung ulang saat dashboard dibuka.

```sql
select
  (select count(*) from movies where deleted_at is null) as active_movies,
  (select count(*) from movies where deleted_at is not null) as deleted_movies,
  (select count(*) from genres) as total_genres,
  (select count(*) from users) as total_users,
  (select count(*) from users where role = 'admin') as total_admins,
  (select count(*) from reviews) as total_reviews,
  (select count(*) from lists) as total_lists,
  (select count(*) from tags) as total_tags;
```

Film yang baru diinput:

```sql
select id, title, is_featured, created_at
from movies
where deleted_at is null
order by created_at desc
limit 5;
```

Aktivitas admin terbaru:

```sql
select l.id, l.action, l.entity, l.entity_id, l.detail, l.created_at,
       u.name as admin_name
from admin_audit_logs l
join users u on u.id = l.admin_id
order by l.created_at desc
limit 10;
```

Film yang paling banyak ditonton, untuk audit admin:

```sql
select m.id, m.title, count(w.id) as watched_count
from movies m
left join watched w on w.movie_id = m.id
where m.deleted_at is null
group by m.id
order by watched_count desc
limit 10;
```

Jumlah review per film untuk query Top Rated. Kolom ini tidak disimpan
dan tidak di-cache:

```sql
select movie_id, round(avg(rating), 2) as average_rating, count(*) as review_count
from reviews
group by movie_id;

## 6. Script Migrasi Laravel

Semua tabel dibuat lewat migration di `backend/database/migrations/`.
Nama file memakai pola `YYYY_MM_DD_NNNNNN_create_<nama>_table.php`.

Migration `users`, `password_reset_tokens`, `sessions`, `cache`, dan
`jobs` sudah dibuat oleh `composer create-project`. Jangan dibuat ulang
dan jangan diubah.

Urutan file:

| Urutan | File migration | Tabel |
|---|---|---|
| 000000 | `0001_01_01_000000_create_users_table.php` | `users` |
| 000001 | `0001_01_01_000001_create_cache_table.php` | `cache` |
| 000002 | `0001_01_01_000002_create_jobs_table.php` | `jobs` |
| 000003 | `0001_01_01_000003_create_movies_table.php` | `movies` |
| 000004 | `0001_01_01_000004_create_genres_table.php` | `genres` |
| 000005 | `0001_01_01_000005_create_movie_genres_table.php` | `movie_genres` |
| 000006 | `0001_01_01_000006_create_watchlist_table.php` | `watchlist` |
| 000007 | `0001_01_01_000007_create_watched_table.php` | `watched` |
| 000008 | `0001_01_01_000008_create_diary_entries_table.php` | `diary_entries` |
| 000009 | `0001_01_01_000009_create_reviews_table.php` | `reviews` |
| 000010 | `0001_01_01_000010_create_lists_table.php` | `lists` |
| 000011 | `0001_01_01_000011_create_list_items_table.php` | `list_items` |
| 000012 | `0001_01_01_000012_create_tags_table.php` | `tags` |
| 000013 | `0001_01_01_000013_create_diary_tags_table.php` | `diary_tags` |
| 000014 | `0001_01_01_000014_create_favorites_table.php` | `favorites` |
| 000015 | `0001_01_01_000015_create_likes_table.php` | `likes` |
| 000016 | `0001_01_01_000016_create_follows_table.php` | `follows` |
| 000017 | `0001_01_01_000017_create_activities_table.php` | `activities` |
| 000018 | `0001_01_01_000018_create_admin_audit_logs_table.php` | `admin_audit_logs` |
| 000019 | `0001_01_01_000019_add_role_to_users_table.php` | kolom `role` |
| 000020 | `0001_01_01_000020_create_personal_access_tokens_table.php` | `personal_access_tokens` |

Perintah pembuatannya, dijalankan dari folder `backend/`:

```
php artisan make:migration create_movies_table
php artisan make:migration create_genres_table
php artisan make:migration create_movie_genres_table
php artisan make:migration create_watchlist_table
php artisan make:migration create_watched_table
php artisan make:migration create_diary_entries_table
php artisan make:migration create_reviews_table
php artisan make:migration create_lists_table
php artisan make:migration create_list_items_table
php artisan make:migration create_tags_table
php artisan make:migration create_diary_tags_table
php artisan make:migration create_favorites_table
php artisan make:migration create_likes_table
php artisan make:migration create_follows_table
php artisan make:migration create_activities_table
php artisan make:migration create_admin_audit_logs_table
php artisan make:migration add_role_to_users_table
```

Laravel memberi nama file berurutan dari tanggal dan jam pembuatan.
Nomor pada tabel di atas adalah urutan yang diharapkan, bukan angka yang
dipaksakan. Yang penting urutan eksekusinya benar.

Perintah menjalankan dan membatalkan:

```
php artisan migrate
php artisan migrate:rollback
php artisan migrate:fresh --seed
php artisan migrate:status
```

Catatan:

- Urutan foreign key dipatok oleh file yang dibuat lebih dulu.
  `movie_genres` setelah `movies` dan `genres`, `diary_tags` setelah
  `diary_entries` dan `tags`, seluruh tabel user setelah `movies`.
- Kolom `role` ditambahkan lewat migration terpisah, bukan langsung di
  migration `create_users_table`, supaya tabel bawaan Laravel tidak
  pernah diedit.
- `deleted_at` ditulis di migration `create_movies_table` karena masih
  bagian dari definisi tabel, bukan perubahan susulan.
- Tiap migration punya header komentar satu baris yang menyebut tabel
  yang dibuat.
- Kolom `created_at` dan `updated_at` memakai `timestamps()`.
- Index dan CHECK constraint ditulis di dalam `up()` pada tabel yang
  sama, bukan migration terpisah.

Rollback:

| File | Effect |
|---|---|
| `add_role_to_users_table` | drop kolom `role` |
| `create_admin_audit_logs_table` | drop `admin_audit_logs` |
| `create_activities_table` | drop `activities` |
| `create_follows_table` | drop `follows` |
| `create_likes_table` | drop `likes` |
| `create_favorites_table` | drop `favorites` |
| `create_diary_tags_table` | drop `diary_tags` |
| `create_tags_table` | drop `tags` |
| `create_list_items_table` | drop `list_items` |
| `create_lists_table` | drop `lists` |
| `create_reviews_table` | drop `reviews` |
| `create_diary_entries_table` | drop `diary_entries` |
| `create_watched_table` | drop `watched` |
| `create_watchlist_table` | drop `watchlist` |
| `create_movie_genres_table` | drop `movie_genres` |
| `create_genres_table` | drop `genres` |
| `create_movies_table` | drop `movies` |

`drop()` dipanggil dalam urutan terbalik dari `up()`.

## 7. Penyimpanan File Gambar

Poster dan backdrop diupload oleh admin dan disimpan di disk publik.

| Aspek | Nilai |
|---|---|
| Disk | `public` |
| Folder poster | `storage/app/public/posters/` |
| Folder backdrop | `storage/app/public/backdrops/` |
| Symlink | `php artisan storage:link` |
| URL publik | `APP_URL` + `/storage/posters/<nama_file>` |
| Format | jpg, jpeg, png, webp |
| Batas poster | 2 MB |
| Batas backdrop | 4 MB |

Catatan:

- `php artisan storage:link` wajib dijalankan setelah migrate. Tanpa
  symlink, gambar tidak bisa diakses dari perangkat.
- Nama file pada storage diacak oleh Laravel, bukan nama asli dari
  perangkat. Ini mencegah tabrakan nama dan path traversal.
- Kolom `poster_path` dan `backdrop_path` hanya menyimpan path relatif
  seperti `posters/8f3a1c.jpg`, bukan URL penuh.
- Pembentukan URL penuh dilakukan di backend pada `MovieResource` dari
  nilai `APP_URL`. Backend tidak pernah mengembalikan path relatif
  mentah ke klien.
- Environment Android emulator memakai `10.0.2.2`, bukan `127.0.0.1`,
  untuk menjangkau `APP_URL` lokal.
- Validasi upload memakai aturan `image`, `mimes`, dan `max` pada
  FormRequest. Validasiåªçœ‹ ekstensi tidak cukup.
- Tidak ada cache TTL untuk gambar di database. Cache gambar dilakukan
  di sisi klien dengan `cached_network_image_ce`.

## 8. Seed Data

Seeder membuat:

- Satu admin. Email dan password-nya dibaca dari `.env` dengan kunci
  `DEMO_ADMIN_EMAIL` dan `DEMO_USER_PASSWORD`, tidak ditulis langsung di
  kode. Role `admin`.
- Satu user demo. Email dibaca dari `.env` dengan kunci
  `DEMO_USER_EMAIL`. Role `user`.
- Lima genre: Action, Drama, Comedy, Horror, Romance.
- Sepuluh film contoh dengan genre, sinopsis, tanggal rilis, durasi,
  bahasa, negara, cast, dan crew.
- `poster_path` dan `backdrop_path` sengaja dikosongkan pada seed.
  Placeholder bukan file biner dan tidak bisa di-commit. Admin
  mengunggah gambar sungguhan lewat halaman admin.

Tidak di-seed:

- Baris `movies_cache`. Tabel itu sudah tidak ada.
- Entri `watchlist`, `watched`, `diary_entries`, `reviews`, `lists`,
  `list_items`, `tags`, `diary_tags`, `favorites`, `likes`, `follows`.
  Data ini milik user dan dibuat lewat aplikasi.
- Baris `activities` dan `admin_audit_logs`. Keduanya tercipta dari aksi
  sungguhan, bukan dari seeder.
- File gambar di `storage/`. Foldernya dibuat tapi isinya tidak.

Tabel yang perlu factory di `backend/database/factories/`:

`MovieFactory`, `GenreFactory`, `WatchlistFactory`, `WatchedFactory`,
`DiaryEntryFactory`, `ReviewFactory`, `MovieListFactory`,
`ListItemFactory`, `TagFactory`, `FavoriteFactory`, `LikeFactory`,
`FollowFactory`, `ActivityFactory`, dan `AdminAuditLogFactory`.
`UserFactory` bawaan Laravel sudah ada dan perlu ditambah nilai
default untuk `role`.

## 9. Catatan

- Data film sepenuhnya milik aplikasi. Tidak ada sumber eksternal yang
  dipanggil, dan tidak ada cache film di luar database.
- Film memakai soft delete lewat kolom `deleted_at`. Baris tidak pernah
  dihapus fisik sehingga data user tetap utuh.
- Rating rata-rata dan jumlah tontonan selalu dihitung dari tabel
  `reviews`, `watched`, dan `watchlist` saat query. Tidak ada kolom
  denormalisasi yang bisa basi.
- Foreign key ke `movies.id` memakai on delete cascade. Soft delete
  membuat cascade ini tidak terpicu pada operasi normal.
- Migration yang sudah dijalankan tidak boleh diedit. Perubahan struktur
  selalu lewat migration baru.
- Tiap file gambar yang sudah diupload tidak dihapus otomatis saat film
  dinonaktifkan. Penghapusan file dibuat eksplisit pada task
  pengelolaan aset.
- Tabel `admin_audit_logs` tidak punya endpoint hapus dan tidak punya
  soft delete.
- `activities` dan `admin_audit_logs` sengaja dipisah supaya tindakan
  admin tidak pernah bocor ke activity feed user.
