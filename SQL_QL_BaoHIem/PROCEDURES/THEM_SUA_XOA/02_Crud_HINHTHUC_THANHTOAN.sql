USE QL_BaoHiem;
GO

CREATE PROCEDURE SP_Them_HinhThucThanhToan
    @TenHT NVARCHAR(100),
    @MoTa NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra trùng tên
        IF EXISTS (SELECT 1 FROM HINHTHUC_THANHTOAN WHERE TenHT = @TenHT)
        BEGIN
            RAISERROR(N'Tên hình thức thanh toán đã tồn tại.', 16, 1);
            RETURN;
        END;

        INSERT INTO HINHTHUC_THANHTOAN (TenHT, MoTa)
        VALUES (@TenHT, @MoTa);

        PRINT N'Thêm hình thức thanh toán thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi thêm hình thức thanh toán: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
--Sửa
CREATE PROCEDURE SP_Sua_HinhThucThanhToan
    @MaHT INT,
    @TenHT NVARCHAR(100),
    @MoTa NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra có tồn tại không
        IF NOT EXISTS (SELECT 1 FROM HINHTHUC_THANHTOAN WHERE MaHT = @MaHT)
        BEGIN
            RAISERROR(N'Không tìm thấy hình thức thanh toán cần sửa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra trùng tên với bản ghi khác
        IF EXISTS (SELECT 1 FROM HINHTHUC_THANHTOAN WHERE TenHT = @TenHT AND MaHT <> @MaHT)
        BEGIN
            RAISERROR(N'Tên hình thức thanh toán đã tồn tại ở bản ghi khác.', 16, 1);
            RETURN;
        END;

        UPDATE HINHTHUC_THANHTOAN
        SET TenHT = @TenHT,
            MoTa = @MoTa
        WHERE MaHT = @MaHT;

        PRINT N'Sửa hình thức thanh toán thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi sửa hình thức thanh toán: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
--Xóa
CREATE PROCEDURE SP_Xoa_HinhThucThanhToan
    @MaHT INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra có tồn tại không
        IF NOT EXISTS (SELECT 1 FROM HINHTHUC_THANHTOAN WHERE MaHT = @MaHT)
        BEGIN
            RAISERROR(N'Không tìm thấy hình thức thanh toán cần xóa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra có đang được dùng trong THANHTOANPHI không
        IF EXISTS (SELECT 1 FROM THANHTOANPHI WHERE MaHT = @MaHT)
        BEGIN
            RAISERROR(N'Không thể xóa hình thức thanh toán này vì đang được sử dụng trong bảng THANHTOANPHI.', 16, 1);
            RETURN;
        END;

        DELETE FROM HINHTHUC_THANHTOAN WHERE MaHT = @MaHT;

        PRINT N'Xóa hình thức thanh toán thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi xóa hình thức thanh toán: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
