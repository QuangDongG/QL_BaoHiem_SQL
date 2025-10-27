<<<<<<< HEAD
USE QL_BaoHiem;  
GO  
  
-- VIEW: 13_V_KhuyenMai_DangApDung  
CREATE OR ALTER VIEW V_KhuyenMai_DangApDung
AS
SELECT 
    KM.MaKM,
    KM.TenKM,
    KM.NoiDung,
    KM.GiaTri,
    KM.DonVi,
    KM.NgayBD,
    KM.NgayKT,
    DATEDIFF(DAY, GETDATE(), KM.NgayKT) AS SoNgayConLai,
    COUNT(HDKM.MaHD) AS SoHopDongApDung
FROM KHUYENMAI KM
LEFT JOIN HOPDONG_KHUYENMAI HDKM ON KM.MaKM = HDKM.MaKM
WHERE KM.NgayBD <= GETDATE() AND KM.NgayKT >= GETDATE()
GROUP BY KM.MaKM, KM.TenKM, KM.NoiDung, KM.GiaTri, 
         KM.DonVi, KM.NgayBD, KM.NgayKT;
GO
=======
USE QL_BaoHiem;  
GO  
  
-- VIEW: 13_V_KhuyenMai_DangApDung  
CREATE OR ALTER VIEW V_KhuyenMai_DangApDung
AS
SELECT 
    KM.MaKM,
    KM.TenKM,
    KM.NoiDung,
    KM.GiaTri,
    KM.DonVi,
    KM.NgayBD,
    KM.NgayKT,
    DATEDIFF(DAY, GETDATE(), KM.NgayKT) AS SoNgayConLai,
    COUNT(HDKM.MaHD) AS SoHopDongApDung
FROM KHUYENMAI KM
LEFT JOIN HOPDONG_KHUYENMAI HDKM ON KM.MaKM = HDKM.MaKM
WHERE KM.NgayBD <= GETDATE() AND KM.NgayKT >= GETDATE()
GROUP BY KM.MaKM, KM.TenKM, KM.NoiDung, KM.GiaTri, 
         KM.DonVi, KM.NgayBD, KM.NgayKT;
GO
>>>>>>> 59c5acf48653319ce8c913c2014f62e09ddfb835
