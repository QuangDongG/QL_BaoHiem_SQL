USE QL_BaoHiem;  
GO  
  
-- VIEW: 10_V_ChiTraBoiThuong_ChiTiet  
CREATE OR ALTER VIEW V_ChiTraBoiThuong_ChiTiet
AS
SELECT 
    CT.MaCT,
    YC.MaYC,
    HD.MaSoHD,
    KH.HoTen AS TenKhachHang,
    YC.LoaiSuKien,
    YC.SoTienYC AS TienYeuCau,
    CT.NgayChiTra,
    CT.SoTienChi,
    CT.HinhThucChi,
    NV.HoTen AS NhanVienChi,
    CT.TrangThai,
    CT.GhiChu
FROM CHITRABOITHUONG CT
INNER JOIN YEUCAUBOITHUONG YC ON CT.MaYC = YC.MaYC
INNER JOIN HOPDONG HD ON YC.MaHD = HD.MaHD
INNER JOIN KHACHHANG KH ON HD.MaKH = KH.MaKH
LEFT JOIN NHANVIEN NV ON CT.MaNV_Chi = NV.MaNV;
GO
