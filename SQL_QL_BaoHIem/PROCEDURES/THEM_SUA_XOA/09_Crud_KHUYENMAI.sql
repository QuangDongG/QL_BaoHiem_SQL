USE QL_BaoHiem;
GO

/* Thêm khuyến mãi */
CREATE OR ALTER PROCEDURE SP_Them_KhuyenMai
    @TenKM NVARCHAR(150),
    @NoiDung NVARCHAR(255) = NULL,
    @GiaTri DECIMAL(10,2),
    @DonVi NVARCHAR(10),
    @NgayBD DATE,
    @NgayKT DATE
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra trùng tên khuyến mãi
        IF EXISTS (SELECT 1 FROM KHUYENMAI WHERE TenKM = @TenKM)
        BEGIN
            RAISERROR(N'Tên khuyến mãi đã tồn tại.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra đơn vị hợp lệ
        IF @DonVi NOT IN (N'%', N'VND')
        BEGIN
            RAISERROR(N'Đơn vị khuyến mãi không hợp lệ. Chỉ chấp nhận % hoặc VND.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra giá trị hợp lệ
        IF @GiaTri < 0
        BEGIN
            RAISERROR(N'Giá trị khuyến mãi phải >= 0.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra ngày hợp lệ
        IF @NgayKT < @NgayBD
        BEGIN
            RAISERROR(N'Ngày kết thúc không được nhỏ hơn ngày bắt đầu.', 16, 1);
            RETURN;
        END;

        INSERT INTO KHUYENMAI (TenKM, NoiDung, GiaTri, DonVi, NgayBD, NgayKT)
        VALUES (@TenKM, @NoiDung, @GiaTri, @DonVi, @NgayBD, @NgayKT);

        PRINT N'Thêm khuyến mãi thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi thêm khuyến mãi: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


/* Sửa khuyến mãi */
CREATE OR ALTER PROCEDURE SP_Sua_KhuyenMai
    @MaKM INT,
    @TenKM NVARCHAR(150),
    @NoiDung NVARCHAR(255) = NULL,
    @GiaTri DECIMAL(10,2),
    @DonVi NVARCHAR(10),
    @NgayBD DATE,
    @NgayKT DATE
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra tồn tại khuyến mãi
        IF NOT EXISTS (SELECT 1 FROM KHUYENMAI WHERE MaKM = @MaKM)
        BEGIN
            RAISERROR(N'Không tìm thấy khuyến mãi cần sửa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra trùng tên (trừ bản ghi hiện tại)
        IF EXISTS (SELECT 1 FROM KHUYENMAI WHERE TenKM = @TenKM AND MaKM <> @MaKM)
        BEGIN
            RAISERROR(N'Tên khuyến mãi đã tồn tại ở bản ghi khác.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra đơn vị hợp lệ
        IF @DonVi NOT IN (N'%', N'VND')
        BEGIN
            RAISERROR(N'Đơn vị khuyến mãi không hợp lệ. Chỉ chấp nhận % hoặc VND.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra giá trị hợp lệ
        IF @GiaTri < 0
        BEGIN
            RAISERROR(N'Giá trị khuyến mãi phải >= 0.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra ngày hợp lệ
        IF @NgayKT < @NgayBD
        BEGIN
            RAISERROR(N'Ngày kết thúc không được nhỏ hơn ngày bắt đầu.', 16, 1);
            RETURN;
        END;

        UPDATE KHUYENMAI
        SET TenKM = @TenKM,
            NoiDung = @NoiDung,
            GiaTri = @GiaTri,
            DonVi = @DonVi,
            NgayBD = @NgayBD,
            NgayKT = @NgayKT
        WHERE MaKM = @MaKM;

        PRINT N'Cập nhật khuyến mãi thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi sửa khuyến mãi: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


/* Xóa khuyến mãi */
CREATE OR ALTER PROCEDURE SP_Xoa_KhuyenMai
    @MaKM INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra tồn tại khuyến mãi
        IF NOT EXISTS (SELECT 1 FROM KHUYENMAI WHERE MaKM = @MaKM)
        BEGIN
            RAISERROR(N'Không tìm thấy khuyến mãi cần xóa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra khuyến mãi có đang được sử dụng trong hợp đồng không
        IF EXISTS (SELECT 1 FROM HOPDONG_KHUYENMAI WHERE MaKM = @MaKM)
        BEGIN
            RAISERROR(N'Không thể xóa khuyến mãi vì đang được áp dụng trong hợp đồng.', 16, 1);
            RETURN;
        END;

        DELETE FROM KHUYENMAI WHERE MaKM = @MaKM;

        PRINT N'Xóa khuyến mãi thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi xóa khuyến mãi: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
