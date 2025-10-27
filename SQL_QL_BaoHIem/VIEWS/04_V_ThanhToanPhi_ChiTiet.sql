<<<<<<< HEAD
USE QL_BaoHiem;  
GO  
  
-- VIEW: 04_V_ThanhToanPhi_ChiTiet  
CREATE OR ALTER VIEW V_ThanhToanPhi_ChiTiet
AS
SELECT 
    TT.MaTT,
    TT.MaGiaoDich,
    HD.MaHD,
    HD.MaSoHD,
    KH.HoTen AS TenKhachHang,
    GB.TenGoi,
    TT.NgayTT,
    TT.SoTien,
    HT.TenHT AS HinhThucThanhToan,
    NV.HoTen AS NhanVienThu,
    TT.TrangThai,
    YEAR(TT.NgayTT) AS Nam,
    MONTH(TT.NgayTT) AS Thang
FROM THANHTOANPHI TT
INNER JOIN HOPDONG HD ON TT.MaHD = HD.MaHD
INNER JOIN KHACHHANG KH ON HD.MaKH = KH.MaKH
INNER JOIN GOIBAOHIEM GB ON HD.MaGoi = GB.MaGoi
INNER JOIN HINHTHUC_THANHTOAN HT ON TT.MaHT = HT.MaHT
LEFT JOIN NHANVIEN NV ON TT.MaNV_Thu = NV.MaNV;
GO
=======
USE QL_BaoHiem;  
GO  
  
-- VIEW: 04_V_ThanhToanPhi_ChiTiet  
CREATE OR ALTER VIEW V_ThanhToanPhi_ChiTiet
AS
SELECT 
    TT.MaTT,
    TT.MaGiaoDich,
    HD.MaHD,
    HD.MaSoHD,
    KH.HoTen AS TenKhachHang,
    GB.TenGoi,
    TT.NgayTT,
    TT.SoTien,
    HT.TenHT AS HinhThucThanhToan,
    NV.HoTen AS NhanVienThu,
    TT.TrangThai,
    YEAR(TT.NgayTT) AS Nam,
    MONTH(TT.NgayTT) AS Thang
FROM THANHTOANPHI TT
INNER JOIN HOPDONG HD ON TT.MaHD = HD.MaHD
INNER JOIN KHACHHANG KH ON HD.MaKH = KH.MaKH
INNER JOIN GOIBAOHIEM GB ON HD.MaGoi = GB.MaGoi
INNER JOIN HINHTHUC_THANHTOAN HT ON TT.MaHT = HT.MaHT
LEFT JOIN NHANVIEN NV ON TT.MaNV_Thu = NV.MaNV;
GO
>>>>>>> 59c5acf48653319ce8c913c2014f62e09ddfb835
