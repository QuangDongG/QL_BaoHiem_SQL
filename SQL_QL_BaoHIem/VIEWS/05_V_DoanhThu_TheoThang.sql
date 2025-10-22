USE QL_BaoHiem;  
GO  
  
-- VIEW: 05_V_DoanhThu_TheoThang  
CREATE OR ALTER VIEW V_DoanhThu_TheoThang
AS
SELECT 
    YEAR(TT.NgayTT) AS Nam,
    MONTH(TT.NgayTT) AS Thang,
    COUNT(TT.MaTT) AS SoGiaoDich,
    SUM(TT.SoTien) AS TongDoanhThu,
    AVG(TT.SoTien) AS DoanhThuTrungBinh,
    MAX(TT.SoTien) AS GiaoDichLonNhat,
    MIN(TT.SoTien) AS GiaoDichNhoNhat
FROM THANHTOANPHI TT
WHERE TT.TrangThai = N'Đã nhận'
GROUP BY YEAR(TT.NgayTT), MONTH(TT.NgayTT);
GO

