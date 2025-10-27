USE QL_BaoHiem;  
GO  
  
-- VIEW: 19_V_GoiBaoHiem_PhoBien  
CREATE OR ALTER VIEW V_GoiBaoHiem_PhoBien
AS
SELECT 
    GB.MaGoi,
    GB.TenGoi,
    LBH.TenLoai,
    GB.PhiDinhKy,
    GB.SoTienBaoHiem,
    GB.ThoiHanThang,
    COUNT(HD.MaHD) AS SoHopDong,
    COUNT(CASE WHEN HD.TrangThai = N'Hiệu lực' THEN 1 END) AS SoHD_HieuLuc,
    SUM(TT.SoTien) AS TongDoanhThu
FROM GOIBAOHIEM GB
INNER JOIN LOAIBAOHIEM LBH ON GB.MaLoai = LBH.MaLoai
LEFT JOIN HOPDONG HD ON GB.MaGoi = HD.MaGoi
LEFT JOIN THANHTOANPHI TT ON HD.MaHD = TT.MaHD AND TT.TrangThai = N'Đã nhận'
GROUP BY GB.MaGoi, GB.TenGoi, LBH.TenLoai, GB.PhiDinhKy, 
         GB.SoTienBaoHiem, GB.ThoiHanThang;
GO
