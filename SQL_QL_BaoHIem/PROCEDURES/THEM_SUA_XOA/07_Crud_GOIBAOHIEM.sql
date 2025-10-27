USE QL_BaoHiem;
GO

/*Thêm gói bảo hiểm */
CREATE OR ALTER PROCEDURE SP_Them_GoiBaoHiem
    @MaLoai INT,
    @TenGoi NVARCHAR(150),
    @PhiDinhKy DECIMAL(18,2),
    @SoTienBaoHiem DECIMAL(18,2),
    @ThoiHanThang INT,
    @DieuKien NVARCHAR(255) = NULL,
    @QuyenLoi NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra loại bảo hiểm tồn tại
        IF NOT EXISTS (SELECT 1 FROM LOAIBAOHIEM WHERE MaLoai = @MaLoai)
        BEGIN
            RAISERROR(N'Mã loại bảo hiểm không tồn tại.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra trùng tên gói
        IF EXISTS (SELECT 1 FROM GOIBAOHIEM WHERE TenGoi = @TenGoi)
        BEGIN
            RAISERROR(N'Tên gói bảo hiểm đã tồn tại.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra dữ liệu đầu vào hợp lệ
        IF @PhiDinhKy < 0 OR @SoTienBaoHiem < 0 OR @ThoiHanThang <= 0
        BEGIN
            RAISERROR(N'Giá trị phí, số tiền bảo hiểm hoặc thời hạn không hợp lệ.', 16, 1);
            RETURN;
        END;

        INSERT INTO GOIBAOHIEM (MaLoai, TenGoi, PhiDinhKy, SoTienBaoHiem, ThoiHanThang, DieuKien, QuyenLoi)
        VALUES (@MaLoai, @TenGoi, @PhiDinhKy, @SoTienBaoHiem, @ThoiHanThang, @DieuKien, @QuyenLoi);

        PRINT N'Thêm gói bảo hiểm thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi thêm gói bảo hiểm: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


/* Sửa gói bảo hiểm */
CREATE OR ALTER PROCEDURE SP_Sua_GoiBaoHiem
    @MaGoi INT,
    @MaLoai INT,
    @TenGoi NVARCHAR(150),
    @PhiDinhKy DECIMAL(18,2),
    @SoTienBaoHiem DECIMAL(18,2),
    @ThoiHanThang INT,
    @DieuKien NVARCHAR(255) = NULL,
    @QuyenLoi NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra tồn tại gói cần sửa
        IF NOT EXISTS (SELECT 1 FROM GOIBAOHIEM WHERE MaGoi = @MaGoi)
        BEGIN
            RAISERROR(N'Không tìm thấy gói bảo hiểm cần sửa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra mã loại hợp lệ
        IF NOT EXISTS (SELECT 1 FROM LOAIBAOHIEM WHERE MaLoai = @MaLoai)
        BEGIN
            RAISERROR(N'Mã loại bảo hiểm không tồn tại.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra trùng tên gói (với bản ghi khác)
        IF EXISTS (SELECT 1 FROM GOIBAOHIEM WHERE TenGoi = @TenGoi AND MaGoi <> @MaGoi)
        BEGIN
            RAISERROR(N'Tên gói bảo hiểm đã tồn tại ở bản ghi khác.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra dữ liệu logic
        IF @PhiDinhKy < 0 OR @SoTienBaoHiem < 0 OR @ThoiHanThang <= 0
        BEGIN
            RAISERROR(N'Giá trị phí, số tiền bảo hiểm hoặc thời hạn không hợp lệ.', 16, 1);
            RETURN;
        END;

        UPDATE GOIBAOHIEM
        SET MaLoai = @MaLoai,
            TenGoi = @TenGoi,
            PhiDinhKy = @PhiDinhKy,
            SoTienBaoHiem = @SoTienBaoHiem,
            ThoiHanThang = @ThoiHanThang,
            DieuKien = @DieuKien,
            QuyenLoi = @QuyenLoi
        WHERE MaGoi = @MaGoi;

        PRINT N'Cập nhật thông tin gói bảo hiểm thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi sửa gói bảo hiểm: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


/*Xóa gói bảo hiểm */
CREATE OR ALTER PROCEDURE SP_Xoa_GoiBaoHiem
    @MaGoi INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra tồn tại
        IF NOT EXISTS (SELECT 1 FROM GOIBAOHIEM WHERE MaGoi = @MaGoi)
        BEGIN
            RAISERROR(N'Không tìm thấy gói bảo hiểm cần xóa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra xem có hợp đồng đang dùng gói này không
        IF EXISTS (SELECT 1 FROM HOPDONG WHERE MaGoi = @MaGoi)
        BEGIN
            RAISERROR(N'Không thể xóa gói bảo hiểm vì đang được sử dụng trong bảng HOPDONG.', 16, 1);
            RETURN;
        END;

        DELETE FROM GOIBAOHIEM WHERE MaGoi = @MaGoi;

        PRINT N'Xóa gói bảo hiểm thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi xóa gói bảo hiểm: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
