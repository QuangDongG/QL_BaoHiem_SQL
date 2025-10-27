USE QL_BaoHiem;
GO

/* Thêm thanh toán phí */
CREATE OR ALTER PROCEDURE SP_Them_ThanhToanPhi
    @MaHD INT,
    @NgayTT DATE,
    @SoTien DECIMAL(18,2),
    @MaHT INT,
    @MaNV_Thu INT = NULL,
    @TrangThai NVARCHAR(30) = N'Đã nhận',
    @MaGiaoDich VARCHAR(30)
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

        -- Kiểm tra hình thức thanh toán tồn tại
        IF NOT EXISTS (SELECT 1 FROM HINHTHUC_THANHTOAN WHERE MaHT = @MaHT)
        BEGIN
            RAISERROR(N'Hình thức thanh toán không tồn tại.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra nhân viên thu (nếu có)
        IF @MaNV_Thu IS NOT NULL AND NOT EXISTS (SELECT 1 FROM NHANVIEN WHERE MaNV = @MaNV_Thu)
        BEGIN
            RAISERROR(N'Mã nhân viên thu không tồn tại.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra trùng mã giao dịch
        IF EXISTS (SELECT 1 FROM THANHTOANPHI WHERE MaGiaoDich = @MaGiaoDich)
        BEGIN
            RAISERROR(N'Mã giao dịch đã tồn tại.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra số tiền hợp lệ
        IF @SoTien < 0
        BEGIN
            RAISERROR(N'Số tiền thanh toán phải >= 0.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra ngày thanh toán >= ngày hiệu lực hợp đồng
        DECLARE @NgayHD DATE;
        SELECT @NgayHD = NgayHieuLuc FROM HOPDONG WHERE MaHD = @MaHD;
        IF @NgayTT < @NgayHD
        BEGIN
            RAISERROR(N'Ngày thanh toán không thể trước ngày hiệu lực của hợp đồng.', 16, 1);
            RETURN;
        END;

        INSERT INTO THANHTOANPHI (MaHD, NgayTT, SoTien, MaHT, MaNV_Thu, TrangThai, MaGiaoDich)
        VALUES (@MaHD, @NgayTT, @SoTien, @MaHT, @MaNV_Thu, @TrangThai, @MaGiaoDich);

        PRINT N'Thêm thanh toán phí thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi thêm thanh toán phí: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


/* Sửa thanh toán phí */
CREATE OR ALTER PROCEDURE SP_Sua_ThanhToanPhi
    @MaTT INT,
    @MaHD INT,
    @NgayTT DATE,
    @SoTien DECIMAL(18,2),
    @MaHT INT,
    @MaNV_Thu INT = NULL,
    @TrangThai NVARCHAR(30) = N'Đã nhận',
    @MaGiaoDich VARCHAR(30)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra bản ghi tồn tại
        IF NOT EXISTS (SELECT 1 FROM THANHTOANPHI WHERE MaTT = @MaTT)
        BEGIN
            RAISERROR(N'Không tìm thấy bản ghi thanh toán cần sửa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra hợp đồng, hình thức, nhân viên hợp lệ
        IF NOT EXISTS (SELECT 1 FROM HOPDONG WHERE MaHD = @MaHD)
        BEGIN
            RAISERROR(N'Mã hợp đồng không tồn tại.', 16, 1);
            RETURN;
        END;
        IF NOT EXISTS (SELECT 1 FROM HINHTHUC_THANHTOAN WHERE MaHT = @MaHT)
        BEGIN
            RAISERROR(N'Hình thức thanh toán không tồn tại.', 16, 1);
            RETURN;
        END;
        IF @MaNV_Thu IS NOT NULL AND NOT EXISTS (SELECT 1 FROM NHANVIEN WHERE MaNV = @MaNV_Thu)
        BEGIN
            RAISERROR(N'Mã nhân viên thu không tồn tại.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra trùng mã giao dịch
        IF EXISTS (SELECT 1 FROM THANHTOANPHI WHERE MaGiaoDich = @MaGiaoDich AND MaTT <> @MaTT)
        BEGIN
            RAISERROR(N'Mã giao dịch đã tồn tại ở bản ghi khác.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra số tiền & ngày
        IF @SoTien < 0
        BEGIN
            RAISERROR(N'Số tiền thanh toán phải >= 0.', 16, 1);
            RETURN;
        END;
        DECLARE @NgayHD DATE;
        SELECT @NgayHD = NgayHieuLuc FROM HOPDONG WHERE MaHD = @MaHD;
        IF @NgayTT < @NgayHD
        BEGIN
            RAISERROR(N'Ngày thanh toán không thể trước ngày hiệu lực của hợp đồng.', 16, 1);
            RETURN;
        END;

        UPDATE THANHTOANPHI
        SET MaHD = @MaHD,
            NgayTT = @NgayTT,
            SoTien = @SoTien,
            MaHT = @MaHT,
            MaNV_Thu = @MaNV_Thu,
            TrangThai = @TrangThai,
            MaGiaoDich = @MaGiaoDich
        WHERE MaTT = @MaTT;

        PRINT N'Cập nhật thanh toán phí thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi sửa thanh toán phí: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


--Khong xoa phi thanh toan
