# Normalisasi Kopma — Rizal Hafiz (25430003)

## 1. Bentuk UNF

```
NOTA_UNF (no_nota_penjualan, tgl_penjualan, kode_petugas, nama_petugas, no_anggota, nama_anggota,
          { kode_barang, nama_barang, qty_detail_penjualan, harga_satuan_detail_penjualan, subtotal_detail_penjualan },
          jumlah_penjualan, diskon_penjualan, total_penjualan)
```

Grup berulang: { kode_barang, ... subtotal_detail_penjualan } karena satu nota berisi banyak barang.

## 2. Bentuk 1NF

Satu baris untuk setiap barang di setiap nota. Kunci primer komposit: (no_nota_penjualan, kode_barang).

```
NOTA_1NF (no_nota_penjualan, kode_barang, tgl_penjualan, kode_petugas, nama_petugas, no_anggota,
          nama_anggota, nama_barang, qty_detail_penjualan, harga_satuan_detail_penjualan,
          subtotal_detail_penjualan, jumlah_penjualan, diskon_penjualan, total_penjualan)
```
## 3. Dependensi Fungsional

FD1: no_nota_penjualan -> tgl_penjualan, kode_petugas, no_anggota   (AB-01)
FD2: kode_petugas -> nama_petugas
FD3: no_anggota -> nama_anggota   (AB-05)
FD4: kode_barang -> nama_barang
FD5: (no_nota_penjualan, kode_barang) -> qty_detail_penjualan, harga_satuan_detail_penjualan   (AB-04)
FD6: qty_detail_penjualan, harga_satuan_detail_penjualan -> subtotal_detail_penjualan   (turunan)

### Titik analisis 1

1. Mengapa FD5 menempatkan harga_satuan_detail_penjualan pada kunci (no_nota_penjualan, kode_barang), bukan pada kode_barang     saja? 

karena harga barang pada saat transaksi dapat berbeda dari harga barang saat ini. Satu barang bisa dijual dengan harga berbeda pada nota yang berbeda, sehingga kode_barang saja tidak cukup untuk menentukan harga saat transaksi.

2.  Apa yang terjadi pada laporan omzet tahun lalu jika harga_satuan_detail_penjualan 
dipindah ke tabel barang?

Jika harga_satuan_detail_penjualan dipindahkan ke tabel barang, perubahan harga barang saat ini dapat menyebabkan harga transaksi lama tidak tercatat dengan benar. Akibatnya, laporan omzet tahun lalu bisa menjadi tidak akurat karena perhitungan menggunakan harga barang saat ini, bukan harga saat transaksi terjadi.

## 4. Menuju 2NF

Untuk memenuhi bentuk normal kedua (2NF), saya memeriksa apakah ada atribut yang hanya bergantung pada sebagian kunci gabungan `(no_nota_penjualan, kode_barang)`. Berdasarkan FD1 dan FD4, atribut pada FD1 bergantung pada `no_nota_penjualan`, sedangkan atribut pada FD4 bergantung pada `kode_barang`. Artinya, kedua dependensi tersebut hanya menggunakan sebagian dari kunci gabungan. Oleh karena itu, relasi perlu dipecah agar setiap atribut nonkunci bergantung pada seluruh kunci primer, bukan hanya sebagian kunci.

```
PENJUALAN (no_nota_penjualan, tgl_penjualan, kode_petugas, nama_petugas, no_anggota, nama_anggota,
           jumlah_penjualan, diskon_penjualan, total_penjualan)
BARANG (kode_barang, nama_barang)
DETAIL_PENJUALAN (no_nota_penjualan*, kode_barang*, qty_detail_penjualan,
                  harga_satuan_detail_penjualan, subtotal_detail_penjualan)
-- * = kunci tamu
```
## 5. Menuju 3NF

Pada tahap 3NF, saya memeriksa apakah terdapat ketergantungan transitif, yaitu ketika suatu atribut bergantung pada atribut nonkunci lain, bukan langsung pada kunci utama. Pada relasi penjualan, terdapat rantai `no_nota_penjualan → kode_petugas → nama_petugas` berdasarkan FD1 dan FD2, serta `no_nota_penjualan → no_anggota → nama_anggota` berdasarkan FD1 dan FD3. Artinya, nama petugas dapat ditentukan melalui kode petugas, sedangkan nama anggota dapat ditentukan melalui nomor anggota. Untuk menghindari ketergantungan transitif dan pengulangan data, informasi petugas dan anggota sebaiknya dipisahkan ke relasi masing-masing.

```
PENJUALAN (no_nota_penjualan, tgl_penjualan, kode_petugas*, no_anggota*,
           jumlah_penjualan, diskon_penjualan, total_penjualan)
PETUGAS (kode_petugas, nama_petugas)
ANGGOTA (no_anggota, nama_anggota)
-- * = kunci tamu
```

## 6. Keputusan Nilai Turunan

Atribut `subtotal_detail_penjualan` dapat dihitung dari `qty_detail_penjualan` dikalikan `harga_satuan_detail_penjualan`. Atribut `jumlah_penjualan` dapat dihitung dengan menjumlahkan seluruh subtotal barang dalam satu nota, sedangkan `diskon_penjualan` dapat ditentukan berdasarkan status keanggotaan dan aturan diskon yang berlaku. Atribut `total_penjualan` dihitung dari jumlah penjualan dikurangi diskon, sementara `bayar_penjualan` digunakan untuk mencatat jumlah uang yang dibayarkan pelanggan. Saya memutuskan bahwa nilai turunan seperti subtotal, jumlah penjualan, diskon, dan total penjualan dihitung dari data sumber saat dibutuhkan agar perubahan kuantitas, harga, atau status anggota tidak menyebabkan data menjadi tidak konsisten.

```
PENJUALAN (no_nota_penjualan, tgl_penjualan, kode_petugas*, no_anggota*, bayar_penjualan)
DETAIL_PENJUALAN (no_nota_penjualan*, kode_barang*, qty_detail_penjualan, harga_satuan_detail_penjualan)
BARANG (kode_barang, nama_barang, kategori_barang, harga_jual_barang, stok_barang, stok_min_barang)
PETUGAS (kode_petugas, nama_petugas, peran_petugas)
ANGGOTA (no_anggota, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, status_anggota, tgl_daftar_anggota)
-- * = kunci tamu
```

### Titik Analisis 2

Menurut saya, kedua keputusan tersebut tetap konsisten karena memiliki tujuan yang berbeda. Pada tabel operasional, total penjualan dihitung dari detail transaksi agar nilainya selalu sesuai dengan kuantitas dan harga saat transaksi berlangsung. Sementara itu, tabel arsip menyimpan total sebagai potret historis agar catatan transaksi masa lalu tetap sama dan tidak berubah ketika data barang diperbarui. Contohnya, jika harga pulpen tahun lalu Rp4.000 lalu naik menjadi Rp4.500, menghitung ulang total arsip menggunakan harga sekarang akan membuat total nota tahun lalu menjadi lebih besar dari transaksi aslinya, sehingga laporan omzet historis menjadi tidak akurat.

## 7. Pencocokan dengan Skema Kanonik

| Relasi | PK hasil normalisasi | PK kanonik | Kunci unik kanonik | Kunci tamu kanonik |
|---|---|---|---|---|
| PENJUALAN | no_nota_penjualan | id_penjualan | no_nota_penjualan | id_petugas, id_anggota (boleh NULL) |
| DETAIL_PENJUALAN | (no_nota_penjualan, kode_barang) | (id_penjualan, id_barang) | – | id_penjualan, id_barang |
| BARANG | kode_barang | id_barang | kode_barang | – |
| PETUGAS | kode_petugas | id_petugas | kode_petugas | – |
| ANGGOTA | no_anggota | id_anggota | no_anggota, nim_anggota | – |

Perbedaan utamanya adalah skema hasil normalisasi menggunakan kode alami sebagai kunci primer, sedangkan skema kanonik menggunakan kunci pengganti `id_*` sebagai kunci primer dan mempertahankan kode alami sebagai kunci unik.

## 8. Pemeriksaan BCNF

| Relasi | Penentu (sisi kiri FD) | Kunci kandidat? | Hasil |
|---|---|---|---|
| PENJUALAN | no_nota_penjualan | Ya | Memenuhi BCNF |
| DETAIL_PENJUALAN | (no_nota_penjualan, kode_barang) | Ya | Memenuhi BCNF |
| BARANG | kode_barang | Ya | Memenuhi BCNF |
| PETUGAS | kode_petugas | Ya | Memenuhi BCNF |
| ANGGOTA | no_anggota, nim_anggota | Ya, keduanya merupakan kunci kandidat alami | Memenuhi BCNF |

Catatan pemeriksaan:
- PENJUALAN: no_nota_penjualan menentukan data penjualan pada satu nota.
- DETAIL_PENJUALAN: Kombinasi no_nota_penjualan dan kode_barang menentukan jumlah serta harga satuan barang pada detail nota.
- BARANG: kode_barang menentukan data barang.
- PETUGAS: kode_petugas menentukan data petugas.
- ANGGOTA: no_anggota dan nim_anggota merupakan kunci unik alami. Keduanya perlu diperiksa, bukan hanya id_anggota sebagai kunci pengganti.

**Kesimpulan:** Berdasarkan FD1–FD5 dan kunci unik pada Tabel 4.2, kelima relasi memenuhi BCNF karena setiap penentu yang diperiksa merupakan kunci kandidat. Pada relasi ANGGOTA, pemeriksaan juga mencakup kunci alami `no_anggota` dan `nim_anggota`, bukan hanya kunci pengganti `id_anggota`.

### Titik Analisis 3

Informasi mengenai pemasok kini disimpan dalam tabel `pemasok` dan dihubungkan dengan transaksi pembelian melalui tabel `pembelian` serta `detail_pembelian`. Dengan cara ini, identitas pemasok disimpan secara terpusat sehingga perbedaan penulisan nama, seperti “CV Sumber ATK” dan “CV. Sumber A.T.K”, dapat dihindari. Selain itu, data pemasok tetap tersimpan meskipun salah satu nota pembelian dihapus, sehingga informasi pemasok tidak ikut hilang. Struktur ini juga memungkinkan satu pemasok memasok berbagai barang dan riwayat pembelian ditelusuri melalui tabel yang saling berhubungan.
