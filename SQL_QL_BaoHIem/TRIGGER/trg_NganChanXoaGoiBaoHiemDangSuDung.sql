CREATE OR ALTER TRIGGER trg_NganChanXoaGoiBaoHiemDangSuDung
ON GOIBAOHIEM
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1
               FROM deleted d
               JOIN HOPDONG hd ON d.MaGoi = hd.MaGoi
               WHERE hd.TrangThai = N'Hiệu lực')
    BEGIN
        DECLARE @MaGoi_Loi INT = (SELECT TOP 1 d.MaGoi
                                 FROM deleted d
                                 JOIN HOPDONG hd ON d.MaGoi = hd.MaGoi
                                 WHERE hd.TrangThai = N'Hiệu lực');
        DECLARE @ErrorMessage NVARCHAR(200) = N'Không thể xóa gói bảo hiểm ' + CAST(@MaGoi_Loi AS VARCHAR) + N' vì đang được sử dụng bởi hợp đồng còn hiệu lực.';
        THROW 51004, @ErrorMessage, 1;
    END
    ELSE
    BEGIN
        -- Thực hiện xóa nếu không vi phạm
        DELETE FROM GOIBAOHIEM
        WHERE MaGoi IN (SELECT MaGoi FROM deleted);
    END
END;
GO

-- 17. Test trg_NganChanXoaGoiBaoHiemDangSuDung
PRINT N'--- Test trg_NganChanXoaGoiBaoHiemDangSuDung ---';
BEGIN TRY
    -- Chọn Gói đang được dùng bởi HĐ hiệu lực (ví dụ MaGoi=1)
    DECLARE @MaGoiDangDung INT = 1;
    IF EXISTS (SELECT 1 FROM HOPDONG WHERE MaGoi = @MaGoiDangDung AND TrangThai = N'Hiệu lực')
    BEGIN
        PRINT N'Thử DELETE Gói BH ' + CAST(@MaGoiDangDung AS VARCHAR) + N' (đang được sử dụng)';
        DELETE FROM GOIBAOHIEM WHERE MaGoi = @MaGoiDangDung;
        PRINT N'LỖI LOGIC: Lẽ ra phải báo lỗi không xóa được Gói BH!';
    END
    ELSE
    BEGIN
        PRINT N'Gói BH ' + CAST(@MaGoiDangDung AS VARCHAR) + N' không có HĐ hiệu lực để test trigger lỗi.';
    END
END TRY
BEGIN CATCH
    PRINT N'Thành công: Đã bắt lỗi từ trigger ngăn xóa Gói BH: ' + ERROR_MESSAGE();
END CATCH;
-- TH thành công (giả định tạo gói mới không có HĐ)
INSERT INTO GOIBAOHIEM(MaLoai, TenGoi, PhiDinhKy, SoTienBaoHiem, ThoiHanThang)
VALUES (1, N'Gói BH Test Xóa', 100000, 10000000, 12);
DECLARE @MaGoiTestXoa INT = SCOPE_IDENTITY();
PRINT N'Thử DELETE Gói BH ' + CAST(@MaGoiTestXoa AS VARCHAR) + N' (mới tạo)';
DELETE FROM GOIBAOHIEM WHERE MaGoi = @MaGoiTestXoa;
IF NOT EXISTS (SELECT 1 FROM GOIBAOHIEM WHERE MaGoi = @MaGoiTestXoa)
    PRINT N'Thành công: Đã xóa Gói BH không có HĐ hiệu lực.';
ELSE
    PRINT N'LỖI LOGIC: Không xóa được Gói BH không có HĐ hiệu lực.';
GO