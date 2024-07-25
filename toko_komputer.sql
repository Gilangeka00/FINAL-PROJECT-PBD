-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 25 Jul 2024 pada 20.37
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `toko_komputer`
--

DELIMITER $$
--
-- Prosedur
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `tambah_stok_produk` (IN `p_id_produk` INT, IN `p_jumlah` INT)   BEGIN
    IF EXISTS (SELECT 1 FROM produk WHERE id_produk = p_id_produk) THEN
        UPDATE produk 
        SET stok = stok + p_jumlah 
        WHERE id_produk = p_id_produk;
    ELSE
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Produk tidak ditemukan';
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `tampilkan_semua_pelanggan` ()   BEGIN
    SELECT * FROM pelanggan;
END$$

--
-- Fungsi
--
CREATE DEFINER=`root`@`localhost` FUNCTION `total_harga_produk_by_kategori` (`id_kategori` INT) RETURNS DECIMAL(10,2)  BEGIN
    DECLARE total DECIMAL(10, 2);
    SELECT SUM(harga) INTO total FROM produk WHERE produk.id_kategori = id_kategori;
    RETURN total;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `total_produk` () RETURNS INT(11)  BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total FROM produk;
    RETURN total;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `detail_transaksi`
--

CREATE TABLE `detail_transaksi` (
  `id_detail` int(11) NOT NULL,
  `id_transaksi` int(11) DEFAULT NULL,
  `id_produk` int(11) DEFAULT NULL,
  `jumlah` int(11) DEFAULT NULL,
  `harga_satuan` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `detail_transaksi`
--

INSERT INTO `detail_transaksi` (`id_detail`, `id_transaksi`, `id_produk`, `jumlah`, `harga_satuan`) VALUES
(2, 1, 3, 2, 200000.00),
(4, 2, 4, 1, 1500000.00),
(5, 3, 5, 3, 600000.00),
(6, 4, 6, 1, 300000.00),
(7, 4, 7, 1, 2000000.00),
(8, 5, 8, 2, 700000.00),
(9, 6, 3, 5, 200000.00),
(10, 7, 4, 1, 1500000.00);

-- --------------------------------------------------------

--
-- Struktur dari tabel `karyawan`
--

CREATE TABLE `karyawan` (
  `id_karyawan` int(11) NOT NULL,
  `nama_karyawan` varchar(100) DEFAULT NULL,
  `email_karyawan` varchar(100) DEFAULT NULL,
  `telepon_karyawan` varchar(15) DEFAULT NULL,
  `alamat_karyawan` text DEFAULT NULL,
  `posisi` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `karyawan`
--

INSERT INTO `karyawan` (`id_karyawan`, `nama_karyawan`, `email_karyawan`, `telepon_karyawan`, `alamat_karyawan`, `posisi`) VALUES
(1, 'Hendra', 'hendra@tokokomputer.com', '08123456775', 'Jl. Pegawai No. 1', 'Kasir'),
(2, 'Indra', 'indra@tokokomputer.com', '08123456774', 'Jl. Pegawai No. 2', 'Gudang'),
(3, 'Joko', 'joko@tokokomputer.com', '08123456773', 'Jl. Pegawai No. 3', 'Manager'),
(4, 'Kiki', 'kiki@tokokomputer.com', '08123456772', 'Jl. Pegawai No. 4', 'Sales'),
(5, 'Lina', 'lina@tokokomputer.com', '08123456771', 'Jl. Pegawai No. 5', 'Marketing'),
(6, 'Mira', 'mira@tokokomputer.com', '08123456770', 'Jl. Pegawai No. 6', 'IT Support'),
(7, 'Nina', 'nina@tokokomputer.com', '08123456769', 'Jl. Pegawai No. 7', 'Administrasi');

-- --------------------------------------------------------

--
-- Struktur dari tabel `karyawan_detail`
--

CREATE TABLE `karyawan_detail` (
  `id_karyawan` int(11) NOT NULL,
  `nomor_identitas` varchar(50) DEFAULT NULL,
  `tanggal_masuk` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `karyawan_detail`
--

INSERT INTO `karyawan_detail` (`id_karyawan`, `nomor_identitas`, `tanggal_masuk`) VALUES
(1, 'ID-001', '2020-01-01'),
(2, 'ID-002', '2021-02-01'),
(3, 'ID-003', '2019-03-01'),
(4, 'ID-004', '2018-04-01'),
(5, 'ID-005', '2017-05-01'),
(6, 'ID-006', '2022-06-01'),
(7, 'ID-007', '2023-07-01');

-- --------------------------------------------------------

--
-- Struktur dari tabel `kategori`
--

CREATE TABLE `kategori` (
  `id_kategori` int(11) NOT NULL,
  `nama_kategori` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `kategori`
--

INSERT INTO `kategori` (`id_kategori`, `nama_kategori`) VALUES
(3, 'Aksesoris'),
(4, 'Printer'),
(5, 'Komponen'),
(6, 'Networking'),
(7, 'Software'),
(8, 'Peralatan Kantor');

--
-- Trigger `kategori`
--
DELIMITER $$
CREATE TRIGGER `after_update_kategori` AFTER UPDATE ON `kategori` FOR EACH ROW BEGIN
  INSERT INTO log_aktivitas (aksi, nama_tabel, id_data, data_lama, data_baru)
  VALUES ('AFTER UPDATE', 'kategori', OLD.id_kategori, CONCAT('Nama Kategori: ', OLD.nama_kategori),
    CONCAT('Nama Kategori: ', NEW.nama_kategori));
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_delete_kategori` BEFORE DELETE ON `kategori` FOR EACH ROW BEGIN
  INSERT INTO log_aktivitas (aksi, nama_tabel, id_data, data_lama)
  VALUES (
    'BEFORE DELETE', 
    'kategori', 
    OLD.id_kategori, 
    CONCAT(
      'Nama Kategori: ', OLD.nama_kategori
    )
  );
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `log_aktivitas`
--

CREATE TABLE `log_aktivitas` (
  `id_log` int(11) NOT NULL,
  `aksi` varchar(50) NOT NULL,
  `nama_tabel` varchar(50) NOT NULL,
  `id_data` int(11) NOT NULL,
  `waktu` datetime NOT NULL DEFAULT current_timestamp(),
  `data_lama` text DEFAULT NULL,
  `data_baru` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `log_aktivitas`
--

INSERT INTO `log_aktivitas` (`id_log`, `aksi`, `nama_tabel`, `id_data`, `waktu`, `data_lama`, `data_baru`) VALUES
(11, 'BEFORE DELETE', 'kategori', 2, '2024-07-24 22:58:30', 'Nama Kategori: Desktop', NULL),
(12, 'BEFORE INSERT', 'produk', 0, '2024-07-25 09:45:46', NULL, NULL),
(14, 'BEFORE INSERT', 'produk', 0, '2024-07-25 09:50:30', NULL, 'Nama Produk: Keyboard Mechanical, Harga: 500000.00, Stok: 20, ID Kategori: 3');

-- --------------------------------------------------------

--
-- Struktur dari tabel `pelanggan`
--

CREATE TABLE `pelanggan` (
  `id_pelanggan` int(11) NOT NULL,
  `nama` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `telepon` varchar(15) DEFAULT NULL,
  `alamat` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `pelanggan`
--

INSERT INTO `pelanggan` (`id_pelanggan`, `nama`, `email`, `telepon`, `alamat`) VALUES
(1, 'Andi Wijaya', 'andi@gmail.com', '08123456789', 'Jl. Merdeka No. 1'),
(2, 'Budi', 'budi@gmail.com', '08123456788', 'Jl. Kemerdekaan No. 2'),
(3, 'Cici', 'cici@gmail.com', '08123456787', 'Jl. Pahlawan No. 3'),
(4, 'Dedi', 'dedi@gmail.com', '08123456786', 'Jl. Jendral No. 4'),
(5, 'Evi', 'evi@gmail.com', '08123456785', 'Jl. Pejuang No. 5'),
(6, 'Feri', 'feri@gmail.com', '08123456784', 'Jl. Veteran No. 6'),
(7, 'Gita', 'gita@gmail.com', '08123456783', 'Jl. Patriot No. 7');

--
-- Trigger `pelanggan`
--
DELIMITER $$
CREATE TRIGGER `before_update_pelanggan` BEFORE UPDATE ON `pelanggan` FOR EACH ROW BEGIN
  INSERT INTO log_aktivitas (aksi, nama_tabel, id_data, data_lama, data_baru)
  VALUES ('BEFORE UPDATE', 'pelanggan', OLD.id_pelanggan, CONCAT('Nama: ', OLD.nama, ', Email: ', OLD.email, ', Telepon: ', OLD.telepon, ', Alamat: ', OLD.alamat),
    CONCAT('Nama: ', NEW.nama, ', Email: ', NEW.email, ', Telepon: ', NEW.telepon, ', Alamat: ', NEW.alamat));
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `produk`
--

CREATE TABLE `produk` (
  `id_produk` int(11) NOT NULL,
  `nama_produk` varchar(100) DEFAULT NULL,
  `harga` decimal(10,2) DEFAULT NULL,
  `stok` int(11) DEFAULT NULL,
  `id_kategori` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `produk`
--

INSERT INTO `produk` (`id_produk`, `nama_produk`, `harga`, `stok`, `id_kategori`) VALUES
(3, 'Mouse Logitech', 200000.00, 30, 3),
(4, 'Printer Canon', 1500000.00, 5, 4),
(5, 'RAM 8GB', 600000.00, 50, 5),
(6, 'Router TP-Link', 300000.00, 8, 6),
(7, 'Windows 10', 2000000.00, 20, 7),
(8, 'Kursi Kantor', 700000.00, 15, 8);

--
-- Trigger `produk`
--
DELIMITER $$
CREATE TRIGGER `before_insert_produk` BEFORE INSERT ON `produk` FOR EACH ROW BEGIN
  INSERT INTO log_aktivitas (aksi, nama_tabel, id_data, data_baru)
  VALUES ('BEFORE INSERT', 'produk', NEW.id_produk, CONCAT('Nama Produk: ', NEW.nama_produk, ', Harga: ', NEW.harga, ', Stok: ', NEW.stok, ', ID Kategori: ', NEW.id_kategori));
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `produk_index`
--

CREATE TABLE `produk_index` (
  `id_produk` int(11) NOT NULL,
  `nama_produk` varchar(100) DEFAULT NULL,
  `harga` decimal(10,2) DEFAULT NULL,
  `stok` int(11) DEFAULT NULL,
  `id_kategori` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `produk_supplier`
--

CREATE TABLE `produk_supplier` (
  `id_produk` int(11) NOT NULL,
  `id_supplier` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `produk_supplier`
--

INSERT INTO `produk_supplier` (`id_produk`, `id_supplier`) VALUES
(3, 3),
(4, 4),
(5, 5),
(6, 5),
(7, 6),
(8, 7);

--
-- Trigger `produk_supplier`
--
DELIMITER $$
CREATE TRIGGER `after_delete_produk_supplier` AFTER DELETE ON `produk_supplier` FOR EACH ROW BEGIN
  INSERT INTO log_aktivitas (aksi, nama_tabel, id_data, data_lama)
  VALUES ('AFTER DELETE', 'produk_supplier', OLD.id_produk, CONCAT('ID Produk: ', OLD.id_produk, ', ID Supplier: ', OLD.id_supplier));
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `supplier`
--

CREATE TABLE `supplier` (
  `id_supplier` int(11) NOT NULL,
  `nama_supplier` varchar(100) DEFAULT NULL,
  `kontak_supplier` varchar(100) DEFAULT NULL,
  `alamat_supplier` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `supplier`
--

INSERT INTO `supplier` (`id_supplier`, `nama_supplier`, `kontak_supplier`, `alamat_supplier`) VALUES
(1, 'PT. Acer Indonesia', '08123456782', 'Jl. Industri No. 1'),
(2, 'PT. Dell Indonesia', '08123456781', 'Jl. Teknologi No. 2'),
(3, 'PT. Logitech Indonesia', '08123456780', 'Jl. Elektronika No. 3'),
(4, 'PT. Canon Indonesia', '08123456779', 'Jl. Peralatan No. 4'),
(5, 'PT. TP-Link Indonesia', '08123456778', 'Jl. Telekomunikasi No. 5'),
(6, 'PT. Microsoft Indonesia', '08123456777', 'Jl. Software No. 6'),
(7, 'PT. Kantor Indonesia', '08123456776', 'Jl. Perkantoran No. 7');

-- --------------------------------------------------------

--
-- Struktur dari tabel `transaksi`
--

CREATE TABLE `transaksi` (
  `id_transaksi` int(11) NOT NULL,
  `id_pelanggan` int(11) DEFAULT NULL,
  `id_karyawan` int(11) DEFAULT NULL,
  `tanggal_transaksi` date DEFAULT NULL,
  `total_harga` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `transaksi`
--

INSERT INTO `transaksi` (`id_transaksi`, `id_pelanggan`, `id_karyawan`, `tanggal_transaksi`, `total_harga`) VALUES
(1, 1, 1, '2023-07-01', 7000000.00),
(2, 2, 2, '2023-07-02', 8000000.00),
(3, 3, 3, '2023-07-03', 3000000.00),
(4, 4, 4, '2023-07-04', 5000000.00),
(5, 5, 5, '2023-07-05', 2500000.00),
(6, 6, 6, '2023-07-06', 1500000.00),
(7, 7, 7, '2023-07-07', 2000000.00),
(8, 2, 4, '2024-07-24', 6000000.00);

--
-- Trigger `transaksi`
--
DELIMITER $$
CREATE TRIGGER `after_insert_transaksi` AFTER INSERT ON `transaksi` FOR EACH ROW BEGIN
  INSERT INTO log_aktivitas (aksi, nama_tabel, id_data, data_baru)
  VALUES ('AFTER INSERT', 'transaksi', NEW.id_transaksi, CONCAT('ID Pelanggan: ', NEW.id_pelanggan, ', ID Karyawan: ', NEW.id_karyawan, ', Tanggal Transaksi: ', NEW.tanggal_transaksi, ', Total Harga: ', NEW.total_harga));
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `view_pelanggan_produk`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `view_pelanggan_produk` (
`id_pelanggan` int(11)
,`nama` varchar(100)
,`nama_produk` varchar(100)
,`harga` decimal(10,2)
);

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `view_produk_harga`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `view_produk_harga` (
`nama_produk` varchar(100)
,`harga` decimal(10,2)
);

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `view_terbatas_produk_harga`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `view_terbatas_produk_harga` (
`nama_produk` varchar(100)
,`harga` decimal(10,2)
);

-- --------------------------------------------------------

--
-- Struktur untuk view `view_pelanggan_produk`
--
DROP TABLE IF EXISTS `view_pelanggan_produk`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_pelanggan_produk`  AS SELECT `p`.`id_pelanggan` AS `id_pelanggan`, `p`.`nama` AS `nama`, `pr`.`nama_produk` AS `nama_produk`, `pr`.`harga` AS `harga` FROM (((`pelanggan` `p` join `transaksi` `t` on(`p`.`id_pelanggan` = `t`.`id_pelanggan`)) join `detail_transaksi` `dt` on(`t`.`id_transaksi` = `dt`.`id_transaksi`)) join `produk` `pr` on(`dt`.`id_produk` = `pr`.`id_produk`)) ;

-- --------------------------------------------------------

--
-- Struktur untuk view `view_produk_harga`
--
DROP TABLE IF EXISTS `view_produk_harga`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_produk_harga`  AS SELECT `produk`.`nama_produk` AS `nama_produk`, `produk`.`harga` AS `harga` FROM `produk` ;

-- --------------------------------------------------------

--
-- Struktur untuk view `view_terbatas_produk_harga`
--
DROP TABLE IF EXISTS `view_terbatas_produk_harga`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_terbatas_produk_harga`  AS SELECT `view_produk_harga`.`nama_produk` AS `nama_produk`, `view_produk_harga`.`harga` AS `harga` FROM `view_produk_harga` WHERE `view_produk_harga`.`harga` > 1000000WITH CASCADEDCHECK OPTION  ;

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `detail_transaksi`
--
ALTER TABLE `detail_transaksi`
  ADD PRIMARY KEY (`id_detail`),
  ADD KEY `id_transaksi` (`id_transaksi`),
  ADD KEY `id_produk` (`id_produk`);

--
-- Indeks untuk tabel `karyawan`
--
ALTER TABLE `karyawan`
  ADD PRIMARY KEY (`id_karyawan`);

--
-- Indeks untuk tabel `karyawan_detail`
--
ALTER TABLE `karyawan_detail`
  ADD PRIMARY KEY (`id_karyawan`);

--
-- Indeks untuk tabel `kategori`
--
ALTER TABLE `kategori`
  ADD PRIMARY KEY (`id_kategori`);

--
-- Indeks untuk tabel `log_aktivitas`
--
ALTER TABLE `log_aktivitas`
  ADD PRIMARY KEY (`id_log`);

--
-- Indeks untuk tabel `pelanggan`
--
ALTER TABLE `pelanggan`
  ADD PRIMARY KEY (`id_pelanggan`);

--
-- Indeks untuk tabel `produk`
--
ALTER TABLE `produk`
  ADD PRIMARY KEY (`id_produk`),
  ADD KEY `id_kategori` (`id_kategori`);

--
-- Indeks untuk tabel `produk_index`
--
ALTER TABLE `produk_index`
  ADD PRIMARY KEY (`id_produk`),
  ADD KEY `idx_nama_produk_harga` (`nama_produk`,`harga`),
  ADD KEY `idx_stok_id_kategori` (`stok`,`id_kategori`),
  ADD KEY `idx_id_kategori_nama_produk` (`id_kategori`,`nama_produk`);

--
-- Indeks untuk tabel `produk_supplier`
--
ALTER TABLE `produk_supplier`
  ADD PRIMARY KEY (`id_produk`,`id_supplier`),
  ADD KEY `id_supplier` (`id_supplier`);

--
-- Indeks untuk tabel `supplier`
--
ALTER TABLE `supplier`
  ADD PRIMARY KEY (`id_supplier`);

--
-- Indeks untuk tabel `transaksi`
--
ALTER TABLE `transaksi`
  ADD PRIMARY KEY (`id_transaksi`),
  ADD KEY `id_pelanggan` (`id_pelanggan`),
  ADD KEY `id_karyawan` (`id_karyawan`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `detail_transaksi`
--
ALTER TABLE `detail_transaksi`
  MODIFY `id_detail` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT untuk tabel `karyawan`
--
ALTER TABLE `karyawan`
  MODIFY `id_karyawan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT untuk tabel `kategori`
--
ALTER TABLE `kategori`
  MODIFY `id_kategori` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT untuk tabel `log_aktivitas`
--
ALTER TABLE `log_aktivitas`
  MODIFY `id_log` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT untuk tabel `pelanggan`
--
ALTER TABLE `pelanggan`
  MODIFY `id_pelanggan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT untuk tabel `produk`
--
ALTER TABLE `produk`
  MODIFY `id_produk` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT untuk tabel `produk_index`
--
ALTER TABLE `produk_index`
  MODIFY `id_produk` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `supplier`
--
ALTER TABLE `supplier`
  MODIFY `id_supplier` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT untuk tabel `transaksi`
--
ALTER TABLE `transaksi`
  MODIFY `id_transaksi` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `detail_transaksi`
--
ALTER TABLE `detail_transaksi`
  ADD CONSTRAINT `detail_transaksi_ibfk_1` FOREIGN KEY (`id_transaksi`) REFERENCES `transaksi` (`id_transaksi`),
  ADD CONSTRAINT `detail_transaksi_ibfk_2` FOREIGN KEY (`id_produk`) REFERENCES `produk` (`id_produk`);

--
-- Ketidakleluasaan untuk tabel `karyawan_detail`
--
ALTER TABLE `karyawan_detail`
  ADD CONSTRAINT `karyawan_detail_ibfk_1` FOREIGN KEY (`id_karyawan`) REFERENCES `karyawan` (`id_karyawan`);

--
-- Ketidakleluasaan untuk tabel `produk`
--
ALTER TABLE `produk`
  ADD CONSTRAINT `produk_ibfk_1` FOREIGN KEY (`id_kategori`) REFERENCES `kategori` (`id_kategori`);

--
-- Ketidakleluasaan untuk tabel `produk_supplier`
--
ALTER TABLE `produk_supplier`
  ADD CONSTRAINT `produk_supplier_ibfk_1` FOREIGN KEY (`id_produk`) REFERENCES `produk` (`id_produk`),
  ADD CONSTRAINT `produk_supplier_ibfk_2` FOREIGN KEY (`id_supplier`) REFERENCES `supplier` (`id_supplier`);

--
-- Ketidakleluasaan untuk tabel `transaksi`
--
ALTER TABLE `transaksi`
  ADD CONSTRAINT `transaksi_ibfk_1` FOREIGN KEY (`id_pelanggan`) REFERENCES `pelanggan` (`id_pelanggan`),
  ADD CONSTRAINT `transaksi_ibfk_2` FOREIGN KEY (`id_karyawan`) REFERENCES `karyawan` (`id_karyawan`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
