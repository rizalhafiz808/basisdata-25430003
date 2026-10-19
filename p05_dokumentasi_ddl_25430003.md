# Dokumentasi DDL Proyek — Perpustakaan Cendekia RH

**Nama:** Rizal Hafiz  **NIM:** 25430003  **Kelas:** A  **Basis data:** `perpus_003`

Sumber: `p02_kebutuhan_data_25430003.md` (AB-01 s.d. AB-11, kamus data), `p04_normalisasi_25430003.md` (skema 3NF), ERD P03.
Parameter P = (03 mod 9) + 1 = **4**, sehingga maks. **6** eksemplar per peminjaman dan denda **Rp4.000** per eksemplar per hari.

## 1. Penyesuaian dari ERD Konseptual ke Desain Fisik

| ERD konseptual / kamus data | Desain fisik | Alasan |
|---|---|---|
| Entitas `kategori_buku` | Tabel `kategori` | Agar PK tetap `id_kategori` (kamus no. 35) dan sesuai standar `id_<nama_tabel>` |
| PK berupa kode (AG-001, BK-001, EK-001, PT-001, KAT-001, PEN-001) | PK `id_*` INT AUTO_INCREMENT + kolom `kode_*` UNIQUE | Mengikuti skema kanonik buku (Modul 4 D.4): kunci pengganti sebagai PK, kode alami sebagai kunci unik |
| PK `nomor_peminjaman` | PK `id_peminjaman` + `no_peminjaman` UNIQUE | Sama seperti di atas. Nomor slip tetap unik (AB-04) |
| `id_detail` | `id_detail_peminjaman` | Standar `id_<nama_tabel>`. Kunci kandidat `(id_peminjaman, id_eksemplar)` dijaga UNIQUE (P04 bagian 10) |
| Atribut tanpa akhiran tabel (`alamat`, `nomor_telepon`, `ISBN`, `pengarang`, `kondisi_buku`, `status_ketersediaan`, `denda`, ...) | `alamat_anggota`, `telepon_anggota`, `isbn_buku`, `pengarang_buku`, `kondisi_eksemplar`, `status_eksemplar`, `denda_detail_peminjaman`, ... | Standar penamaan buku: setiap kolom diberi akhiran nama tabel |

## 2. Pemetaan Tipe Data

| Kolom | Tipe | Alasan |
|---|---|---|
| `id_*` (kecuali petugas, kategori) | INT AUTO_INCREMENT | Kunci pengganti. Volume 60 transaksi/hari, jadi data detail tumbuh cepat |
| `id_petugas`, `id_kategori` | SMALLINT AUTO_INCREMENT | Jumlah petugas dan kategori sedikit. FK yang merujuknya juga SMALLINT (tipe FK harus sama persis) |
| `kode_*` | VARCHAR(10) | Kode berformat `XX-001`/`KAT-001`, panjang bisa bertambah |
| `no_peminjaman` | VARCHAR(15) | Format nomor slip bisa berkembang (mis. `PJ-2610-0001`) |
| `kode_inventaris_eksemplar` | VARCHAR(15) | Kode inventaris buku fisik |
| `isbn_buku` | CHAR(13) NULL | ISBN-13 selalu 13 karakter. Boleh kosong jika tidak tersedia (kamus no. 15) |
| `tahun_terbit_buku` | YEAR NULL | Tipe YEAR otomatis menolak tahun tidak valid (kamus no. 17) |
| `nama_*`, `judul_buku`, `pengarang_buku` | VARCHAR(100–200) | Teks dengan panjang bervariasi |
| `telepon_*` | VARCHAR(15) | Nomor telepon bukan angka untuk dihitung, dan bisa diawali 0 |
| `tgl_peminjaman`, `tgl_daftar_anggota`, `tgl_jatuh_tempo_...`, `tgl_kembali_...` | DATE | Kamus data memakai format YYYY-MM-DD. Jam tidak dibutuhkan untuk menghitung keterlambatan |
| `denda_detail_peminjaman` | DECIMAL(12,2) NULL | Uang harus tepat (FLOAT menimbulkan galat pembulatan). NULL selama belum kembali |
| `status_anggota`, `status_petugas` | ENUM('aktif','nonaktif') | Nilainya terbatas (kamus no. 7, 12) |
| `jenis_kelamin_anggota` | ENUM('laki-laki','perempuan') | Pilihan yang ditetapkan (kamus no. 3) |
| `kondisi_eksemplar` | ENUM('baik','rusak') | AB-07 |
| `status_eksemplar` | ENUM('tersedia','dipinjam') | AB-07 |

## 3. Constraint dan Kaitannya dengan Aturan Bisnis

| Constraint | Jenis | Aturan |
|---|---|---|
| `uq_anggota_kode` | UNIQUE | AB-01 ID anggota unik |
| `uq_buku_kode`, `uq_eksemplar_kode`, `uq_eksemplar_inventaris` | UNIQUE | AB-02 ID buku, ID eksemplar, dan kode inventaris unik |
| `fk_eksemplar_buku` (id_buku NOT NULL) | FK | AB-03 setiap eksemplar terhubung ke satu judul buku |
| `uq_peminjaman_no`, `fk_peminjaman_anggota`, `fk_peminjaman_petugas` (NOT NULL) | UNIQUE, FK | AB-04 nomor peminjaman unik, wajib punya anggota dan petugas |
| `ck_eksemplar_rusak` | CHECK | AB-05/AB-07 eksemplar rusak tidak boleh berstatus dipinjam |
| `uq_detail_peminjaman_eksemplar` | UNIQUE komposit | Kunci kandidat P04: satu eksemplar hanya sekali per transaksi |
| `tgl_jatuh_tempo_detail_peminjaman` NOT NULL | NOT NULL | AB-06 jatuh tempo disimpan per eksemplar |
| `ck_detail_peminjaman_denda` | CHECK **berbasis P** | AB-08 denda = Rp4.000 × hari terlambat, jadi ≥ 0 dan kelipatan 4.000 |
| `ck_detail_peminjaman_denda_kembali` | CHECK | AB-09 denda baru diisi saat eksemplar dikembalikan |
| `fk_buku_kategori`, `fk_buku_penerbit` (NOT NULL) | FK | AB-10 buku terhubung ke kategori dan penerbit yang terdaftar |
| `status_anggota` ENUM + DEFAULT 'aktif' | ENUM, DEFAULT | AB-11 status hanya aktif/nonaktif |
| `fk_detail_peminjaman_peminjaman` ON DELETE CASCADE | FK | Detail tidak berarti tanpa slip induknya. Jika slip dibatalkan, rinciannya ikut terhapus |
| FK lain tanpa ON DELETE (RESTRICT) | FK | Riwayat transaksi disimpan 5 tahun (P02 9.3, isu kualitas no. 10), jadi anggota, petugas, buku, dan eksemplar yang punya riwayat tidak boleh dihapus |

## 4. Aturan yang Tidak Dapat Dijaga Constraint (ditandai untuk Modul 14)

| Aturan | Alasan CHECK tidak bisa | Rencana |
|---|---|---|
| AB-05 maks. **6 eksemplar** per peminjaman (P + 2) | Menyangkut **jumlah baris** di `detail_peminjaman`, sedangkan CHECK hanya memeriksa satu baris | Hitung baris detail di dalam transaksi, lalu ROLLBACK jika lebih dari 6 (Modul 14) |
| AB-05 eksemplar harus tersedia dan baik saat dipinjam | Datanya ada di tabel `eksemplar`, bukan di baris detail | Periksa di dalam transaksi peminjaman |
| AB-06 jatuh tempo = tgl_peminjaman + 7 hari | `tgl_peminjaman` ada di tabel lain | Isi otomatis di transaksi peminjaman |
| AB-07 status eksemplar berubah saat pinjam/kembali | Perlu UPDATE pada tabel lain | UPDATE dalam transaksi yang sama |
| AB-11 hanya anggota aktif yang boleh meminjam | Datanya ada di tabel `anggota` | Periksa di dalam transaksi peminjaman |

## 5. Hasil Uji Constraint (`p05_uji_constraint_25430003.sql`)

| Uji | Perintah | Kode galat | Aturan |
|---|---|---|---|
| U1 | Eksemplar dengan id_buku 99 | 1452 | AB-03 |
| U2 | Kode anggota AG-001 kembar | 1062 | AB-01 |
| U3 | EK-001 dua kali di PJ-001 | 1062 | Kunci kandidat P04 |
| U4 | Eksemplar rusak + dipinjam | 4025 | AB-05/AB-07 |
| U5 | Denda Rp5.000 | 4025 | AB-08 (P = 4) |
| U6 | Denda diisi sebelum kembali | 4025 | AB-09 |
| U7 | status_anggota = 'cuti' | 1265 | AB-11 |
| U8 | Hapus anggota yang punya riwayat | 1451 | Retensi riwayat |
| Positif | EK-005 terlambat 2 hari, denda Rp8.000 | Diterima | AB-08, contoh slip P02 |

## 6. Perbandingan phpMyAdmin Designer dengan ERD

*(Diamati pada Designer phpMyAdmin, 19 Oktober 2026, login sebagai dev_003.)*

| Aspek | ERD (konseptual/fisik) | Designer phpMyAdmin | Hasil |
|---|---|---|---|
| Jumlah tabel | 8 entitas | 8 tabel | Sama |
| Relasi | 7 relasi | 7 garis FK | Sama |
| Kardinalitas | Notasi Crow's Foot (1, 0..N, 1..N) | Hanya garis FK tanpa notasi kardinalitas | Berbeda tampilan |
| Kunci primer | `id_kategori`, `nomor_peminjaman`, `id_detail`, dst. | `id_*` surrogate + `kode_*`/`no_peminjaman` UNIQUE | Berbeda, sesuai bagian 1 |
| Nama entitas | `kategori_buku` | `kategori` | Berbeda, sesuai bagian 1 |
| Tipe data dan nilai ENUM | Dicantumkan di ERD fisik | Terlihat (mis. `int(11)`, `enum('baik','rusak')`, `decimal(12,2)`) | Sama |
| CHECK, DEFAULT, UNIQUE | Dicantumkan di ERD fisik | Tidak terlihat di Designer (hanya di Structure / SHOW CREATE TABLE) | Berbeda tampilan |
| Data pribadi | Ditandai 🔒 | Tidak ada penanda | Berbeda tampilan |
