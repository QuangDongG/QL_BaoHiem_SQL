CREATE TABLE HINHTHUC_THANHTOAN(
    MaHT INT IDENTITY(1,1) PRIMARY KEY,
    TenHT NVARCHAR(100) NOT NULL UNIQUE,     -- Tên hình thức: Tiền mặt, Chuyển khoản, Ví điện tử
    MoTa NVARCHAR(255) 
);