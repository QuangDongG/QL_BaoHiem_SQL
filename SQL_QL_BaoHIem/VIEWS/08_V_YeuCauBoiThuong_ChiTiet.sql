<<<<<<< HEAD
USE QL_BaoHiem;  
GO  
  
-- VIEW: 08_V_YeuCauBoiThuong_ChiTiet  
CREATE OR ALTER VIEW V_YeuCauBoiThuong_ChiTiet
AS
SELECT 
    YC.MaYC,
    HD.MaHD,
    HD.MaSoHD,
    KH.HoTen AS TenKhachHang,
    KH.SDT,
    GB.TenGoi,
    LBH.TenLoai AS LoaiBaoHiem,
    YC.NgayYeuCau,
    YC.NgaySuKien,
    YC.LoaiSuKien,
    YC.SoTienYC AS SoTienYeuCau,
    TT.TenTT AS TrangThai,
    YC.GhiChu,
    ISNULL(SUM(CT.SoTienChi), 0) AS SoTienDaChi,
    YC.SoTienYC - ISNULL(SUM(CT.SoTienChi), 0) AS SoTienConLai
FROM YEUCAUBOITHUONG YC
INNER JOIN HOPDONG HD ON YC.MaHD = HD.MaHD
INNER JOIN KHACHHANG KH ON HD.MaKH = KH.MaKH
INNER JOIN GOIBAOHIEM GB ON HD.MaGoi = GB.MaGoi
INNER JOIN LOAIBAOHIEM LBH ON GB.MaLoai = LBH.MaLoai
INNER JOIN TINHTRANG_YEUCAU TT ON YC.MaTT_TrangThai = TT.MaTT
LEFT JOIN CHITRABOITHUONG CT ON YC.MaYC = CT.MaYC
GROUP BY YC.MaYC, HD.MaHD, HD.MaSoHD, KH.HoTen, KH.SDT, 
         GB.TenGoi, LBH.TenLoai, YC.NgayYeuCau, YC.NgaySuKien,
         YC.LoaiSuKien, YC.SoTienYC, TT.TenTT, YC.GhiChu;
GO
=======
USE QL_BaoHiem;  
GO  
  
-- VIEW: 08_V_YeuCauBoiThuong_ChiTiet  
CREATE OR ALTER VIEW V_YeuCauBoiThuong_ChiTiet
AS
SELECT 
    YC.MaYC,
    HD.MaHD,
    HD.MaSoHD,
    KH.HoTen AS TenKhachHang,
    KH.SDT,
    GB.TenGoi,
    LBH.TenLoai AS LoaiBaoHiem,
    YC.NgayYeuCau,
    YC.NgaySuKien,
    YC.LoaiSuKien,
    YC.SoTienYC AS SoTienYeuCau,
    TT.TenTT AS TrangThai,
    YC.GhiChu,
    ISNULL(SUM(CT.SoTienChi), 0) AS SoTienDaChi,
    YC.SoTienYC - ISNULL(SUM(CT.SoTienChi), 0) AS SoTienConLai
FROM YEUCAUBOITHUONG YC
INNER JOIN HOPDONG HD ON YC.MaHD = HD.MaHD
INNER JOIN KHACHHANG KH ON HD.MaKH = KH.MaKH
INNER JOIN GOIBAOHIEM GB ON HD.MaGoi = GB.MaGoi
INNER JOIN LOAIBAOHIEM LBH ON GB.MaLoai = LBH.MaLoai
INNER JOIN TINHTRANG_YEUCAU TT ON YC.MaTT_TrangThai = TT.MaTT
LEFT JOIN CHITRABOITHUONG CT ON YC.MaYC = CT.MaYC
GROUP BY YC.MaYC, HD.MaHD, HD.MaSoHD, KH.HoTen, KH.SDT, 
         GB.TenGoi, LBH.TenLoai, YC.NgayYeuCau, YC.NgaySuKien,
         YC.LoaiSuKien, YC.SoTienYC, TT.TenTT, YC.GhiChu;
GO
>>>>>>> 59c5acf48653319ce8c913c2014f62e09ddfb835
