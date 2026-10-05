  -- p01_milestone_25430003.sql
    -- Password sengaja diganti penanda. JANGAN commit password asli.
     CREATE DATABASE IF NOT EXISTS perpus_003
     CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
     CREATE USER IF NOT EXISTS 'dev_003'@'localhost' IDENTIFIED BY '<password_kerja>';

     GRANT ALL PRIVILEGES ON perpus_003.* TO 'dev_003'@'localhost';