# 06-testing

Aturan testing frontend dan backend.

## Wajibnya Test

| Jenis task | Test minimal |
|---|---|
| Fitur baru | 1 unit test di domain atau data |
| Komponen reusable baru | 1 widget test render tanpa error |
| Halaman baru | 1 widget test render tanpa error |
| Bug fix | 1 test yang mereproduksi bug sebelum perbaikan |
| Endpoint baru di backend | 1 feature test untuk kasus sukses dan 1 untuk kasus gagal |
| Endpoint yang mengubah data | 1 test otorisasi pemilik dan 1 test nonpemilik |
| Perilaku database | 1 test untuk unique constraint dan cascade yang relevan |

Task tanpa test dan tanpa alasan yang tercatat di `CHANGELOG.md` dianggap
belum selesai.

## Kualitas Test

- Test harus deterministik. Tidak bergantung pada jaringan asli, waktu
  sistem, locale, atau urutan eksekusi.
- Panggilan jaringan di mock, bukan ke server sungguhan. Untuk Flutter
  pakai `mocktail`. Untuk backend pakai `Http::fake`.
- Waktu tetap. Jangan memakai `now()` tanpa titik injeksi waktu pada
  class yang diuji.
- Satu test satu perilaku. Jangan menggabungkan beberapa assert dalam
  satu test.
- Nama test menjelaskan perilaku, bukan implementasi.

Format nama test Flutter:

```dart
test('namaPerilaku yang diharapkan', () {
  // Arrange, Act, Assert
});
```

Format nama test backend:

```php
public function test_nama_perilaku_yang_diharapkan(): void
{
    // Arrange, Act, Assert
}
```

## Backend

- Database test memakai `RefreshDatabase`.
- Feature test memakai `Sanctum::actingAs` untuk user yang sudah login.
- Tidak ada assert pada pesan error Bahasa Indonesia sebagai satu-satunya
  cara verifying validasi. Assert juga pada status HTTP.
- Factory wajib dipakai, bukan membuat baris manual di dalam test.

## Frontend

- Provider diuji dengan override repository, bukan dengan HTTP sungguhan.
- Widget test menguji perilaku yang dilihat user, bukan struktur internal
  widget.
- Golden test tidak dipakai pada MVP karena token visual belum
  difinalisasi di Stitch.

## Verifikasi Sebelum Task Selesai

Jalankan berurutan dan catat hasilnya di `CHANGELOG.md`:

```
cd frontend && flutter analyze
cd frontend && flutter test
cd backend && php artisan test
```

- `flutter analyze`: 0 error. Warning harus dijelaskan kalau ada.
- `flutter test`: semua pass.
- `php artisan test`: semua pass.
- Tidak ada file test yang di-comment atau di-skip tanpa alasan tertulis.
- Path test memakai prefix `frontend/`, misalnya
  `frontend/test/features/diary/diary_page_test.dart`.

## Coverage

Tidak ada target coverage numerik pada MVP. Yang dijaga adalah setiap
perilaku bisnis di domain punya test. Coverage tinggi dengan test yang
tidak menguji perilaku sama tidak berguna.
