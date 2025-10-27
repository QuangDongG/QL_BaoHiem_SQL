<<<<<<< HEAD
USE QL_BaoHiem;  
GO  
  
-- VIEW: 18_V_Top_KhachHang_DoanhThu  
CREATE OR ALTER VIEW V_Top_KhachHang_DoanhThu
AS
SELECT
    KH.MaKH,
    KH.HoTen,
    KH.SDT,
    KH.Email,
    COUNT(DISTINCT HD.MaHD) AS SoHopDong,
    SUM(TT.SoTien) AS TongDoanhThu,
    AVG(TT.SoTien) AS DoanhThuTrungBinh
FROM KHACHHANG KH
INNER JOIN HOPDONG HD ON KH.MaKH = HD.MaKH
INNER JOIN THANHTOANPHI TT ON HD.MaHD = TT.MaHD
WHERE TT.TrangThai = N'Đã nhận'
GROUP BY KH.MaKH, KH.HoTen, KH.SDT, KH.Email
GO
=======
USE QL_BaoHiem;  
GO  
  
-- VIEW: 18_V_Top_KhachHang_DoanhThu  
CREATE OR ALTER VIEW V_Top_KhachHang_DoanhThu
AS
SELECT
    KH.MaKH,
    KH.HoTen,
    KH.SDT,
    KH.Email,
    COUNT(DISTINCT HD.MaHD) AS SoHopDong,
    SUM(TT.SoTien) AS TongDoanhThu,
    AVG(TT.SoTien) AS DoanhThuTrungBinh
FROM KHACHHANG KH
INNER JOIN HOPDONG HD ON KH.MaKH = HD.MaKH
INNER JOIN THANHTOANPHI TT ON HD.MaHD = TT.MaHD
WHERE TT.TrangThai = N'Đã nhận'
GROUP BY KH.MaKH, KH.HoTen, KH.SDT, KH.Email
GO
>>>>>>> 59c5acf48653319ce8c913c2014f62e09ddfb835
