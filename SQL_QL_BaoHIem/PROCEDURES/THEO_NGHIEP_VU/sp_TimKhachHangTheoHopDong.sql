CREATE OR ALTER PROCEDURE sp_TimKhachHangTheoHopDong
    @MaHD INT = NULL,
    @MaSoHD VARCHAR(30) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF @MaHD IS NULL AND @MaSoHD IS NULL
        BEGIN
            RAISERROR(N'Phải cung cấp Mã hợp đồng (MaHD) hoặc Mã số hợp đồng (MaSoHD).', 16, 1);
            RETURN;
        END

        DECLARE @ActualMaHD INT = @MaHD;

        -- Nếu chỉ cung cấp MaSoHD, tìm MaHD tương ứng
        IF @ActualMaHD IS NULL AND @MaSoHD IS NOT NULL
        BEGIN
            SELECT @ActualMaHD = MaHD FROM HOPDONG WHERE MaSoHD = @MaSoHD;
            IF @ActualMaHD IS NULL
            BEGIN
                RAISERROR(N'Không tìm thấy hợp đồng với Mã số HĐ cung cấp.', 16, 1);
                RETURN;
            END
        END
        ELSE IF NOT EXISTS (SELECT 1 FROM HOPDONG WHERE MaHD = @ActualMaHD) -- Kiểm tra MaHD nếu được cung cấp
        BEGIN
             RAISERROR(N'Mã hợp đồng không tồn tại.', 16, 1);
             RETURN;
        END

        -- Lấy thông tin khách hàng
        SELECT
            kh.MaKH,
            kh.HoTen,
            kh.NgaySinh,
            kh.GioiTinh,
            kh.CCCD,
            kh.DiaChi,
            kh.SDT,
            kh.Email,
            kh.NgheNghiep
        FROM KHACHHANG kh
        JOIN HOPDONG hd ON kh.MaKH = hd.MaKH
        WHERE hd.MaHD = @ActualMaHD;

    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi tìm khách hàng theo hợp đồng: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Test sp_TimKhachHangTheoHopDong
PRINT N'--- Test sp_TimKhachHangTheoHopDong ---';
-- Test tìm theo MaHD (Giả sử HĐ 1 tồn tại)
PRINT N'Tìm KH theo MaHD = 1:';
EXEC sp_TimKhachHangTheoHopDong @MaHD = 1;
-- Test tìm theo MaSoHD (Lấy MaSoHD của HĐ 1)
DECLARE @MaSoHD_1 VARCHAR(30) = (SELECT MaSoHD FROM HOPDONG WHERE MaHD = 1);
PRINT N'Tìm KH theo MaSoHD = ' + @MaSoHD_1 + N':';
EXEC sp_TimKhachHangTheoHopDong @MaSoHD = @MaSoHD_1;
-- Test lỗi: Không cung cấp tham số
PRINT N'Test lỗi: Không cung cấp MaHD hay MaSoHD:';
EXEC sp_TimKhachHangTheoHopDong; -- Dự kiến RAISERROR
-- Test lỗi: MaHD không tồn tại
PRINT N'Test lỗi: MaHD = 9999 (không tồn tại):';
EXEC sp_TimKhachHangTheoHopDong @MaHD = 9999; -- Dự kiến RAISERROR
-- Test lỗi: MaSoHD không tồn tại
PRINT N'Test lỗi: MaSoHD = "HD-KHONG-TON-TAI":';
EXEC sp_TimKhachHangTheoHopDong @MaSoHD = 'HD-KHONG-TON-TAI'; -- Dự kiến RAISERROR
GO