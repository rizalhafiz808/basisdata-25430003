-- =====================================================================
-- p06_latihan_kopma_25430003.sql
-- Modul 6 Latihan E: pengarsipan anggota dan kenaikan harga
-- Nama: Rizal Hafiz | NIM: 25430003 | Kelas: A
-- Jalankan dari prompt MariaDB sebagai mhs_003, SETELAH p06_uji_kopma:
--   SOURCE D:/praktikum/basisdata-25430003/p06_latihan_kopma_25430003.sql
-- =====================================================================

USE kopma_003;
SET SESSION sql_safe_updates = 1;

-- ================= E.1 Arsip anggota nonaktif sebelum 2025 =================
DROP TABLE IF EXISTS anggota_arsip;
CREATE TABLE anggota_arsip LIKE anggota;

-- Calon arsip: nonaktif, daftar sebelum 2025, dan TIDAK punya penjualan.
-- Syarat NOT EXISTS wajib karena fk_penjualan_anggota memakai ON DELETE SET NULL:
-- tanpa syarat ini server TIDAK menolak, tetapi nota lama kehilangan anggotanya.
SELECT a.no_anggota, a.nama_anggota, a.status_anggota, a.tgl_daftar_anggota,
       (SELECT COUNT(*) FROM penjualan p WHERE p.id_anggota = a.id_anggota) AS jumlah_nota
FROM anggota a
WHERE a.status_anggota = 'nonaktif' AND a.tgl_daftar_anggota < '2025-01-01';

INSERT INTO anggota_arsip
SELECT a.* FROM anggota a
WHERE a.status_anggota = 'nonaktif'
  AND a.tgl_daftar_anggota < '2025-01-01'
  AND NOT EXISTS (SELECT 1 FROM penjualan p WHERE p.id_anggota = a.id_anggota);

-- Mode aman menolak WHERE berbentuk subquery, jadi diberi LIMIT sebagai batas aman
DELETE FROM anggota
WHERE id_anggota IN (SELECT id_anggota FROM anggota_arsip)
LIMIT 100;

SELECT 'anggota' AS tabel, COUNT(*) AS jumlah FROM anggota
UNION ALL SELECT 'anggota_arsip', COUNT(*) FROM anggota_arsip;
SELECT no_anggota, nama_anggota, status_anggota, tgl_daftar_anggota FROM anggota_arsip;

-- ================= E.2 Harga makanan naik 5%, dibulatkan ke ratusan =================
SELECT kode_barang, nama_barang, harga_jual_barang AS harga_lama
FROM barang WHERE kategori_barang = 'makanan';

UPDATE barang
SET harga_jual_barang = ROUND(harga_jual_barang * 1.05, -2)
WHERE kategori_barang = 'makanan' AND id_barang > 0;

SELECT kode_barang, nama_barang, harga_jual_barang AS harga_baru
FROM barang WHERE kategori_barang = 'makanan';
