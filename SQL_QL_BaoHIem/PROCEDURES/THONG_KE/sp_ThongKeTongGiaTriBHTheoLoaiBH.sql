CREATE OR ALTER PROCEDURE sp_ThongKeTongGiaTriBHTheoLoaiBH
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT
            lbh.TenLoai,
            SUM(ISNULL(gbh.SoTienBaoHiem, 0)) AS TongGiaTriBaoHiem
        FROM HOPDONG hd
        JOIN GOIBAOHIEM gbh ON hd.MaGoi = gbh.MaGoi
        JOIN LOAIBAOHIEM lbh ON gbh.MaLoai = lbh.MaLoai
        WHERE hd.TrangThai = N'Hiệu lực' AND hd.NgayHetHan >= GETDATE()
        GROUP BY lbh.TenLoai
        ORDER BY TongGiaTriBaoHiem DESC;
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi thống kê tổng giá trị bảo hiểm theo loại: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- 13. Test sp_ThongKeTongGiaTriBHTheoLoaiBH
PRINT N'--- Test sp_ThongKeTongGiaTriBHTheoLoaiBH ---';
EXEC sp_ThongKeTongGiaTriBHTheoLoaiBH;
GO