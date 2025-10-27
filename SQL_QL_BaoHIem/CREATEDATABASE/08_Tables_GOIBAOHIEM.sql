CREATE TABLE GOIBAOHIEM(
    MaGoi INT IDENTITY(1,1) PRIMARY KEY,
    MaLoai INT NOT NULL,
    TenGoi NVARCHAR(150) NOT NULL UNIQUE,
    PhiDinhKy DECIMAL(18,2) CHECK(PhiDinhKy >= 0),      -- Phí khách hàng đóng theo kỳ
    SoTienBaoHiem DECIMAL(18,2) CHECK(SoTienBaoHiem >= 0), -- Giá trị bảo hiểm
    ThoiHanThang INT CHECK(ThoiHanThang > 0),           -- Thời hạn hợp đồng
    DieuKien NVARCHAR(255),                             -- Điều kiện tham gia
    QuyenLoi NVARCHAR(255),                             -- Quyền lợi chính
    FOREIGN KEY (MaLoai) REFERENCES LOAIBAOHIEM(MaLoai)
);