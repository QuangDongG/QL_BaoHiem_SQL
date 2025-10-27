CREATE OR ALTER PROCEDURE sp_CapNhatThongTinLienHeKhachHang
    @MaKH INT,
    @SDT VARCHAR(20) = NULL, -- NULL nếu không muốn cập nhật
    @Email VARCHAR(150) = NULL -- NULL nếu không muốn cập nhật
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra khách hàng tồn tại
        IF NOT EXISTS (SELECT 1 FROM KHACHHANG WHERE MaKH = @MaKH)
        BEGIN
            RAISERROR(N'Không tìm thấy khách hàng cần cập nhật.', 16, 1);
            RETURN;
        END

        -- Kiểm tra xem có gì để cập nhật không
        IF @SDT IS NULL AND @Email IS NULL
        BEGIN
             RAISERROR(N'Phải cung cấp ít nhất SĐT hoặc Email mới.', 16, 1);
            RETURN;
        END

        -- Kiểm tra Email mới (nếu có) có bị trùng với KH khác không
        IF @Email IS NOT NULL AND EXISTS (SELECT 1 FROM KHACHHANG WHERE Email = @Email AND MaKH <> @MaKH)
        BEGIN
            RAISERROR(N'Email mới đã được sử dụng bởi khách hàng khác.', 16, 1);
            RETURN;
        END

        -- Thực hiện cập nhật
        UPDATE KHACHHANG
        SET SDT = ISNULL(@SDT, SDT), -- Giữ giá trị cũ nếu tham số là NULL
            Email = ISNULL(@Email, Email)
        WHERE MaKH = @MaKH;

        PRINT N'Cập nhật thông tin liên hệ cho khách hàng ' + CAST(@MaKH AS VARCHAR) + N' thành công!';

    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi cập nhật thông tin liên hệ khách hàng: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Test sp_CapNhatThongTinLienHeKhachHang
PRINT N'--- Test sp_CapNhatThongTinLienHeKhachHang ---';
DECLARE @MaKHTestUpdate INT = 1;
DECLARE @SDTCu VARCHAR(20), @EmailCu VARCHAR(150);
-- Lấy thông tin cũ
SELECT @SDTCu = SDT, @EmailCu = Email FROM KHACHHANG WHERE MaKH = @MaKHTestUpdate;
PRINT N'Thông tin cũ KH ' + CAST(@MaKHTestUpdate AS VARCHAR) + N' - SĐT: ' + ISNULL(@SDTCu,'NULL') + N', Email: ' + ISNULL(@EmailCu,'NULL');
-- TH Cập nhật SĐT
EXEC sp_CapNhatThongTinLienHeKhachHang @MaKH = @MaKHTestUpdate, @SDT = '0987654321';
SELECT SDT, Email FROM KHACHHANG WHERE MaKH = @MaKHTestUpdate;
-- TH Cập nhật Email
EXEC sp_CapNhatThongTinLienHeKhachHang @MaKH = @MaKHTestUpdate, @Email = 'emailmoi@test.com';
SELECT SDT, Email FROM KHACHHANG WHERE MaKH = @MaKHTestUpdate;
-- TH Cập nhật cả hai
EXEC sp_CapNhatThongTinLienHeKhachHang @MaKH = @MaKHTestUpdate, @SDT = '1122334455', @Email = 'emailmoi2@test.com';
SELECT SDT, Email FROM KHACHHANG WHERE MaKH = @MaKHTestUpdate;
-- TH lỗi: Không có gì cập nhật
EXEC sp_CapNhatThongTinLienHeKhachHang @MaKH = @MaKHTestUpdate; -- Dự kiến RAISERROR
-- TH lỗi: Email trùng (Giả sử email KH 2 là huynhhuutung2@gmail.com)
-- EXEC sp_CapNhatThongTinLienHeKhachHang @MaKH = @MaKHTestUpdate, @Email = 'huynhhuutung2@gmail.com'; -- Dự kiến RAISERROR
-- TH lỗi: MaKH không tồn tại
EXEC sp_CapNhatThongTinLienHeKhachHang @MaKH = 9999, @SDT = '000'; -- Dự kiến RAISERROR
-- Hoàn tác thay đổi
EXEC sp_CapNhatThongTinLienHeKhachHang @MaKH = @MaKHTestUpdate, @SDT = @SDTCu, @Email = @EmailCu;
PRINT N'Đã hoàn tác thông tin KH ' + CAST(@MaKHTestUpdate AS VARCHAR);
SELECT SDT, Email FROM KHACHHANG WHERE MaKH = @MaKHTestUpdate;
GO