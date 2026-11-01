-- =====================================================================
-- p06_uji_kopma_25430003.sql
-- Modul 6 langkah D.3-D.4: ubah/hapus aman dan skenario uji Kopma
-- Nama: Rizal Hafiz | NIM: 25430003 | Kelas: A
-- Jalankan dari prompt MariaDB sebagai mhs_003, SETELAH p06_data_kopma:
--   SOURCE D:/praktikum/basisdata-25430003/p06_uji_kopma_25430003.sql
-- =====================================================================

USE kopma_003;
SELECT CURRENT_USER(), NOW();

-- ================= D.3 Mengubah dan menghapus dengan aman =================
SET SESSION sql_safe_updates = 1;

-- Harus DITOLAK: ERROR 1175 (tanpa WHERE)
UPDATE barang SET harga_jual_barang = harga_jual_barang * 1.1;

-- Harus DITERIMA: WHERE memakai kolom kunci
UPDATE barang SET harga_jual_barang = harga_jual_barang * 1.1
WHERE kategori_barang = 'ATK' AND id_barang > 0;
SELECT kode_barang, harga_jual_barang FROM barang;

-- Titik Analisis 1: harga nota lama tidak ikut naik
SELECT d.id_penjualan, d.id_barang, d.harga_satuan_detail_penjualan
FROM detail_penjualan d
WHERE d.id_penjualan = (SELECT id_penjualan FROM penjualan WHERE no_nota_penjualan = 'PJ-2609-0142');

-- Hapus nota uji kedua -> detailnya ikut terhapus (ON DELETE CASCADE)
SELECT COUNT(*) AS detail_sebelum FROM detail_penjualan
WHERE id_penjualan = (SELECT id_penjualan FROM penjualan WHERE no_nota_penjualan = 'PJ-2609-0143');
DELETE FROM penjualan WHERE no_nota_penjualan = 'PJ-2609-0143';
SELECT COUNT(*) AS detail_sesudah FROM detail_penjualan
WHERE id_penjualan NOT IN (SELECT id_penjualan FROM penjualan);

-- Harus DITOLAK: ERROR 1451 (Rina pernah melayani PJ-2609-0142)
DELETE FROM petugas WHERE kode_petugas = 'K03';

-- ================= D.4 Skenario uji =================

-- UJ-01 (positif, AB-02): nota baru dengan anggota aktif -> DITERIMA
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES ('PJ-2609-0144', '2026-09-25 09:05:00',
        (SELECT id_petugas FROM petugas WHERE kode_petugas = 'K02'),
        (SELECT id_anggota FROM anggota WHERE no_anggota = 'A-0458'), 10000);
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT (SELECT id_penjualan FROM penjualan WHERE no_nota_penjualan = 'PJ-2609-0144'),
       id_barang, 2, harga_jual_barang FROM barang WHERE kode_barang = 'MNM-001';
UPDATE barang SET stok_barang = stok_barang - 2 WHERE kode_barang = 'MNM-001';

-- UJ-02 (positif, AB-02): nota pembeli umum -> DITERIMA, id_anggota NULL
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES ('PJ-2609-0145', '2026-09-25 09:20:00',
        (SELECT id_petugas FROM petugas WHERE kode_petugas = 'K01'), NULL, 5000);
SELECT no_nota_penjualan, id_anggota FROM penjualan WHERE no_nota_penjualan = 'PJ-2609-0145';

-- UJ-03 (negatif, AB-03): stok -5 -> ERROR 4025
UPDATE barang SET stok_barang = -5 WHERE kode_barang = 'MKN-001';

-- UJ-04 (negatif, AB-01): nomor nota kembar -> ERROR 1062
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES ('PJ-2609-0142', NOW(), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'K01'), NULL, 5000);

-- UJ-05 (negatif, ck_detail_qty): qty 0 -> ERROR 4025
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT (SELECT id_penjualan FROM penjualan WHERE no_nota_penjualan = 'PJ-2609-0145'),
       id_barang, 0, harga_jual_barang FROM barang WHERE kode_barang = 'MKN-001';

-- UJ-06 (negatif, AB-05): NIM anggota kembar -> ERROR 1062
INSERT INTO anggota (no_anggota, nim_anggota, nama_anggota, prodi_anggota, status_anggota, tgl_daftar_anggota)
VALUES ('A-0459', '2543000117', 'Anggota NIM Kembar', 'Ilmu Komputer', 'aktif', '2026-09-25');

-- UJ-07 (negatif, fk_penjualan_petugas): petugas 99 -> ERROR 1452
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES ('PJ-2609-0199', NOW(), 99, NULL, 5000);

-- UJ-08 (negatif, kebijakan lab): UPDATE tanpa WHERE di mode aman -> ERROR 1175
UPDATE barang SET stok_min_barang = 5;

-- UJ-09 (Titik Analisis 3, diperkirakan GAGAL, AB-03):
-- qty 50 padahal stok Roti Cokelat hanya 6 -> SEHARUSNYA ditolak, tetapi DITERIMA
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT (SELECT id_penjualan FROM penjualan WHERE no_nota_penjualan = 'PJ-2609-0145'),
       id_barang, 50, harga_jual_barang FROM barang WHERE kode_barang = 'MKN-001';
SELECT kode_barang, stok_barang FROM barang WHERE kode_barang = 'MKN-001';

-- ---------- Jumlah baris per tabel setelah uji ----------
SELECT 'petugas' AS tabel, COUNT(*) AS jumlah_baris FROM petugas
UNION ALL SELECT 'anggota', COUNT(*) FROM anggota
UNION ALL SELECT 'barang', COUNT(*) FROM barang
UNION ALL SELECT 'pemasok', COUNT(*) FROM pemasok
UNION ALL SELECT 'penjualan', COUNT(*) FROM penjualan
UNION ALL SELECT 'detail_penjualan', COUNT(*) FROM detail_penjualan
UNION ALL SELECT 'pembelian', COUNT(*) FROM pembelian
UNION ALL SELECT 'detail_pembelian', COUNT(*) FROM detail_pembelian;
