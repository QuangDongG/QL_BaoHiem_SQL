USE QL_BaoHiem;  
GO  
  
-- VIEW: 14_V_HopDong_KhuyenMai  
CREATE OR ALTER VIEW V_HopDong_KhuyenMai
AS
SELECT 
    HD.MaHD,
    HD.MaSoHD,
    KH.HoTen AS TenKhachHang,
    GB.TenGoi,
    KM.TenKM,
    KM.GiaTri,
    KM.DonVi,
    CASE 
        WHEN KM.DonVi = N'%' THEN GB.PhiDinhKy * KM.GiaTri / 100
        WHEN KM.DonVi = N'VND' THEN KM.GiaTri
        ELSE 0
    END AS GiaTriGiamGia,
    GB.PhiDinhKy - CASE 
        WHEN KM.DonVi = N'%' THEN GB.PhiDinhKy * KM.GiaTri / 100
        WHEN KM.DonVi = N'VND' THEN KM.GiaTri
        ELSE 0
    END AS PhiSauGiam
FROM HOPDONG HD
INNER JOIN KHACHHANG KH ON HD.MaKH = KH.MaKH
INNER JOIN GOIBAOHIEM GB ON HD.MaGoi = GB.MaGoi
INNER JOIN HOPDONG_KHUYENMAI HDKM ON HD.MaHD = HDKM.MaHD
INNER JOIN KHUYENMAI KM ON HDKM.MaKM = KM.MaKM;
GO
