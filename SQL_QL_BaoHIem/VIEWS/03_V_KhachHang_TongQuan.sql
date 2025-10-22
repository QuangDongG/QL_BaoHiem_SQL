USE QL_BaoHiem;  
GO  
  
-- VIEW: 03_V_KhachHang_TongQuan  
CREATE OR ALTER VIEW V_KhachHang_TongQuan
AS
SELECT 
    KH.MaKH,
    KH.HoTen,
    KH.NgaySinh,
    KH.GioiTinh,
    KH.CCCD,
    KH.SDT,
    KH.Email,
    KH.NgheNghiep,
    KH.ThuNhap,
    COUNT(DISTINCT HD.MaHD) AS SoHopDong,
    COUNT(DISTINCT CASE WHEN HD.TrangThai = N'Hiệu lực' THEN HD.MaHD END) AS SoHD_HieuLuc,
    COUNT(DISTINCT CASE WHEN HD.TrangThai = N'Hết hạn' THEN HD.MaHD END) AS SoHD_HetHan,
    MAX(HD.NgayKy) AS NgayKyGanNhat
FROM KHACHHANG KH
LEFT JOIN HOPDONG HD ON KH.MaKH = HD.MaKH
GROUP BY KH.MaKH, KH.HoTen, KH.NgaySinh, KH.GioiTinh, 
         KH.CCCD, KH.SDT, KH.Email, KH.NgheNghiep, KH.ThuNhap;
GO