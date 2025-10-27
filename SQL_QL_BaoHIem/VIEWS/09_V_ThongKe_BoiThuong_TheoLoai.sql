<<<<<<< HEAD
USE QL_BaoHiem;  
GO  
  
-- VIEW: 09_V_ThongKe_BoiThuong_TheoLoai  
CREATE OR ALTER VIEW V_ThongKe_BoiThuong_TheoLoai
AS
SELECT 
    LBH.MaLoai,
    LBH.TenLoai,
    COUNT(DISTINCT YC.MaYC) AS SoYeuCau,
    SUM(YC.SoTienYC) AS TongTienYeuCau,
    SUM(CT.SoTienChi) AS TongTienDaChi,
    AVG(YC.SoTienYC) AS TrungBinhYeuCau,
    CASE 
        WHEN SUM(YC.SoTienYC) > 0 
        THEN (SUM(CT.SoTienChi) * 100.0 / SUM(YC.SoTienYC))
        ELSE 0 
    END AS TyLeChiTra
FROM LOAIBAOHIEM LBH
INNER JOIN GOIBAOHIEM GB ON LBH.MaLoai = GB.MaLoai
INNER JOIN HOPDONG HD ON GB.MaGoi = HD.MaGoi
INNER JOIN YEUCAUBOITHUONG YC ON HD.MaHD = YC.MaHD
LEFT JOIN CHITRABOITHUONG CT ON YC.MaYC = CT.MaYC
GROUP BY LBH.MaLoai, LBH.TenLoai;
GO
=======
USE QL_BaoHiem;  
GO  
  
-- VIEW: 09_V_ThongKe_BoiThuong_TheoLoai  
CREATE OR ALTER VIEW V_ThongKe_BoiThuong_TheoLoai
AS
SELECT 
    LBH.MaLoai,
    LBH.TenLoai,
    COUNT(DISTINCT YC.MaYC) AS SoYeuCau,
    SUM(YC.SoTienYC) AS TongTienYeuCau,
    SUM(CT.SoTienChi) AS TongTienDaChi,
    AVG(YC.SoTienYC) AS TrungBinhYeuCau,
    CASE 
        WHEN SUM(YC.SoTienYC) > 0 
        THEN (SUM(CT.SoTienChi) * 100.0 / SUM(YC.SoTienYC))
        ELSE 0 
    END AS TyLeChiTra
FROM LOAIBAOHIEM LBH
INNER JOIN GOIBAOHIEM GB ON LBH.MaLoai = GB.MaLoai
INNER JOIN HOPDONG HD ON GB.MaGoi = HD.MaGoi
INNER JOIN YEUCAUBOITHUONG YC ON HD.MaHD = YC.MaHD
LEFT JOIN CHITRABOITHUONG CT ON YC.MaYC = CT.MaYC
GROUP BY LBH.MaLoai, LBH.TenLoai;
GO
>>>>>>> 59c5acf48653319ce8c913c2014f62e09ddfb835
