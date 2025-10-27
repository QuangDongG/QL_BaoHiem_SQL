CREATE OR ALTER PROCEDURE sp_TimHopDongTheoKhachHang
    @MaKH INT = NULL,
    @CCCD VARCHAR(20) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF @MaKH IS NULL AND @CCCD IS NULL
        BEGIN
            RAISERROR(N'Phải cung cấp Mã khách hàng (MaKH) hoặc CCCD.', 16, 1);
            RETURN;
        END

        DECLARE @ActualMaKH INT = @MaKH;

        -- Nếu chỉ cung cấp CCCD, tìm MaKH tương ứng
        IF @ActualMaKH IS NULL AND @CCCD IS NOT NULL
        BEGIN
            SELECT @ActualMaKH = MaKH FROM KHACHHANG WHERE CCCD = @CCCD;
            IF @ActualMaKH IS NULL
            BEGIN
                RAISERROR(N'Không tìm thấy khách hàng với CCCD cung cấp.', 16, 1);
                RETURN;
            END
        END
        ELSE IF NOT EXISTS (SELECT 1 FROM KHACHHANG WHERE MaKH = @ActualMaKH) -- Kiểm tra MaKH nếu được cung cấp
        BEGIN
             RAISERROR(N'Mã khách hàng không tồn tại.', 16, 1);
             RETURN;
        END

        -- Lấy thông tin hợp đồng
        SELECT
            hd.MaHD,
            hd.MaSoHD,
            gbh.TenGoi AS TenGoiBaoHiem,
            lbh.TenLoai AS TenLoaiBaoHiem,
            hd.NgayKy,
            hd.NgayHieuLuc,
            hd.NgayHetHan,
            hd.TrangThai
        FROM HOPDONG hd
        JOIN GOIBAOHIEM gbh ON hd.MaGoi = gbh.MaGoi
        JOIN LOAIBAOHIEM lbh ON gbh.MaLoai = lbh.MaLoai
        WHERE hd.MaKH = @ActualMaKH
        ORDER BY hd.NgayKy DESC;

    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi tìm hợp đồng theo khách hàng: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Test sp_TimHopDongTheoKhachHang
PRINT N'--- Test sp_TimHopDongTheoKhachHang ---';
-- Test tìm theo MaKH (Giả sử KH 1 có hợp đồng)
PRINT N'Tìm HĐ theo MaKH = 1:';
EXEC sp_TimHopDongTheoKhachHang @MaKH = 1;
-- Test tìm theo CCCD (Lấy CCCD của KH 1)
DECLARE @CCCD_KH1 VARCHAR(20) = (SELECT CCCD FROM KHACHHANG WHERE MaKH = 1);
PRINT N'Tìm HĐ theo CCCD = ' + @CCCD_KH1 + N':';
EXEC sp_TimHopDongTheoKhachHang @CCCD = @CCCD_KH1;
-- Test lỗi: Không cung cấp tham số
PRINT N'Test lỗi: Không cung cấp MaKH hay CCCD:';
EXEC sp_TimHopDongTheoKhachHang; -- Dự kiến RAISERROR
-- Test lỗi: MaKH không tồn tại
PRINT N'Test lỗi: MaKH = 9999 (không tồn tại):';
EXEC sp_TimHopDongTheoKhachHang @MaKH = 9999; -- Dự kiến RAISERROR
-- Test lỗi: CCCD không tồn tại
PRINT N'Test lỗi: CCCD = "000000000000" (không tồn tại):';
EXEC sp_TimHopDongTheoKhachHang @CCCD = '000000000000'; -- Dự kiến RAISERROR
GO