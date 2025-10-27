USE QL_BaoHiem;
GO

/* Thêm nhân viên */
CREATE OR ALTER PROCEDURE SP_Them_NhanVien
    @HoTen NVARCHAR(120),
    @GioiTinh NCHAR(3),
    @NgaySinh DATE = NULL,
    @SDT VARCHAR(20) = NULL,
    @Email VARCHAR(150),
    @DiaChi NVARCHAR(255) = NULL,
    @ChucVu NVARCHAR(100) = NULL,
    @Luong DECIMAL(18,2) = 0,
    @MaPhong INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra trùng email
        IF EXISTS (SELECT 1 FROM NHANVIEN WHERE Email = @Email)
        BEGIN
            RAISERROR(N'Email nhân viên đã tồn tại.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra giới tính hợp lệ
        IF @GioiTinh NOT IN (N'Nam', N'Nữ', N'Khác')
        BEGIN
            RAISERROR(N'Giới tính không hợp lệ. Chỉ được nhập Nam, Nữ hoặc Khác.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra phòng ban nếu có
        IF @MaPhong IS NOT NULL AND NOT EXISTS (SELECT 1 FROM PHONGBAN WHERE MaPhong = @MaPhong)
        BEGIN
            RAISERROR(N'Mã phòng ban không tồn tại.', 16, 1);
            RETURN;
        END;

        INSERT INTO NHANVIEN (HoTen, GioiTinh, NgaySinh, SDT, Email, DiaChi, ChucVu, Luong, MaPhong)
        VALUES (@HoTen, @GioiTinh, @NgaySinh, @SDT, @Email, @DiaChi, @ChucVu, @Luong, @MaPhong);

        PRINT N'Thêm nhân viên thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi thêm nhân viên: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


/* Sửa thông tin nhân viên */
CREATE OR ALTER PROCEDURE SP_Sua_NhanVien
    @MaNV INT,
    @HoTen NVARCHAR(120),
    @GioiTinh NCHAR(3),
    @NgaySinh DATE = NULL,
    @SDT VARCHAR(20) = NULL,
    @Email VARCHAR(150),
    @DiaChi NVARCHAR(255) = NULL,
    @ChucVu NVARCHAR(100) = NULL,
    @Luong DECIMAL(18,2) = 0,
    @MaPhong INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra tồn tại nhân viên
        IF NOT EXISTS (SELECT 1 FROM NHANVIEN WHERE MaNV = @MaNV)
        BEGIN
            RAISERROR(N'Không tìm thấy nhân viên cần sửa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra trùng email với người khác
        IF EXISTS (SELECT 1 FROM NHANVIEN WHERE Email = @Email AND MaNV <> @MaNV)
        BEGIN
            RAISERROR(N'Email này đã được sử dụng bởi nhân viên khác.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra giới tính hợp lệ
        IF @GioiTinh NOT IN (N'Nam', N'Nữ', N'Khác')
        BEGIN
            RAISERROR(N'Giới tính không hợp lệ. Chỉ được nhập Nam, Nữ hoặc Khác.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra mã phòng hợp lệ nếu có
        IF @MaPhong IS NOT NULL AND NOT EXISTS (SELECT 1 FROM PHONGBAN WHERE MaPhong = @MaPhong)
        BEGIN
            RAISERROR(N'Mã phòng ban không tồn tại.', 16, 1);
            RETURN;
        END;

        UPDATE NHANVIEN
        SET HoTen = @HoTen,
            GioiTinh = @GioiTinh,
            NgaySinh = @NgaySinh,
            SDT = @SDT,
            Email = @Email,
            DiaChi = @DiaChi,
            ChucVu = @ChucVu,
            Luong = @Luong,
            MaPhong = @MaPhong
        WHERE MaNV = @MaNV;

        PRINT N'Cập nhật thông tin nhân viên thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi sửa nhân viên: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


/*Xóa nhân viên */
CREATE OR ALTER PROCEDURE SP_Xoa_NhanVien
    @MaNV INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra nhân viên tồn tại
        IF NOT EXISTS (SELECT 1 FROM NHANVIEN WHERE MaNV = @MaNV)
        BEGIN
            RAISERROR(N'Không tìm thấy nhân viên cần xóa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra nhân viên có liên kết với bảng khác không
        IF EXISTS (SELECT 1 FROM HOPDONG WHERE MaNV_TuVan = @MaNV)
            OR EXISTS (SELECT 1 FROM THANHTOANPHI WHERE MaNV_Thu = @MaNV)
            OR EXISTS (SELECT 1 FROM CHITRABOITHUONG WHERE MaNV_Chi = @MaNV)
            OR EXISTS (SELECT 1 FROM TAIKHOAN WHERE MaNV = @MaNV)
        BEGIN
            RAISERROR(N'Không thể xóa nhân viên này vì đang được sử dụng trong các bảng liên quan.', 16, 1);
            RETURN;
        END;

        DELETE FROM NHANVIEN WHERE MaNV = @MaNV;

        PRINT N'Xóa nhân viên thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi xóa nhân viên: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
