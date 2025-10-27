<<<<<<< HEAD
USE QL_BaoHiem;  
GO  
  
-- VIEW: 02_V_HopDongSapHetHan  
CREATE OR ALTER VIEW V_HopDongSapHetHan
AS
SELECT 
    HD.MaHD,
    HD.MaSoHD,
    KH.HoTen AS TenKhachHang,
    KH.SDT,
    KH.Email,
    GB.TenGoi,
    HD.NgayHetHan,
    DATEDIFF(DAY, GETDATE(), HD.NgayHetHan) AS SoNgayConLai,
    HD.TrangThai
FROM HOPDONG HD
INNER JOIN KHACHHANG KH ON HD.MaKH = KH.MaKH
INNER JOIN GOIBAOHIEM GB ON HD.MaGoi = GB.MaGoi
WHERE HD.NgayHetHan BETWEEN GETDATE() AND DATEADD(DAY, 30, GETDATE())
    AND HD.TrangThai = N'Hiệu lực';
=======
USE QL_BaoHiem;  
GO  
  
-- VIEW: 02_V_HopDongSapHetHan  
CREATE OR ALTER VIEW V_HopDongSapHetHan
AS
SELECT 
    HD.MaHD,
    HD.MaSoHD,
    KH.HoTen AS TenKhachHang,
    KH.SDT,
    KH.Email,
    GB.TenGoi,
    HD.NgayHetHan,
    DATEDIFF(DAY, GETDATE(), HD.NgayHetHan) AS SoNgayConLai,
    HD.TrangThai
FROM HOPDONG HD
INNER JOIN KHACHHANG KH ON HD.MaKH = KH.MaKH
INNER JOIN GOIBAOHIEM GB ON HD.MaGoi = GB.MaGoi
WHERE HD.NgayHetHan BETWEEN GETDATE() AND DATEADD(DAY, 30, GETDATE())
    AND HD.TrangThai = N'Hiệu lực';
>>>>>>> 59c5acf48653319ce8c913c2014f62e09ddfb835
GO