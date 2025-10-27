<<<<<<< HEAD
USE QL_BaoHiem;
GO

/*  Thêm hợp đồng */
CREATE OR ALTER PROCEDURE SP_Them_HopDong
    @MaKH INT,
    @MaGoi INT,
    @MaNV_TuVan INT = NULL,
    @MaSoHD VARCHAR(30),
    @NgayKy DATE,
    @NgayHieuLuc DATE,
    @NgayHetHan DATE,
    @TrangThai NVARCHAR(30),
    @GhiChu NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra mã khách hàng
        IF NOT EXISTS (SELECT 1 FROM KHACHHANG WHERE MaKH = @MaKH)
        BEGIN
            RAISERROR(N'Mã khách hàng không tồn tại.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra mã gói bảo hiểm
        IF NOT EXISTS (SELECT 1 FROM GOIBAOHIEM WHERE MaGoi = @MaGoi)
        BEGIN
            RAISERROR(N'Mã gói bảo hiểm không tồn tại.', 16, 1);
            RETURN;
        END;

        --  Kiểm tra nhân viên tư vấn (nếu có)
        IF @MaNV_TuVan IS NOT NULL AND NOT EXISTS (SELECT 1 FROM NHANVIEN WHERE MaNV = @MaNV_TuVan)
        BEGIN
            RAISERROR(N'Mã nhân viên tư vấn không tồn tại.', 16, 1);
            RETURN;
        END;

        --  Kiểm tra trùng mã hợp đồng
        IF EXISTS (SELECT 1 FROM HOPDONG WHERE MaSoHD = @MaSoHD)
        BEGIN
            RAISERROR(N'Mã số hợp đồng đã tồn tại.', 16, 1);
            RETURN;
        END;

        --  Kiểm tra ngày hợp lệ
        IF @NgayHetHan < @NgayHieuLuc OR @NgayKy > @NgayHieuLuc
        BEGIN
            RAISERROR(N'Ngày ký, ngày hiệu lực hoặc ngày hết hạn không hợp lệ.', 16, 1);
            RETURN;
        END;

        --  Kiểm tra trạng thái hợp lệ
        IF @TrangThai NOT IN (N'Hiệu lực', N'Hết hạn', N'Tạm dừng', N'Huỷ')
        BEGIN
            RAISERROR(N'Trạng thái hợp đồng không hợp lệ.', 16, 1);
            RETURN;
        END;

        INSERT INTO HOPDONG (MaKH, MaGoi, MaNV_TuVan, MaSoHD, NgayKy, NgayHieuLuc, NgayHetHan, TrangThai, GhiChu)
        VALUES (@MaKH, @MaGoi, @MaNV_TuVan, @MaSoHD, @NgayKy, @NgayHieuLuc, @NgayHetHan, @TrangThai, @GhiChu);

        PRINT N'Thêm hợp đồng thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi thêm hợp đồng: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


/* Sửa hợp đồng */
CREATE OR ALTER PROCEDURE SP_Sua_HopDong
    @MaHD INT,
    @MaKH INT,
    @MaGoi INT,
    @MaNV_TuVan INT = NULL,
    @MaSoHD VARCHAR(30),
    @NgayKy DATE,
    @NgayHieuLuc DATE,
    @NgayHetHan DATE,
    @TrangThai NVARCHAR(30),
    @GhiChu NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra tồn tại hợp đồng
        IF NOT EXISTS (SELECT 1 FROM HOPDONG WHERE MaHD = @MaHD)
        BEGIN
            RAISERROR(N'Không tìm thấy hợp đồng cần sửa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra mã khách hàng, gói, nhân viên
        IF NOT EXISTS (SELECT 1 FROM KHACHHANG WHERE MaKH = @MaKH)
        BEGIN
            RAISERROR(N'Mã khách hàng không tồn tại.', 16, 1);
            RETURN;
        END;

        IF NOT EXISTS (SELECT 1 FROM GOIBAOHIEM WHERE MaGoi = @MaGoi)
        BEGIN
            RAISERROR(N'Mã gói bảo hiểm không tồn tại.', 16, 1);
            RETURN;
        END;

        IF @MaNV_TuVan IS NOT NULL AND NOT EXISTS (SELECT 1 FROM NHANVIEN WHERE MaNV = @MaNV_TuVan)
        BEGIN
            RAISERROR(N'Mã nhân viên tư vấn không tồn tại.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra trùng mã hợp đồng
        IF EXISTS (SELECT 1 FROM HOPDONG WHERE MaSoHD = @MaSoHD AND MaHD <> @MaHD)
        BEGIN
            RAISERROR(N'Mã số hợp đồng đã tồn tại ở bản ghi khác.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra ngày hợp lệ
        IF @NgayHetHan < @NgayHieuLuc OR @NgayKy > @NgayHieuLuc
        BEGIN
            RAISERROR(N'Ngày ký, ngày hiệu lực hoặc ngày hết hạn không hợp lệ.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra trạng thái hợp lệ
        IF @TrangThai NOT IN (N'Hiệu lực', N'Hết hạn', N'Tạm dừng', N'Huỷ')
        BEGIN
            RAISERROR(N'Trạng thái hợp đồng không hợp lệ.', 16, 1);
            RETURN;
        END;

        UPDATE HOPDONG
        SET MaKH = @MaKH,
            MaGoi = @MaGoi,
            MaNV_TuVan = @MaNV_TuVan,
            MaSoHD = @MaSoHD,
            NgayKy = @NgayKy,
            NgayHieuLuc = @NgayHieuLuc,
            NgayHetHan = @NgayHetHan,
            TrangThai = @TrangThai,
            GhiChu = @GhiChu
        WHERE MaHD = @MaHD;

        PRINT N'Cập nhật hợp đồng thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi sửa hợp đồng: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


/*Xóa hợp đồng */
CREATE OR ALTER PROCEDURE SP_Xoa_HopDong
    @MaHD INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra hợp đồng tồn tại
        IF NOT EXISTS (SELECT 1 FROM HOPDONG WHERE MaHD = @MaHD)
        BEGIN
            RAISERROR(N'Không tìm thấy hợp đồng cần xóa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra có dữ liệu liên quan
        IF EXISTS (SELECT 1 FROM THANHTOANPHI WHERE MaHD = @MaHD)
            OR EXISTS (SELECT 1 FROM YEUCAUBOITHUONG WHERE MaHD = @MaHD)
            OR EXISTS (SELECT 1 FROM HOPDONG_KHUYENMAI WHERE MaHD = @MaHD)
        BEGIN
            RAISERROR(N'Không thể xóa hợp đồng vì đang có dữ liệu liên quan (Thanh toán, Bồi thường, Khuyến mãi).', 16, 1);
            RETURN;
        END;

        DELETE FROM HOPDONG WHERE MaHD = @MaHD;

        PRINT N'Xóa hợp đồng thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi xóa hợp đồng: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
=======
USE QL_BaoHiem;
GO

/*  Thêm hợp đồng */
CREATE OR ALTER PROCEDURE SP_Them_HopDong
    @MaKH INT,
    @MaGoi INT,
    @MaNV_TuVan INT = NULL,
    @MaSoHD VARCHAR(30),
    @NgayKy DATE,
    @NgayHieuLuc DATE,
    @NgayHetHan DATE,
    @TrangThai NVARCHAR(30),
    @GhiChu NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra mã khách hàng
        IF NOT EXISTS (SELECT 1 FROM KHACHHANG WHERE MaKH = @MaKH)
        BEGIN
            RAISERROR(N'Mã khách hàng không tồn tại.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra mã gói bảo hiểm
        IF NOT EXISTS (SELECT 1 FROM GOIBAOHIEM WHERE MaGoi = @MaGoi)
        BEGIN
            RAISERROR(N'Mã gói bảo hiểm không tồn tại.', 16, 1);
            RETURN;
        END;

        --  Kiểm tra nhân viên tư vấn (nếu có)
        IF @MaNV_TuVan IS NOT NULL AND NOT EXISTS (SELECT 1 FROM NHANVIEN WHERE MaNV = @MaNV_TuVan)
        BEGIN
            RAISERROR(N'Mã nhân viên tư vấn không tồn tại.', 16, 1);
            RETURN;
        END;

        --  Kiểm tra trùng mã hợp đồng
        IF EXISTS (SELECT 1 FROM HOPDONG WHERE MaSoHD = @MaSoHD)
        BEGIN
            RAISERROR(N'Mã số hợp đồng đã tồn tại.', 16, 1);
            RETURN;
        END;

        --  Kiểm tra ngày hợp lệ
        IF @NgayHetHan < @NgayHieuLuc OR @NgayKy > @NgayHieuLuc
        BEGIN
            RAISERROR(N'Ngày ký, ngày hiệu lực hoặc ngày hết hạn không hợp lệ.', 16, 1);
            RETURN;
        END;

        --  Kiểm tra trạng thái hợp lệ
        IF @TrangThai NOT IN (N'Hiệu lực', N'Hết hạn', N'Tạm dừng', N'Huỷ')
        BEGIN
            RAISERROR(N'Trạng thái hợp đồng không hợp lệ.', 16, 1);
            RETURN;
        END;

        INSERT INTO HOPDONG (MaKH, MaGoi, MaNV_TuVan, MaSoHD, NgayKy, NgayHieuLuc, NgayHetHan, TrangThai, GhiChu)
        VALUES (@MaKH, @MaGoi, @MaNV_TuVan, @MaSoHD, @NgayKy, @NgayHieuLuc, @NgayHetHan, @TrangThai, @GhiChu);

        PRINT N'Thêm hợp đồng thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi thêm hợp đồng: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


/* Sửa hợp đồng */
CREATE OR ALTER PROCEDURE SP_Sua_HopDong
    @MaHD INT,
    @MaKH INT,
    @MaGoi INT,
    @MaNV_TuVan INT = NULL,
    @MaSoHD VARCHAR(30),
    @NgayKy DATE,
    @NgayHieuLuc DATE,
    @NgayHetHan DATE,
    @TrangThai NVARCHAR(30),
    @GhiChu NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra tồn tại hợp đồng
        IF NOT EXISTS (SELECT 1 FROM HOPDONG WHERE MaHD = @MaHD)
        BEGIN
            RAISERROR(N'Không tìm thấy hợp đồng cần sửa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra mã khách hàng, gói, nhân viên
        IF NOT EXISTS (SELECT 1 FROM KHACHHANG WHERE MaKH = @MaKH)
        BEGIN
            RAISERROR(N'Mã khách hàng không tồn tại.', 16, 1);
            RETURN;
        END;

        IF NOT EXISTS (SELECT 1 FROM GOIBAOHIEM WHERE MaGoi = @MaGoi)
        BEGIN
            RAISERROR(N'Mã gói bảo hiểm không tồn tại.', 16, 1);
            RETURN;
        END;

        IF @MaNV_TuVan IS NOT NULL AND NOT EXISTS (SELECT 1 FROM NHANVIEN WHERE MaNV = @MaNV_TuVan)
        BEGIN
            RAISERROR(N'Mã nhân viên tư vấn không tồn tại.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra trùng mã hợp đồng
        IF EXISTS (SELECT 1 FROM HOPDONG WHERE MaSoHD = @MaSoHD AND MaHD <> @MaHD)
        BEGIN
            RAISERROR(N'Mã số hợp đồng đã tồn tại ở bản ghi khác.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra ngày hợp lệ
        IF @NgayHetHan < @NgayHieuLuc OR @NgayKy > @NgayHieuLuc
        BEGIN
            RAISERROR(N'Ngày ký, ngày hiệu lực hoặc ngày hết hạn không hợp lệ.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra trạng thái hợp lệ
        IF @TrangThai NOT IN (N'Hiệu lực', N'Hết hạn', N'Tạm dừng', N'Huỷ')
        BEGIN
            RAISERROR(N'Trạng thái hợp đồng không hợp lệ.', 16, 1);
            RETURN;
        END;

        UPDATE HOPDONG
        SET MaKH = @MaKH,
            MaGoi = @MaGoi,
            MaNV_TuVan = @MaNV_TuVan,
            MaSoHD = @MaSoHD,
            NgayKy = @NgayKy,
            NgayHieuLuc = @NgayHieuLuc,
            NgayHetHan = @NgayHetHan,
            TrangThai = @TrangThai,
            GhiChu = @GhiChu
        WHERE MaHD = @MaHD;

        PRINT N'Cập nhật hợp đồng thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi sửa hợp đồng: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


/*Xóa hợp đồng */
CREATE OR ALTER PROCEDURE SP_Xoa_HopDong
    @MaHD INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra hợp đồng tồn tại
        IF NOT EXISTS (SELECT 1 FROM HOPDONG WHERE MaHD = @MaHD)
        BEGIN
            RAISERROR(N'Không tìm thấy hợp đồng cần xóa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra có dữ liệu liên quan
        IF EXISTS (SELECT 1 FROM THANHTOANPHI WHERE MaHD = @MaHD)
            OR EXISTS (SELECT 1 FROM YEUCAUBOITHUONG WHERE MaHD = @MaHD)
            OR EXISTS (SELECT 1 FROM HOPDONG_KHUYENMAI WHERE MaHD = @MaHD)
        BEGIN
            RAISERROR(N'Không thể xóa hợp đồng vì đang có dữ liệu liên quan (Thanh toán, Bồi thường, Khuyến mãi).', 16, 1);
            RETURN;
        END;

        DELETE FROM HOPDONG WHERE MaHD = @MaHD;

        PRINT N'Xóa hợp đồng thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi xóa hợp đồng: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
>>>>>>> 59c5acf48653319ce8c913c2014f62e09ddfb835
