--MEMBUAT DATABASE
CREATE DATABASE perpustakaan_v2;
USE perpustakaan_v2;


-- MEMBUAT TABEL
-- Struktur Tabel Kategori Buku
CREATE TABLE kategori_buku (
    id_kategori INT AUTO_INCREMENT PRIMARY KEY,
    nama_kategori VARCHAR(50) NOT NULL UNIQUE,
    deskripsi TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Struktur Tabel Penerbit
CREATE TABLE penerbit (
    id_penerbit INT AUTO_INCREMENT PRIMARY KEY,
    nama_penerbit VARCHAR(100) NOT NULL,
    alamat TEXT,
    telepon VARCHAR(15),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--Struktur Tabel Buku
CREATE TABLE buku (
    id_buku INT AUTO_INCREMENT PRIMARY KEY,
    kode_buku VARCHAR(20) UNIQUE NOT NULL,
    judul VARCHAR(200) NOT NULL,

    id_kategori INT NOT NULL,
    id_penerbit INT NOT NULL,

    pengarang VARCHAR(100) NOT NULL,
    tahun_terbit INT NOT NULL,
    isbn VARCHAR(20),
    harga DECIMAL(10,2) NOT NULL,
    stok INT NOT NULL DEFAULT 0,
    deskripsi TEXT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (id_kategori) REFERENCES kategori_buku(id_kategori),
    FOREIGN KEY (id_penerbit) REFERENCES penerbit(id_penerbit)
);



--Bonus Tabel Rak
CREATE TABLE rak (
    id_rak INT AUTO_INCREMENT PRIMARY KEY,
    nama_rak VARCHAR(50) NOT NULL,
    lokasi VARCHAR(100)
);

-- Insert Data Rak
INSERT INTO rak (nama_rak, lokasi) VALUES
('Rak A', 'Lantai 1'),
('Rak B', 'Lantai 1'),
('Rak C', 'Lantai 2'),
('Rak D', 'Lantai 2'),
('Rak E', 'Lantai 3');


-- Bonus Soft Delete di semua Tabel
ALTER TABLE kategori_buku ADD COLUMN is_deleted BOOLEAN DEFAULT FALSE;
ALTER TABLE penerbit ADD COLUMN is_deleted BOOLEAN DEFAULT FALSE;
ALTER TABLE buku ADD COLUMN is_deleted BOOLEAN DEFAULT FALSE;
ALTER TABLE rak ADD COLUMN is_deleted BOOLEAN DEFAULT FALSE;

--Bonus Stored Procedure
DELIMITER //

CREATE PROCEDURE tambah_buku (
    IN p_kode VARCHAR(20),
    IN p_judul VARCHAR(200),
    IN p_kategori INT,
    IN p_penerbit INT,
    IN p_pengarang VARCHAR(100),
    IN p_tahun INT,
    IN p_harga DECIMAL(10,2),
    IN p_stok INT
)
BEGIN
    INSERT INTO buku (
        kode_buku, judul, id_kategori, id_penerbit,
        pengarang, tahun_terbit, harga, stok
    )
    VALUES (
        p_kode, p_judul, p_kategori, p_penerbit,
        p_pengarang, p_tahun, p_harga, p_stok
    );
END //

DELIMITER ;



-- INSERT DATA
--5 Kategori Buku
INSERT INTO kategori_buku (nama_kategori, deskripsi) VALUES
('Programming', 'Buku pemrograman'),
('Database', 'Buku database'),
('Web Design', 'Desain web'),
('Networking', 'Jaringan komputer'),
('Mobile Development', 'Pengembangan aplikasi mobile');

-- 5 Penerbit
INSERT INTO penerbit (nama_penerbit, alamat, telepon, email) VALUES
('Informatika', 'Jogja', '088789467382', 'info@informatika.com'),
('kaveci', 'Pekalongan', '087991883883', 'info@kaveci.com'),
('Gramedia', 'Jakarta', '088165738292', 'info@gramedia.com'),
('Graha Ilmu', 'Yogyakarta', '085678893773', 'info@grahailmu.com'),
('MykoooReserve', 'Pekalongan', '081787799975', 'info@mykooo.com');

-- 15 Buku
INSERT INTO buku 
(kode_buku, judul, id_kategori, id_penerbit, pengarang, tahun_terbit, harga, stok)
VALUES
('BK-001','PHP Dasar',1,1,'Budi Raharjo',2023,90000,10),
('BK-002','MySQL Lanjut',2,4,'Andi Nugroho',2022,110000,8),
('BK-003','Laravel Advanced',1,1,'Siti Aminah',2024,130000,12),
('BK-004','UI/UX Design',3,5,'Dedi Santoso',2023,95000,7),
('BK-005','Jaringan Komputer',4,2,'Ahmad Yani',2021,100000,5),
('BK-006','React Native',5,1,'Rina Putri',2024,140000,9),
('BK-007','PostgreSQL',2,4,'Rudi Hartono',2023,115000,6),
('BK-008','HTML CSS',3,3,'Dina Sari',2022,80000,15),
('BK-009','Android Development',5,5,'Rizky',2024,150000,4),
('BK-010','Cyber Security',4,2,'Agus Salim',2023,120000,3),
('BK-011','Java Programming',1,3,'Fajar',2022,105000,11),
('BK-012','Data Mining',2,1,'Nina',2023,125000,6),
('BK-013','Bootstrap Design',3,5,'Sari',2024,85000,8),
('BK-014','Cloud Networking',4,2,'Bambang',2023,135000,5),
('BK-015','Flutter Mobile',5,1,'Andi Wijaya',2024,145000,7);



-- QUERY
-- Tampilkan buku dengan kategori dan penerbit
SELECT 
    b.judul,
    k.nama_kategori,
    p.nama_penerbit,
    b.harga,
    b.stok
FROM buku b
JOIN kategori_buku k ON b.id_kategori = k.id_kategori
JOIN penerbit p ON b.id_penerbit = p.id_penerbit;

-- Jumlah buku per kategori
SELECT 
    k.nama_kategori,
    COUNT(b.id_buku) AS jumlah_buku
FROM buku b
JOIN kategori_buku k ON b.id_kategori = k.id_kategori
GROUP BY k.nama_kategori;

-- Jumlah buku per penerbit
SELECT 
    p.nama_penerbit,
    COUNT(b.id_buku) AS jumlah_buku
FROM buku b
JOIN penerbit p ON b.id_penerbit = p.id_penerbit
GROUP BY p.nama_penerbit;

-- Detail lengkap buku (kategori + penerbit)
SELECT 
    b.kode_buku,
    b.judul,
    b.pengarang,
    b.tahun_terbit,
    b.harga,
    b.stok,
    k.nama_kategori,
    p.nama_penerbit
FROM buku b
JOIN kategori_buku k ON b.id_kategori = k.id_kategori
JOIN penerbit p ON b.id_penerbit = p.id_penerbit;