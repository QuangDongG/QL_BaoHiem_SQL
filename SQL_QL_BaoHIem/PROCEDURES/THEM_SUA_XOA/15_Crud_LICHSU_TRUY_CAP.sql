USE QL_BaoHiem;
GO

/* Thêm lịch sử truy cập */
CREATE OR ALTER PROCEDURE SP_Them_LichSuTruyCap
    @MaTK INT,
    @HanhDong NVARCHAR(200),
    @MoTa NVARCHAR(255) = NULL,
    @DiaChiIP VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        --Kiểm tra tài khoản tồn tại
        IF NOT EXISTS (SELECT 1 FROM TAIKHOAN WHERE MaTK = @MaTK)
        BEGIN
            RAISERROR(N'Mã tài khoản không tồn tại.', 16, 1);
            RETURN;
        END;

        INSERT INTO LICHSU_TRUY_CAP (MaTK, ThoiGian, HanhDong, MoTa, DiaChiIP)
        VALUES (@MaTK, SYSDATETIME(), @HanhDong, @MoTa, @DiaChiIP);

        PRINT N'Đã ghi lịch sử truy cập thành công.';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi thêm lịch sử truy cập: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


/*Xóa toàn bộ lịch sử truy cập của 1 tài khoản */
CREATE OR ALTER PROCEDURE SP_Xoa_LichSuTruyCap_TheoTaiKhoan
    @MaTK INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra tài khoản tồn tại
        IF NOT EXISTS (SELECT 1 FROM TAIKHOAN WHERE MaTK = @MaTK)
        BEGIN
            RAISERROR(N'Tài khoản không tồn tại.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra có log nào không
        IF NOT EXISTS (SELECT 1 FROM LICHSU_TRUY_CAP WHERE MaTK = @MaTK)
        BEGIN
            RAISERROR(N'Tài khoản này chưa có lịch sử truy cập.', 16, 1);
            RETURN;
        END;

        DELETE FROM LICHSU_TRUY_CAP WHERE MaTK = @MaTK;

        PRINT N'Đã xóa toàn bộ lịch sử truy cập của tài khoản.';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi xóa lịch sử truy cập: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


/*Xóa lịch sử truy cập cũ hơn số ngày chỉ định */
CREATE OR ALTER PROCEDURE SP_Xoa_LichSuTruyCap_CuHonNgay
    @SoNgay INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF @SoNgay <= 0
        BEGIN
            RAISERROR(N'Số ngày phải lớn hơn 0.', 16, 1);
            RETURN;
        END;

        DELETE FROM LICHSU_TRUY_CAP
        WHERE ThoiGian < DATEADD(DAY, -@SoNgay, SYSDATETIME());

        PRINT N'Đã xóa lịch sử truy cập cũ hơn ' + CAST(@SoNgay AS NVARCHAR) + N' ngày.';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi xóa lịch sử truy cập cũ: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
