USE QL_BaoHiem;  
GO  
  
-- VIEW: 06_V_DoanhThu_TheoLoaiBaoHiem  
CREATE OR ALTER VIEW V_DoanhThu_TheoLoaiBaoHiem
AS
SELECT 
    LBH.MaLoai,
    LBH.TenLoai,
    COUNT(DISTINCT HD.MaHD) AS SoHopDong,
    COUNT(DISTINCT HD.MaKH) AS SoKhachHang,
    SUM(TT.SoTien) AS TongDoanhThu,
    AVG(TT.SoTien) AS DoanhThuTrungBinh
FROM LOAIBAOHIEM LBH
INNER JOIN GOIBAOHIEM GB ON LBH.MaLoai = GB.MaLoai
INNER JOIN HOPDONG HD ON GB.MaGoi = HD.MaGoi
LEFT JOIN THANHTOANPHI TT ON HD.MaHD = TT.MaHD
WHERE TT.TrangThai = N'Đã nhận' OR TT.TrangThai IS NULL
GROUP BY LBH.MaLoai, LBH.TenLoai;
GO
