USE QL_BaoHiem;
GO
/*Thêm tài khoản */
CREATE OR ALTER PROCEDURE SP_Them_TaiKhoan
    @TenDangNhap VARCHAR(100),
    @MatKhauHash VARBINARY(256),
    @LoaiTK NVARCHAR(20),
    @MaKH INT = NULL,
    @MaNV INT = NULL,
    @TrangThai NVARCHAR(20) = N'Hoạt động'
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        --Kiểm tra trùng tên đăng nhập
        IF EXISTS (SELECT 1 FROM TAIKHOAN WHERE TenDangNhap = @TenDangNhap)
        BEGIN
            RAISERROR(N'Tên đăng nhập đã tồn tại.', 16, 1);
            RETURN;
        END;

        --Kiểm tra loại tài khoản hợp lệ
        IF @LoaiTK NOT IN (N'KH', N'NV')
        BEGIN
            RAISERROR(N'Loại tài khoản không hợp lệ. Chỉ chấp nhận KH hoặc NV.', 16, 1);
            RETURN;
        END;

        --Kiểm tra ràng buộc loại tài khoản
        IF @LoaiTK = N'KH' AND @MaKH IS NULL
        BEGIN
            RAISERROR(N'Tài khoản loại KH phải liên kết với mã khách hàng.', 16, 1);
            RETURN;
        END;
        IF @LoaiTK = N'NV' AND @MaNV IS NULL
        BEGIN
            RAISERROR(N'Tài khoản loại NV phải liên kết với mã nhân viên.', 16, 1);
            RETURN;
        END;

        --Kiểm tra tồn tại của KH hoặc NV
        IF @MaKH IS NOT NULL AND NOT EXISTS (SELECT 1 FROM KHACHHANG WHERE MaKH = @MaKH)
        BEGIN
            RAISERROR(N'Mã khách hàng không tồn tại.', 16, 1);
            RETURN;
        END;
        IF @MaNV IS NOT NULL AND NOT EXISTS (SELECT 1 FROM NHANVIEN WHERE MaNV = @MaNV)
        BEGIN
            RAISERROR(N'Mã nhân viên không tồn tại.', 16, 1);
            RETURN;
        END;

        INSERT INTO TAIKHOAN (TenDangNhap, MatKhauHash, LoaiTK, MaKH, MaNV, NgayTao, TrangThai)
        VALUES (@TenDangNhap, @MatKhauHash, @LoaiTK, @MaKH, @MaNV, GETDATE(), @TrangThai);

        PRINT N'Thêm tài khoản thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi thêm tài khoản: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


/*Sửa tài khoản */
CREATE OR ALTER PROCEDURE SP_Sua_TaiKhoan
    @MaTK INT,
    @TenDangNhap VARCHAR(100),
    @MatKhauHash VARBINARY(256),
    @LoaiTK NVARCHAR(20),
    @MaKH INT = NULL,
    @MaNV INT = NULL,
    @TrangThai NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        --Kiểm tra tồn tại tài khoản
        IF NOT EXISTS (SELECT 1 FROM TAIKHOAN WHERE MaTK = @MaTK)
        BEGIN
            RAISERROR(N'Không tìm thấy tài khoản cần sửa.', 16, 1);
            RETURN;
        END;

        --Kiểm tra trùng tên đăng nhập
        IF EXISTS (SELECT 1 FROM TAIKHOAN WHERE TenDangNhap = @TenDangNhap AND MaTK <> @MaTK)
        BEGIN
            RAISERROR(N'Tên đăng nhập đã tồn tại ở tài khoản khác.', 16, 1);
            RETURN;
        END;

        --Kiểm tra loại tài khoản hợp lệ
        IF @LoaiTK NOT IN (N'KH', N'NV')
        BEGIN
            RAISERROR(N'Loại tài khoản không hợp lệ.', 16, 1);
            RETURN;
        END;

        --Kiểm tra ràng buộc loại tài khoản
        IF @LoaiTK = N'KH' AND @MaKH IS NULL
        BEGIN
            RAISERROR(N'Tài khoản KH phải có mã khách hàng.', 16, 1);
            RETURN;
        END;
        IF @LoaiTK = N'NV' AND @MaNV IS NULL
        BEGIN
            RAISERROR(N'Tài khoản NV phải có mã nhân viên.', 16, 1);
            RETURN;
        END;

        --Kiểm tra tồn tại khách hàng hoặc nhân viên
        IF @MaKH IS NOT NULL AND NOT EXISTS (SELECT 1 FROM KHACHHANG WHERE MaKH = @MaKH)
        BEGIN
            RAISERROR(N'Mã khách hàng không tồn tại.', 16, 1);
            RETURN;
        END;
        IF @MaNV IS NOT NULL AND NOT EXISTS (SELECT 1 FROM NHANVIEN WHERE MaNV = @MaNV)
        BEGIN
            RAISERROR(N'Mã nhân viên không tồn tại.', 16, 1);
            RETURN;
        END;

        UPDATE TAIKHOAN
        SET TenDangNhap = @TenDangNhap,
            MatKhauHash = @MatKhauHash,
            LoaiTK = @LoaiTK,
            MaKH = @MaKH,
            MaNV = @MaNV,
            TrangThai = @TrangThai
        WHERE MaTK = @MaTK;

        PRINT N'Cập nhật tài khoản thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi sửa tài khoản: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


/*Xóa tài khoản */
CREATE OR ALTER PROCEDURE SP_Xoa_TaiKhoan
    @MaTK INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        --Kiểm tra tồn tại
        IF NOT EXISTS (SELECT 1 FROM TAIKHOAN WHERE MaTK = @MaTK)
        BEGIN
            RAISERROR(N'Không tìm thấy tài khoản cần xóa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra có lịch sử truy cập (nếu có)
        IF EXISTS (SELECT 1 FROM LICHSU_TRUY_CAP WHERE MaTK = @MaTK)
        BEGIN
            RAISERROR(N'Không thể xóa tài khoản vì đã có lịch sử truy cập.', 16, 1);
            RETURN;
        END;

        DELETE FROM TAIKHOAN WHERE MaTK = @MaTK;

        PRINT N'Xóa tài khoản thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi xóa tài khoản: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
