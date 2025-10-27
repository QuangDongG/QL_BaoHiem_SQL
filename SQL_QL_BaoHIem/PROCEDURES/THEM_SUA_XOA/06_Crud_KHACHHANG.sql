USE QL_BaoHiem;
GO

/* Thêm khách hàng */
CREATE OR ALTER PROCEDURE SP_Them_KhachHang
    @HoTen NVARCHAR(120),
    @NgaySinh DATE = NULL,
    @GioiTinh NCHAR(3),
    @CCCD VARCHAR(20) = NULL,
    @DiaChi NVARCHAR(255) = NULL,
    @SDT VARCHAR(20) = NULL,
    @Email VARCHAR(150) = NULL,
    @NgheNghiep NVARCHAR(100) = NULL,
    @ThuNhap DECIMAL(18,2) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra giới tính hợp lệ
        IF @GioiTinh NOT IN (N'Nam', N'Nữ', N'Khác')
        BEGIN
            RAISERROR(N'Giới tính không hợp lệ. Chỉ được nhập Nam, Nữ hoặc Khác.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra trùng CCCD
        IF @CCCD IS NOT NULL AND EXISTS (SELECT 1 FROM KHACHHANG WHERE CCCD = @CCCD)
        BEGIN
            RAISERROR(N'CCCD đã tồn tại.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra trùng Email
        IF @Email IS NOT NULL AND EXISTS (SELECT 1 FROM KHACHHANG WHERE Email = @Email)
        BEGIN
            RAISERROR(N'Email khách hàng đã tồn tại.', 16, 1);
            RETURN;
        END;

        INSERT INTO KHACHHANG (HoTen, NgaySinh, GioiTinh, CCCD, DiaChi, SDT, Email, NgheNghiep, ThuNhap)
        VALUES (@HoTen, @NgaySinh, @GioiTinh, @CCCD, @DiaChi, @SDT, @Email, @NgheNghiep, @ThuNhap);

        PRINT N'Thêm khách hàng thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi thêm khách hàng: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


/* Sửa thông tin khách hàng */
CREATE OR ALTER PROCEDURE SP_Sua_KhachHang
    @MaKH INT,
    @HoTen NVARCHAR(120),
    @NgaySinh DATE = NULL,
    @GioiTinh NCHAR(3),
    @CCCD VARCHAR(20) = NULL,
    @DiaChi NVARCHAR(255) = NULL,
    @SDT VARCHAR(20) = NULL,
    @Email VARCHAR(150) = NULL,
    @NgheNghiep NVARCHAR(100) = NULL,
    @ThuNhap DECIMAL(18,2) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra tồn tại khách hàng
        IF NOT EXISTS (SELECT 1 FROM KHACHHANG WHERE MaKH = @MaKH)
        BEGIN
            RAISERROR(N'Không tìm thấy khách hàng cần sửa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra giới tính hợp lệ
        IF @GioiTinh NOT IN (N'Nam', N'Nữ', N'Khác')
        BEGIN
            RAISERROR(N'Giới tính không hợp lệ. Chỉ được nhập Nam, Nữ hoặc Khác.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra trùng CCCD với khách khác
        IF @CCCD IS NOT NULL AND EXISTS (SELECT 1 FROM KHACHHANG WHERE CCCD = @CCCD AND MaKH <> @MaKH)
        BEGIN
            RAISERROR(N'CCCD đã tồn tại ở khách hàng khác.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra trùng Email với khách khác
        IF @Email IS NOT NULL AND EXISTS (SELECT 1 FROM KHACHHANG WHERE Email = @Email AND MaKH <> @MaKH)
        BEGIN
            RAISERROR(N'Email này đã được sử dụng bởi khách hàng khác.', 16, 1);
            RETURN;
        END;

        UPDATE KHACHHANG
        SET HoTen = @HoTen,
            NgaySinh = @NgaySinh,
            GioiTinh = @GioiTinh,
            CCCD = @CCCD,
            DiaChi = @DiaChi,
            SDT = @SDT,
            Email = @Email,
            NgheNghiep = @NgheNghiep,
            ThuNhap = @ThuNhap
        WHERE MaKH = @MaKH;

        PRINT N'Cập nhật thông tin khách hàng thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi sửa khách hàng: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


/* Xóa khách hàng */
CREATE OR ALTER PROCEDURE SP_Xoa_KhachHang
    @MaKH INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra tồn tại
        IF NOT EXISTS (SELECT 1 FROM KHACHHANG WHERE MaKH = @MaKH)
        BEGIN
            RAISERROR(N'Không tìm thấy khách hàng cần xóa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra có liên kết dữ liệu ở bảng khác
        IF EXISTS (SELECT 1 FROM HOPDONG WHERE MaKH = @MaKH)
            OR EXISTS (SELECT 1 FROM YEUCAUBOITHUONG YC JOIN HOPDONG HD ON YC.MaHD = HD.MaHD WHERE HD.MaKH = @MaKH)
            OR EXISTS (SELECT 1 FROM TAIKHOAN WHERE MaKH = @MaKH)
        BEGIN
            RAISERROR(N'Không thể xóa khách hàng này vì đang có dữ liệu liên quan trong Hợp đồng, Bồi thường hoặc Tài khoản.', 16, 1);
            RETURN;
        END;

        DELETE FROM KHACHHANG WHERE MaKH = @MaKH;

        PRINT N'Xóa khách hàng thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi xóa khách hàng: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
