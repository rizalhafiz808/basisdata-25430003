# Normalisasi Perpustakaan Cendekia RH — Rizal Hafiz (25430003)

## 1. Dokumen Sumber

Dokumen sumber yang digunakan adalah Slip Peminjaman Buku pada dokumen kebutuhan data P02 Bagian 3.1.

## 2. Bentuk UNF

```
SLIP_UNF (
    nomor_peminjaman,
    tanggal_peminjaman,
    id_anggota,
    nama_anggota,
    id_petugas,
    nama_petugas,
    {
        no,
        id_eksemplar,
        judul_buku,
        tanggal_jatuh_tempo,
        tanggal_pengembalian,
        hari_terlambat,
        denda
    }
)
```

Kolom `no` dimasukkan sebagai nomor urut buku dalam slip, bukan sebagai identitas unik eksemplar. Identitas setiap eksemplar tetap menggunakan `id_eksemplar`.

Grup berulang terdapat pada daftar buku yang dipinjam, karena satu slip peminjaman dapat memuat beberapa eksemplar buku dengan informasi masing-masing.

## 3. Bentuk 1NF

Grup berulang dihilangkan dengan membuat satu baris untuk setiap eksemplar yang dipinjam dalam setiap slip peminjaman.

Kunci primer komposit yang digunakan adalah `(nomor_peminjaman, id_eksemplar)` karena satu slip dapat berisi beberapa eksemplar, dan pasangan nomor peminjaman serta ID eksemplar membedakan setiap detail peminjaman dalam slip.

```text
SLIP_1NF (
    nomor_peminjaman,
    tanggal_peminjaman,
    id_anggota,
    nama_anggota,
    id_petugas,
    nama_petugas,
    id_eksemplar,
    judul_buku,
    tanggal_jatuh_tempo,
    tanggal_pengembalian,
    hari_terlambat,
    denda
)
```

Kolom `no` dibuang karena hanya berfungsi sebagai nomor urut tampilan pada slip dan dapat dibuat kembali saat slip dicetak. Kolom tersebut tidak termasuk atribut dalam kamus data P02.

## 4. Dependensi Fungsional

FD1: `nomor_peminjaman -> tanggal_peminjaman, id_anggota, id_petugas` (AB-04)

FD2: `id_anggota -> nama_anggota` (AB-01 dan Bagian 4 P02)

FD3: `id_petugas -> nama_petugas` (AB-04 dan Bagian 4 P02)

FD4a: `id_eksemplar -> id_buku` (AB-03 dan Kamus Data P02 Bagian 8 nomor 20–21)

FD4b: `id_buku -> judul_buku` (AB-02 dan Kamus Data P02 Bagian 8 nomor 13–14)

FD5: `(nomor_peminjaman, id_eksemplar) -> tanggal_jatuh_tempo` (AB-06)

FD6: `(nomor_peminjaman, id_eksemplar) -> tanggal_pengembalian` (Bagian 3.2 P02)

FD7: `tanggal_jatuh_tempo`, `tanggal_pengembalian` -> `hari_terlambat` (turunan, AB-08 dan P02 Bagian 3.2)

FD8: (nomor_peminjaman, id_eksemplar) -> denda (AB-09)

## 5. Menuju 2NF

Pada relasi `SLIP_1NF`, kunci primer kompositnya adalah `(nomor_peminjaman, id_eksemplar)`. Atribut `tanggal_peminjaman`, `id_anggota`, dan `id_petugas` hanya bergantung pada `nomor_peminjaman`, sedangkan `judul_buku` bergantung pada `id_eksemplar`. Dengan demikian, terdapat atribut yang hanya bergantung pada sebagian kunci primer. Untuk memenuhi 2NF, atribut-atribut tersebut perlu dipisahkan ke dalam relasi yang sesuai.

```
PEMINJAMAN (
    nomor_peminjaman (PK),
    tanggal_peminjaman,
    id_anggota*,
    nama_anggota,
    id_petugas*,
    nama_petugas
)

EKSEMPLAR (
    id_eksemplar (PK),
    judul_buku
)

DETAIL_PEMINJAMAN (
    nomor_peminjaman* (PK),
    id_eksemplar* (PK),
    tanggal_jatuh_tempo,
    tanggal_pengembalian,
    hari_terlambat,
    denda
)
```

Keterangan:
- PK = Primary Key (kunci primer).
- Tanda * = Foreign Key (kunci tamu).
- PEMINJAMAN menyimpan informasi utama transaksi.
- EKSEMPLAR menyimpan identitas eksemplar dan judul buku.
- DETAIL_PEMINJAMAN menyimpan informasi setiap eksemplar dalam transaksi.

Catatan: Relasi di atas merupakan pemisahan untuk menghilangkan ketergantungan parsial. Ketergantungan transitif seperti `id_anggota -> nama_anggota` dan `id_petugas -> nama_petugas` masih ada pada `PEMINJAMAN`, sehingga perlu ditangani saat menuju 3NF.

## 6. Menuju 3NF

Berdasarkan pemeriksaan ketiga relasi hasil 2NF, ditemukan tiga rantai ketergantungan transitif. Pertama, pada relasi `PEMINJAMAN`, terdapat rantai `nomor_peminjaman -> id_anggota -> nama_anggota`, karena nomor peminjaman menentukan anggota yang meminjam, sedangkan ID anggota menentukan nama anggota (AB-01 dan AB-04). Kedua, terdapat rantai `nomor_peminjaman -> id_petugas -> nama_petugas`, karena nomor peminjaman menentukan petugas yang melayani, sedangkan ID petugas menentukan nama petugas (AB-04). Ketiga, pada relasi `EKSEMPLAR`, terdapat rantai `id_eksemplar -> id_buku -> judul_buku`. Berdasarkan AB-03, setiap eksemplar terhubung dengan satu judul buku, sedangkan satu judul buku dapat memiliki beberapa eksemplar. Kamus data P02 Bagian 8 nomor 13–14 menunjukkan bahwa `id_buku` dan `judul_buku` merupakan atribut entitas Buku, sedangkan nomor 20–21 menunjukkan bahwa `id_eksemplar` dan `id_buku` merupakan atribut entitas Eksemplar. Oleh karena itu, atribut nama anggota, nama petugas, dan judul buku perlu dipisahkan ke relasi masing-masing agar tidak terjadi ketergantungan transitif.

```
ANGGOTA (
    id_anggota (PK),
    nama_anggota
)

PETUGAS (
    id_petugas (PK),
    nama_petugas
)

BUKU (
    id_buku (PK),
    judul_buku
)

EKSEMPLAR (
    id_eksemplar (PK),
    id_buku (FK)
)

PEMINJAMAN (
    nomor_peminjaman (PK),
    tanggal_peminjaman,
    id_anggota (FK),
    id_petugas (FK)
)

DETAIL_PEMINJAMAN (
    nomor_peminjaman (PK, FK),
    id_eksemplar (PK, FK),
    tanggal_jatuh_tempo,
    tanggal_pengembalian,
    denda
)
```

Keterangan:
- PK = Primary Key, yaitu kunci primer.
- FK = Foreign Key, yaitu kunci tamu yang merujuk ke relasi lain.
- Relasi ANGGOTA, PETUGAS, dan BUKU menyimpan data induk masing-masing.
- Relasi EKSEMPLAR menghubungkan setiap buku fisik dengan judul buku melalui id_buku.
- Relasi PEMINJAMAN menyimpan informasi utama transaksi serta ID anggota dan petugas yang terkait.
- Relasi DETAIL_PEMINJAMAN menyimpan informasi setiap eksemplar dalam transaksi. Pasangan nomor_peminjaman dan id_eksemplar menjadi PK komposit.
- hari_terlambat tidak disimpan sebagai atribut karena nilainya dihitung dari tanggal jatuh tempo dan tanggal pengembalian, atau tanggal pemeriksaan jika buku belum dikembalikan. Denda tetap disimpan sesuai aturan AB-09.


**Catatan:** Pemisahan ini menghilangkan tiga rantai ketergantungan transitif yang ditemukan pada relasi 2NF dan menempatkan atribut pada relasi sesuai kepemilikannya dalam kamus data P02.

## 7. Pemeriksaan BCNF

| Relasi | FD yang berlaku | Penentu (sisi kiri FD) | Kunci kandidat? | Hasil |
|---|---|---|---|---|
| ANGGOTA | FD2: `id_anggota -> nama_anggota` | `id_anggota` | Ya | Memenuhi BCNF |
| PETUGAS | FD3: `id_petugas -> nama_petugas` | `id_petugas` | Ya | Memenuhi BCNF |
| BUKU | FD4b: `id_buku -> judul_buku` | `id_buku` | Ya | Memenuhi BCNF |
| EKSEMPLAR | FD4a: `id_eksemplar -> id_buku` | `id_eksemplar` | Ya | Memenuhi BCNF |
| PEMINJAMAN | FD1: `nomor_peminjaman -> tanggal_peminjaman, id_anggota, id_petugas` | `nomor_peminjaman` | Ya | Memenuhi BCNF |
| DETAIL_PEMINJAMAN | FD5, FD6, FD8: `(nomor_peminjaman, id_eksemplar) -> tanggal_jatuh_tempo, tanggal_pengembalian, denda` | `(nomor_peminjaman, id_eksemplar)` | Ya | Memenuhi BCNF |

Kesimpulan: Keenam relasi memenuhi BCNF karena setiap penentu dalam dependensi fungsional nontrivial yang berlaku pada relasinya merupakan kunci kandidat.

## 8. Keputusan Nilai Turunan

**Keputusan `hari_terlambat`:** Nilai `hari_terlambat` tidak disimpan sebagai atribut tetap, tetapi dihitung berdasarkan selisih tanggal jatuh tempo dan tanggal pengembalian. Jika buku belum dikembalikan dan sudah melewati tanggal jatuh tempo, jumlah hari keterlambatan dihitung sampai tanggal pemeriksaan. Keputusan ini sesuai dengan AB-08 dan P02 Bagian 3.2 karena jumlah hari keterlambatan dapat diperoleh dari tanggal yang sudah tersimpan.

**Keputusan `denda`:** Nilai `denda` dihitung saat eksemplar dikembalikan berdasarkan jumlah hari keterlambatan dan tarif yang berlaku, kemudian disimpan pada detail peminjaman. Sesuai AB-09 dan P02 Bagian 3.2, penyimpanan ini diperlukan agar catatan denda transaksi lama tidak berubah ketika tarif denda di masa depan mengalami perubahan.

**Perbedaan dengan `total_penjualan` pada kasus Kopma:** Nilai `denda` disimpan karena harus mempertahankan nilai historis berdasarkan tarif saat pengembalian, sedangkan `total_penjualan` pada kasus Kopma dapat dihitung dari data transaksi penjualan sehingga tidak perlu disimpan sebagai nilai turunan yang berpotensi tidak konsisten.

Pada kasus Kopma, harga historis sudah tersimpan pada detail penjualan melalui atribut `harga_satuan_detail_penjualan` sesuai AB-04, sehingga `total_penjualan` dapat dihitung kembali berdasarkan harga dan jumlah barang pada transaksi. Sebaliknya, pada Perpustakaan Cendekia RH, tarif denda historis tidak disimpan pada kolom tersendiri, sehingga nilai `denda` harus disimpan agar catatan denda lama tetap sesuai dengan tarif yang berlaku saat pengembalian.

**Nilai turunan lain berdasarkan KI-05 dan KI-06:**

- **Total denda pada KI-05:** Tidak disimpan sebagai atribut tersendiri karena dapat dihitung dengan menjumlahkan nilai `denda` dari detail peminjaman dalam periode laporan bulanan.
- **Jumlah transaksi peminjaman pada KI-06:** Tidak disimpan sebagai atribut tersendiri karena dapat dihitung dengan menghitung jumlah nomor peminjaman yang berbeda dalam periode laporan.
- **Jumlah eksemplar yang dipinjam pada KI-06:** Tidak disimpan sebagai atribut tersendiri karena dapat dihitung dari jumlah detail peminjaman yang sesuai dengan periode laporan.

## 9. Ringkasan Tahapan Normalisasi

| Tahap | Relasi hasil | Masalah yang dihilangkan | FD yang dipakai |
|---|---|---|---|
| UNF | `SLIP_UNF` | Grup berulang pada daftar eksemplar dalam satu slip peminjaman masih ada. | Belum diterapkan |
| 1NF | `SLIP_1NF` | Grup berulang dihilangkan dengan membuat satu baris untuk setiap eksemplar yang dipinjam. Setiap atribut berisi satu nilai. | FD1–FD8 |
| 2NF | `PEMINJAMAN`, `EKSEMPLAR`, `DETAIL_PEMINJAMAN` | Ketergantungan parsial pada sebagian kunci primer komposit dihilangkan dengan memisahkan atribut transaksi, eksemplar, dan detail peminjaman. | FD1, FD4a, FD4b, FD5, FD6, FD8 |
| 3NF | `ANGGOTA`, `PETUGAS`, `BUKU`, `EKSEMPLAR`, `PEMINJAMAN`, `DETAIL_PEMINJAMAN` | Ketergantungan transitif dihilangkan dengan memisahkan nama anggota, nama petugas, dan judul buku ke relasi masing-masing. | FD2, FD3, FD4a, FD4b, FD1, FD5, FD6, dan FD8. |
| Hasil akhir | Enam relasi: `ANGGOTA`, `PETUGAS`, `BUKU`, `EKSEMPLAR`, `PEMINJAMAN`, `DETAIL_PEMINJAMAN` | Seluruh relasi diperiksa terhadap BCNF. `hari_terlambat`, total denda, jumlah transaksi, dan jumlah eksemplar dihitung saat dibutuhkan, sedangkan `denda` disimpan untuk mempertahankan nilai historis sesuai AB-09. | FD1, FD2, FD3, FD4a, FD4b, FD5, FD6, dan FD8. FD7 tidak digunakan dalam tabel akhir karena `hari_terlambat` merupakan nilai turunan yang dihitung, bukan atribut yang disimpan. |

## 10. Sinkronisasi dengan ERD

**1. Entitas Kategori Buku dan Penerbit**

Entitas `kategori_buku` dan `penerbit` tetap dipertahankan dalam ERD karena berasal dari identifikasi entitas kandidat pada P02 Bagian 4 dan didukung oleh AB-10. Meskipun tidak muncul langsung pada slip peminjaman, kedua entitas diperlukan untuk menyimpan informasi kategori dan penerbit yang berhubungan dengan data buku.

**2. Pemeriksaan atribut nilai turunan**

ERD tetap dipertahankan karena atribut `hari_terlambat`, total denda, jumlah transaksi, dan jumlah eksemplar tidak dicantumkan sebagai atribut tersimpan. Nilai-nilai tersebut dihitung ketika diperlukan sesuai keputusan pada Bagian 8. Sementara itu, atribut `denda` tetap disimpan pada `detail_peminjaman` sesuai AB-09 agar catatan denda historis tidak berubah ketika tarif diperbarui.

**3. Pemeriksaan kunci primer Detail Peminjaman**

ERD tetap menggunakan `id_detail` sebagai kunci primer pada entitas `detail_peminjaman`, sesuai rancangan ERD awal dan kamus data P02 Bagian 8 nomor 29. Walaupun hasil normalisasi menetapkan pasangan `(nomor_peminjaman, id_eksemplar)` sebagai kunci primer komposit, `id_detail` tetap dipertahankan sebagai identitas unik detail peminjaman dalam ERD. Perbedaan ini dicatat sebagai keputusan rancangan agar identitas detail tetap menggunakan atribut yang telah ditetapkan dalam dokumen kebutuhan data.

**Kesimpulan:** ERD tidak berubah. Entitas `kategori_buku` dan `penerbit` tetap dipertahankan karena merupakan bagian dari kebutuhan data P02, atribut nilai turunan tidak ditambahkan sebagai atribut tersimpan, dan `id_detail` tetap digunakan sebagai kunci primer sesuai rancangan ERD awal.