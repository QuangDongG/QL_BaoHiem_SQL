<<<<<<< HEAD
USE QL_BaoHiem;
GO

/*Thêm phòng ban */
CREATE OR ALTER PROCEDURE SP_Them_PhongBan
    @TenPhong NVARCHAR(100),
    @MoTa NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra trùng tên phòng
        IF EXISTS (SELECT 1 FROM PHONGBAN WHERE TenPhong = @TenPhong)
        BEGIN
            RAISERROR(N'Tên phòng ban đã tồn tại.', 16, 1);
            RETURN;
        END;

        INSERT INTO PHONGBAN (TenPhong, MoTa)
        VALUES (@TenPhong, @MoTa);

        PRINT N'Thêm phòng ban thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi thêm phòng ban: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

--Sửa
CREATE OR ALTER PROCEDURE SP_Sua_PhongBan
    @MaPhong INT,
    @TenPhong NVARCHAR(100),
    @MoTa NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra tồn tại mã cần sửa
        IF NOT EXISTS (SELECT 1 FROM PHONGBAN WHERE MaPhong = @MaPhong)
        BEGIN
            RAISERROR(N'Không tìm thấy phòng ban cần sửa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra trùng tên với bản ghi khác
        IF EXISTS (SELECT 1 FROM PHONGBAN WHERE TenPhong = @TenPhong AND MaPhong <> @MaPhong)
        BEGIN
            RAISERROR(N'Tên phòng ban đã tồn tại ở bản ghi khác.', 16, 1);
            RETURN;
        END;

        UPDATE PHONGBAN
        SET TenPhong = @TenPhong,
            MoTa = @MoTa
        WHERE MaPhong = @MaPhong;

        PRINT N'Sửa thông tin phòng ban thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi sửa phòng ban: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


--Xóa
CREATE OR ALTER PROCEDURE SP_Xoa_PhongBan
    @MaPhong INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra tồn tại
        IF NOT EXISTS (SELECT 1 FROM PHONGBAN WHERE MaPhong = @MaPhong)
        BEGIN
            RAISERROR(N'Không tìm thấy phòng ban cần xóa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra có nhân viên thuộc phòng này không
        IF EXISTS (SELECT 1 FROM NHANVIEN WHERE MaPhong = @MaPhong)
        BEGIN
            RAISERROR(N'Không thể xóa phòng ban vì đang có nhân viên thuộc phòng này.', 16, 1);
            RETURN;
        END;

        DELETE FROM PHONGBAN WHERE MaPhong = @MaPhong;

        PRINT N'Xóa phòng ban thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi xóa phòng ban: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
=======
USE QL_BaoHiem;
GO

/*Thêm phòng ban */
CREATE OR ALTER PROCEDURE SP_Them_PhongBan
    @TenPhong NVARCHAR(100),
    @MoTa NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra trùng tên phòng
        IF EXISTS (SELECT 1 FROM PHONGBAN WHERE TenPhong = @TenPhong)
        BEGIN
            RAISERROR(N'Tên phòng ban đã tồn tại.', 16, 1);
            RETURN;
        END;

        INSERT INTO PHONGBAN (TenPhong, MoTa)
        VALUES (@TenPhong, @MoTa);

        PRINT N'Thêm phòng ban thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi thêm phòng ban: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

--Sửa
CREATE OR ALTER PROCEDURE SP_Sua_PhongBan
    @MaPhong INT,
    @TenPhong NVARCHAR(100),
    @MoTa NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra tồn tại mã cần sửa
        IF NOT EXISTS (SELECT 1 FROM PHONGBAN WHERE MaPhong = @MaPhong)
        BEGIN
            RAISERROR(N'Không tìm thấy phòng ban cần sửa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra trùng tên với bản ghi khác
        IF EXISTS (SELECT 1 FROM PHONGBAN WHERE TenPhong = @TenPhong AND MaPhong <> @MaPhong)
        BEGIN
            RAISERROR(N'Tên phòng ban đã tồn tại ở bản ghi khác.', 16, 1);
            RETURN;
        END;

        UPDATE PHONGBAN
        SET TenPhong = @TenPhong,
            MoTa = @MoTa
        WHERE MaPhong = @MaPhong;

        PRINT N'Sửa thông tin phòng ban thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi sửa phòng ban: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


--Xóa
CREATE OR ALTER PROCEDURE SP_Xoa_PhongBan
    @MaPhong INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra tồn tại
        IF NOT EXISTS (SELECT 1 FROM PHONGBAN WHERE MaPhong = @MaPhong)
        BEGIN
            RAISERROR(N'Không tìm thấy phòng ban cần xóa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra có nhân viên thuộc phòng này không
        IF EXISTS (SELECT 1 FROM NHANVIEN WHERE MaPhong = @MaPhong)
        BEGIN
            RAISERROR(N'Không thể xóa phòng ban vì đang có nhân viên thuộc phòng này.', 16, 1);
            RETURN;
        END;

        DELETE FROM PHONGBAN WHERE MaPhong = @MaPhong;

        PRINT N'Xóa phòng ban thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi xóa phòng ban: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
>>>>>>> 59c5acf48653319ce8c913c2014f62e09ddfb835
