CREATE OR ALTER PROCEDURE sp_LietKeKhachHangTheoThanhPho
    @TenThanhPho NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT
            DiaChi AS ThanhPho,
            COUNT(MaKH) AS SoLuongKhachHang
        FROM KHACHHANG
        WHERE @TenThanhPho IS NULL OR DiaChi LIKE '%' + @TenThanhPho + '%'
        GROUP BY DiaChi
        ORDER BY SoLuongKhachHang DESC;
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi liệt kê khách hàng theo thành phố: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- 9. Test sp_LietKeKhachHangTheoThanhPho
-- Liệt kê tất cả
EXEC sp_LietKeKhachHangTheoThanhPho;
-- Liệt kê theo thành phố cụ thể
EXEC sp_LietKeKhachHangTheoThanhPho @TenThanhPho = N'Hà Nội';
EXEC sp_LietKeKhachHangTheoThanhPho @TenThanhPho = N'Không tồn tại';
GO