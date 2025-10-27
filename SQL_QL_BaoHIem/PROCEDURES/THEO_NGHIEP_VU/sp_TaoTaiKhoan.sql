CREATE OR ALTER PROCEDURE sp_TaoTaiKhoan
    @TenDangNhap VARCHAR(100),
    @MatKhau VARCHAR(100), -- Mật khẩu dạng text, sẽ được hash
    @LoaiTK NVARCHAR(20),  -- 'NV' hoặc 'KH'
    @MaLienKet INT        -- MaNV nếu là NV, MaKH nếu là KH
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra loại tài khoản hợp lệ
        IF @LoaiTK NOT IN (N'NV', N'KH')
        BEGIN
            RAISERROR(N'Loại tài khoản phải là "NV" hoặc "KH".', 16, 1);
            RETURN;
        END

        -- Kiểm tra tên đăng nhập đã tồn tại chưa
        IF EXISTS (SELECT 1 FROM TAIKHOAN WHERE TenDangNhap = @TenDangNhap)
        BEGIN
            RAISERROR(N'Tên đăng nhập đã tồn tại.', 16, 1);
            RETURN;
        END

        DECLARE @MaNV INT = NULL;
        DECLARE @MaKH INT = NULL;

        -- Kiểm tra MaNV hoặc MaKH có tồn tại và chưa có tài khoản
        IF @LoaiTK = N'NV'
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM NHANVIEN WHERE MaNV = @MaLienKet)
            BEGIN
                RAISERROR(N'Mã nhân viên không tồn tại.', 16, 1);
                RETURN;
            END
            IF EXISTS (SELECT 1 FROM TAIKHOAN WHERE MaNV = @MaLienKet)
            BEGIN
                RAISERROR(N'Nhân viên này đã có tài khoản.', 16, 1);
                RETURN;
            END
            SET @MaNV = @MaLienKet;
        END
        ELSE -- @LoaiTK = N'KH'
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM KHACHHANG WHERE MaKH = @MaLienKet)
            BEGIN
                RAISERROR(N'Mã khách hàng không tồn tại.', 16, 1);
                RETURN;
            END
             IF EXISTS (SELECT 1 FROM TAIKHOAN WHERE MaKH = @MaLienKet)
            BEGIN
                RAISERROR(N'Khách hàng này đã có tài khoản.', 16, 1);
                RETURN;
            END
            SET @MaKH = @MaLienKet;
        END

        -- Hash mật khẩu
        DECLARE @MatKhauHash VARBINARY(256) = HASHBYTES('SHA2_256', @MatKhau);

        -- Thêm tài khoản
        INSERT INTO TAIKHOAN (TenDangNhap, MatKhauHash, LoaiTK, MaKH, MaNV)
        VALUES (@TenDangNhap, @MatKhauHash, @LoaiTK, @MaKH, @MaNV);

        PRINT N'Tạo tài khoản thành công cho ' + @TenDangNhap;

    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi tạo tài khoản: ' + ERROR_MESSAGE();
        -- Có thể thêm log lỗi vào bảng nếu cần
    END CATCH
END;
GO

-- 5. Test sp_TaoTaiKhoan
PRINT N'--- Test sp_TaoTaiKhoan ---';
-- TH thành công NV (Giả sử NV 165 chưa có TK)
EXEC sp_TaoTaiKhoan @TenDangNhap = 'NVTEST165', @MatKhau = 'password123', @LoaiTK = N'NV', @MaLienKet = 165;
-- TH thành công KH (Giả sử KH 500 chưa có TK)
EXEC sp_TaoTaiKhoan @TenDangNhap = 'KHTEST500', @MatKhau = 'khachhang@', @LoaiTK = N'KH', @MaLienKet = 500;
-- TH lỗi: Tên đăng nhập trùng
EXEC sp_TaoTaiKhoan @TenDangNhap = 'NVTEST165', @MatKhau = 'password123', @LoaiTK = N'NV', @MaLienKet = 166; -- Dự kiến lỗi RAISERROR
-- TH lỗi: Mã liên kết không tồn tại
EXEC sp_TaoTaiKhoan @TenDangNhap = 'NVTEST999', @MatKhau = 'password123', @LoaiTK = N'NV', @MaLienKet = 999; -- Dự kiến lỗi RAISERROR
-- TH lỗi: Mã liên kết đã có tài khoản
EXEC sp_TaoTaiKhoan @TenDangNhap = 'NVTEST001_NEW', @MatKhau = 'password123', @LoaiTK = N'NV', @MaLienKet = 1; -- Dự kiến lỗi RAISERROR
-- TH lỗi: Loại TK không hợp lệ
EXEC sp_TaoTaiKhoan @TenDangNhap = 'TESTINVALID', @MatKhau = 'password123', @LoaiTK = N'ADMIN', @MaLienKet = 1; -- Dự kiến lỗi RAISERROR
-- Kiểm tra tài khoản đã tạo
SELECT * FROM TAIKHOAN WHERE TenDangNhap IN ('NVTEST165', 'KHTEST500');
-- Xóa tài khoản test
DELETE FROM TAIKHOAN WHERE TenDangNhap IN ('NVTEST165', 'KHTEST500');
GO