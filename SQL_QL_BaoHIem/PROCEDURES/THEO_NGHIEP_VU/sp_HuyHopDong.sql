CREATE OR ALTER PROCEDURE sp_HuyHopDong
    @MaHD INT,
    @LyDoHuy NVARCHAR(255) = NULL -- Ghi chú lý do hủy
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DECLARE @TrangThaiHienTai NVARCHAR(30);

        SELECT @TrangThaiHienTai = TrangThai FROM HOPDONG WHERE MaHD = @MaHD;

        IF @TrangThaiHienTai IS NULL
        BEGIN
             RAISERROR(N'Không tìm thấy hợp đồng cần hủy.', 16, 1);
            RETURN;
        END

        -- Kiểm tra xem hợp đồng đã bị hủy chưa
        IF @TrangThaiHienTai = N'Huỷ'
        BEGIN
            RAISERROR(N'Hợp đồng này đã ở trạng thái "Huỷ".', 16, 1);
            RETURN;
        END

        -- (Tùy chọn) Thêm kiểm tra nghiệp vụ khác, ví dụ: không cho hủy nếu có YCBT đang xử lý
        -- IF EXISTS (SELECT 1 FROM YEUCAUBOITHUONG yc JOIN TINHTRANG_YEUCAU tt ON yc.MaTT_TrangThai = tt.MaTT WHERE yc.MaHD = @MaHD AND tt.TenTT = N'Đang xử lý')
        -- BEGIN
        --     RAISERROR(N'Không thể hủy hợp đồng khi có yêu cầu bồi thường đang xử lý.', 16, 1);
        --     RETURN;
        -- END

        -- Cập nhật trạng thái và ghi chú
        UPDATE HOPDONG
        SET TrangThai = N'Huỷ',
            GhiChu = ISNULL(GhiChu + N'; ', N'') + N'Hủy ngày ' + FORMAT(GETDATE(), 'dd/MM/yyyy') + N'. Lý do: ' + ISNULL(@LyDoHuy, N'Không rõ')
        WHERE MaHD = @MaHD;

        PRINT N'Hủy hợp đồng ' + CAST(@MaHD AS VARCHAR) + N' thành công!';

    END TRY
    BEGIN CATCH
         PRINT N'Lỗi khi hủy hợp đồng: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Test sp_HuyHopDong
PRINT N'--- Test sp_HuyHopDong ---';
-- Chọn 1 HĐ đang 'Hiệu lực' hoặc 'Tạm dừng' để hủy
DECLARE @MaHDTestHuy INT = (SELECT TOP 1 MaHD FROM HOPDONG WHERE TrangThai IN (N'Hiệu lực', N'Tạm dừng'));
DECLARE @TrangThaiTruocHuy NVARCHAR(30);
IF @MaHDTestHuy IS NOT NULL
BEGIN
    SELECT @TrangThaiTruocHuy = TrangThai FROM HOPDONG WHERE MaHD = @MaHDTestHuy;
    PRINT N'Trạng thái HĐ ' + CAST(@MaHDTestHuy AS VARCHAR) + N' trước khi hủy: ' + @TrangThaiTruocHuy;
    -- Thực hiện hủy
    EXEC sp_HuyHopDong @MaHD = @MaHDTestHuy, @LyDoHuy = N'Khách yêu cầu - Test';
    -- Kiểm tra trạng thái sau khi hủy
    SELECT MaHD, TrangThai, GhiChu FROM HOPDONG WHERE MaHD = @MaHDTestHuy; -- Dự kiến TrangThai = 'Huỷ', GhiChu được cập nhật
    -- Thử hủy lần nữa
    EXEC sp_HuyHopDong @MaHD = @MaHDTestHuy; -- Dự kiến RAISERROR
    -- Hoàn tác (chuyển lại trạng thái cũ) - Chỉ zu zu zu zu zu test
    -- UPDATE HOPDONG SET TrangThai = @TrangThaiTruocHuy, GhiChu = REPLACE(GhiChu, '; Hủy ngày ...', '') WHERE MaHD = @MaHDTestHuy;
    PRINT N'Đã hủy HĐ ' + CAST(@MaHDTestHuy AS VARCHAR) + N'. Cần hoàn tác thủ công nếu muốn giữ HĐ.';
END
ELSE
BEGIN
    PRINT N'Không tìm thấy HĐ phù hợp để test hủy.';
END
-- Test lỗi: HĐ không tồn tại
EXEC sp_HuyHopDong @MaHD = 9999; -- Dự kiến RAISERROR
GO