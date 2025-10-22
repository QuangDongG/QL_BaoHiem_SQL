USE QL_BaoHiem;  
GO  
  
-- VIEW: 15_V_TaiKhoan_ThongTin  
CREATE OR ALTER VIEW V_TaiKhoan_ThongTin
AS
SELECT 
    TK.MaTK,
    TK.TenDangNhap,
    TK.LoaiTK,
    CASE 
        WHEN TK.LoaiTK = N'KH' THEN KH.HoTen
        WHEN TK.LoaiTK = N'NV' THEN NV.HoTen
        ELSE NULL
    END AS HoTen,
    CASE 
        WHEN TK.LoaiTK = N'KH' THEN KH.Email
        WHEN TK.LoaiTK = N'NV' THEN NV.Email
        ELSE NULL
    END AS Email,
    TK.NgayTao,
    TK.TrangThai,
    COUNT(LS.MaLS) AS SoLanTruyCap,
    MAX(LS.ThoiGian) AS LanTruyCapCuoi
FROM TAIKHOAN TK
LEFT JOIN KHACHHANG KH ON TK.MaKH = KH.MaKH
LEFT JOIN NHANVIEN NV ON TK.MaNV = NV.MaNV
LEFT JOIN LICHSU_TRUY_CAP LS ON TK.MaTK = LS.MaTK
GROUP BY TK.MaTK, TK.TenDangNhap, TK.LoaiTK, 
         KH.HoTen, KH.Email, NV.HoTen, NV.Email,
         TK.NgayTao, TK.TrangThai;
GO
