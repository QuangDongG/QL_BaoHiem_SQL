CREATE OR ALTER PROCEDURE sp_XemYeuCauBoiThuongTheoHopDong
    @MaHD INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM HOPDONG WHERE MaHD = @MaHD)
        BEGIN
            RAISERROR(N'Không tìm thấy hợp đồng.', 16, 1);
            RETURN;
        END

        SELECT
            yc.MaYC,
            yc.NgayYeuCau,
            yc.NgaySuKien,
            yc.LoaiSuKien,
            yc.SoTienYC,
            tt.TenTT AS TrangThaiYeuCau,
            yc.GhiChu AS GhiChuYeuCau,
            ct.MaCT AS MaChiTra,
            ct.NgayChiTra,
            ct.SoTienChi,
            ct.TrangThai AS TrangThaiChiTra
        FROM YEUCAUBOITHUONG yc
        JOIN TINHTRANG_YEUCAU tt ON yc.MaTT_TrangThai = tt.MaTT
        LEFT JOIN CHITRABOITHUONG ct ON yc.MaYC = ct.MaYC -- LEFT JOIN để lấy cả YC chưa có chi trả
        WHERE yc.MaHD = @MaHD
        ORDER BY yc.NgayYeuCau DESC;

        IF @@ROWCOUNT = 0
        BEGIN
            PRINT N'Hợp đồng ' + CAST(@MaHD AS VARCHAR) + N' chưa có yêu cầu bồi thường nào.';
        END

    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi xem yêu cầu bồi thường theo hợp đồng: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Test sp_XemYeuCauBoiThuongTheoHopDong
PRINT N'--- Test sp_XemYeuCauBoiThuongTheoHopDong ---';
-- Test với HĐ có YCBT (ví dụ MaHD = 90)
PRINT N'Xem YCBT của HĐ 90:';
EXEC sp_XemYeuCauBoiThuongTheoHopDong @MaHD = 90;
-- Test với HĐ có YCBT đã chi trả (ví dụ MaHD = 38)
PRINT N'Xem YCBT của HĐ 38:';
EXEC sp_XemYeuCauBoiThuongTheoHopDong @MaHD = 38;
-- Test với HĐ không có YCBT (Chọn 1 HĐ bất kỳ, ví dụ 1)
PRINT N'Xem YCBT của HĐ 1:';
EXEC sp_XemYeuCauBoiThuongTheoHopDong @MaHD = 1; -- Dự kiến thông báo chưa có YCBT
-- Test lỗi: MaHD không tồn tại
PRINT N'Test lỗi: MaHD = 9999';
EXEC sp_XemYeuCauBoiThuongTheoHopDong @MaHD = 9999; -- Dự kiến RAISERROR
GO