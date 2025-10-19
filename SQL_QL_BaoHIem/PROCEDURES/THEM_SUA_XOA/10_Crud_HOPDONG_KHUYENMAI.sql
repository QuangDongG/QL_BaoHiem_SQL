USE QL_BaoHiem;
GO

/*  Thêm khuyến mãi vào hợp đồng */
CREATE OR ALTER PROCEDURE SP_Them_HopDong_KhuyenMai
    @MaHD INT,
    @MaKM INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra hợp đồng tồn tại
        IF NOT EXISTS (SELECT 1 FROM HOPDONG WHERE MaHD = @MaHD)
        BEGIN
            RAISERROR(N'Mã hợp đồng không tồn tại.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra khuyến mãi tồn tại
        IF NOT EXISTS (SELECT 1 FROM KHUYENMAI WHERE MaKM = @MaKM)
        BEGIN
            RAISERROR(N'Mã khuyến mãi không tồn tại.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra trùng khóa
        IF EXISTS (SELECT 1 FROM HOPDONG_KHUYENMAI WHERE MaHD = @MaHD AND MaKM = @MaKM)
        BEGIN
            RAISERROR(N'Khuyến mãi này đã được áp dụng cho hợp đồng.', 16, 1);
            RETURN;
        END;

        INSERT INTO HOPDONG_KHUYENMAI (MaHD, MaKM)
        VALUES (@MaHD, @MaKM);

        PRINT N'Thêm khuyến mãi vào hợp đồng thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi thêm khuyến mãi vào hợp đồng: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


/* Xóa 1 khuyến mãi khỏi hợp đồng */
CREATE OR ALTER PROCEDURE SP_Xoa_HopDong_KhuyenMai
    @MaHD INT,
    @MaKM INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra tồn tại bản ghi cần xóa
        IF NOT EXISTS (SELECT 1 FROM HOPDONG_KHUYENMAI WHERE MaHD = @MaHD AND MaKM = @MaKM)
        BEGIN
            RAISERROR(N'Không tìm thấy mối quan hệ hợp đồng – khuyến mãi cần xóa.', 16, 1);
            RETURN;
        END;

        DELETE FROM HOPDONG_KHUYENMAI
        WHERE MaHD = @MaHD AND MaKM = @MaKM;

        PRINT N'Xóa khuyến mãi khỏi hợp đồng thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi xóa khuyến mãi khỏi hợp đồng: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


/*Xóa toàn bộ khuyến mãi của 1 hợp đồng (tùy chọn) */
CREATE OR ALTER PROCEDURE SP_XoaTatCa_KhuyenMai_TheoHopDong
    @MaHD INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra hợp đồng tồn tại
        IF NOT EXISTS (SELECT 1 FROM HOPDONG WHERE MaHD = @MaHD)
        BEGIN
            RAISERROR(N'Hợp đồng không tồn tại.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra có khuyến mãi nào gắn với hợp đồng không
        IF NOT EXISTS (SELECT 1 FROM HOPDONG_KHUYENMAI WHERE MaHD = @MaHD)
        BEGIN
            RAISERROR(N'Hợp đồng này không có khuyến mãi để xóa.', 16, 1);
            RETURN;
        END;

        DELETE FROM HOPDONG_KHUYENMAI WHERE MaHD = @MaHD;

        PRINT N'Đã xóa toàn bộ khuyến mãi của hợp đồng thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi xóa toàn bộ khuyến mãi của hợp đồng: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
