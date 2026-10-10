# Dokumen Kebutuhan Data - Perpustakaan Cendekia RH

## 1. Latar Belakang dan Aktivitas Organisasi

Perpustakaan Cendekia RH merupakan perpustakaan sekolah yang menyediakan layanan membaca dan peminjaman buku bagi siswa dan guru. Koleksi perpustakaan meliputi buku pelajaran, buku referensi, karya sastra, dan buku bacaan umum yang mendukung kegiatan belajar mengajar.

Dalam kegiatan sehari-hari, petugas perpustakaan bertanggung jawab mengelola data anggota, mencatat koleksi buku, melayani peminjaman dan pengembalian, serta mencatat denda apabila terjadi keterlambatan sesuai ketentuan perpustakaan. Kepala perpustakaan memerlukan informasi mengenai ketersediaan buku, aktivitas peminjaman, keterlambatan pengembalian, dan jumlah denda.

Saat ini, pencatatan data perpustakaan dilakukan menggunakan buku tulis sehingga pencarian data dan pemeriksaan riwayat transaksi membutuhkan waktu lebih lama.

Setiap judul buku dapat memiliki beberapa eksemplar fisik, sehingga data judul buku dan setiap eksemplarnya perlu dicatat secara terpisah agar ketersediaan buku dapat diketahui dengan tepat.

Pengelolaan data yang terstruktur diperlukan agar informasi anggota dan buku tidak tercatat berulang, status ketersediaan buku tetap akurat, dan riwayat transaksi dapat ditelusuri. Oleh karena itu, basis data dirancang untuk membantu petugas mengelola administrasi perpustakaan dan membantu kepala perpustakaan memantau kegiatan operasional secara berkala.

## 2. Aktor dan proses bisnis

### 2.1 Aktor

- **Anggota**: siswa atau guru yang terdaftar di perpustakaan dan menggunakan layanan peminjaman buku.
- **Petugas perpustakaan**: bertanggung jawab mengelola data buku, data anggota, transaksi peminjaman, pengembalian, dan denda.
- **Kepala perpustakaan**: memantau kegiatan operasional perpustakaan melalui laporan.

Siswa dan guru dikelompokkan sebagai anggota karena keduanya menggunakan layanan peminjaman buku. Anggota berperan dalam mengajukan peminjaman dan menyerahkan buku saat pengembalian, sedangkan petugas perpustakaan mencatat dan mengelola transaksi tersebut.

### 2.2 Proses Bisnis

| Kode | Proses Bisnis | Aktor | Pemicu |
|---|---|---|---|
| PB-01 | Pencatatan judul buku dan eksemplar | Petugas perpustakaan | Buku baru diterima untuk ditambahkan ke koleksi. |
| PB-02 | Pendaftaran anggota | Petugas perpustakaan | Siswa atau guru ingin menjadi anggota perpustakaan. |
| PB-03 | Peminjaman buku | Anggota dan petugas perpustakaan | Anggota mengajukan peminjaman buku. |
| PB-04 | Pengembalian buku | Anggota dan petugas perpustakaan | Anggota menyerahkan buku yang dipinjam. |
| PB-05 | Pengelolaan denda | Petugas perpustakaan | Buku dikembalikan melewati batas waktu yang ditentukan. |
| PB-06 | Pembuatan laporan perpustakaan | Petugas perpustakaan dan kepala perpustakaan | Kepala perpustakaan meminta laporan kegiatan operasional perpustakaan. |
| PB-07 | Pembaruan status anggota | Petugas perpustakaan | Petugas perlu mengaktifkan atau menonaktifkan status keanggotaan. |
| PB-08 | Pengelolaan data petugas | Petugas perpustakaan | Ada petugas baru atau perlu perubahan data petugas. |

## 3. Dokumen sumber yang dianalisis

### 3.1 Contoh Dokumen Sumber: Slip Peminjaman Buku

**PERPUSTAKAAN CENDEKIA RH**  
**SLIP PEMINJAMAN BUKU**

| Informasi | Keterangan |
|---|---|
| Nomor Peminjaman | PJ-001 |
| Tanggal Peminjaman | 10 Oktober 2026 |
| ID Anggota | AG-001 |
| Nama Anggota | Andi Saputra |
| ID Petugas | PT-001 |
| Nama Petugas | Siti Rahma |

**Daftar Buku yang Dipinjam**

| No. | ID Eksemplar | Judul Buku | Tanggal Jatuh Tempo | Tanggal Pengembalian | Hari Terlambat | Denda |
|---|---|---|---|---|---|---|
| 1 | EK-001 | Dasar-Dasar Basis Data | 17 Oktober 2026 | 17 Oktober 2026 | 0 | Rp0 |
| 2 | EK-005 | Pemrograman untuk Pemula | 17 Oktober 2026 | 19 Oktober 2026 | 2 | Rp8.000 |

**Catatan:** Tanggal pengembalian, jumlah hari keterlambatan, dan denda diisi saat setiap eksemplar dikembalikan. Contoh ini menggunakan data fiktif.

### 3.2 Tabel Pembedahan Dokumen

| Isian | Level (Slip / Detail) | Disimpan / Dihitung | Alasan Singkat |
|---|---|---|---|
| Nomor peminjaman | Slip | Disimpan | Menjadi identitas unik transaksi peminjaman. |
| Tanggal peminjaman | Slip | Disimpan | Mencatat tanggal transaksi dimulai. |
| ID anggota | Slip | Disimpan | Menghubungkan transaksi dengan data anggota. |
| Nama anggota | Slip | Disimpan pada data anggota | Nama ditampilkan berdasarkan ID anggota agar tidak dicatat berulang. |
| ID petugas | Slip | Disimpan | Mengidentifikasi petugas yang melayani transaksi. |
| Nama petugas | Slip | Disimpan pada data petugas | Nama ditampilkan berdasarkan ID petugas agar tidak dicatat berulang. |
| ID eksemplar | Detail | Disimpan | Mengidentifikasi setiap buku fisik yang dipinjam. |
| Judul buku | Detail | Disimpan pada data buku | Judul ditampilkan melalui hubungan data eksemplar dengan data buku. |
| Tanggal jatuh tempo | Detail | Disimpan | Menjaga catatan batas pengembalian sesuai aturan saat peminjaman, meskipun aturan berubah kemudian. |
| Tanggal pengembalian | Detail | Disimpan | Mencatat tanggal pengembalian setiap eksemplar karena buku dapat dikembalikan pada hari berbeda. |
| Jumlah hari keterlambatan | Detail | Dihitung | Dihitung dari selisih tanggal pengembalian dengan tanggal jatuh tempo, dengan nilai minimum nol. |
| Denda | Detail | Dihitung lalu disimpan | Dihitung saat pengembalian berdasarkan keterlambatan dan tarif yang berlaku, kemudian disimpan agar perubahan tarif tidak mengubah catatan denda lama. |

## 4. Entitas kandidat dan elemen data

| Entitas | Elemen Data (Atribut) | Alasan Singkat |
|---|---|---|
| Anggota | ID anggota, nama anggota, jenis kelamin, alamat, nomor telepon, tanggal pendaftaran, status anggota | Menyimpan identitas dan status siswa atau guru yang menggunakan layanan perpustakaan. |
| Petugas | ID petugas, nama petugas, nomor telepon, username, status petugas | Menyimpan identitas petugas yang melayani transaksi perpustakaan. |
| Buku | ID buku, judul buku, ISBN, pengarang, tahun terbit, ID kategori, ID penerbit | Menyimpan informasi setiap judul buku serta menghubungkannya dengan kategori dan penerbit. |
| Eksemplar | ID eksemplar, ID buku, kode inventaris, kondisi buku, status ketersediaan | Membedakan setiap buku fisik dan mencatat statusnya agar petugas dapat mengetahui apakah buku tersedia atau sedang dipinjam. |
| Peminjaman | Nomor peminjaman, tanggal peminjaman, ID anggota, ID petugas | Mencatat transaksi peminjaman dan pihak yang terlibat. |
| Detail Peminjaman | ID detail, nomor peminjaman, ID eksemplar, tanggal jatuh tempo, tanggal pengembalian, denda | Mencatat setiap eksemplar dalam transaksi, termasuk informasi pengembalian dan denda masing-masing buku. |
| Kategori Buku | ID kategori, nama kategori, deskripsi kategori | Mengelompokkan buku berdasarkan jenisnya agar pencarian dan penyusunan laporan lebih mudah. |
| Penerbit | ID penerbit, nama penerbit, alamat penerbit, nomor telepon | Menyimpan informasi penerbit agar dapat digunakan oleh banyak judul buku tanpa pengulangan. |

**Keputusan tentang entitas Denda:** Denda tidak dijadikan entitas tersendiri pada rancangan awal karena nilai denda dicatat pada tingkat Detail Peminjaman untuk setiap eksemplar. Nilai denda dihitung saat pengembalian, kemudian disimpan agar perubahan tarif di masa depan tidak mengubah catatan denda lama.

**Keputusan tentang status ketersediaan:** Status ketersediaan disimpan sebagai atribut pada entitas Eksemplar karena petugas perlu mengetahui ketersediaan setiap buku dengan cepat, dan statusnya harus diperbarui saat peminjaman maupun pengembalian agar tetap sesuai dengan riwayat transaksi.

## 5. Aturan bisnis

Aturan bisnis berikut menjadi dasar pengelolaan data dan operasional Perpustakaan Cendekia RH. Ketentuan lama peminjaman dan denda merupakan asumsi untuk rancangan perpustakaan fiktif.

| Kode | Aturan Bisnis | Asal Aturan |
|---|---|---|
| AB-01 | Setiap anggota harus memiliki ID anggota yang unik dan terdaftar sebelum dapat melakukan peminjaman. Contoh: anggota AG-001 terdaftar dengan satu ID yang tidak boleh digunakan anggota lain. | Bagian 2, proses PB-02 dan keputusan rancangan |
| AB-02 | Setiap judul buku memiliki ID buku yang unik, sedangkan setiap eksemplar fisik memiliki ID eksemplar dan kode inventaris yang unik. Contoh: EK-001 dan EK-005 merupakan dua eksemplar berbeda. | Bagian 3, contoh slip peminjaman |
| AB-03 | Setiap eksemplar harus terhubung dengan satu judul buku, dan satu judul buku dapat memiliki beberapa eksemplar. Contoh: satu judul buku dapat memiliki eksemplar EK-001 dan EK-002. | Bagian 1 dan Bagian 4 |
| AB-04 | Setiap transaksi peminjaman harus memiliki nomor peminjaman yang unik, tanggal peminjaman, ID anggota, dan ID petugas. Contoh: transaksi PJ-001 mencatat anggota AG-001 dan petugas PT-001. | Bagian 3, contoh slip peminjaman |
| AB-05 | Satu transaksi peminjaman dapat mencakup maksimal 6 eksemplar. Eksemplar hanya boleh dipinjam jika status ketersediaannya tersedia dan kondisinya baik. Contoh: transaksi boleh memuat maksimal 6 eksemplar; eksemplar berkondisi rusak tidak boleh dipinjam meskipun status ketersediaannya tersedia. | Parameter P di Bagian 9 dan keputusan rancangan |
| AB-06 | Lama peminjaman adalah 7 hari kalender sejak tanggal peminjaman. Tanggal jatuh tempo disimpan pada setiap detail peminjaman. Contoh: peminjaman pada 10 Oktober 2026 memiliki tanggal jatuh tempo 17 Oktober 2026. | Bagian 3, contoh slip dan keputusan rancangan |
| AB-07 | Status ketersediaan eksemplar menggunakan nilai tersedia atau dipinjam, sedangkan kondisi buku menggunakan nilai baik atau rusak. Saat EK-005 dipinjam, statusnya berubah dari tersedia menjadi dipinjam. Ketika EK-005 dikembalikan dalam kondisi baik pada 19 Oktober 2026, statusnya kembali menjadi tersedia. Jika dikembalikan dalam kondisi rusak, kondisi dicatat sebagai rusak dan eksemplar tidak boleh dipinjam sampai dinyatakan layak digunakan kembali. | Bagian 4, atribut kondisi buku dan status ketersediaan |
| AB-08 | Denda keterlambatan adalah Rp4.000 per eksemplar per hari kalender setelah tanggal jatuh tempo. Contoh: EK-005 jatuh tempo 17 Oktober dan dikembalikan 19 Oktober 2026, sehingga terlambat 2 hari dan dikenai denda Rp8.000. | Parameter P di Bagian 9 dan Bagian 3, contoh slip |
| AB-09 | Denda dihitung saat eksemplar dikembalikan, lalu nilai denda disimpan pada detail peminjaman agar perubahan tarif tidak mengubah catatan denda sebelumnya. Contoh: denda EK-005 tetap Rp8.000 meskipun tarif untuk transaksi berikutnya berubah. | Bagian 3, tabel pembedahan dokumen dan keputusan rancangan |
| AB-10 | Setiap buku harus terhubung dengan satu kategori dan satu penerbit yang tercatat pada entitas Kategori Buku dan Penerbit. Contoh: sebuah buku menggunakan ID kategori KAT-001 dan ID penerbit PEN-001. | Bagian 4, entitas Buku, Kategori Buku, dan Penerbit |
| AB-11 | Hanya anggota berstatus aktif yang boleh meminjam buku. Contoh: anggota AG-001 berstatus aktif dapat mengajukan peminjaman, sedangkan anggota berstatus nonaktif tidak dapat melakukan peminjaman sampai statusnya diaktifkan kembali oleh petugas perpustakaan. | Bagian 4, atribut status anggota dan keputusan rancangan |

**Catatan:** Lama peminjaman 7 hari, tarif denda Rp4.000 per hari, dan nilai status merupakan ketentuan rancangan fiktif yang digunakan untuk pengujian sistem.

## 6. Kebutuhan informasi

| Kode | Kebutuhan Informasi | Pengguna | Waktu Dibutuhkan | Data yang Diperlukan |
|---|---|---|---|---|
| KI-01 | Daftar anggota aktif dan nonaktif | Petugas perpustakaan | Saat melayani pendaftaran atau peminjaman | Anggota: ID anggota, nama anggota, status anggota |
| KI-02 | Daftar judul buku dan jumlah eksemplar yang tersedia | Petugas perpustakaan dan anggota | Saat mencari buku atau mengajukan peminjaman | Buku: ID buku, judul buku; Eksemplar: ID eksemplar, ID buku, status ketersediaan, kondisi buku |
| KI-03 | Daftar transaksi peminjaman yang masih berlangsung | Petugas perpustakaan | Setiap hari saat memantau buku yang belum dikembalikan | Peminjaman: nomor peminjaman, tanggal peminjaman, ID anggota; Detail Peminjaman: ID eksemplar, tanggal jatuh tempo, tanggal pengembalian |
| KI-04 | Daftar keterlambatan pengembalian buku | Petugas perpustakaan | Setiap hari saat memeriksa pengembalian | Peminjaman: nomor peminjaman; Detail Peminjaman: ID eksemplar, tanggal jatuh tempo, tanggal pengembalian |
| KI-05 | Rekapitulasi denda keterlambatan | Kepala perpustakaan | Pada akhir setiap bulan | Detail Peminjaman: ID eksemplar, tanggal pengembalian, denda |
| KI-06 | Laporan aktivitas peminjaman | Kepala perpustakaan | Pada akhir setiap bulan | Peminjaman: nomor peminjaman, tanggal peminjaman; Detail Peminjaman: ID eksemplar |
| KI-07 | Daftar eksemplar yang rusak | Petugas perpustakaan | Saat memeriksa koleksi dan sebelum melayani peminjaman | Eksemplar: ID eksemplar, ID buku, kondisi buku, status ketersediaan |

### 6.1 Cara Uji Kebutuhan Informasi

- **KI-01:** Masukkan anggota AG-001 dengan status aktif. Hasil pengujian harus menampilkan AG-001 sebagai anggota aktif. Jika statusnya diubah menjadi nonaktif, hasil harus menunjukkan status nonaktif.

- **KI-02:** Misalkan satu judul buku memiliki 3 eksemplar: EK-001 berstatus tersedia dan berkondisi baik, EK-002 berstatus dipinjam dan berkondisi baik, serta EK-003 berstatus tersedia tetapi berkondisi rusak. Hasil pengujian harus menunjukkan 1 eksemplar tersedia untuk dipinjam, yaitu EK-001, karena eksemplar harus berstatus tersedia dan berkondisi baik.

- **KI-03:** Pada 18 Oktober 2026, periksa transaksi PJ-001. EK-001 sudah dikembalikan pada 17 Oktober, sedangkan EK-005 baru dikembalikan pada 19 Oktober. Hasil pengujian harus menampilkan 1 eksemplar yang masih dipinjam, yaitu EK-005, dengan tanggal jatuh tempo 17 Oktober 2026.

- **KI-04:** Eksemplar yang belum dikembalikan tetapi sudah melewati tanggal jatuh tempo tetap dimasukkan dalam daftar keterlambatan, dengan jumlah hari keterlambatan dihitung sampai tanggal pemeriksaan.

- **KI-05:** Berdasarkan contoh slip PJ-001, denda EK-005 adalah Rp8.000. Jika hanya transaksi contoh ini yang masuk dalam periode laporan, total denda pada laporan adalah Rp8.000.

- **KI-06:** Laporan aktivitas peminjaman menghitung jumlah transaksi dan jumlah eksemplar yang dipinjam secara terpisah. Untuk periode 1–31 Oktober 2026, jika hanya ada transaksi PJ-001 yang memuat EK-001 dan EK-005, laporan harus menunjukkan 1 transaksi peminjaman dan 2 eksemplar dipinjam.

- **KI-07:** Jika EK-005 dicatat berkondisi rusak, eksemplar tersebut harus muncul dalam daftar buku rusak dan tidak boleh dipinjam sebelum dinyatakan layak digunakan kembali.

**Catatan:** Data EK-002 dan EK-003 pada pengujian KI-02 merupakan data tambahan fiktif untuk menguji aturan bisnis AB-05, bukan bagian dari slip PJ-001.

## 7. Matriks CRUD

Matriks CRUD digunakan untuk menunjukkan proses bisnis yang membuat, membaca, memperbarui, dan menghapus data pada setiap entitas. Huruf C berarti Create, R berarti Read, U berarti Update, dan D berarti Delete.

| Entitas | PB-01 | PB-02 | PB-03 | PB-04 | PB-05 | PB-06 | PB-07 | PB-08 |
|---|---|---|---|---|---|---|---|---|
| Anggota | - | C | R | R | R | R | U | - |
| Petugas | R | R | R | R | R | R | R | C, R, U |
| Buku | C, R, U | - | R | R | - | R | - | - |
| Eksemplar | C, R, U | - | R, U | R, U | R | R | - | - |
| Peminjaman | - | - | C, R | R, U | R | R | - | - |
| Detail Peminjaman | - | - | C, R | R, U | R, U | R | - | - |
| Kategori Buku | C, R, U | - | R | - | - | R | - | - |
| Penerbit | C, R, U | - | R | - | - | R | - | - |

Keterangan proses:
- **PB-01:** Pencatatan judul buku dan eksemplar.
- **PB-02:** Pendaftaran anggota.
- **PB-03:** Peminjaman buku.
- **PB-04:** Pengembalian buku.
- **PB-05:** Pengelolaan denda.
- **PB-06:** Pembuatan laporan perpustakaan.
- **PB-07:** Pembaruan status anggota.
- **PB-08:** Pengelolaan data petugas.

## 8. Kamus data awal

Kamus data awal menjelaskan arti setiap elemen data, contoh nilai, aturan pengisian, dan pihak yang bertanggung jawab atas data tersebut. Kamus ini disusun berdasarkan entitas kandidat pada Bagian 4.

| No. | Entitas | Elemen Data | Arti | Contoh Nilai | Aturan | Penanggung Jawab |
|---:|---|---|---|---|---|---|
| 1 | Anggota | id_anggota | Identitas unik anggota | AG-001 | Wajib diisi dan unik | Petugas perpustakaan |
| 2 | Anggota | nama_anggota | Nama lengkap anggota | Andi Saputra | Wajib diisi | Petugas perpustakaan |
| 3 | Anggota | jenis_kelamin | Jenis kelamin anggota | Laki-laki | Menggunakan pilihan yang ditetapkan | Petugas perpustakaan |
| 4 | Anggota | alamat | Alamat tempat tinggal anggota | Jl. Melati No. 10 | Data pribadi, akses terbatas | Petugas perpustakaan |
| 5 | Anggota | nomor_telepon | Nomor telepon anggota | 081234567890 | Data pribadi, akses terbatas | Petugas perpustakaan |
| 6 | Anggota | tanggal_pendaftaran | Tanggal anggota didaftarkan | 2026-10-10 | Format YYYY-MM-DD | Petugas perpustakaan |
| 7 | Anggota | status_anggota | Status keanggotaan | Aktif | Hanya aktif atau nonaktif | Petugas perpustakaan |
| 8 | Petugas | id_petugas | Identitas unik petugas | PT-001 | Wajib diisi dan unik | Kepala perpustakaan |
| 9 | Petugas | nama_petugas | Nama lengkap petugas | Siti Rahma | Wajib diisi | Kepala perpustakaan |
| 10 | Petugas | nomor_telepon | Nomor telepon petugas | 081298765432 | Data pribadi, akses terbatas | Kepala perpustakaan |
| 11 | Petugas | username | Nama pengguna untuk login | siti001 | Wajib diisi dan unik | Kepala perpustakaan |
| 12 | Petugas | status_petugas | Status petugas pada sistem | Aktif | Hanya aktif atau nonaktif | Kepala perpustakaan |
| 13 | Buku | id_buku | Identitas unik judul buku | BK-001 | Wajib diisi dan unik | Petugas perpustakaan |
| 14 | Buku | judul_buku | Judul buku | Dasar-Dasar Basis Data | Wajib diisi | Petugas perpustakaan |
| 15 | Buku | ISBN | Nomor identifikasi buku | 9786020000000 | Dicatat sesuai ISBN buku jika tersedia | Petugas perpustakaan |
| 16 | Buku | pengarang | Nama pengarang buku | Budi Santoso | Wajib diisi jika informasinya tersedia | Petugas perpustakaan |
| 17 | Buku | tahun_terbit | Tahun buku diterbitkan | 2024 | Berupa tahun yang valid | Petugas perpustakaan |
| 18 | Buku | id_kategori | Identitas kategori buku | KAT-001 | Harus merujuk kategori yang terdaftar | Petugas perpustakaan |
| 19 | Buku | id_penerbit | Identitas penerbit buku | PEN-001 | Harus merujuk penerbit yang terdaftar | Petugas perpustakaan |
| 20 | Eksemplar | id_eksemplar | Identitas unik buku fisik | EK-001 | Wajib diisi dan unik | Petugas perpustakaan |
| 21 | Eksemplar | id_buku | Identitas judul buku induk | BK-001 | Harus merujuk buku yang terdaftar | Petugas perpustakaan |
| 22 | Eksemplar | kode_inventaris | Kode inventaris buku fisik | INV-001 | Wajib diisi dan unik | Petugas perpustakaan |
| 23 | Eksemplar | kondisi_buku | Kondisi fisik eksemplar | Baik | Menggunakan nilai baik atau rusak | Petugas perpustakaan |
| 24 | Eksemplar | status_ketersediaan | Status peminjaman eksemplar | Tersedia | Menggunakan nilai tersedia atau dipinjam | Petugas perpustakaan |
| 25 | Peminjaman | nomor_peminjaman | Identitas unik transaksi | PJ-001 | Wajib diisi dan unik | Petugas perpustakaan |
| 26 | Peminjaman | tanggal_peminjaman | Tanggal transaksi peminjaman | 2026-10-10 | Format YYYY-MM-DD | Petugas perpustakaan |
| 27 | Peminjaman | id_anggota | Anggota yang meminjam | AG-001 | Harus merujuk anggota terdaftar | Petugas perpustakaan |
| 28 | Peminjaman | id_petugas | Petugas yang melayani | PT-001 | Harus merujuk petugas terdaftar | Petugas perpustakaan |
| 29 | Detail Peminjaman | id_detail | Identitas unik detail peminjaman | DT-001 | Wajib diisi dan unik | Petugas perpustakaan |
| 30 | Detail Peminjaman | nomor_peminjaman | Transaksi induk detail | PJ-001 | Harus merujuk transaksi peminjaman | Petugas perpustakaan |
| 31 | Detail Peminjaman | id_eksemplar | Eksemplar yang dipinjam | EK-005 | Harus merujuk eksemplar terdaftar | Petugas perpustakaan |
| 32 | Detail Peminjaman | tanggal_jatuh_tempo | Batas pengembalian eksemplar | 2026-10-17 | Disimpan sesuai aturan saat peminjaman | Petugas perpustakaan |
| 33 | Detail Peminjaman | tanggal_pengembalian | Tanggal eksemplar dikembalikan | 2026-10-19 | Kosong sampai eksemplar dikembalikan | Petugas perpustakaan |
| 34 | Detail Peminjaman | denda | Nilai denda untuk eksemplar | 8000 | Dihitung saat pengembalian lalu disimpan dalam rupiah | Petugas perpustakaan |
| 35 | Kategori Buku | id_kategori | Identitas unik kategori | KAT-001 | Wajib diisi dan unik | Petugas perpustakaan |
| 36 | Kategori Buku | nama_kategori | Nama kategori buku | Referensi | Wajib diisi | Petugas perpustakaan |
| 37 | Kategori Buku | deskripsi_kategori | Penjelasan kategori | Buku referensi pembelajaran | Boleh dikosongkan jika tidak tersedia | Petugas perpustakaan |
| 38 | Penerbit | id_penerbit | Identitas unik penerbit | PEN-001 | Wajib diisi dan unik | Petugas perpustakaan |
| 39 | Penerbit | nama_penerbit | Nama penerbit buku | Cendekia Press | Wajib diisi | Petugas perpustakaan |
| 40 | Penerbit | alamat_penerbit | Alamat penerbit | Jl. Pendidikan No. 5 | Boleh dikosongkan jika tidak tersedia | Petugas perpustakaan |
| 41 | Penerbit | nomor_telepon | Nomor telepon penerbit | 0725123456 | Boleh dikosongkan jika tidak tersedia | Petugas perpustakaan |

**Catatan:** Contoh nilai pada kamus data merupakan data fiktif. Penanggung jawab menunjukkan pihak yang bertanggung jawab menjaga kebenaran dan kelengkapan data. Elemen `tanggal_pengembalian` boleh kosong selama eksemplar masih dipinjam, sedangkan jumlah hari keterlambatan dihitung dari tanggal jatuh tempo dan tanggal pengembalian atau tanggal pemeriksaan untuk buku yang belum dikembalikan.

## 9. Kebutuhan non-fungsional data

### 9.1 Perhitungan Parameter P

Dua digit terakhir NIM adalah **03**.

Perhitungan parameter P berdasarkan ketentuan modul:

P = (2 digit terakhir NIM mod 9) + 1

P = (03 mod 9) + 1

P = 3 + 1 = **4**

Berdasarkan hasil perhitungan tersebut, parameter P digunakan untuk menentukan kebutuhan data Perpustakaan Cendekia RH sebagai berikut:

| Ketentuan | Perhitungan | Hasil |
|---|---|---|
| Maksimal buku per transaksi | P + 2 = 4 + 2 | 6 eksemplar |
| Denda keterlambatan per eksemplar per hari | P × Rp1.000 | Rp4.000 |
| Perkiraan volume transaksi harian | 40 + (5 × P) = 40 + (5 × 4) | 60 transaksi per hari |

### 9.2 Volume Data

Sistem dirancang untuk menangani perkiraan **60 transaksi peminjaman per hari**. Setiap transaksi dapat berisi maksimal 6 eksemplar buku. Data yang dikelola meliputi anggota, petugas, judul buku, eksemplar, peminjaman, detail peminjaman, kategori buku, dan penerbit.

Sistem perlu mendukung pencarian data anggota dan buku, pencatatan peminjaman serta pengembalian, penghitungan denda, dan pembuatan laporan tanpa membuat data ganda.

### 9.3 Penyimpanan dan Retensi Data

Data anggota, petugas, buku, eksemplar, peminjaman, pengembalian, dan denda perlu disimpan secara terstruktur agar dapat digunakan untuk kegiatan operasional dan penyusunan laporan.

Sebagai usulan awal, riwayat transaksi disimpan minimal selama **5 tahun** agar dapat digunakan untuk pemeriksaan dan evaluasi. Ketentuan retensi ini merupakan usulan rancangan dan perlu disesuaikan dengan kebijakan sekolah.

Data transaksi yang sudah selesai tidak langsung dihapus agar riwayat peminjaman dan pengembalian tetap dapat ditelusuri. Pencadangan data juga perlu dilakukan secara berkala untuk mengurangi risiko kehilangan data.

### 9.4 Keamanan dan Privasi Data

| Elemen data pribadi | Siapa boleh mengakses | Alasan |
|---|---|---|
| alamat anggota | Petugas perpustakaan dan kepala perpustakaan | Keperluan administrasi anggota |
| nomor_telepon anggota | Petugas perpustakaan dan kepala perpustakaan | Keperluan menghubungi anggota |
| nomor_telepon petugas | Kepala perpustakaan | Keperluan administrasi petugas |

### 9.5 Kualitas dan Konsistensi Data

Sistem perlu menjaga agar setiap anggota, petugas, judul buku, eksemplar, dan transaksi memiliki identitas yang unik. Data yang terhubung harus mengacu pada identitas yang valid agar tidak terjadi transaksi dengan anggota atau eksemplar yang tidak terdaftar.

Status ketersediaan eksemplar harus diperbarui ketika buku dipinjam atau dikembalikan. Nilai denda disimpan setelah dihitung agar riwayat denda transaksi sebelumnya tidak berubah apabila tarif denda diperbarui.

Catatan: aturan retensi 5 tahun, pencadangan berkala, dan pembatasan akses di atas merupakan usulan kebutuhan sistem untuk Perpustakaan Cendekia RH, bukan ketentuan resmi sekolah yang sudah dikonfirmasi.

## 10. Isu kualitas data yang diantisipasi

Beberapa masalah kualitas data yang mungkin terjadi pada sistem Perpustakaan Cendekia RH beserta cara pencegahannya adalah sebagai berikut.

| No. | Potensi Masalah | Dampak | Cara Pencegahan |
|---|---|---|---|
| 1 | Data anggota tercatat lebih dari satu kali. | Data anggota menjadi ganda dan menyulitkan pencarian. | Setiap anggota harus memiliki ID anggota yang unik. |
| 2 | Data judul buku tidak lengkap. | Petugas kesulitan mencari dan mengenali buku. | Judul buku dan data penting lainnya harus diisi sebelum disimpan. |
| 3 | Kode inventaris eksemplar sama. | Buku fisik sulit dibedakan dan dilacak. | Setiap eksemplar harus memiliki ID eksemplar dan kode inventaris yang unik. |
| 4 | Status ketersediaan buku tidak diperbarui. | Buku yang sedang dipinjam dapat dianggap tersedia. | Status eksemplar harus diperbarui setiap kali terjadi peminjaman dan pengembalian. |
| 5 | Transaksi menggunakan anggota yang tidak terdaftar atau tidak aktif. | Peminjaman tidak sesuai dengan aturan perpustakaan. | Sistem harus memeriksa keberadaan dan status anggota sebelum peminjaman. |
| 6 | Tanggal jatuh tempo atau tanggal pengembalian salah. | Perhitungan keterlambatan dan denda menjadi tidak akurat. | Petugas harus memeriksa tanggal dan sistem harus memvalidasi urutan tanggal. |
| 7 | Denda tidak sesuai dengan jumlah hari keterlambatan. | Total denda yang tercatat menjadi tidak akurat. | Denda dihitung berdasarkan jumlah hari keterlambatan dan tarif yang berlaku, kemudian nilainya disimpan. |
| 8 | Data buku tidak terhubung dengan kategori atau penerbit yang valid. | Informasi buku menjadi tidak konsisten dan laporan dapat keliru. | Sistem harus memastikan ID kategori dan ID penerbit mengacu pada data yang terdaftar. |
| 9 | Kondisi buku rusak tetapi tetap dapat dipinjam. | Buku yang tidak layak digunakan berisiko dipinjam kembali. | Petugas harus memperbarui kondisi buku dan memastikan eksemplar rusak tidak dapat dipinjam. |
| 10 | Riwayat transaksi dihapus atau diubah tanpa alasan yang jelas. | Riwayat peminjaman, pengembalian, dan denda sulit ditelusuri. | Perubahan data harus dibatasi sesuai kewenangan dan riwayat transaksi yang sudah selesai tetap disimpan. |

Dengan pencegahan tersebut, data perpustakaan diharapkan lebih akurat, lengkap, konsisten, dan mudah ditelusuri. Pemeriksaan data perlu dilakukan secara berkala agar kesalahan dapat diketahui dan diperbaiki sebelum memengaruhi transaksi maupun laporan perpustakaan.