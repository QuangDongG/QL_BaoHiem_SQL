CREATE OR ALTER TRIGGER trg_KiemTraNgaySuKienHopLe
ON YEUCAUBOITHUONG
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra xem có bản ghi nào vi phạm không
    IF EXISTS (SELECT 1 FROM inserted WHERE NgaySuKien > NgayYeuCau)
    BEGIN
        ROLLBACK TRANSACTION;
        DECLARE @MaYC_Loi INT = (SELECT TOP 1 MaYC FROM inserted WHERE NgaySuKien > NgayYeuCau);
        DECLARE @ErrorMessage NVARCHAR(200) = N'Lỗi tại yêu cầu ' + ISNULL(CAST(@MaYC_Loi AS VARCHAR), 'mới') + N': Ngày xảy ra sự kiện không được sau ngày yêu cầu.';
        THROW 51003, @ErrorMessage, 1;
        RETURN;
    END
END;
GO

-- 16. Test trg_KiemTraNgaySuKienHopLe
PRINT N'--- Test trg_KiemTraNgaySuKienHopLe ---';
BEGIN TRY
    -- TH lỗi: Ngày sự kiện sau ngày yêu cầu
    PRINT N'Thử INSERT YC với Ngày sự kiện > Ngày yêu cầu';
    INSERT INTO YEUCAUBOITHUONG (MaHD, NgayYeuCau, NgaySuKien, LoaiSuKien, SoTienYC, MaTT_TrangThai)
    VALUES (1, GETDATE(), DATEADD(DAY, 1, GETDATE()), N'Test lỗi ngày', 1000, 1);
    PRINT N'LỖI LOGIC: Lẽ ra phải báo lỗi ngày sự kiện!';
END TRY
BEGIN CATCH
    PRINT N'Thành công: Đã bắt lỗi từ trigger ngày sự kiện không hợp lệ: ' + ERROR_MESSAGE();
END CATCH;
-- TH thành công
INSERT INTO YEUCAUBOITHUONG (MaHD, NgayYeuCau, NgaySuKien, LoaiSuKien, SoTienYC, MaTT_TrangThai)
VALUES (1, GETDATE(), DATEADD(DAY, -1, GETDATE()), N'Test ngày OK', 1000, 1);
DECLARE @MaYCTestNgay INT = SCOPE_IDENTITY();
PRINT N'Thành công: Đã INSERT YC mới (MaYC=' + CAST(@MaYCTestNgay AS VARCHAR) + N') với ngày hợp lệ.';
-- Xóa bản ghi test
DELETE FROM YEUCAUBOITHUONG WHERE MaYC = @MaYCTestNgay;
GO