-- =====================================================================
-- p05_ddl_25430003.sql
-- Milestone Proyek 5: DDL dan Constraint - Perpustakaan Cendekia RH
-- Nama: Rizal Hafiz | NIM: 25430003 | Kelas: A
-- Sumber rancangan: p02_kebutuhan_data_25430003.md (AB-01..AB-11),
--                   p04_normalisasi_25430003.md (skema 3NF), ERD P03
-- Parameter P = (03 mod 9) + 1 = 4
--   -> maks. 6 eksemplar per peminjaman (AB-05)
--   -> denda Rp4.000 per eksemplar per hari (AB-08)
-- Jalankan sebagai dev_003:  mysql -u dev_003 -p < p05_ddl_25430003.sql
-- Skrip dapat dijalankan ulang dari basis data kosong.
-- =====================================================================

USE perpus_003;

-- ---------------------------------------------------------------------
-- 1. Hapus tabel lama: urutan ANAK -> INDUK (kebalikan urutan pembuatan)
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS detail_peminjaman;
DROP TABLE IF EXISTS peminjaman;
DROP TABLE IF EXISTS eksemplar;
DROP TABLE IF EXISTS buku;
DROP TABLE IF EXISTS petugas;
DROP TABLE IF EXISTS anggota;
DROP TABLE IF EXISTS penerbit;
DROP TABLE IF EXISTS kategori;

-- ---------------------------------------------------------------------
-- 2. Tabel MASTER (tanpa kunci tamu)
-- ---------------------------------------------------------------------

-- Entitas "kategori_buku" di ERD. Nama tabel fisik: kategori, supaya PK
-- tetap id_kategori sesuai kamus data no. 35 dan standar id_<nama_tabel>.
CREATE TABLE kategori (
  id_kategori        SMALLINT     NOT NULL AUTO_INCREMENT,
  kode_kategori      VARCHAR(10)  NOT NULL,                 -- KAT-001
  nama_kategori      VARCHAR(50)  NOT NULL,
  deskripsi_kategori VARCHAR(255) NULL,                     -- boleh kosong (kamus no. 37)
  PRIMARY KEY (id_kategori),
  UNIQUE KEY uq_kategori_kode (kode_kategori),              -- AB-10
  UNIQUE KEY uq_kategori_nama (nama_kategori)               -- isu kualitas no. 8: kategori tidak ganda
) ENGINE=InnoDB;

CREATE TABLE penerbit (
  id_penerbit      INT          NOT NULL AUTO_INCREMENT,
  kode_penerbit    VARCHAR(10)  NOT NULL,                   -- PEN-001
  nama_penerbit    VARCHAR(100) NOT NULL,
  alamat_penerbit  VARCHAR(200) NULL,                       -- boleh kosong (kamus no. 40)
  telepon_penerbit VARCHAR(15)  NULL,                       -- boleh kosong (kamus no. 41)
  PRIMARY KEY (id_penerbit),
  UNIQUE KEY uq_penerbit_kode (kode_penerbit)               -- AB-10
) ENGINE=InnoDB;

CREATE TABLE anggota (
  id_anggota            INT                          NOT NULL AUTO_INCREMENT,
  kode_anggota          VARCHAR(10)                  NOT NULL,             -- AG-001
  nama_anggota          VARCHAR(100)                 NOT NULL,
  jenis_kelamin_anggota ENUM('laki-laki','perempuan') NOT NULL,
  alamat_anggota        VARCHAR(200)                 NULL,                 -- DATA PRIBADI (PDP)
  telepon_anggota       VARCHAR(15)                  NULL,                 -- DATA PRIBADI (PDP)
  tgl_daftar_anggota    DATE                         NOT NULL,
  status_anggota        ENUM('aktif','nonaktif')     NOT NULL DEFAULT 'aktif', -- AB-11
  PRIMARY KEY (id_anggota),
  UNIQUE KEY uq_anggota_kode (kode_anggota)                                 -- AB-01
) ENGINE=InnoDB;

CREATE TABLE petugas (
  id_petugas       SMALLINT                 NOT NULL AUTO_INCREMENT,
  kode_petugas     VARCHAR(10)              NOT NULL,                 -- PT-001
  nama_petugas     VARCHAR(100)             NOT NULL,
  telepon_petugas  VARCHAR(15)              NULL,                     -- DATA PRIBADI (PDP)
  username_petugas VARCHAR(30)              NOT NULL,
  status_petugas   ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif',
  PRIMARY KEY (id_petugas),
  UNIQUE KEY uq_petugas_kode (kode_petugas),                          -- AB-04 (petugas teridentifikasi unik)
  UNIQUE KEY uq_petugas_username (username_petugas)                   -- kamus data no. 11
) ENGINE=InnoDB;

CREATE TABLE buku (
  id_buku           INT          NOT NULL AUTO_INCREMENT,
  kode_buku         VARCHAR(10)  NOT NULL,                  -- BK-001
  judul_buku        VARCHAR(200) NOT NULL,
  isbn_buku         CHAR(13)     NULL,                      -- jika tersedia (kamus no. 15)
  pengarang_buku    VARCHAR(100) NULL,                      -- jika tersedia (kamus no. 16)
  tahun_terbit_buku YEAR         NULL,                      -- tipe YEAR menolak tahun tidak valid
  id_kategori       SMALLINT     NOT NULL,
  id_penerbit       INT          NOT NULL,
  PRIMARY KEY (id_buku),
  UNIQUE KEY uq_buku_kode (kode_buku),                      -- AB-02
  UNIQUE KEY uq_buku_isbn (isbn_buku),                      -- satu ISBN = satu judul (NULL boleh banyak)
  CONSTRAINT fk_buku_kategori FOREIGN KEY (id_kategori)
    REFERENCES kategori (id_kategori),                      -- AB-10
  CONSTRAINT fk_buku_penerbit FOREIGN KEY (id_penerbit)
    REFERENCES penerbit (id_penerbit)                       -- AB-10
) ENGINE=InnoDB;

CREATE TABLE eksemplar (
  id_eksemplar              INT                         NOT NULL AUTO_INCREMENT,
  kode_eksemplar            VARCHAR(10)                 NOT NULL,              -- EK-001
  id_buku                   INT                         NOT NULL,
  kode_inventaris_eksemplar VARCHAR(15)                 NOT NULL,              -- INV-001
  kondisi_eksemplar         ENUM('baik','rusak')        NOT NULL DEFAULT 'baik',     -- AB-07
  status_eksemplar          ENUM('tersedia','dipinjam') NOT NULL DEFAULT 'tersedia', -- AB-07
  PRIMARY KEY (id_eksemplar),
  UNIQUE KEY uq_eksemplar_kode (kode_eksemplar),                                -- AB-02
  UNIQUE KEY uq_eksemplar_inventaris (kode_inventaris_eksemplar),               -- AB-02
  CONSTRAINT fk_eksemplar_buku FOREIGN KEY (id_buku)
    REFERENCES buku (id_buku),                                                  -- AB-03
  -- AB-05 & AB-07: eksemplar rusak tidak boleh berstatus dipinjam
  CONSTRAINT ck_eksemplar_rusak
    CHECK (NOT (kondisi_eksemplar = 'rusak' AND status_eksemplar = 'dipinjam'))
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 3. Tabel TRANSAKSI (dengan kunci tamu)
-- ---------------------------------------------------------------------

CREATE TABLE peminjaman (
  id_peminjaman  INT         NOT NULL AUTO_INCREMENT,
  no_peminjaman  VARCHAR(15) NOT NULL,                      -- PJ-001 (nomor di slip)
  tgl_peminjaman DATE        NOT NULL,
  id_anggota     INT         NOT NULL,                      -- wajib: tidak ada peminjam umum
  id_petugas     SMALLINT    NOT NULL,
  PRIMARY KEY (id_peminjaman),
  UNIQUE KEY uq_peminjaman_no (no_peminjaman),              -- AB-04
  -- Tanpa ON DELETE: anggota/petugas yang punya riwayat tidak boleh dihapus
  -- (riwayat disimpan 5 tahun, p02 bagian 9.3 dan isu kualitas no. 10)
  CONSTRAINT fk_peminjaman_anggota FOREIGN KEY (id_anggota)
    REFERENCES anggota (id_anggota),                        -- AB-01, AB-04
  CONSTRAINT fk_peminjaman_petugas FOREIGN KEY (id_petugas)
    REFERENCES petugas (id_petugas)                         -- AB-04
) ENGINE=InnoDB;

CREATE TABLE detail_peminjaman (
  id_detail_peminjaman              INT           NOT NULL AUTO_INCREMENT, -- id_detail di ERD (kamus no. 29)
  id_peminjaman                     INT           NOT NULL,
  id_eksemplar                      INT           NOT NULL,
  tgl_jatuh_tempo_detail_peminjaman DATE          NOT NULL,                -- disimpan per eksemplar, AB-06
  tgl_kembali_detail_peminjaman     DATE          NULL,                    -- NULL = masih dipinjam
  denda_detail_peminjaman           DECIMAL(12,2) NULL,                    -- NULL sampai dikembalikan, AB-09
  PRIMARY KEY (id_detail_peminjaman),
  -- Kunci kandidat hasil normalisasi P04: satu eksemplar sekali per transaksi
  UNIQUE KEY uq_detail_peminjaman_eksemplar (id_peminjaman, id_eksemplar),
  CONSTRAINT fk_detail_peminjaman_peminjaman FOREIGN KEY (id_peminjaman)
    REFERENCES peminjaman (id_peminjaman) ON DELETE CASCADE,
  CONSTRAINT fk_detail_peminjaman_eksemplar FOREIGN KEY (id_eksemplar)
    REFERENCES eksemplar (id_eksemplar),                    -- AB-02, AB-03
  -- AB-08 (berbasis P = 4): denda = Rp4.000 x hari terlambat,
  -- jadi nilainya tidak negatif dan selalu kelipatan 4.000
  CONSTRAINT ck_detail_peminjaman_denda
    CHECK (denda_detail_peminjaman IS NULL
           OR (denda_detail_peminjaman >= 0 AND MOD(denda_detail_peminjaman, 4000) = 0)),
  -- AB-09: denda baru dihitung saat eksemplar dikembalikan
  CONSTRAINT ck_detail_peminjaman_denda_kembali
    CHECK (denda_detail_peminjaman IS NULL OR tgl_kembali_detail_peminjaman IS NOT NULL)
  -- AB-05 (maks. 6 eksemplar per peminjaman) menyangkut BANYAK BARIS,
  -- sehingga TIDAK BISA dijaga CHECK. Ditandai untuk Modul 14 (transaksi).
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 4. Aturan yang BELUM bisa dijaga oleh constraint (ditunda ke Modul 14)
--   AB-05  maks. 6 eksemplar per peminjaman      -> hitung baris detail
--   AB-05  eksemplar harus tersedia & baik saat dipinjam -> cek tabel lain
--   AB-06  jatuh tempo = tgl_peminjaman + 7 hari  -> beda tabel
--   AB-07  status eksemplar berubah saat pinjam/kembali -> UPDATE dalam transaksi
--   AB-11  hanya anggota aktif yang boleh meminjam -> cek tabel anggota
-- ---------------------------------------------------------------------

SHOW TABLES;
