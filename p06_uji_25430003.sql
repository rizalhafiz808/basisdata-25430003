-- =====================================================================
-- p06_uji_25430003.sql
-- Milestone Proyek 6: skenario uji Perpustakaan Cendekia RH (perpus_003)
-- Nama: Rizal Hafiz | NIM: 25430003 | Kelas: A
-- Jalankan dari prompt MariaDB sebagai dev_003, SETELAH p06_data_25430003.sql:
--   SOURCE D:/praktikum/basisdata-25430003/p06_uji_25430003.sql
-- Seluruh uji berada di dalam satu transaksi dan diakhiri ROLLBACK,
-- sehingga data sampel tetap utuh untuk Pertemuan 7 dan seterusnya.
-- Hasil yang diharapkan:
--   UJ-01..UJ-03 diterima | UJ-04..UJ-13 ditolak | UJ-14, UJ-15 diterima = GAGAL
-- =====================================================================

USE perpus_003;
SELECT CURRENT_USER(), NOW();
SET SESSION sql_safe_updates = 1;
START TRANSACTION;

-- ======================= UJI POSITIF =======================

-- UJ-01 (AB-04, AB-06, AB-07): peminjaman baru oleh anggota aktif -> DITERIMA
INSERT INTO peminjaman (no_peminjaman, tgl_peminjaman, id_anggota, id_petugas)
VALUES ('PJ-041', '2026-10-31',
        (SELECT id_anggota FROM anggota WHERE kode_anggota = 'AG-002'),
        (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PT-002'));
INSERT INTO detail_peminjaman (id_peminjaman, id_eksemplar, tgl_jatuh_tempo_detail_peminjaman)
VALUES ((SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-041'),
        (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-009'),
        '2026-11-07');
UPDATE eksemplar SET status_eksemplar = 'dipinjam' WHERE kode_eksemplar = 'EK-009';
SELECT p.no_peminjaman, e.kode_eksemplar, e.status_eksemplar, d.tgl_jatuh_tempo_detail_peminjaman
FROM detail_peminjaman d
JOIN peminjaman p ON p.id_peminjaman = d.id_peminjaman
JOIN eksemplar  e ON e.id_eksemplar  = d.id_eksemplar
WHERE p.no_peminjaman = 'PJ-041';

-- UJ-02 (AB-08, AB-09): pengembalian sebelum jatuh tempo, denda 0 -> DITERIMA
UPDATE detail_peminjaman
SET tgl_kembali_detail_peminjaman = '2026-11-05', denda_detail_peminjaman = 0
WHERE id_peminjaman = (SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-041')
  AND id_eksemplar  = (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-009');
UPDATE eksemplar SET status_eksemplar = 'tersedia' WHERE kode_eksemplar = 'EK-009';

-- UJ-03 (AB-08, berbasis P): EK-035 (PJ-019) jatuh tempo 28 Okt, kembali 31 Okt
-- -> terlambat 3 hari x Rp4.000 = Rp12.000 -> DITERIMA
UPDATE detail_peminjaman
SET tgl_kembali_detail_peminjaman = '2026-10-31', denda_detail_peminjaman = 12000
WHERE id_peminjaman = (SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-019')
  AND id_eksemplar  = (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-035');
UPDATE eksemplar SET status_eksemplar = 'tersedia' WHERE kode_eksemplar = 'EK-035';
SELECT p.no_peminjaman, e.kode_eksemplar, d.tgl_jatuh_tempo_detail_peminjaman, d.tgl_kembali_detail_peminjaman,
       DATEDIFF(d.tgl_kembali_detail_peminjaman, d.tgl_jatuh_tempo_detail_peminjaman) AS hari_terlambat,
       d.denda_detail_peminjaman
FROM detail_peminjaman d
JOIN peminjaman p ON p.id_peminjaman = d.id_peminjaman
JOIN eksemplar  e ON e.id_eksemplar  = d.id_eksemplar
WHERE (p.no_peminjaman = 'PJ-041' AND e.kode_eksemplar = 'EK-009')
   OR (p.no_peminjaman = 'PJ-019' AND e.kode_eksemplar = 'EK-035');

-- ======================= UJI NEGATIF =======================

-- UJ-04 (AB-04): nomor peminjaman kembar -> ERROR 1062
INSERT INTO peminjaman (no_peminjaman, tgl_peminjaman, id_anggota, id_petugas)
VALUES ('PJ-001', '2026-10-31',
        (SELECT id_anggota FROM anggota WHERE kode_anggota = 'AG-003'),
        (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PT-001'));

-- UJ-05 (AB-01): peminjaman oleh anggota yang tidak terdaftar (id 999) -> ERROR 1452
INSERT INTO peminjaman (no_peminjaman, tgl_peminjaman, id_anggota, id_petugas)
VALUES ('PJ-099', '2026-10-31', 999,
        (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PT-001'));

-- UJ-06 (AB-02): kode inventaris eksemplar kembar -> ERROR 1062
INSERT INTO eksemplar (kode_eksemplar, id_buku, kode_inventaris_eksemplar)
VALUES ('EK-041', (SELECT id_buku FROM buku WHERE kode_buku = 'BK-001'), 'INV-2026-001');

-- UJ-07 (AB-10): buku dengan kategori yang tidak terdaftar -> ERROR 1452
INSERT INTO buku (kode_buku, judul_buku, id_kategori, id_penerbit)
VALUES ('BK-099', 'Buku Tanpa Kategori', 99,
        (SELECT id_penerbit FROM penerbit WHERE kode_penerbit = 'PEN-001'));

-- UJ-08 (AB-08, berbasis P): denda Rp6.000 bukan kelipatan Rp4.000 -> ERROR 4025
UPDATE detail_peminjaman
SET tgl_kembali_detail_peminjaman = '2026-10-31', denda_detail_peminjaman = 6000
WHERE id_peminjaman = (SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-026')
  AND id_eksemplar  = (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-003');

-- UJ-09 (AB-09): denda diisi padahal eksemplar belum dikembalikan -> ERROR 4025
UPDATE detail_peminjaman
SET denda_detail_peminjaman = 4000
WHERE id_peminjaman = (SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-026')
  AND id_eksemplar  = (SELECT id_eksemplar FROM eksemplar WHERE kode_eksemplar = 'EK-013');

-- UJ-10 (AB-05, AB-07): eksemplar rusak EK-021 diubah menjadi dipinjam -> ERROR 4025
UPDATE eksemplar SET status_eksemplar = 'dipinjam' WHERE kode_eksemplar = 'EK-021';

-- UJ-11 (AB-11): status anggota di luar aktif/nonaktif -> ERROR 1265
UPDATE anggota SET status_anggota = 'cuti' WHERE kode_anggota = 'AG-003';

-- UJ-12 (retensi riwayat, P02 9.3): hapus petugas yang punya riwayat -> ERROR 1451
DELETE FROM petugas WHERE kode_petugas = 'PT-001';

-- UJ-13 (kebijakan lab): UPDATE tanpa WHERE di mode aman -> ERROR 1175
UPDATE eksemplar SET status_eksemplar = 'tersedia';

-- ============ UJI YANG DIPERKIRAKAN GAGAL (utang desain Modul 14) ============

-- UJ-14 (AB-05, berbasis P + 2 = 6): satu slip berisi 7 eksemplar
-- -> SEHARUSNYA ditolak, tetapi DITERIMA
INSERT INTO peminjaman (no_peminjaman, tgl_peminjaman, id_anggota, id_petugas)
VALUES ('PJ-042', '2026-10-31',
        (SELECT id_anggota FROM anggota WHERE kode_anggota = 'AG-009'),
        (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PT-003'));
INSERT INTO detail_peminjaman (id_peminjaman, id_eksemplar, tgl_jatuh_tempo_detail_peminjaman)
SELECT (SELECT id_peminjaman FROM peminjaman WHERE no_peminjaman = 'PJ-042'), id_eksemplar, '2026-11-07'
FROM eksemplar
WHERE kode_eksemplar IN ('EK-010', 'EK-016', 'EK-017', 'EK-018', 'EK-024', 'EK-025', 'EK-027');
SELECT p.no_peminjaman, COUNT(*) AS jumlah_eksemplar
FROM detail_peminjaman d JOIN peminjaman p ON p.id_peminjaman = d.id_peminjaman
WHERE p.no_peminjaman = 'PJ-042' GROUP BY p.no_peminjaman;

-- UJ-15 (AB-11): anggota NONAKTIF AG-011 meminjam -> SEHARUSNYA ditolak, tetapi DITERIMA
INSERT INTO peminjaman (no_peminjaman, tgl_peminjaman, id_anggota, id_petugas)
VALUES ('PJ-043', '2026-10-31',
        (SELECT id_anggota FROM anggota WHERE kode_anggota = 'AG-011'),
        (SELECT id_petugas FROM petugas WHERE kode_petugas = 'PT-003'));
SELECT p.no_peminjaman, a.kode_anggota, a.status_anggota
FROM peminjaman p JOIN anggota a ON a.id_anggota = p.id_anggota
WHERE p.no_peminjaman = 'PJ-043';

-- ---------- Jumlah baris sebelum ROLLBACK ----------
SELECT 'peminjaman' AS tabel, COUNT(*) AS jumlah_baris FROM peminjaman
UNION ALL SELECT 'detail_peminjaman', COUNT(*) FROM detail_peminjaman;

ROLLBACK;

-- ---------- Jumlah baris setelah ROLLBACK (kembali ke data sampel) ----------
SELECT 'kategori' AS tabel, COUNT(*) AS jumlah_baris FROM kategori
UNION ALL SELECT 'penerbit', COUNT(*) FROM penerbit
UNION ALL SELECT 'anggota', COUNT(*) FROM anggota
UNION ALL SELECT 'petugas', COUNT(*) FROM petugas
UNION ALL SELECT 'buku', COUNT(*) FROM buku
UNION ALL SELECT 'eksemplar', COUNT(*) FROM eksemplar
UNION ALL SELECT 'peminjaman', COUNT(*) FROM peminjaman
UNION ALL SELECT 'detail_peminjaman', COUNT(*) FROM detail_peminjaman;
