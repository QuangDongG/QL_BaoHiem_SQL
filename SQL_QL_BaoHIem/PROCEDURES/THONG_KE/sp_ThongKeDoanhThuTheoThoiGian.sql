CREATE OR ALTER PROCEDURE sp_ThongKeDoanhThuTheoThoiGian
    @TuNgay DATE,
    @DenNgay DATE
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF @TuNgay > @DenNgay
        BEGIN
            RAISERROR(N'Ngày bắt đầu không thể lớn hơn ngày kết thúc.', 16, 1);
            RETURN;
        END

        SELECT
            SUM(ISNULL(SoTien, 0)) AS TongDoanhThu
        FROM THANHTOANPHI
        WHERE NgayTT BETWEEN @TuNgay AND @DenNgay
          AND TrangThai = N'Đã nhận';
    END TRY
    BEGIN CATCH
         PRINT N'Lỗi khi thống kê doanh thu: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- 8. Test sp_ThongKeDoanhThuTheoThoiGian
-- TH hợp lệ
EXEC sp_ThongKeDoanhThuTheoThoiGian @TuNgay = '2024-01-01', @DenNgay = '2024-12-31';
-- TH lỗi: Ngày không hợp lệ
EXEC sp_ThongKeDoanhThuTheoThoiGian @TuNgay = '2025-01-01', @DenNgay = '2024-12-31'; -- Dự kiến lỗi RAISERROR
GO