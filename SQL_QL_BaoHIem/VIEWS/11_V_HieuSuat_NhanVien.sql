<<<<<<< HEAD
USE QL_BaoHiem;  
GO  
  
-- VIEW: 11_V_HieuSuat_NhanVien  
CREATE OR ALTER VIEW V_HieuSuat_NhanVien
AS
SELECT 
    NV.MaNV,
    NV.HoTen,
    NV.ChucVu,
    PB.TenPhong,
    COUNT(DISTINCT HD.MaHD) AS SoHopDongTuVan,
    COUNT(DISTINCT CASE WHEN HD.TrangThai = N'Hiệu lực' THEN HD.MaHD END) AS SoHD_HieuLuc,
    SUM(TT.SoTien) AS TongDoanhThu,
    AVG(TT.SoTien) AS DoanhThuTrungBinh
FROM NHANVIEN NV
LEFT JOIN PHONGBAN PB ON NV.MaPhong = PB.MaPhong
LEFT JOIN HOPDONG HD ON NV.MaNV = HD.MaNV_TuVan
LEFT JOIN THANHTOANPHI TT ON HD.MaHD = TT.MaHD AND TT.TrangThai = N'Đã nhận'
GROUP BY NV.MaNV, NV.HoTen, NV.ChucVu, PB.TenPhong;
GO

=======
USE QL_BaoHiem;  
GO  
  
-- VIEW: 11_V_HieuSuat_NhanVien  
CREATE OR ALTER VIEW V_HieuSuat_NhanVien
AS
SELECT 
    NV.MaNV,
    NV.HoTen,
    NV.ChucVu,
    PB.TenPhong,
    COUNT(DISTINCT HD.MaHD) AS SoHopDongTuVan,
    COUNT(DISTINCT CASE WHEN HD.TrangThai = N'Hiệu lực' THEN HD.MaHD END) AS SoHD_HieuLuc,
    SUM(TT.SoTien) AS TongDoanhThu,
    AVG(TT.SoTien) AS DoanhThuTrungBinh
FROM NHANVIEN NV
LEFT JOIN PHONGBAN PB ON NV.MaPhong = PB.MaPhong
LEFT JOIN HOPDONG HD ON NV.MaNV = HD.MaNV_TuVan
LEFT JOIN THANHTOANPHI TT ON HD.MaHD = TT.MaHD AND TT.TrangThai = N'Đã nhận'
GROUP BY NV.MaNV, NV.HoTen, NV.ChucVu, PB.TenPhong;
GO

>>>>>>> 59c5acf48653319ce8c913c2014f62e09ddfb835
