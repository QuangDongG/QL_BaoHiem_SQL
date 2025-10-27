USE QL_BaoHiem;  
GO  
  
-- VIEW: 17_V_TongQuan_HeThong  
CREATE OR ALTER VIEW V_TongQuan_HeThong
AS
SELECT 
    (SELECT COUNT(*) FROM KHACHHANG) AS TongKhachHang,
    (SELECT COUNT(*) FROM HOPDONG WHERE TrangThai = N'Hiệu lực') AS HopDongHieuLuc,
    (SELECT COUNT(*) FROM HOPDONG) AS TongHopDong,
    (SELECT COUNT(*) FROM NHANVIEN) AS TongNhanVien,
    (SELECT SUM(SoTien) FROM THANHTOANPHI WHERE TrangThai = N'Đã nhận') AS TongDoanhThu,
    (SELECT COUNT(*) FROM YEUCAUBOITHUONG) AS TongYeuCauBoiThuong,
    (SELECT SUM(SoTienChi) FROM CHITRABOITHUONG) AS TongTienBoiThuong;
GO
