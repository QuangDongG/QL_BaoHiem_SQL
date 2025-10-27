CREATE OR ALTER TRIGGER trg_NganChanXoaKhachHangCoHopDong
ON KHACHHANG
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra xem có khách hàng nào trong danh sách xóa có hợp đồng hiệu lực không
    IF EXISTS (SELECT 1
               FROM deleted d
               JOIN HOPDONG hd ON d.MaKH = hd.MaKH
               WHERE hd.TrangThai = N'Hiệu lực')
    BEGIN
        -- Lấy mã KH đầu tiên bị lỗi để hiển thị (có thể cải thiện để báo nhiều KH hơn)
        DECLARE @MaKH_Loi INT = (SELECT TOP 1 d.MaKH
                                 FROM deleted d
                                 JOIN HOPDONG hd ON d.MaKH = hd.MaKH
                                 WHERE hd.TrangThai = N'Hiệu lực');
        DECLARE @ErrorMessage NVARCHAR(200) = N'Không thể xóa khách hàng ' + CAST(@MaKH_Loi AS VARCHAR) + N' (và có thể các KH khác) vì còn hợp đồng đang hiệu lực.';
        THROW 51002, @ErrorMessage, 1;
        -- Không thực hiện DELETE nào cả do INSTEAD OF
    END
    ELSE
    BEGIN
        -- Nếu không có KH nào vi phạm, thực hiện DELETE thực sự
        DELETE FROM KHACHHANG
        WHERE MaKH IN (SELECT MaKH FROM deleted);
    END
END;
GO

-- 13. Test trg_NganChanXoaKhachHangCoHopDong
PRINT N'--- Test trg_NganChanXoaKhachHangCoHopDong ---';
BEGIN TRY
    -- Chọn KH có HĐ hiệu lực
    DECLARE @MaKHCoHDHieuLuc INT = (SELECT TOP 1 MaKH FROM HOPDONG WHERE TrangThai = N'Hiệu lực');
    IF @MaKHCoHDHieuLuc IS NOT NULL
    BEGIN
        PRINT N'Thử DELETE KH ' + CAST(@MaKHCoHDHieuLuc AS VARCHAR) + N' (có HĐ hiệu lực)';
        DELETE FROM KHACHHANG WHERE MaKH = @MaKHCoHDHieuLuc;
        PRINT N'LỖI LOGIC: Lẽ ra phải báo lỗi không xóa được KH!';
    END
    ELSE
    BEGIN
        PRINT N'Không tìm thấy KH có HĐ hiệu lực để test trigger lỗi.';
    END
END TRY
BEGIN CATCH
    PRINT N'Thành công: Đã bắt lỗi từ trigger ngăn xóa KH: ' + ERROR_MESSAGE();
END CATCH;
-- TH thành công (giả định tạo KH mới không có HĐ)
INSERT INTO KHACHHANG(HoTen, NgaySinh, GioiTinh, CCCD, DiaChi, SDT, Email)
VALUES (N'KH Test Xóa', '1995-01-01', N'Nam', '999999999999', N'Test', '0123456789', 'testxoa@email.com');
DECLARE @MaKHTestXoa INT = SCOPE_IDENTITY();
PRINT N'Thử DELETE KH ' + CAST(@MaKHTestXoa AS VARCHAR) + N' (mới tạo, không có HĐ)';
DELETE FROM KHACHHANG WHERE MaKH = @MaKHTestXoa;
IF NOT EXISTS (SELECT 1 FROM KHACHHANG WHERE MaKH = @MaKHTestXoa)
    PRINT N'Thành công: Đã xóa KH không có HĐ hiệu lực.';
ELSE
    PRINT N'LỖI LOGIC: Không xóa được KH không có HĐ hiệu lực.';
GO