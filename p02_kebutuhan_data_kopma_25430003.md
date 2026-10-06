# Dokumen Kebutuhan Data - Koperasi Mahasiswa Sejahtera (Kopma)

## 1. Latar belakang dan aktivitas organisasi

Kopma merupakan koperasi mahasiswa yang menjual berbagai kebutuhan seperti alat tulis, makanan ringan, dan minuman di lingkungan kampus. Pembelinya dapat berasal dari anggota koperasi maupun masyarakat umum, sedangkan kegiatan operasionalnya dilakukan oleh kasir, petugas gudang, dan ketua koperasi.

## 2. Aktor dan proses bisnis

| Kode  | Proses bisnis | Aktor | Pemicu |
| ----  |---- | ---- | ---- |
| PB-01 | Mendaftarkan anggota | Kasir (atas permintaan mahasiswa) | Mahasiswa ingin menjadi anggota |
| PB-02 | Mencatat penjualan | Kasir | Pembeli membayar di kasir
| PB-03 | Memesan barang ke pemasok | Petugas gudang | Stok di bawah batas minimum |
| PB-04 | Menerima barang dari pemasok | Petugas gudang | Barang datang bersama faktur |
| PB-05 | Menyusun laporan bulanan | Ketua koperasi | Awal bulan |
| PB-06 | Mendaftarkan pemasok | Petugas gudang | Kopma bekerja sama dengan pemasok baru |
| PB-07 | Memperbarui status anggota | Ketua koperasi | Status keanggotaan anggota perlu diubah |

Pemasok tidak dimasukkan sebagai aktor karena dalam batasan proses bisnis yang dianalisis, pemasok berada di luar sistem Kopma. Pemasok hanya berperan sebagai pihak yang menerima pesanan dan mengirimkan barang beserta faktur, sedangkan proses yang dikelola oleh sistem Kopma berfokus pada kegiatan petugas gudang dalam membuat pesanan dan menerima barang.

## 3. Dokumen sumber yang dianalisis

nota penjualan Kopma (Gambar 2.5 pada buku).

Elemen yang disimpan

- Nomor nota
- Tanggal dan waktu transaksi
- Kode/nama petugas kasir
- Nomor anggota (jika pembeli anggota)
- Kode barang
- Jumlah barang (qty)
- Harga satuan saat transaksi
- Diskon
- Uang yang dibayarkan

Elemen yang dihitung (turunan)

- Subtotal, yaitu hasil perkalian jumlah barang dengan harga satuan.
- Total pembayaran, yaitu nilai akhir setelah subtotal dan diskon diperhitungkan.
- Kembalian, yaitu uang yang dibayarkan dikurangi total pembayaran.

## 4. Entitas kandidat dan elemen data

| Entitas kandidat | Elemen data utama | Sumber |
|---|---|---|
| Anggota | nomor anggota, NIM, nama, program studi, nomor HP, status aktif | Formulir pendaftaran |
| Barang | kode, nama, kategori, harga jual, stok, batas minimum stok | Daftar barang, faktur |
| Penjualan | nomor nota, tanggal-jam, kasir, anggota (opsional), bayar | Nota penjualan |
| Detail penjualan | nomor nota, barang, qty, harga saat transaksi | Nota penjualan |
| Petugas | kode petugas, nama, peran (kasir/gudang/ketua) | Wawancara |
| Pemasok | kode, nama, telepon, alamat | Faktur pemasok |
| Pembelian dan detailnya | nomor faktur, tanggal, pemasok, barang, qty, harga beli | Faktur pemasok |

Penjualan dan Detail Penjualan dipisahkan karena Penjualan menyimpan informasi umum satu transaksi, sedangkan Detail Penjualan menyimpan setiap barang yang dibeli dalam transaksi tersebut. Jika satu nota membeli tiga barang berbeda, maka cukup ada satu data Penjualan dengan tiga data pada Detail Penjualan.

## 5. Aturan bisnis

| Kode | Aturan bisnis | Asal aturan |
|---|---|---|
| AB-01 | Setiap nota memiliki nomor unik dan minimal satu baris barang. | Paragraf 2: "Tiga kasir bekerja bergantian per sif. Kasir mencatat penjualan dan mencetak nota." |
| AB-02 | Penjualan boleh tanpa anggota (pembeli umum); jika ada, anggota harus berstatus aktif untuk memperoleh diskon 5%. | Paragraf 1: "Pembeli dapat berupa anggota atau umum" dan "Anggota aktif memperoleh diskon 5% untuk setiap nota." |
| AB-03 | Stok barang tidak boleh negatif; penjualan ditolak bila qty melebihi stok tersedia. | Kutipan petugas gudang: "Kadang di buku catatan stoknya malah minus." |
| AB-04 | Harga jual yang dipakai pada nota disimpan per baris dan tidak berubah meski harga barang kemudian naik. | Kutipan ketua: "Harga barang sering naik, jadi kami bingung saat melihat nota lama." |
| AB-05 | NIM anggota unik; pencarian anggota dapat dilakukan lewat nomor anggota atau NIM. | Kutipan kasir: "Anggota sering lupa membawa kartu, jadi kami mencarinya lewat NIM." |
| AB-06 | Pesanan pembelian dibuat bila stok kurang dari batas minimum barang tersebut. | Paragraf 2: "Bila stok suatu barang di bawah batas minimum, ia membuat pesanan pembelian ke pemasok." |

## 6. Kebutuhan informasi

Berdasarkan narasi, ketua menerima empat jenis laporan setiap awal bulan: omzet, barang terlaris, stok menipis, dan anggota paling aktif. Modul kemudian merumuskan kebutuhan tersebut menjadi kebutuhan yang spesifik, terukur, dan dapat diuji seperti pada Tabel 2.5.

| Kode | Kebutuhan informasi | Data yang diperlukan |
|---|---|---|
| KI-01 | Menampilkan omzet, yaitu total nilai penjualan dalam rupiah, untuk setiap hari dan setiap bulan. Omzet dihitung dari data Detail Penjualan, bukan disimpan sebagai data tersendiri. | Penjualan, Detail penjualan |
| KI-02 | Menampilkan 5 barang yang paling banyak terjual setiap bulan, diurutkan berdasarkan jumlah barang yang terjual. | Detail penjualan, Barang |
| KI-03 | Menampilkan daftar barang yang stoknya berada di bawah batas minimum yang telah ditentukan. | Barang |
| KI-04 | Menampilkan 10 anggota dengan total nilai belanja (rupiah) terbesar setiap bulan, diurutkan dari total nilai belanja terbesar ke terkecil. | Penjualan, Detail penjualan, Anggota |

## 7. Matriks CRUD

| Proses | Anggota | Barang | Penjualan | Detail | Pemasok | Pembelian |
|--------|---------|--------|-----------|--------|---------|-----------|
| PB-01 Mendaftarkan anggota | C | | | | | |
| PB-02 Mencatat penjualan | R | R, U | C | C | | |
| PB-03 Memesan barang ke pemasok | | R | | | R | C |
| PB-04 Menerima barang dari pemasok | | U | | | R | R, U |
| PB-05 Menyusun laporan bulanan | R | R | R | R | | |
| PB-06 Mendaftarkan pemasok | | | | | C | |
| PB-07 Memperbarui status anggota | U | | | | | |

**Titik Analisis 3:**  
Kolom Pemasok sebelumnya hanya memiliki `R`, sehingga perlu ada proses Mendaftarkan pemasok agar data pemasok dapat dibuat terlebih dahulu. Pada kolom Anggota sudah terdapat `C` dan `R`, tetapi belum ada `U` karena status aktif anggota dapat berubah dan perlu diperbarui. Proses Memperbarui status anggota ditambahkan untuk mencatat perubahan status tersebut.

## 8. Kamus data awal

| Elemen | Arti | Contoh | Aturan | Penanggung jawab |
|---|---|---|---|---|
| no_anggota | Nomor anggota koperasi | A-0457 | Unik, format A-4 digit | Ketua |
| nim_anggota | NIM anggota | 2301010123 | Unik, 10 digit | Ketua |
| no_hp_anggota | Nomor HP anggota | 0812xxxx | Data pribadi, akses terbatas | Ketua |
| no_nota_penjualan | Nomor nota penjualan | PJ-2609-0142 | Unik per nota | Kasir |
| harga_satuan_detail_penjualan | Harga jual saat transaksi | 4000 | Bilangan bulat ≥ 0 (rupiah) | Kasir |
| stok_barang | Jumlah barang tersedia | 35 | Bilangan bulat ≥ 0 (AB-03) | Petugas gudang |
| kode_barang | Kode unik untuk setiap barang | ATK-001 | Harus unik | Petugas gudang |
| nama_barang | Nama barang yang dijual | Pulpen Hitam | Tidak boleh kosong | Petugas gudang |
| harga_jual_barang | Harga jual barang yang berlaku saat ini | 4500 | Nilai dalam rupiah, tidak boleh negatif, dan harga pada nota mengikuti AB-04 | Petugas gudang |
| status_anggota | Status keaktifan anggota | aktif | Hanya boleh bernilai aktif atau nonaktif; hanya anggota aktif yang mendapat diskon 5% (AB-02) | Ketua |
| nama_pemasok | Nama pihak yang memasok barang ke Kopma | PT Sumber Jaya | Tidak boleh kosong | Petugas gudang |

## 9. Kebutuhan non-fungsional data

- **Volume:** Diperkirakan sekitar 150 nota per hari. Angka ini penting untuk memperkirakan jumlah data transaksi yang akan dikelola oleh basis data dan memastikan rancangan mampu menangani pertambahan data tersebut.

- **Retensi:** Data transaksi disimpan minimal selama 5 tahun. Ketentuan ini penting agar riwayat transaksi tetap tersedia ketika dibutuhkan untuk melihat atau memeriksa transaksi sebelumnya.

- **Privasi:** Elemen yang termasuk data pribadi adalah no_hp_anggota dan nim_anggota. Nomor HP hanya boleh dilihat oleh ketua, sedangkan NIM perlu dapat dilihat oleh kasir karena digunakan untuk mencari data anggota, sehingga pembatasannya tetap diterapkan sesuai kebutuhan akses masing-masing.

## 10. Isu kualitas data yang diantisipasi

- **Privasi:** Elemen yang termasuk data pribadi adalah **no_hp_anggota** dan **nim_anggota**. Nomor HP hanya boleh dilihat oleh **ketua**, sedangkan NIM perlu dapat dilihat oleh **kasir** karena digunakan untuk mencari data anggota. Dengan demikian, akses NIM tetap diberikan kepada kasir sesuai kebutuhan pekerjaannya, sedangkan data pribadi lainnya dibatasi.

- **Isu 1:** Harga barang sering naik sehingga ketua kesulitan mengetahui harga pada nota lama → dicegah oleh **AB-04**.
- **Isu 2:** Catatan stok barang terkadang menjadi minus → dicegah oleh **AB-03**.
- **Isu 3:** Anggota sering lupa membawa kartu sehingga kasir kesulitan mencari data anggota → dicegah oleh **AB-05**.