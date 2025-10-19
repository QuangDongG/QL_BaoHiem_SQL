CREATE TABLE NHANVIEN(
    MaNV INT IDENTITY(1,1) PRIMARY KEY,
    HoTen NVARCHAR(120) NOT NULL,
    GioiTinh NCHAR(3) CHECK(GioiTinh IN (N'Nam', N'Nữ', N'Khác')),
    NgaySinh DATE,
    SDT VARCHAR(20),
    Email VARCHAR(150) UNIQUE,
    DiaChi NVARCHAR(255),
    ChucVu NVARCHAR(100),
    Luong DECIMAL(18,2) CHECK(Luong >= 0),
    MaPhong INT,
    FOREIGN KEY (MaPhong) REFERENCES PHONGBAN(MaPhong)
);