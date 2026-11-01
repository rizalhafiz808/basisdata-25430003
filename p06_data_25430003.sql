-- =====================================================================
-- p06_data_25430003.sql
-- Milestone Proyek 6: Data sampel Perpustakaan Cendekia RH (perpus_003)
-- Nama: Rizal Hafiz | NIM: 25430003 | Kelas: A
-- Parameter P = (03 mod 9) + 1 = 4
--   -> peminjaman (transaksi utama)  : 10 x P = 40 baris, tersebar 10-30 Okt 2026
--   -> maks. eksemplar per peminjaman: P + 2  = 6   (AB-05)
--   -> denda per eksemplar per hari  : P x Rp1.000 = Rp4.000 (AB-08)
--   -> jatuh tempo = tanggal pinjam + 7 hari (AB-06)
-- Tanggal acuan data ("hari ini"): 2026-10-31. Pinjaman yang dikembalikan
-- setelah 30 Okt dibiarkan terbuka (tgl_kembali NULL).
-- Jalankan sebagai dev_003 SETELAH DDL (basis data kosong):
--   mysql -u dev_003 -p perpus_003 < p05_ddl_25430003.sql
--   mysql -u dev_003 -p perpus_003 < p06_data_25430003.sql
-- Nilai id tidak ditebak: kunci tamu diambil dari kode alami (kode_*, no_peminjaman).
-- =====================================================================

USE perpus_003;

-- ---------- 1. Data induk ----------
INSERT INTO kategori (kode_kategori, nama_kategori, deskripsi_kategori) VALUES
  ('KAT-001', 'Pelajaran', 'Buku paket dan pendamping mata pelajaran'),
  ('KAT-002', 'Referensi', 'Buku referensi pembelajaran'),
  ('KAT-003', 'Sastra', 'Novel, cerpen, dan puisi'),
  ('KAT-004', 'Bacaan Umum', 'Buku pengetahuan umum dan pengembangan diri'),
  ('KAT-005', 'Sains dan Teknologi', 'Buku sains populer dan komputer'),
  ('KAT-006', 'Agama', 'Buku keagamaan dan akhlak');

INSERT INTO penerbit (kode_penerbit, nama_penerbit, alamat_penerbit, telepon_penerbit) VALUES
  ('PEN-001', 'Cendekia Press', 'Jl. Pendidikan No. 5, Metro', '0725123456'),
  ('PEN-002', 'Pustaka Sai Bumi', 'Jl. Ki Hajar Dewantara No. 18, Metro Timur', '0725418820'),
  ('PEN-003', 'Gerbang Aksara Lampung', 'Jl. Zainal Abidin Pagaralam No. 41, Bandar Lampung', '0721703315'),
  ('PEN-004', 'Lentera Ilmu Nusantara', 'Jl. Margonda Raya No. 210, Depok', '0217872290'),
  ('PEN-005', 'Mitra Pelajar Mandiri', NULL, NULL),
  ('PEN-006', 'Bintang Kecil Edukasi', 'Jl. Soekarno-Hatta No. 7, Metro Barat', '0725476614');

INSERT INTO anggota (kode_anggota, nama_anggota, jenis_kelamin_anggota, alamat_anggota,
                     telepon_anggota, tgl_daftar_anggota, status_anggota) VALUES
  ('AG-001', 'Andi Saputra', 'laki-laki', 'Jl. Melati No. 10, Metro Pusat', '081234567890', '2026-07-14', 'aktif'),
  ('AG-002', 'Nur Aisyah Rahmawati', 'perempuan', 'Jl. Cendana No. 3, Metro Pusat', '081377214508', '2026-07-14', 'aktif'),
  ('AG-003', 'Bima Aditya Pratama', 'laki-laki', 'Jl. Kenanga No. 22, Metro Timur', '082179663140', '2026-07-15', 'aktif'),
  ('AG-004', 'Salsabila Putri Ramadhani', 'perempuan', 'Jl. Diponegoro No. 7, Metro Barat', NULL, '2026-07-15', 'aktif'),
  ('AG-005', 'Rafi Kurniawan', 'laki-laki', 'Jl. Sumbawa No. 15, Metro Utara', '085269317702', '2026-07-16', 'aktif'),
  ('AG-006', 'Zahra Aulia Nabila', 'perempuan', 'Jl. Sriwijaya No. 31, Metro Pusat', '081272904415', '2026-07-20', 'aktif'),
  ('AG-007', 'Dimas Arya Wicaksono', 'laki-laki', NULL, '089631842276', '2026-07-21', 'aktif'),
  ('AG-008', 'Fadhilah Nur Azizah', 'perempuan', 'Jl. Pattimura No. 9, Metro Timur', '082281450937', '2026-08-03', 'aktif'),
  ('AG-009', 'Drs. Sutrisno', 'laki-laki', 'Jl. Imam Bonjol No. 44, Metro Barat', '081379025563', '2026-07-13', 'aktif'),
  ('AG-010', 'Rini Wulandari, S.Pd.', 'perempuan', 'Jl. Hasanudin No. 12, Metro Pusat', '085279441208', '2026-07-13', 'aktif'),
  ('AG-011', 'Galang Saputra', 'laki-laki', 'Jl. Gatot Subroto No. 5, Metro Selatan', '081366724519', '2025-07-21', 'nonaktif'),
  ('AG-012', 'Indah Permatasari', 'perempuan', NULL, NULL, '2025-07-22', 'nonaktif');

INSERT INTO petugas (kode_petugas, nama_petugas, telepon_petugas, username_petugas, status_petugas) VALUES
  ('PT-001', 'Siti Rahma', '081298765432', 'siti001', 'aktif'),
  ('PT-002', 'Hendri Kusuma', '085273316640', 'hendri002', 'aktif'),
  ('PT-003', 'Maya Anggraini', '082180044713', 'maya003', 'aktif'),
  ('PT-004', 'Yoga Firmansyah', NULL, 'yoga004', 'aktif'),
  ('PT-005', 'Lestari Handayani', '081379900215', 'lestari005', 'nonaktif');

INSERT INTO buku (kode_buku, judul_buku, isbn_buku, pengarang_buku, tahun_terbit_buku, id_kategori, id_penerbit) VALUES
  ('BK-001', 'Dasar-Dasar Basis Data', '9786020000000', 'Budi Santoso', 2024,
   (SELECT id_kategori FROM kategori WHERE kode_kategori = 'KAT-005'),
   (SELECT id_penerbit FROM penerbit WHERE kode_penerbit = 'PEN-001')),
  ('BK-002', 'Pemrograman untuk Pemula', '9786021447301', 'Rahmat Hidayat', 2023,
   (SELECT id_kategori FROM kategori WHERE kode_kategori = 'KAT-005'),
   (SELECT id_penerbit FROM penerbit WHERE kode_penerbit = 'PEN-004')),
  ('BK-003', 'Matematika Kelas X Kurikulum Merdeka', '9786023318452', 'Tim Guru Cendekia', 2023,
   (SELECT id_kategori FROM kategori WHERE kode_kategori = 'KAT-001'),
   (SELECT id_penerbit FROM penerbit WHERE kode_penerbit = 'PEN-001')),
  ('BK-004', 'Bahasa Indonesia Kelas XI', '9786023318469', 'Tim Guru Cendekia', 2023,
   (SELECT id_kategori FROM kategori WHERE kode_kategori = 'KAT-001'),
   (SELECT id_penerbit FROM penerbit WHERE kode_penerbit = 'PEN-001')),
  ('BK-005', 'Fisika Dasar untuk SMA', '9786027104412', 'Dewi Kartikasari', 2022,
   (SELECT id_kategori FROM kategori WHERE kode_kategori = 'KAT-001'),
   (SELECT id_penerbit FROM penerbit WHERE kode_penerbit = 'PEN-005')),
  ('BK-006', 'Kamus Lengkap Bahasa Inggris-Indonesia', '9786025520187', 'Hendra Wijaya', 2021,
   (SELECT id_kategori FROM kategori WHERE kode_kategori = 'KAT-002'),
   (SELECT id_penerbit FROM penerbit WHERE kode_penerbit = 'PEN-004')),
  ('BK-007', 'Atlas Indonesia dan Dunia', '9786025520194', NULL, 2022,
   (SELECT id_kategori FROM kategori WHERE kode_kategori = 'KAT-002'),
   (SELECT id_penerbit FROM penerbit WHERE kode_penerbit = 'PEN-003')),
  ('BK-008', 'Senja di Way Kambas', '9786026639025', 'Laila Fitriani', 2024,
   (SELECT id_kategori FROM kategori WHERE kode_kategori = 'KAT-003'),
   (SELECT id_penerbit FROM penerbit WHERE kode_penerbit = 'PEN-002')),
  ('BK-009', 'Kumpulan Cerpen Tanah Lado', '9786026639032', 'Ahmad Zaki Mubarak', 2023,
   (SELECT id_kategori FROM kategori WHERE kode_kategori = 'KAT-003'),
   (SELECT id_penerbit FROM penerbit WHERE kode_penerbit = 'PEN-002')),
  ('BK-010', 'Kisah Para Penjelajah Nusantara', '9786028815216', 'Rina Oktaviani', 2020,
   (SELECT id_kategori FROM kategori WHERE kode_kategori = 'KAT-004'),
   (SELECT id_penerbit FROM penerbit WHERE kode_penerbit = 'PEN-003')),
  ('BK-011', 'Belajar Disiplin Sejak Dini', '9786028815223', 'Yusuf Maulana', 2021,
   (SELECT id_kategori FROM kategori WHERE kode_kategori = 'KAT-004'),
   (SELECT id_penerbit FROM penerbit WHERE kode_penerbit = 'PEN-006')),
  ('BK-012', 'Mengenal Tata Surya', '9786029930451', 'Agus Prasetyo', 2022,
   (SELECT id_kategori FROM kategori WHERE kode_kategori = 'KAT-005'),
   (SELECT id_penerbit FROM penerbit WHERE kode_penerbit = 'PEN-006')),
  ('BK-013', 'Akhlak Mulia untuk Pelajar', '9786029930468', 'Ustaz Hamdan Ali', 2021,
   (SELECT id_kategori FROM kategori WHERE kode_kategori = 'KAT-006'),
   (SELECT id_penerbit FROM penerbit WHERE kode_penerbit = 'PEN-005')),
  ('BK-014', 'Sejarah Lampung dari Masa ke Masa', NULL, 'Tim Penulis Sai Bumi', 2019,
   (SELECT id_kategori FROM kategori WHERE kode_kategori = 'KAT-002'),
   (SELECT id_penerbit FROM penerbit WHERE kode_penerbit = 'PEN-002')),
  ('BK-015', 'Puisi-Puisi dari Bumi Ruwa Jurai', '9786024471182', 'Siti Nurhaliza Putri', 2024,
   (SELECT id_kategori FROM kategori WHERE kode_kategori = 'KAT-003'),
   (SELECT id_penerbit FROM penerbit WHERE kode_penerbit = 'PEN-003'));

-- Semua eksemplar masuk dalam kondisi baik dan tersedia; status akhir diperbarui di bagian 3
INSERT INTO eksemplar (kode_eksemplar, id_buku, kode_inventaris_eksemplar) VALUES
  ('EK-001', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-001'), 'INV-2026-001'),
  ('EK-002', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-001'), 'INV-2026-002'),
  ('EK-003', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-001'), 'INV-2026-003'),
  ('EK-004', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-001'), 'INV-2026-004'),
  ('EK-005', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-002'), 'INV-2026-005'),
  ('EK-006', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-002'), 'INV-2026-006'),
  ('EK-007', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-002'), 'INV-2026-007'),
  ('EK-008', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-003'), 'INV-2026-008'),
  ('EK-009', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-003'), 'INV-2026-009'),
  ('EK-010', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-003'), 'INV-2026-010'),
  ('EK-011', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-004'), 'INV-2026-011'),
  ('EK-012', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-004'), 'INV-2026-012'),
  ('EK-013', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-004'), 'INV-2026-013'),
  ('EK-014', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-005'), 'INV-2026-014'),
  ('EK-015', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-005'), 'INV-2026-015'),
  ('EK-016', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-005'), 'INV-2026-016'),
  ('EK-017', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-006'), 'INV-2026-017'),
  ('EK-018', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-006'), 'INV-2026-018'),
  ('EK-019', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-006'), 'INV-2026-019'),
  ('EK-020', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-007'), 'INV-2026-020'),
  ('EK-021', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-007'), 'INV-2026-021'),
  ('EK-022', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-008'), 'INV-2026-022'),
  ('EK-023', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-008'), 'INV-2026-023'),
  ('EK-024', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-008'), 'INV-2026-024'),
  ('EK-025', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-009'), 'INV-2026-025'),
  ('EK-026', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-009'), 'INV-2026-026'),
  ('EK-027', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-010'), 'INV-2026-027'),
  ('EK-028', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-010'), 'INV-2026-028'),
  ('EK-029', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-010'), 'INV-2026-029'),
  ('EK-030', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-011'), 'INV-2026-030'),
  ('EK-031', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-011'), 'INV-2026-031'),
  ('EK-032', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-012'), 'INV-2026-032'),
  ('EK-033', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-012'), 'INV-2026-033'),
  ('EK-034', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-012'), 'INV-2026-034'),
  ('EK-035', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-013'), 'INV-2026-035'),
  ('EK-036', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-013'), 'INV-2026-036'),
  ('EK-037', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-014'), 'INV-2026-037'),
  ('EK-038', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-014'), 'INV-2026-038'),
  ('EK-039', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-015'), 'INV-2026-039'),
  ('EK-040', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-015'), 'INV-2026-040');

-- ---------- 2. Transaksi: 40 peminjaman (10 x P) ----------
-- PJ-001 sama dengan contoh slip P02 bagian 3.1
INSERT INTO peminjaman (no_peminjaman, tgl_peminjaman, id_anggota, id_petugas) VALUES
  ('PJ-001', '2026-10-10', (SELECT id_anggota FROM anggota WHERE kode_anggota = 'AG-001'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PT-001')),
  ('PJ-002', '2026-10-10', (SELECT id_anggota FROM anggota WHERE kode_anggota = 'AG-007'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PT-001')),
  ('PJ-003', '2026-10-10', (SELECT id_anggota FROM anggota WHERE kode_anggota = 'AG-002'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PT-002')),
  ('PJ-004', '2026-10-13', (SELECT id_anggota FROM anggota WHERE kode_anggota = 'AG-005'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PT-002')),
  ('PJ-005', '2026-10-14', (SELECT id_anggota FROM anggota WHERE kode_anggota = 'AG-006'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PT-001')),
  ('PJ-006', '2026-10-14', (SELECT id_anggota FROM anggota WHERE kode_anggota = 'AG-008'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PT-001')),
  ('PJ-007', '2026-10-15', (SELECT id_anggota FROM anggota WHERE kode_anggota = 'AG-009'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PT-003')),
  ('PJ-008', '2026-10-15', (SELECT id_anggota FROM anggota WHERE kode_anggota = 'AG-006'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PT-004')),
  ('PJ-009', '2026-10-16', (SELECT id_anggota FROM anggota WHERE kode_anggota = 'AG-008'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PT-001')),
  ('PJ-010', '2026-10-16', (SELECT id_anggota FROM anggota WHERE kode_anggota = 'AG-003'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PT-003')),
  ('PJ-011', '2026-10-17', (SELECT id_anggota FROM anggota WHERE kode_anggota = 'AG-008'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PT-001')),
  ('PJ-012', '2026-10-17', (SELECT id_anggota FROM anggota WHERE kode_anggota = 'AG-001'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PT-003')),
  ('PJ-013', '2026-10-19', (SELECT id_anggota FROM anggota WHERE kode_anggota = 'AG-007'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PT-004')),
  ('PJ-014', '2026-10-19', (SELECT id_anggota FROM anggota WHERE kode_anggota = 'AG-010'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PT-004')),
  ('PJ-015', '2026-10-19', (SELECT id_anggota FROM anggota WHERE kode_anggota = 'AG-010'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PT-003')),
  ('PJ-016', '2026-10-20', (SELECT id_anggota FROM anggota WHERE kode_anggota = 'AG-008'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PT-001')),
  ('PJ-017', '2026-10-20', (SELECT id_anggota FROM anggota WHERE kode_anggota = 'AG-009'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PT-002')),
  ('PJ-018', '2026-10-20', (SELECT id_anggota FROM anggota WHERE kode_anggota = 'AG-010'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PT-003')),
  ('PJ-019', '2026-10-21', (SELECT id_anggota FROM anggota WHERE kode_anggota = 'AG-008'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PT-002')),
  ('PJ-020', '2026-10-21', (SELECT id_anggota FROM anggota WHERE kode_anggota = 'AG-009'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PT-002')),
  ('PJ-021', '2026-10-21', (SELECT id_anggota FROM anggota WHERE kode_anggota = 'AG-004'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PT-001')),
  ('PJ-022', '2026-10-21', (SELECT id_anggota FROM anggota WHERE kode_anggota = 'AG-001'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PT-004')),
  ('PJ-023', '2026-10-22', (SELECT id_anggota FROM anggota WHERE kode_anggota = 'AG-005'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PT-001')),
  ('PJ-024', '2026-10-22', (SELECT id_anggota FROM anggota WHERE kode_anggota = 'AG-006'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PT-003')),
  ('PJ-025', '2026-10-23', (SELECT id_anggota FROM anggota WHERE kode_anggota = 'AG-005'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PT-001')),
  ('PJ-026', '2026-10-23', (SELECT id_anggota FROM anggota WHERE kode_anggota = 'AG-003'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PT-001')),
  ('PJ-027', '2026-10-24', (SELECT id_anggota FROM anggota WHERE kode_anggota = 'AG-004'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PT-001')),
  ('PJ-028', '2026-10-24', (SELECT id_anggota FROM anggota WHERE kode_anggota = 'AG-009'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PT-003')),
  ('PJ-029', '2026-10-24', (SELECT id_anggota FROM anggota WHERE kode_anggota = 'AG-009'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PT-001')),
  ('PJ-030', '2026-10-26', (SELECT id_anggota FROM anggota WHERE kode_anggota = 'AG-004'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PT-002')),
  ('PJ-031', '2026-10-26', (SELECT id_anggota FROM anggota WHERE kode_anggota = 'AG-003'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PT-003')),
  ('PJ-032', '2026-10-27', (SELECT id_anggota FROM anggota WHERE kode_anggota = 'AG-004'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PT-004')),
  ('PJ-033', '2026-10-28', (SELECT id_anggota FROM anggota WHERE kode_anggota = 'AG-003'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PT-002')),
  ('PJ-034', '2026-10-29', (SELECT id_anggota FROM anggota WHERE kode_anggota = 'AG-008'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PT-004')),
  ('PJ-035', '2026-10-30', (SELECT id_anggota FROM anggota WHERE kode_anggota = 'AG-001'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PT-001')),
  ('PJ-036', '2026-10-30', (SELECT id_anggota FROM anggota WHERE kode_anggota = 'AG-010'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PT-004')),
  ('PJ-037', '2026-10-30', (SELECT id_anggota FROM anggota WHERE kode_anggota = 'AG-009'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PT-001')),
  ('PJ-038', '2026-10-30', (SELECT id_anggota FROM anggota WHERE kode_anggota = 'AG-002'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PT-003')),
  ('PJ-039', '2026-10-30', (SELECT id_anggota FROM anggota WHERE kode_anggota = 'AG-001'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PT-002')),
  ('PJ-040', '2026-10-30', (SELECT id_anggota FROM anggota WHERE kode_anggota = 'AG-008'), (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PT-002'));

-- denda = Rp4.000 x hari terlambat (AB-08), NULL jika belum kembali (AB-09)
INSERT INTO detail_peminjaman (id_peminjaman, id_eksemplar, tgl_jatuh_tempo_detail_peminjaman,
                               tgl_kembali_detail_peminjaman, denda_detail_peminjaman) VALUES
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-001'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-001'), '2026-10-17', '2026-10-17', 0.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-001'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-005'), '2026-10-17', '2026-10-19', 8000.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-002'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-027'), '2026-10-17', '2026-10-21', 16000.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-003'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-003'), '2026-10-17', '2026-10-16', 0.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-003'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-017'), '2026-10-17', '2026-10-17', 0.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-004'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-014'), '2026-10-20', '2026-10-21', 4000.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-005'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-022'), '2026-10-21', '2026-10-23', 8000.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-006'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-028'), '2026-10-21', '2026-10-16', 0.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-007'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-013'), '2026-10-22', '2026-10-21', 0.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-008'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-033'), '2026-10-22', '2026-10-22', 0.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-009'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-006'), '2026-10-23', '2026-10-23', 0.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-009'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-034'), '2026-10-23', '2026-10-28', 20000.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-009'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-037'), '2026-10-23', '2026-10-21', 0.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-009'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-040'), '2026-10-23', '2026-10-21', 0.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-010'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-002'), '2026-10-23', '2026-10-23', 0.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-010'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-024'), '2026-10-23', '2026-10-25', 8000.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-010'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-018'), '2026-10-23', '2026-10-25', 8000.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-011'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-010'), '2026-10-24', '2026-10-24', 0.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-012'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-003'), '2026-10-24', '2026-10-22', 0.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-013'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-039'), '2026-10-26', '2026-10-29', 12000.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-014'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-038'), '2026-10-26', '2026-10-25', 0.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-014'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-021'), '2026-10-26', '2026-10-25', 0.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-014'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-036'), '2026-10-26', '2026-10-23', 0.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-015'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-029'), '2026-10-26', '2026-10-25', 0.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-016'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-030'), '2026-10-27', '2026-10-27', 0.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-016'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-015'), '2026-10-27', '2026-10-28', 4000.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-016'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-007'), '2026-10-27', '2026-10-27', 0.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-017'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-008'), '2026-10-27', '2026-10-26', 0.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-018'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-020'), '2026-10-27', '2026-10-22', 0.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-019'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-005'), '2026-10-28', '2026-10-23', 0.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-019'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-017'), '2026-10-28', '2026-10-28', 0.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-019'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-028'), '2026-10-28', '2026-10-29', 4000.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-019'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-009'), '2026-10-28', '2026-10-29', 4000.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-019'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-035'), '2026-10-28', NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-019'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-031'), '2026-10-28', '2026-10-28', 0.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-020'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-026'), '2026-10-28', '2026-10-28', 0.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-020'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-011'), '2026-10-28', '2026-10-28', 0.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-020'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-032'), '2026-10-28', '2026-10-28', 0.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-021'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-016'), '2026-10-28', '2026-10-28', 0.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-021'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-001'), '2026-10-28', '2026-10-26', 0.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-022'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-012'), '2026-10-28', '2026-10-28', 0.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-023'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-023'), '2026-10-29', '2026-10-29', 0.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-024'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-040'), '2026-10-29', '2026-10-27', 0.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-024'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-025'), '2026-10-29', '2026-10-27', 0.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-025'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-027'), '2026-10-30', '2026-10-30', 0.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-026'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-037'), '2026-10-30', '2026-10-29', 0.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-026'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-013'), '2026-10-30', NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-026'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-019'), '2026-10-30', '2026-10-26', 0.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-026'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-003'), '2026-10-30', NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-027'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-005'), '2026-10-31', NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-027'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-002'), '2026-10-31', NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-028'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-006'), '2026-10-31', '2026-10-27', 0.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-028'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-014'), '2026-10-31', NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-028'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-022'), '2026-10-31', NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-029'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-020'), '2026-10-31', NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-030'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-036'), '2026-11-02', '2026-10-28', 0.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-031'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-004'), '2026-11-02', NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-032'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-024'), '2026-11-03', '2026-10-30', 0.00),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-032'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-038'), '2026-11-03', NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-033'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-008'), '2026-11-04', NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-034'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-032'), '2026-11-05', NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-034'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-001'), '2026-11-05', NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-034'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-019'), '2026-11-05', NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-035'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-006'), '2026-11-06', NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-035'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-037'), '2026-11-06', NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-035'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-023'), '2026-11-06', NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-035'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-028'), '2026-11-06', NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-036'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-012'), '2026-11-06', NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-036'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-031'), '2026-11-06', NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-036'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-015'), '2026-11-06', NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-037'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-026'), '2026-11-06', NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-038'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-040'), '2026-11-06', NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-039'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-007'), '2026-11-06', NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-040'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-029'), '2026-11-06', NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-040'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-036'), '2026-11-06', NULL, NULL),
  ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-040'), (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-011'), '2026-11-06', NULL, NULL);

-- ---------- 3. Status akhir eksemplar (AB-07) ----------
-- Eksemplar yang masih dipinjam (tgl_kembali NULL)
UPDATE eksemplar SET status_eksemplar = 'dipinjam'
WHERE kode_eksemplar IN ('EK-001', 'EK-002', 'EK-003', 'EK-004', 'EK-005', 'EK-006', 'EK-007', 'EK-008', 'EK-011', 'EK-012', 'EK-013', 'EK-014', 'EK-015', 'EK-019', 'EK-020', 'EK-022', 'EK-023', 'EK-026', 'EK-028', 'EK-029', 'EK-031', 'EK-032', 'EK-035', 'EK-036', 'EK-037', 'EK-038', 'EK-040');

-- Eksemplar yang dikembalikan dalam kondisi rusak (tetap tersedia, tidak boleh dipinjam)
UPDATE eksemplar SET kondisi_eksemplar = 'rusak'
WHERE kode_eksemplar IN ('EK-021', 'EK-033');

-- ---------- 4. Ringkasan ----------
SELECT 'kategori' AS tabel, COUNT(*) AS jumlah_baris FROM kategori
UNION ALL SELECT 'penerbit', COUNT(*) FROM penerbit
UNION ALL SELECT 'anggota', COUNT(*) FROM anggota
UNION ALL SELECT 'petugas', COUNT(*) FROM petugas
UNION ALL SELECT 'buku', COUNT(*) FROM buku
UNION ALL SELECT 'eksemplar', COUNT(*) FROM eksemplar
UNION ALL SELECT 'peminjaman', COUNT(*) FROM peminjaman
UNION ALL SELECT 'detail_peminjaman', COUNT(*) FROM detail_peminjaman;

SELECT COUNT(DISTINCT tgl_peminjaman) AS jumlah_tanggal_berbeda,
       MIN(tgl_peminjaman) AS tanggal_awal, MAX(tgl_peminjaman) AS tanggal_akhir
FROM peminjaman;
