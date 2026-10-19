-- =====================================================================
-- p05_uji_constraint_25430003.sql
-- Bukti constraint proyek Perpustakaan Cendekia RH menolak data salah
-- Nama: Rizal Hafiz | NIM: 25430003 | Kelas: A
-- Jalankan SETELAH p05_ddl_25430003.sql, sebagai dev_003:
--   mysql -u dev_003 -p
--   SOURCE D:/praktikum/basisdata-25430003/p05_uji_constraint_25430003.sql
-- Hasil yang diharapkan: 8 ERROR (1452, 1062, 1062, 4025, 4025, 4025, 1265, 1451)
-- =====================================================================

USE perpus_003;

-- ---------- Data induk secukupnya (harus BERHASIL) ----------
INSERT INTO kategori (kode_kategori, nama_kategori, deskripsi_kategori) VALUES
  ('KAT-001', 'Referensi', 'Buku referensi pembelajaran');
INSERT INTO penerbit (kode_penerbit, nama_penerbit) VALUES
  ('PEN-001', 'Cendekia Press');
INSERT INTO anggota (kode_anggota, nama_anggota, jenis_kelamin_anggota, tgl_daftar_anggota) VALUES
  ('AG-001', 'Andi Saputra', 'laki-laki', '2026-10-01');
INSERT INTO petugas (kode_petugas, nama_petugas, username_petugas) VALUES
  ('PT-001', 'Siti Rahma', 'siti001');
INSERT INTO buku (kode_buku, judul_buku, id_kategori, id_penerbit) VALUES
  ('BK-001', 'Dasar-Dasar Basis Data', 1, 1),
  ('BK-002', 'Pemrograman untuk Pemula', 1, 1);
INSERT INTO eksemplar (kode_eksemplar, id_buku, kode_inventaris_eksemplar) VALUES
  ('EK-001', 1, 'INV-001'),
  ('EK-005', 2, 'INV-005');
INSERT INTO peminjaman (no_peminjaman, tgl_peminjaman, id_anggota, id_petugas) VALUES
  ('PJ-001', '2026-10-10', 1, 1);
INSERT INTO detail_peminjaman (id_peminjaman, id_eksemplar, tgl_jatuh_tempo_detail_peminjaman) VALUES
  (1, 1, '2026-10-17'),
  (1, 2, '2026-10-17');

-- ---------- Uji NEGATIF (semua HARUS DITOLAK) ----------

-- U1 FK (AB-03): eksemplar merujuk buku 99 yang tidak ada -> ERROR 1452
INSERT INTO eksemplar (kode_eksemplar, id_buku, kode_inventaris_eksemplar)
VALUES ('EK-099', 99, 'INV-099');

-- U2 UNIQUE (AB-01): kode anggota kembar -> ERROR 1062
INSERT INTO anggota (kode_anggota, nama_anggota, jenis_kelamin_anggota, tgl_daftar_anggota)
VALUES ('AG-001', 'Anggota Kembar', 'perempuan', '2026-10-12');

-- U3 UNIQUE komposit: EK-001 dicatat dua kali di PJ-001 -> ERROR 1062
INSERT INTO detail_peminjaman (id_peminjaman, id_eksemplar, tgl_jatuh_tempo_detail_peminjaman)
VALUES (1, 1, '2026-10-17');

-- U4 CHECK (AB-05/AB-07): eksemplar rusak berstatus dipinjam -> ERROR 4025
UPDATE eksemplar SET kondisi_eksemplar = 'rusak', status_eksemplar = 'dipinjam'
WHERE kode_eksemplar = 'EK-001';

-- U5 CHECK berbasis P (AB-08): denda Rp5.000 bukan kelipatan Rp4.000 -> ERROR 4025
UPDATE detail_peminjaman SET tgl_kembali_detail_peminjaman = '2026-10-19', denda_detail_peminjaman = 5000
WHERE id_peminjaman = 1 AND id_eksemplar = 2;

-- U6 CHECK (AB-09): denda diisi padahal belum dikembalikan -> ERROR 4025
UPDATE detail_peminjaman SET denda_detail_peminjaman = 4000
WHERE id_peminjaman = 1 AND id_eksemplar = 1;

-- U7 ENUM + mode ketat (AB-11): status anggota di luar aktif/nonaktif -> ERROR 1265
UPDATE anggota SET status_anggota = 'cuti' WHERE kode_anggota = 'AG-001';

-- U8 FK tanpa ON DELETE: anggota yang punya riwayat tidak boleh dihapus -> ERROR 1451
DELETE FROM anggota WHERE kode_anggota = 'AG-001';

-- ---------- Uji POSITIF (harus BERHASIL) ----------
-- EK-005 jatuh tempo 17 Okt, kembali 19 Okt -> 2 hari x Rp4.000 = Rp8.000 (contoh slip P02)
UPDATE detail_peminjaman SET tgl_kembali_detail_peminjaman = '2026-10-19', denda_detail_peminjaman = 8000
WHERE id_peminjaman = 1 AND id_eksemplar = 2;

SELECT p.no_peminjaman, e.kode_eksemplar, d.tgl_jatuh_tempo_detail_peminjaman,
       d.tgl_kembali_detail_peminjaman,
       GREATEST(DATEDIFF(d.tgl_kembali_detail_peminjaman, d.tgl_jatuh_tempo_detail_peminjaman), 0) AS hari_terlambat,
       d.denda_detail_peminjaman
FROM detail_peminjaman d
JOIN peminjaman p ON p.id_peminjaman = d.id_peminjaman
JOIN eksemplar  e ON e.id_eksemplar  = d.id_eksemplar;
