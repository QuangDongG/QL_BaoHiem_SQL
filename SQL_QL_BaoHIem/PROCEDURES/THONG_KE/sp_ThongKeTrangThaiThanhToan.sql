CREATE OR ALTER PROCEDURE sp_ThongKeTrangThaiThanhToan
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT
            TrangThai,
            COUNT(MaTT) AS SoLuong,
            SUM(ISNULL(SoTien, 0)) AS TongSoTien
        FROM THANHTOANPHI
        GROUP BY TrangThai
        ORDER BY SoLuong DESC;
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi thống kê trạng thái thanh toán: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


PRINT N'--- Test sp_ThongKeTrangThaiThanhToan ---';
EXEC sp_ThongKeTrangThaiThanhToan;
GO