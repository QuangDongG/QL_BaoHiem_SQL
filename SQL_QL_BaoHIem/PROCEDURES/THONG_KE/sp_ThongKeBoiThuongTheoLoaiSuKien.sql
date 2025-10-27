CREATE OR ALTER PROCEDURE sp_ThongKeBoiThuongTheoLoaiSuKien
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT
            yc.LoaiSuKien,
            COUNT(yc.MaYC) AS SoLuongYeuCau,
            SUM(ISNULL(yc.SoTienYC, 0)) AS TongSoTienYeuCau,
            SUM(ISNULL(ct.SoTienChi, 0)) AS TongSoTienDaChiTra
        FROM YEUCAUBOITHUONG yc
        LEFT JOIN CHITRABOITHUONG ct ON yc.MaYC = ct.MaYC AND ct.TrangThai = N'Đã chi trả'
        GROUP BY yc.LoaiSuKien
        ORDER BY SoLuongYeuCau DESC;
    END TRY
    BEGIN CATCH
         PRINT N'Lỗi khi thống kê bồi thường theo loại sự kiện: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- 10. Test sp_ThongKeBoiThuongTheoLoaiSuKien
EXEC sp_ThongKeBoiThuongTheoLoaiSuKien;
GO