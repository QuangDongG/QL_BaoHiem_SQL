USE QL_BaoHiem;  
GO  
  
-- VIEW: 07_V_CongNo_HopDong  
CREATE OR ALTER VIEW V_CongNo_HopDong
AS
SELECT 
    HD.MaHD,
    HD.MaSoHD,
    KH.HoTen AS TenKhachHang,
    KH.SDT,
    GB.TenGoi,
    GB.PhiDinhKy,
    HD.NgayHieuLuc,
    HD.NgayHetHan,
    DATEDIFF(MONTH, HD.NgayHieuLuc, GETDATE()) AS SoThangDaDong,
    GB.PhiDinhKy * DATEDIFF(MONTH, HD.NgayHieuLuc, GETDATE()) AS SoTienPhaiDong,
    ISNULL(SUM(TT.SoTien), 0) AS SoTienDaDong,
    GB.PhiDinhKy * DATEDIFF(MONTH, HD.NgayHieuLuc, GETDATE()) - ISNULL(SUM(TT.SoTien), 0) AS SoTienConNo
FROM HOPDONG HD
INNER JOIN KHACHHANG KH ON HD.MaKH = KH.MaKH
INNER JOIN GOIBAOHIEM GB ON HD.MaGoi = GB.MaGoi
LEFT JOIN THANHTOANPHI TT ON HD.MaHD = TT.MaHD AND TT.TrangThai = N'Đã nhận'
WHERE HD.TrangThai = N'Hiệu lực'
    AND HD.NgayHieuLuc <= GETDATE()
GROUP BY HD.MaHD, HD.MaSoHD, KH.HoTen, KH.SDT, GB.TenGoi, 
         GB.PhiDinhKy, HD.NgayHieuLuc, HD.NgayHetHan
HAVING GB.PhiDinhKy * DATEDIFF(MONTH, HD.NgayHieuLuc, GETDATE()) > ISNULL(SUM(TT.SoTien), 0);
GO
