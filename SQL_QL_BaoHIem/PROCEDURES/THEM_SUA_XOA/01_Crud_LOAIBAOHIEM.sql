USE QL_BaoHiem;
GO

CREATE PROCEDURE SP_Them_LoaiBaoHiem
    @TenLoai NVARCHAR(100),
    @MoTa NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra trùng tên loại
        IF EXISTS (SELECT 1 FROM LOAIBAOHIEM WHERE TenLoai = @TenLoai)
        BEGIN
            RAISERROR(N'Tên loại bảo hiểm đã tồn tại.', 16, 1);
            RETURN;
        END;

        INSERT INTO LOAIBAOHIEM (TenLoai, MoTa)
        VALUES (@TenLoai, @MoTa);

        PRINT N'Thêm loại bảo hiểm thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi thêm loại bảo hiểm: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
--Sửa
CREATE PROCEDURE SP_Sua_LoaiBaoHiem
    @MaLoai INT,
    @TenLoai NVARCHAR(100),
    @MoTa NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM LOAIBAOHIEM WHERE MaLoai = @MaLoai)
        BEGIN
            RAISERROR(N'Không tìm thấy loại bảo hiểm cần sửa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra trùng tên với loại khác
        IF EXISTS (SELECT 1 FROM LOAIBAOHIEM WHERE TenLoai = @TenLoai AND MaLoai <> @MaLoai)
        BEGIN
            RAISERROR(N'Tên loại bảo hiểm đã tồn tại ở bản ghi khác.', 16, 1);
            RETURN;
        END;

        UPDATE LOAIBAOHIEM
        SET TenLoai = @TenLoai,
            MoTa = @MoTa
        WHERE MaLoai = @MaLoai;

        PRINT N'Sửa loại bảo hiểm thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi sửa loại bảo hiểm: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
--Xóa
CREATE PROCEDURE SP_Xoa_LoaiBaoHiem
    @MaLoai INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM LOAIBAOHIEM WHERE MaLoai = @MaLoai)
        BEGIN
            RAISERROR(N'Không tìm thấy loại bảo hiểm cần xóa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra có gói bảo hiểm liên kết không
        IF EXISTS (SELECT 1 FROM GOIBAOHIEM WHERE MaLoai = @MaLoai)
        BEGIN
            RAISERROR(N'Không thể xóa loại bảo hiểm này vì đang được sử dụng trong bảng GOIBAOHIEM.', 16, 1);
            RETURN;
        END;

        DELETE FROM LOAIBAOHIEM WHERE MaLoai = @MaLoai;

        PRINT N'Xóa loại bảo hiểm thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi xóa loại bảo hiểm: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
