CREATE OR ALTER PROCEDURE sp_ThongKeHopDongTheoTrangThai
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT
            TrangThai,
            COUNT(MaHD) AS SoLuongHopDong
        FROM HOPDONG
        GROUP BY TrangThai
        ORDER BY SoLuongHopDong DESC;
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi thống kê hợp đồng theo trạng thái: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- 7. Test sp_ThongKeHopDongTheoTrangThai
EXEC sp_ThongKeHopDongTheoTrangThai;
GO