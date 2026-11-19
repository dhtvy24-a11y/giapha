USE master;
GO

-- 1. Tạo Database mới nếu chưa có
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'GiaPhaHoNguyen')
BEGIN
    CREATE DATABASE GiaPhaHoNguyen;
END
GO

USE GiaPhaHoNguyen;
GO

-- 2. Xóa các bảng cũ để làm sạch từ đầu
IF OBJECT_ID('SuKien', 'U') IS NOT NULL DROP TABLE SuKien;
IF OBJECT_ID('HonNhan', 'U') IS NOT NULL DROP TABLE HonNhan;
IF OBJECT_ID('QuanHeChaCon', 'U') IS NOT NULL DROP TABLE QuanHeChaCon;
IF OBJECT_ID('ThanhVien', 'U') IS NOT NULL DROP TABLE ThanhVien;
IF OBJECT_ID('TheHe', 'U') IS NOT NULL DROP TABLE TheHe;
IF OBJECT_ID('DongHo', 'U') IS NOT NULL DROP TABLE DongHo;
GO

-- 3. Tạo cấu trúc 6 bảng chuẩn
CREATE TABLE DongHo (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ten_dong_ho NVARCHAR(100) NOT NULL,
    mo_ta NVARCHAR(MAX)
);

CREATE TABLE TheHe (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ten_the_he NVARCHAR(50) NOT NULL,
    mo_ta NVARCHAR(255)
);

CREATE TABLE ThanhVien (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ho_ten NVARCHAR(100) NOT NULL,
    gioi_tinh NVARCHAR(10) NOT NULL,
    ngay_sinh DATE,
    ngay_mat DATE,
    trang_thai NVARCHAR(50) DEFAULT (N'Còn sống'),
    dong_ho_id INT FOREIGN KEY REFERENCES DongHo(id),
    the_he_id INT FOREIGN KEY REFERENCES TheHe(id)
);

CREATE TABLE QuanHeChaCon (
    id INT IDENTITY(1,1) PRIMARY KEY,
    cha_id INT FOREIGN KEY REFERENCES ThanhVien(id),
    me_id INT FOREIGN KEY REFERENCES ThanhVien(id) NULL,
    con_id INT FOREIGN KEY REFERENCES ThanhVien(id)
);

CREATE TABLE HonNhan (
    id INT IDENTITY(1,1) PRIMARY KEY,
    chong_id INT FOREIGN KEY REFERENCES ThanhVien(id),
    vo_id INT FOREIGN KEY REFERENCES ThanhVien(id),
    ngay_cuoi DATE,
    trang_thai NVARCHAR(50) DEFAULT (N'Đang kết hôn')
);

CREATE TABLE SuKien (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ten_su_kien NVARCHAR(150) NOT NULL,
    ngay_dien_ra DATE,
    dia_diem NVARCHAR(255),
    noi_dung NVARCHAR(MAX),
    thanh_vien_lien_quan INT FOREIGN KEY REFERENCES ThanhVien(id) NULL
);
GO

-- 4. Nạp Dữ Liệu Mẫu
INSERT INTO DongHo (ten_dong_ho, mo_ta) VALUES (N'Tộc Họ Nguyễn', N'Gia phả dòng họ Nguyễn gốc');

INSERT INTO TheHe (ten_the_he, mo_ta) VALUES 
(N'Đời 1', N'Thế hệ Cụ Tổ'),
(N'Đời 2', N'Thế hệ thứ hai'),
(N'Đời 3', N'Thế hệ thứ ba'),
(N'Đời 4', N'Thế hệ thứ tư'),
(N'Đời 5', N'Thế hệ thứ năm');

-- Nạp đúng chuẩn 17 Thành Viên khớp từng ID trên hình (13 Nam, 4 Nữ)[cite: 11]
-- Đời 1 (ID 1)[cite: 11]
INSERT INTO ThanhVien (ho_ten, gioi_tinh, ngay_sinh, trang_thai, dong_ho_id, the_he_id) VALUES 
(N'Nguyễn Văn An', N'Nam', '1990-01-01', N'Còn sống', 1, 1); -- ID 1[cite: 11]

-- Đời 2 (ID 2, 3, 4)[cite: 11]
INSERT INTO ThanhVien (ho_ten, gioi_tinh, ngay_sinh, trang_thai, dong_ho_id, the_he_id) VALUES 
(N'Nguyễn Văn Bình', N'Nam', '1993-01-01', N'Còn sống', 1, 2),   -- ID 2[cite: 11]
(N'Nguyễn Văn Cường', N'Nam', '1960-01-01', N'Còn sống', 1, 2),   -- ID 3[cite: 11]
(N'Nguyễn Thị Dung', N'Nữ', '1965-01-01', N'Còn sống', 1, 2);    -- ID 4[cite: 11]

-- Đời 3 (ID 5, 6, 7, 8)[cite: 11]
INSERT INTO ThanhVien (ho_ten, gioi_tinh, ngay_sinh, trang_thai, dong_ho_id, the_he_id) VALUES 
(N'Nguyễn Văn Dũng', N'Nam', '1980-01-01', N'Còn sống', 1, 3),   -- ID 5[cite: 11]
(N'Nguyễn Thị Hoa', N'Nữ', '1983-01-01', N'Còn sống', 1, 3),    -- ID 6[cite: 11]
(N'Nguyễn Văn Giang', N'Nam', '1985-01-01', N'Còn sống', 1, 3),  -- ID 7[cite: 11]
(N'Nguyễn Văn Hải', N'Nam', '1988-01-01', N'Còn sống', 1, 3);   -- ID 8[cite: 11]

-- Đời 4 (ID 9, 10, 11, 12, 13, 14)[cite: 11]
INSERT INTO ThanhVien (ho_ten, gioi_tinh, ngay_sinh, trang_thai, dong_ho_id, the_he_id) VALUES 
(N'Nguyễn Văn Khôi', N'Nam', '2005-01-01', N'Còn sống', 1, 4),    -- ID 9[cite: 11]
(N'Nguyễn Minh Khánh', N'Nam', '2008-01-01', N'Còn sống', 1, 4),  -- ID 10[cite: 11]
(N'Nguyễn Thanh Tùng', N'Nam', '2010-01-01', N'Còn sống', 1, 4),  -- ID 11[cite: 11]
(N'Nguyễn Thảo Nhi', N'Nữ', '2012-01-01', N'Còn sống', 1, 4),    -- ID 12[cite: 11]
(N'Nguyễn Hoàng Nam', N'Nam', '2016-11-11', N'Còn sống', 1, 4),  -- ID 13[cite: 11]
(N'Nguyễn Tuấn Kiệt', N'Nam', '2018-10-12', N'Còn sống', 1, 4);  -- ID 14 (Sửa lại ID 14 theo vị trí trên hình)[cite: 11]

-- Đời 5 (ID 15, 16, 17)[cite: 11]
INSERT INTO ThanhVien (ho_ten, gioi_tinh, ngay_sinh, trang_thai, dong_ho_id, the_he_id) VALUES 
(N'Nguyễn Văn Bảo', N'Nam', '2024-03-14', N'Còn sống', 1, 5),    -- ID 15[cite: 11]
(N'Nguyễn Ngọc Anh', N'Nữ', '2025-03-30', N'Còn sống', 1, 5),    -- ID 16[cite: 11]
(N'Nguyễn Gia Hưng', N'Nam', '2025-01-01', N'Còn sống', 1, 5);  -- ID 17[cite: 11]
GO

-- 5. Thiết lập Quan hệ Cha - Con khớp chuẩn hình sơ đồ
INSERT INTO QuanHeChaCon (cha_id, me_id, con_id) VALUES 
-- Cụ An (ID 1) sinh ra Đời 2[cite: 11]
(1, NULL, 2),  -- Bình (ID 2)[cite: 11]
(1, NULL, 3),  -- Cường (ID 3)[cite: 11]
(1, NULL, 4),  -- Dung (ID 4)[cite: 11]

-- Bình (ID 2) sinh ra Đời 3[cite: 11]
(2, NULL, 5),  -- Dũng (ID 5)[cite: 11]
(2, NULL, 6),  -- Hoa (ID 6)[cite: 11]

-- Cường (ID 3) sinh ra Đời 3[cite: 11]
(3, NULL, 7),  -- Giang (ID 7)[cite: 11]
(3, NULL, 8),  -- Hải (ID 8)[cite: 11]

-- Dũng (ID 5) sinh ra Đời 4[cite: 11]
(5, NULL, 9),  -- Khôi (ID 9)[cite: 11]
(5, NULL, 10), -- Minh Khánh (ID 10)[cite: 11]

-- Hoa (ID 6) sinh ra Đời 4[cite: 11]
(6, NULL, 11), -- Thanh Tùng (ID 11)[cite: 11]
(6, NULL, 12), -- Thảo Nhi (ID 12)[cite: 11]

-- Giang (ID 7) sinh ra Đời 4[cite: 11]
(7, NULL, 13), -- Hoàng Nam (ID 13)[cite: 11]

-- Hải (ID 8) sinh ra Đời 4 (hoặc Đời 5 tương ứng)[cite: 11]
(8, NULL, 14), -- Tuấn Kiệt (ID 14)[cite: 11]

-- Khôi (ID 9) sinh ra Đời 5[cite: 11]
(9, NULL, 15), -- Văn Bảo (ID 15)[cite: 11]
(9, NULL, 16), -- Ngọc Anh (ID 16)[cite: 11]

-- Thanh Tùng (ID 11) sinh ra Đời 5[cite: 11]
(11, NULL, 17); -- Gia Hưng (ID 17)[cite: 11]
GO
USE GiaPhaHoNguyen;
GO

-- 1. Thêm các thành viên mới để mở rộng nhánh phả hệ và đa dạng hóa tìm kiếm
-- Đời 2 (Thêm cô con gái: Nguyễn Thị Mai)
INSERT INTO ThanhVien (ho_ten, gioi_tinh, ngay_sinh, trang_thai, dong_ho_id, the_he_id) 
VALUES (N'Nguyễn Thị Mai', N'Nữ', '1968-06-15', N'Còn sống', 1, 2);

-- Đời 3 (Thêm con của Bình/Cường: Nguyễn Văn Hoàng, Nguyễn Thị Ngọc)
INSERT INTO ThanhVien (ho_ten, gioi_tinh, ngay_sinh, trang_thai, dong_ho_id, the_he_id) VALUES 
(N'Nguyễn Văn Hoàng', N'Nam', '1992-09-10', N'Còn sống', 1, 3),
(N'Nguyễn Thị Ngọc', N'Nữ', '1995-12-20', N'Còn sống', 1, 3);

-- Đời 4 (Thêm con cháu ở các nhánh: Nguyễn Văn Long, Nguyễn Thị Phượng)
INSERT INTO ThanhVien (ho_ten, gioi_tinh, ngay_sinh, trang_thai, dong_ho_id, the_he_id) VALUES 
(N'Nguyễn Văn Long', N'Nam', '2011-03-05', N'Còn sống', 1, 4),
(N'Nguyễn Thị Phượng', N'Nữ', '2014-08-18', N'Còn sống', 1, 4);

-- Đời 5 (Thêm chắt: Nguyễn Văn Phúc)
INSERT INTO ThanhVien (ho_ten, gioi_tinh, ngay_sinh, trang_thai, dong_ho_id, the_he_id) 
VALUES (N'Nguyễn Văn Phúc', N'Nam', '2026-02-10', N'Còn sống', 1, 5);
GO

-- 2. Móc nối quan hệ cha con cho các thành viên mới vừa thêm
-- Lấy ID tự động liên kết (Giả sử các ID mới tiếp nối theo thứ tự tăng dần)
DECLARE @An INT = (SELECT id FROM ThanhVien WHERE ho_ten = N'Nguyễn Văn An');
DECLARE @Binh INT = (SELECT id FROM ThanhVien WHERE ho_ten = N'Nguyễn Văn Bình');
DECLARE @Mai INT = (SELECT id FROM ThanhVien WHERE ho_ten = N'Nguyễn Thị Mai');
DECLARE @Hoang INT = (SELECT id FROM ThanhVien WHERE ho_ten = N'Nguyễn Văn Hoàng');
DECLARE @Ngoc INT = (SELECT id FROM ThanhVien WHERE ho_ten = N'Nguyễn Thị Ngọc');
DECLARE @Long INT = (SELECT id FROM ThanhVien WHERE ho_ten = N'Nguyễn Văn Long');
DECLARE @Phuong INT = (SELECT id FROM ThanhVien WHERE ho_ten = N'Nguyễn Thị Phượng');
DECLARE @Phuc INT = (SELECT id FROM ThanhVien WHERE ho_ten = N'Nguyễn Văn Phúc');

-- Cụ An sinh thêm cô Mai (Đời 2)
INSERT INTO QuanHeChaCon (cha_id, con_id) VALUES (@An, @Mai);

-- Bình sinh thêm Hoàng và Ngọc (Đời 3 - là anh chị em ruột với Dũng và Hoa để test tính năng tìm anh em)
INSERT INTO QuanHeChaCon (cha_id, con_id) VALUES 
(@Binh, @Hoang),
(@Binh, @Ngoc);

-- Hoàng sinh ra Long (Đời 4)
INSERT INTO QuanHeChaCon (cha_id, con_id) VALUES (@Hoang, @Long);

-- Ngọc sinh ra Phượng (Đời 4)
INSERT INTO QuanHeChaCon (cha_id, con_id) VALUES (@Ngoc, @Phuong);

-- Long sinh ra Phúc (Đời 5)
INSERT INTO QuanHeChaCon (cha_id, con_id) VALUES (@Long, @Phuc);
GO

-- 3. Kiểm tra lại toàn bộ danh sách thành viên sau khi mở rộng
SELECT tv.id, tv.ho_ten, tv.gioi_tinh, th.ten_the_he 
FROM ThanhVien tv
JOIN TheHe th ON tv.the_he_id = th.id
ORDER BY tv.id ASC;
GO