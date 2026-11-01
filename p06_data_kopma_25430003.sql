-- =====================================================================
-- p06_data_kopma_25430003.sql
-- Modul 6 langkah D.1-D.2: data contoh Kopma
-- Nama: Rizal Hafiz | NIM: 25430003 | Kelas: A
-- Jalankan SETELAH DDL (basis data harus kosong):
--   mysql -u mhs_003 -p kopma_003 < p05_ddl_kopma_25430003.sql
--   mysql -u mhs_003 -p kopma_003 < p06_data_kopma_25430003.sql
-- =====================================================================

USE kopma_003;

-- ---------- D.1 Data induk (INSERT banyak baris) ----------
INSERT INTO petugas (kode_petugas, nama_petugas, peran_petugas) VALUES
  ('K01', 'Dimas', 'kasir'),
  ('K02', 'Sari',  'kasir'),
  ('K03', 'Rina',  'kasir'),
  ('G01', 'Joko',  'gudang'),
  ('P01', 'Ketua Kopma', 'ketua');

INSERT INTO barang (kode_barang, nama_barang, kategori_barang,
                    harga_jual_barang, stok_barang, stok_min_barang) VALUES
  ('ATK-001', 'Pulpen Gel 0.5',  'ATK',     4000, 120, 20),
  ('ATK-002', 'Buku Tulis 58',   'ATK',     6500,  80, 20),
  ('MNM-001', 'Air Mineral 600', 'minuman', 4000,  48, 24),
  ('MKN-001', 'Roti Cokelat',    'makanan', 5000,   6, 10);

-- Minimal tiga anggota, satu nonaktif
INSERT INTO anggota (no_anggota, nim_anggota, nama_anggota, prodi_anggota,
                     no_hp_anggota, status_anggota, tgl_daftar_anggota) VALUES
  ('A-0457', '2543000117', 'Nadia Putri Lestari', 'Ilmu Komputer',   '081272340117', 'aktif',    '2025-08-25'),
  ('A-0458', '2541000208', 'Bagas Pratama',       'Pendidikan Matematika', NULL,     'aktif',    '2025-09-02'),
  ('A-0312', '2341000356', 'Fikri Ramadhan',      'Manajemen',       '085366120356', 'nonaktif', '2024-02-14');

-- Minimal dua pemasok
INSERT INTO pemasok (nama_pemasok, telepon_pemasok, alamat_pemasok) VALUES
  ('CV Sumber Ilmu Metro',     '0725-41234', 'Jl. A. Yani No. 21, Metro Pusat'),
  ('UD Segar Jaya Lampung',    '0725-47788', 'Jl. Jenderal Sudirman No. 8, Metro Timur');

-- ---------- D.2 Nota contoh Modul 2: PJ-2609-0142 ----------
-- Kasir Rina (K03) melayani anggota A-0457, bayar Rp30.000
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES ('PJ-2609-0142', '2026-09-24 10:15:00',
        (SELECT id_petugas FROM petugas WHERE kode_petugas = 'K03'),
        (SELECT id_anggota FROM anggota WHERE no_anggota = 'A-0457'),
        30000);

-- Harga satuan disalin dari harga jual SAAT INI (AB-04), bukan diketik manual
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT (SELECT id_penjualan FROM penjualan WHERE no_nota_penjualan = 'PJ-2609-0142'),
       id_barang, 3, harga_jual_barang
FROM barang WHERE kode_barang = 'ATK-001';

INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT (SELECT id_penjualan FROM penjualan WHERE no_nota_penjualan = 'PJ-2609-0142'),
       id_barang, 1, harga_jual_barang
FROM barang WHERE kode_barang = 'ATK-002';

INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT (SELECT id_penjualan FROM penjualan WHERE no_nota_penjualan = 'PJ-2609-0142'),
       id_barang, 2, harga_jual_barang
FROM barang WHERE kode_barang = 'MNM-001';

-- Stok dikurangi sesuai qty pada nota
UPDATE barang SET stok_barang = stok_barang - 3 WHERE kode_barang = 'ATK-001';
UPDATE barang SET stok_barang = stok_barang - 1 WHERE kode_barang = 'ATK-002';
UPDATE barang SET stok_barang = stok_barang - 2 WHERE kode_barang = 'MNM-001';

-- ---------- Nota uji kedua (akan dihapus di langkah D.3) ----------
-- Pembeli umum (id_anggota NULL), kasir Dimas (K01). Stok sengaja tidak dikurangi
-- karena nota ini hanya untuk membuktikan ON DELETE CASCADE.
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES ('PJ-2609-0143', '2026-09-24 10:40:00',
        (SELECT id_petugas FROM petugas WHERE kode_petugas = 'K01'), NULL, 10000);

INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT (SELECT id_penjualan FROM penjualan WHERE no_nota_penjualan = 'PJ-2609-0143'),
       id_barang, 1, harga_jual_barang
FROM barang WHERE kode_barang = 'MKN-001';

-- ---------- Pemesanan ulang (AB-06): stok Roti Cokelat 6 < minimum 10 ----------
INSERT INTO pembelian (no_faktur_pembelian, tgl_pembelian, id_pemasok, status_pembelian)
VALUES ('FK-SJ-0925-01', '2026-09-25',
        (SELECT id_pemasok FROM pemasok WHERE nama_pemasok = 'UD Segar Jaya Lampung'), 'dipesan');

INSERT INTO detail_pembelian (id_pembelian, id_barang, qty_detail_pembelian, harga_beli_detail_pembelian)
SELECT (SELECT id_pembelian FROM pembelian WHERE no_faktur_pembelian = 'FK-SJ-0925-01'),
       id_barang, 24, 3800
FROM barang WHERE kode_barang = 'MKN-001';

-- ---------- Ringkasan ----------
SELECT 'petugas' AS tabel, COUNT(*) AS jumlah_baris FROM petugas
UNION ALL SELECT 'anggota', COUNT(*) FROM anggota
UNION ALL SELECT 'barang', COUNT(*) FROM barang
UNION ALL SELECT 'pemasok', COUNT(*) FROM pemasok
UNION ALL SELECT 'penjualan', COUNT(*) FROM penjualan
UNION ALL SELECT 'detail_penjualan', COUNT(*) FROM detail_penjualan
UNION ALL SELECT 'pembelian', COUNT(*) FROM pembelian
UNION ALL SELECT 'detail_pembelian', COUNT(*) FROM detail_pembelian;
