CREATE OR ALTER PROCEDURE sp_ThongKeKhachHangTheoNhomTuoi
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        WITH KhachHangTuoi AS (
            SELECT
                MaKH,
                dbo.fn_TinhTuoi(NgaySinh) AS Tuoi
            FROM KHACHHANG
            WHERE NgaySinh IS NOT NULL
        )
        SELECT
            CASE
                WHEN Tuoi < 18 THEN N'Dưới 18'
                WHEN Tuoi BETWEEN 18 AND 30 THEN N'18 - 30'
                WHEN Tuoi BETWEEN 31 AND 45 THEN N'31 - 45'
                WHEN Tuoi BETWEEN 46 AND 60 THEN N'46 - 60'
                WHEN Tuoi > 60 THEN N'Trên 60'
                ELSE N'Không xác định'
            END AS NhomTuoi,
            COUNT(MaKH) AS SoLuongKhachHang
        FROM KhachHangTuoi
        GROUP BY
            CASE
                WHEN Tuoi < 18 THEN N'Dưới 18'
                WHEN Tuoi BETWEEN 18 AND 30 THEN N'18 - 30'
                WHEN Tuoi BETWEEN 31 AND 45 THEN N'31 - 45'
                WHEN Tuoi BETWEEN 46 AND 60 THEN N'46 - 60'
                WHEN Tuoi > 60 THEN N'Trên 60'
                ELSE N'Không xác định'
            END
        ORDER BY NhomTuoi;
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi thống kê khách hàng theo nhóm tuổi: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- 14. Test sp_ThongKeKhachHangTheoNhomTuoi
PRINT N'--- Test sp_ThongKeKhachHangTheoNhomTuoi ---';
EXEC sp_ThongKeKhachHangTheoNhomTuoi;
GO