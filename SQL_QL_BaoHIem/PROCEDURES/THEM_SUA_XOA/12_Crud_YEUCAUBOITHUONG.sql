USE QL_BaoHiem;
GO
/*Thêm yêu cầu bồi thường */
CREATE OR ALTER PROCEDURE SP_Them_YeuCauBoiThuong
    @MaHD INT,
    @NgayYeuCau DATE,
    @NgaySuKien DATE,
    @LoaiSuKien NVARCHAR(100),
    @SoTienYC DECIMAL(18,2),
    @MaTT_TrangThai INT,
    @GhiChu NVARCHAR(255) = NULL
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

        -- Kiểm tra trạng thái yêu cầu tồn tại
        IF NOT EXISTS (SELECT 1 FROM TINHTRANG_YEUCAU WHERE MaTT = @MaTT_TrangThai)
        BEGIN
            RAISERROR(N'Mã trạng thái yêu cầu không tồn tại.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra ngày sự kiện không sau ngày yêu cầu
        IF @NgaySuKien > @NgayYeuCau
        BEGIN
            RAISERROR(N'Ngày sự kiện không được lớn hơn ngày yêu cầu.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra ngày yêu cầu hợp lệ so với hợp đồng
        DECLARE @NgayHD DATE, @NgayHetHan DATE;
        SELECT @NgayHD = NgayHieuLuc, @NgayHetHan = NgayHetHan FROM HOPDONG WHERE MaHD = @MaHD;
        IF @NgayYeuCau < @NgayHD OR @NgayYeuCau > @NgayHetHan
        BEGIN
            RAISERROR(N'Ngày yêu cầu bồi thường phải nằm trong thời hạn hợp đồng.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra số tiền
        IF @SoTienYC < 0
        BEGIN
            RAISERROR(N'Số tiền yêu cầu không hợp lệ (phải >= 0).', 16, 1);
            RETURN;
        END;

        INSERT INTO YEUCAUBOITHUONG (MaHD, NgayYeuCau, NgaySuKien, LoaiSuKien, SoTienYC, MaTT_TrangThai, GhiChu)
        VALUES (@MaHD, @NgayYeuCau, @NgaySuKien, @LoaiSuKien, @SoTienYC, @MaTT_TrangThai, @GhiChu);

        PRINT N'Thêm yêu cầu bồi thường thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi thêm yêu cầu bồi thường: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


/* Sửa yêu cầu bồi thường */
CREATE OR ALTER PROCEDURE SP_Sua_YeuCauBoiThuong
    @MaYC INT,
    @MaHD INT,
    @NgayYeuCau DATE,
    @NgaySuKien DATE,
    @LoaiSuKien NVARCHAR(100),
    @SoTienYC DECIMAL(18,2),
    @MaTT_TrangThai INT,
    @GhiChu NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra bản ghi tồn tại
        IF NOT EXISTS (SELECT 1 FROM YEUCAUBOITHUONG WHERE MaYC = @MaYC)
        BEGIN
            RAISERROR(N'Không tìm thấy yêu cầu bồi thường cần sửa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra hợp đồng và trạng thái tồn tại
        IF NOT EXISTS (SELECT 1 FROM HOPDONG WHERE MaHD = @MaHD)
        BEGIN
            RAISERROR(N'Mã hợp đồng không tồn tại.', 16, 1);
            RETURN;
        END;
        IF NOT EXISTS (SELECT 1 FROM TINHTRANG_YEUCAU WHERE MaTT = @MaTT_TrangThai)
        BEGIN
            RAISERROR(N'Mã trạng thái yêu cầu không tồn tại.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra ngày hợp lệ
        IF @NgaySuKien > @NgayYeuCau
        BEGIN
            RAISERROR(N'Ngày sự kiện không được lớn hơn ngày yêu cầu.', 16, 1);
            RETURN;
        END;

        DECLARE @NgayHD DATE, @NgayHetHan DATE;
        SELECT @NgayHD = NgayHieuLuc, @NgayHetHan = NgayHetHan FROM HOPDONG WHERE MaHD = @MaHD;
        IF @NgayYeuCau < @NgayHD OR @NgayYeuCau > @NgayHetHan
        BEGIN
            RAISERROR(N'Ngày yêu cầu phải nằm trong thời hạn hợp đồng.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra số tiền
        IF @SoTienYC < 0
        BEGIN
            RAISERROR(N'Số tiền yêu cầu không hợp lệ (phải >= 0).', 16, 1);
            RETURN;
        END;

        UPDATE YEUCAUBOITHUONG
        SET MaHD = @MaHD,
            NgayYeuCau = @NgayYeuCau,
            NgaySuKien = @NgaySuKien,
            LoaiSuKien = @LoaiSuKien,
            SoTienYC = @SoTienYC,
            MaTT_TrangThai = @MaTT_TrangThai,
            GhiChu = @GhiChu
        WHERE MaYC = @MaYC;

        PRINT N'Cập nhật yêu cầu bồi thường thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi sửa yêu cầu bồi thường: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


/*Xóa yêu cầu bồi thường */
CREATE OR ALTER PROCEDURE SP_Xoa_YeuCauBoiThuong
    @MaYC INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra bản ghi tồn tại
        IF NOT EXISTS (SELECT 1 FROM YEUCAUBOITHUONG WHERE MaYC = @MaYC)
        BEGIN
            RAISERROR(N'Không tìm thấy yêu cầu bồi thường cần xóa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra có chi trả nào liên kết không
        IF EXISTS (SELECT 1 FROM CHITRABOITHUONG WHERE MaYC = @MaYC)
        BEGIN
            RAISERROR(N'Không thể xóa yêu cầu bồi thường này vì đã có chi trả liên quan.', 16, 1);
            RETURN;
        END;

        DELETE FROM YEUCAUBOITHUONG WHERE MaYC = @MaYC;

        PRINT N'Xóa yêu cầu bồi thường thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi xóa yêu cầu bồi thường: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
