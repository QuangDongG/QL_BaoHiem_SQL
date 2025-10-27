CREATE OR ALTER PROCEDURE sp_TopKhachHangDongPhiNhieuNhat
    @TopN INT = 10 -- Lấy top 10 nếu không chỉ định
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF @TopN <= 0
        BEGIN
             RAISERROR(N'Số lượng top phải là số dương.', 16, 1);
            RETURN;
        END

        SELECT TOP (@TopN)
            kh.MaKH,
            kh.HoTen,
            kh.Email,
            kh.SDT,
            dbo.fn_TongPhiDaThanhToan(kh.MaKH) AS TongPhiDaDong
        FROM KHACHHANG kh
        ORDER BY TongPhiDaDong DESC;

    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi lấy top khách hàng đóng phí: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- 11. Test sp_TopKhachHangDongPhiNhieuNhat
PRINT N'--- Test sp_TopKhachHangDongPhiNhieuNhat ---';
-- Top 10 (mặc định)
EXEC sp_TopKhachHangDongPhiNhieuNhat;
-- Top 5
EXEC sp_TopKhachHangDongPhiNhieuNhat @TopN = 5;
-- TH lỗi: Top âm
EXEC sp_TopKhachHangDongPhiNhieuNhat @TopN = -3; -- Dự kiến lỗi RAISERROR
GO