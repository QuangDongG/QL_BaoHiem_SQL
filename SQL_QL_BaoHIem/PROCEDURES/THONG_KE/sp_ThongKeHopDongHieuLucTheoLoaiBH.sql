CREATE OR ALTER PROCEDURE sp_ThongKeHopDongHieuLucTheoLoaiBH
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT
            lbh.TenLoai,
            COUNT(hd.MaHD) AS SoLuongHopDongHieuLuc
        FROM HOPDONG hd
        JOIN GOIBAOHIEM gbh ON hd.MaGoi = gbh.MaGoi
        JOIN LOAIBAOHIEM lbh ON gbh.MaLoai = lbh.MaLoai
        WHERE hd.TrangThai = N'Hiệu lực' AND hd.NgayHetHan >= GETDATE() -- Đảm bảo còn hiệu lực và chưa hết hạn
        GROUP BY lbh.TenLoai
        ORDER BY SoLuongHopDongHieuLuc DESC;
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi thống kê hợp đồng hiệu lực theo loại bảo hiểm: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- 12. Test sp_ThongKeHopDongHieuLucTheoLoaiBH
EXEC sp_ThongKeHopDongHieuLucTheoLoaiBH;
GO