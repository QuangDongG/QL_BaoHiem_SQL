<<<<<<< HEAD
USE QL_BaoHiem;
GO

CREATE PROCEDURE SP_Them_TinhTrangYeuCau
    @TenTT NVARCHAR(100),
    @MoTa NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra trùng tên tình trạng
        IF EXISTS (SELECT 1 FROM TINHTRANG_YEUCAU WHERE TenTT = @TenTT)
        BEGIN
            RAISERROR(N'Tên tình trạng yêu cầu đã tồn tại.', 16, 1);
            RETURN;
        END;

        INSERT INTO TINHTRANG_YEUCAU (TenTT, MoTa)
        VALUES (@TenTT, @MoTa);

        PRINT N'Thêm tình trạng yêu cầu thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi thêm tình trạng yêu cầu: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
--Sửa
CREATE PROCEDURE SP_Sua_TinhTrangYeuCau
    @MaTT INT,
    @TenTT NVARCHAR(100),
    @MoTa NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra tồn tại mã cần sửa
        IF NOT EXISTS (SELECT 1 FROM TINHTRANG_YEUCAU WHERE MaTT = @MaTT)
        BEGIN
            RAISERROR(N'Không tìm thấy tình trạng yêu cầu cần sửa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra trùng tên với bản ghi khác
        IF EXISTS (SELECT 1 FROM TINHTRANG_YEUCAU WHERE TenTT = @TenTT AND MaTT <> @MaTT)
        BEGIN
            RAISERROR(N'Tên tình trạng yêu cầu đã tồn tại ở bản ghi khác.', 16, 1);
            RETURN;
        END;

        UPDATE TINHTRANG_YEUCAU
        SET TenTT = @TenTT,
            MoTa = @MoTa
        WHERE MaTT = @MaTT;

        PRINT N'Cập nhật tình trạng yêu cầu thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi sửa tình trạng yêu cầu: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
--Xóa
CREATE PROCEDURE SP_Xoa_TinhTrangYeuCau
    @MaTT INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra tồn tại mã cần xóa
        IF NOT EXISTS (SELECT 1 FROM TINHTRANG_YEUCAU WHERE MaTT = @MaTT)
        BEGIN
            RAISERROR(N'Không tìm thấy tình trạng yêu cầu cần xóa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra có đang được sử dụng trong bảng YEUCAUBOITHUONG không
        IF EXISTS (SELECT 1 FROM YEUCAUBOITHUONG WHERE MaTT_TrangThai = @MaTT)
        BEGIN
            RAISERROR(N'Không thể xóa tình trạng này vì đang được sử dụng trong bảng YEUCAUBOITHUONG.', 16, 1);
            RETURN;
        END;

        DELETE FROM TINHTRANG_YEUCAU WHERE MaTT = @MaTT;

        PRINT N'Xóa tình trạng yêu cầu thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi xóa tình trạng yêu cầu: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
=======
USE QL_BaoHiem;
GO

CREATE PROCEDURE SP_Them_TinhTrangYeuCau
    @TenTT NVARCHAR(100),
    @MoTa NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra trùng tên tình trạng
        IF EXISTS (SELECT 1 FROM TINHTRANG_YEUCAU WHERE TenTT = @TenTT)
        BEGIN
            RAISERROR(N'Tên tình trạng yêu cầu đã tồn tại.', 16, 1);
            RETURN;
        END;

        INSERT INTO TINHTRANG_YEUCAU (TenTT, MoTa)
        VALUES (@TenTT, @MoTa);

        PRINT N'Thêm tình trạng yêu cầu thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi thêm tình trạng yêu cầu: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
--Sửa
CREATE PROCEDURE SP_Sua_TinhTrangYeuCau
    @MaTT INT,
    @TenTT NVARCHAR(100),
    @MoTa NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra tồn tại mã cần sửa
        IF NOT EXISTS (SELECT 1 FROM TINHTRANG_YEUCAU WHERE MaTT = @MaTT)
        BEGIN
            RAISERROR(N'Không tìm thấy tình trạng yêu cầu cần sửa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra trùng tên với bản ghi khác
        IF EXISTS (SELECT 1 FROM TINHTRANG_YEUCAU WHERE TenTT = @TenTT AND MaTT <> @MaTT)
        BEGIN
            RAISERROR(N'Tên tình trạng yêu cầu đã tồn tại ở bản ghi khác.', 16, 1);
            RETURN;
        END;

        UPDATE TINHTRANG_YEUCAU
        SET TenTT = @TenTT,
            MoTa = @MoTa
        WHERE MaTT = @MaTT;

        PRINT N'Cập nhật tình trạng yêu cầu thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi sửa tình trạng yêu cầu: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
--Xóa
CREATE PROCEDURE SP_Xoa_TinhTrangYeuCau
    @MaTT INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra tồn tại mã cần xóa
        IF NOT EXISTS (SELECT 1 FROM TINHTRANG_YEUCAU WHERE MaTT = @MaTT)
        BEGIN
            RAISERROR(N'Không tìm thấy tình trạng yêu cầu cần xóa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra có đang được sử dụng trong bảng YEUCAUBOITHUONG không
        IF EXISTS (SELECT 1 FROM YEUCAUBOITHUONG WHERE MaTT_TrangThai = @MaTT)
        BEGIN
            RAISERROR(N'Không thể xóa tình trạng này vì đang được sử dụng trong bảng YEUCAUBOITHUONG.', 16, 1);
            RETURN;
        END;

        DELETE FROM TINHTRANG_YEUCAU WHERE MaTT = @MaTT;

        PRINT N'Xóa tình trạng yêu cầu thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi xóa tình trạng yêu cầu: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
>>>>>>> 59c5acf48653319ce8c913c2014f62e09ddfb835
