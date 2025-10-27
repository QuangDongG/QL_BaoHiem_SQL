CREATE OR ALTER PROCEDURE sp_XemChiTietGoiBaoHiem
    @MaGoi INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM GOIBAOHIEM WHERE MaGoi = @MaGoi)
        BEGIN
            RAISERROR(N'Không tìm thấy gói bảo hiểm.', 16, 1);
            RETURN;
        END

        SELECT
            gbh.MaGoi,
            gbh.TenGoi,
            lbh.TenLoai AS LoaiBaoHiem,
            gbh.PhiDinhKy,
            gbh.SoTienBaoHiem,
            gbh.ThoiHanThang,
            gbh.DieuKien,
            gbh.QuyenLoi,
            lbh.MoTa AS MoTaLoaiBH
        FROM GOIBAOHIEM gbh
        JOIN LOAIBAOHIEM lbh ON gbh.MaLoai = lbh.MaLoai
        WHERE gbh.MaGoi = @MaGoi;

    END TRY
    BEGIN CATCH
         PRINT N'Lỗi khi xem chi tiết gói bảo hiểm: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Test sp_XemChiTietGoiBaoHiem
PRINT N'--- Test sp_XemChiTietGoiBaoHiem ---';
-- Test với MaGoi = 1
EXEC sp_XemChiTietGoiBaoHiem @MaGoi = 1;
-- Test với MaGoi = 4
EXEC sp_XemChiTietGoiBaoHiem @MaGoi = 4;
-- Test lỗi: MaGoi không tồn tại
EXEC sp_XemChiTietGoiBaoHiem @MaGoi = 99; -- Dự kiến RAISERROR
GO