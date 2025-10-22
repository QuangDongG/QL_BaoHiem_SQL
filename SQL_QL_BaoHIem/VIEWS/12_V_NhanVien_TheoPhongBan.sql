USE QL_BaoHiem;  
GO  
  
-- VIEW: 12_V_NhanVien_TheoPhongBan  
CREATE OR ALTER VIEW V_NhanVien_TheoPhongBan
AS
SELECT 
    PB.MaPhong,
    PB.TenPhong,
    COUNT(NV.MaNV) AS SoNhanVien,
    AVG(NV.Luong) AS LuongTrungBinh,
    SUM(NV.Luong) AS TongLuong
FROM PHONGBAN PB
LEFT JOIN NHANVIEN NV ON PB.MaPhong = NV.MaPhong
GROUP BY PB.MaPhong, PB.TenPhong;
GO
