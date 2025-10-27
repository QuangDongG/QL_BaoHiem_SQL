<<<<<<< HEAD
USE QL_BaoHiem;  
GO  
  
-- VIEW: 16_V_LichSuTruyCap_GanDay  
CREATE OR ALTER VIEW V_LichSuTruyCap_GanDay
AS
SELECT
    LS.MaLS,
    TK.TenDangNhap,
    TK.LoaiTK,
    LS.ThoiGian,
    LS.HanhDong,
    LS.MoTa,
    LS.DiaChiIP
FROM LICHSU_TRUY_CAP LS
INNER JOIN TAIKHOAN TK ON LS.MaTK = TK.MaTK
GO
=======
USE QL_BaoHiem;  
GO  
  
-- VIEW: 16_V_LichSuTruyCap_GanDay  
CREATE OR ALTER VIEW V_LichSuTruyCap_GanDay
AS
SELECT
    LS.MaLS,
    TK.TenDangNhap,
    TK.LoaiTK,
    LS.ThoiGian,
    LS.HanhDong,
    LS.MoTa,
    LS.DiaChiIP
FROM LICHSU_TRUY_CAP LS
INNER JOIN TAIKHOAN TK ON LS.MaTK = TK.MaTK
GO
>>>>>>> 59c5acf48653319ce8c913c2014f62e09ddfb835
