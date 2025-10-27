CREATE TABLE LOAIBAOHIEM(
    MaLoai INT IDENTITY(1,1) PRIMARY KEY,
    TenLoai NVARCHAR(100) NOT NULL UNIQUE,   -- Tên loại bảo hiểm (Y tế, Nhân thọ, Tài sản)
    MoTa NVARCHAR(255)                       -- Mô tả chi tiết về loại bảo hiểm
);