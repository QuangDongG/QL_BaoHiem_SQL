CREATE OR ALTER PROCEDURE sp_ThongKeTrangThaiYeuCauBoiThuong
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT
            ttyc.TenTT AS TrangThaiYeuCau,
            COUNT(yc.MaYC) AS SoLuong,
            SUM(ISNULL(yc.SoTienYC, 0)) AS TongSoTienYeuCau
        FROM YEUCAUBOITHUONG yc
        JOIN TINHTRANG_YEUCAU ttyc ON yc.MaTT_TrangThai = ttyc.MaTT
        GROUP BY ttyc.TenTT
        ORDER BY SoLuong DESC;
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi thống kê trạng thái yêu cầu bồi thường: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- 18. Test sp_ThongKeTrangThaiYeuCauBoiThuong
PRINT N'--- Test sp_ThongKeTrangThaiYeuCauBoiThuong ---';
EXEC sp_ThongKeTrangThaiYeuCauBoiThuong;
GO