<<<<<<< HEAD
USE QL_BaoHiem;
GO

/*Thêm chi trả bồi thường */
CREATE OR ALTER PROCEDURE SP_Them_ChiTraBoiThuong
    @MaYC INT,
    @NgayChiTra DATE,
    @SoTienChi DECIMAL(18,2),
    @HinhThucChi NVARCHAR(100),
    @TrangThai NVARCHAR(30) = N'Đã chi trả',
    @MaNV_Chi INT = NULL,
    @GhiChu NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        --Kiểm tra yêu cầu bồi thường tồn tại
        IF NOT EXISTS (SELECT 1 FROM YEUCAUBOITHUONG WHERE MaYC = @MaYC)
        BEGIN
            RAISERROR(N'Mã yêu cầu bồi thường không tồn tại.', 16, 1);
            RETURN;
        END;

        --Kiểm tra nhân viên chi (nếu có)
        IF @MaNV_Chi IS NOT NULL AND NOT EXISTS (SELECT 1 FROM NHANVIEN WHERE MaNV = @MaNV_Chi)
        BEGIN
            RAISERROR(N'Mã nhân viên chi trả không tồn tại.', 16, 1);
            RETURN;
        END;

        --Kiểm tra số tiền hợp lệ
        IF @SoTienChi < 0
        BEGIN
            RAISERROR(N'Số tiền chi trả phải >= 0.', 16, 1);
            RETURN;
        END;

        --Lấy ngày yêu cầu và tổng tiền đã chi để kiểm tra
        DECLARE @NgayYC DATE, @SoTienYC DECIMAL(18,2), @TongChi DECIMAL(18,2);
        SELECT @NgayYC = NgayYeuCau, @SoTienYC = SoTienYC
        FROM YEUCAUBOITHUONG WHERE MaYC = @MaYC;

        SELECT @TongChi = ISNULL(SUM(SoTienChi), 0)
        FROM CHITRABOITHUONG WHERE MaYC = @MaYC;

        --Kiểm tra ngày chi trả hợp lệ
        IF @NgayChiTra < @NgayYC
        BEGIN
            RAISERROR(N'Ngày chi trả không được trước ngày yêu cầu bồi thường.', 16, 1);
            RETURN;
        END;

        --Kiểm tra tổng chi trả không vượt số tiền yêu cầu
        IF @TongChi + @SoTienChi > @SoTienYC
        BEGIN
            RAISERROR(N'Tổng số tiền chi vượt quá số tiền yêu cầu bồi thường.', 16, 1);
            RETURN;
        END;

        INSERT INTO CHITRABOITHUONG (MaYC, NgayChiTra, SoTienChi, HinhThucChi, TrangThai, MaNV_Chi, GhiChu)
        VALUES (@MaYC, @NgayChiTra, @SoTienChi, @HinhThucChi, @TrangThai, @MaNV_Chi, @GhiChu);

        PRINT N'Thêm chi trả bồi thường thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi thêm chi trả bồi thường: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


/*Sửa chi trả bồi thường */
CREATE OR ALTER PROCEDURE SP_Sua_ChiTraBoiThuong
    @MaCT INT,
    @MaYC INT,
    @NgayChiTra DATE,
    @SoTienChi DECIMAL(18,2),
    @HinhThucChi NVARCHAR(100),
    @TrangThai NVARCHAR(30),
    @MaNV_Chi INT = NULL,
    @GhiChu NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        --Kiểm tra bản ghi tồn tại
        IF NOT EXISTS (SELECT 1 FROM CHITRABOITHUONG WHERE MaCT = @MaCT)
        BEGIN
            RAISERROR(N'Không tìm thấy bản ghi chi trả cần sửa.', 16, 1);
            RETURN;
        END;

        --Kiểm tra FK hợp lệ
        IF NOT EXISTS (SELECT 1 FROM YEUCAUBOITHUONG WHERE MaYC = @MaYC)
        BEGIN
            RAISERROR(N'Mã yêu cầu bồi thường không tồn tại.', 16, 1);
            RETURN;
        END;
        IF @MaNV_Chi IS NOT NULL AND NOT EXISTS (SELECT 1 FROM NHANVIEN WHERE MaNV = @MaNV_Chi)
        BEGIN
            RAISERROR(N'Mã nhân viên chi trả không tồn tại.', 16, 1);
            RETURN;
        END;

        --Kiểm tra số tiền hợp lệ
        IF @SoTienChi < 0
        BEGIN
            RAISERROR(N'Số tiền chi trả phải >= 0.', 16, 1);
            RETURN;
        END;

        --Lấy dữ liệu hiện tại để kiểm tra tổng chi
        DECLARE @SoTienYC DECIMAL(18,2), @NgayYC DATE, @TongChi DECIMAL(18,2);
        SELECT @SoTienYC = SoTienYC, @NgayYC = NgayYeuCau
        FROM YEUCAUBOITHUONG WHERE MaYC = @MaYC;

        SELECT @TongChi = ISNULL(SUM(SoTienChi), 0)
        FROM CHITRABOITHUONG
        WHERE MaYC = @MaYC AND MaCT <> @MaCT;

        --Kiểm tra ngày chi trả
        IF @NgayChiTra < @NgayYC
        BEGIN
            RAISERROR(N'Ngày chi trả không được trước ngày yêu cầu bồi thường.', 16, 1);
            RETURN;
        END;

        --Kiểm tra tổng chi không vượt quá số tiền yêu cầu
        IF @TongChi + @SoTienChi > @SoTienYC
        BEGIN
            RAISERROR(N'Tổng số tiền chi vượt quá số tiền yêu cầu bồi thường.', 16, 1);
            RETURN;
        END;

        UPDATE CHITRABOITHUONG
        SET MaYC = @MaYC,
            NgayChiTra = @NgayChiTra,
            SoTienChi = @SoTienChi,
            HinhThucChi = @HinhThucChi,
            TrangThai = @TrangThai,
            MaNV_Chi = @MaNV_Chi,
            GhiChu = @GhiChu
        WHERE MaCT = @MaCT;

        PRINT N'Cập nhật chi trả bồi thường thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi sửa chi trả bồi thường: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


=======
USE QL_BaoHiem;
GO

/*Thêm chi trả bồi thường */
CREATE OR ALTER PROCEDURE SP_Them_ChiTraBoiThuong
    @MaYC INT,
    @NgayChiTra DATE,
    @SoTienChi DECIMAL(18,2),
    @HinhThucChi NVARCHAR(100),
    @TrangThai NVARCHAR(30) = N'Đã chi trả',
    @MaNV_Chi INT = NULL,
    @GhiChu NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        --Kiểm tra yêu cầu bồi thường tồn tại
        IF NOT EXISTS (SELECT 1 FROM YEUCAUBOITHUONG WHERE MaYC = @MaYC)
        BEGIN
            RAISERROR(N'Mã yêu cầu bồi thường không tồn tại.', 16, 1);
            RETURN;
        END;

        --Kiểm tra nhân viên chi (nếu có)
        IF @MaNV_Chi IS NOT NULL AND NOT EXISTS (SELECT 1 FROM NHANVIEN WHERE MaNV = @MaNV_Chi)
        BEGIN
            RAISERROR(N'Mã nhân viên chi trả không tồn tại.', 16, 1);
            RETURN;
        END;

        --Kiểm tra số tiền hợp lệ
        IF @SoTienChi < 0
        BEGIN
            RAISERROR(N'Số tiền chi trả phải >= 0.', 16, 1);
            RETURN;
        END;

        --Lấy ngày yêu cầu và tổng tiền đã chi để kiểm tra
        DECLARE @NgayYC DATE, @SoTienYC DECIMAL(18,2), @TongChi DECIMAL(18,2);
        SELECT @NgayYC = NgayYeuCau, @SoTienYC = SoTienYC
        FROM YEUCAUBOITHUONG WHERE MaYC = @MaYC;

        SELECT @TongChi = ISNULL(SUM(SoTienChi), 0)
        FROM CHITRABOITHUONG WHERE MaYC = @MaYC;

        --Kiểm tra ngày chi trả hợp lệ
        IF @NgayChiTra < @NgayYC
        BEGIN
            RAISERROR(N'Ngày chi trả không được trước ngày yêu cầu bồi thường.', 16, 1);
            RETURN;
        END;

        --Kiểm tra tổng chi trả không vượt số tiền yêu cầu
        IF @TongChi + @SoTienChi > @SoTienYC
        BEGIN
            RAISERROR(N'Tổng số tiền chi vượt quá số tiền yêu cầu bồi thường.', 16, 1);
            RETURN;
        END;

        INSERT INTO CHITRABOITHUONG (MaYC, NgayChiTra, SoTienChi, HinhThucChi, TrangThai, MaNV_Chi, GhiChu)
        VALUES (@MaYC, @NgayChiTra, @SoTienChi, @HinhThucChi, @TrangThai, @MaNV_Chi, @GhiChu);

        PRINT N'Thêm chi trả bồi thường thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi thêm chi trả bồi thường: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


/*Sửa chi trả bồi thường */
CREATE OR ALTER PROCEDURE SP_Sua_ChiTraBoiThuong
    @MaCT INT,
    @MaYC INT,
    @NgayChiTra DATE,
    @SoTienChi DECIMAL(18,2),
    @HinhThucChi NVARCHAR(100),
    @TrangThai NVARCHAR(30),
    @MaNV_Chi INT = NULL,
    @GhiChu NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        --Kiểm tra bản ghi tồn tại
        IF NOT EXISTS (SELECT 1 FROM CHITRABOITHUONG WHERE MaCT = @MaCT)
        BEGIN
            RAISERROR(N'Không tìm thấy bản ghi chi trả cần sửa.', 16, 1);
            RETURN;
        END;

        --Kiểm tra FK hợp lệ
        IF NOT EXISTS (SELECT 1 FROM YEUCAUBOITHUONG WHERE MaYC = @MaYC)
        BEGIN
            RAISERROR(N'Mã yêu cầu bồi thường không tồn tại.', 16, 1);
            RETURN;
        END;
        IF @MaNV_Chi IS NOT NULL AND NOT EXISTS (SELECT 1 FROM NHANVIEN WHERE MaNV = @MaNV_Chi)
        BEGIN
            RAISERROR(N'Mã nhân viên chi trả không tồn tại.', 16, 1);
            RETURN;
        END;

        --Kiểm tra số tiền hợp lệ
        IF @SoTienChi < 0
        BEGIN
            RAISERROR(N'Số tiền chi trả phải >= 0.', 16, 1);
            RETURN;
        END;

        --Lấy dữ liệu hiện tại để kiểm tra tổng chi
        DECLARE @SoTienYC DECIMAL(18,2), @NgayYC DATE, @TongChi DECIMAL(18,2);
        SELECT @SoTienYC = SoTienYC, @NgayYC = NgayYeuCau
        FROM YEUCAUBOITHUONG WHERE MaYC = @MaYC;

        SELECT @TongChi = ISNULL(SUM(SoTienChi), 0)
        FROM CHITRABOITHUONG
        WHERE MaYC = @MaYC AND MaCT <> @MaCT;

        --Kiểm tra ngày chi trả
        IF @NgayChiTra < @NgayYC
        BEGIN
            RAISERROR(N'Ngày chi trả không được trước ngày yêu cầu bồi thường.', 16, 1);
            RETURN;
        END;

        --Kiểm tra tổng chi không vượt quá số tiền yêu cầu
        IF @TongChi + @SoTienChi > @SoTienYC
        BEGIN
            RAISERROR(N'Tổng số tiền chi vượt quá số tiền yêu cầu bồi thường.', 16, 1);
            RETURN;
        END;

        UPDATE CHITRABOITHUONG
        SET MaYC = @MaYC,
            NgayChiTra = @NgayChiTra,
            SoTienChi = @SoTienChi,
            HinhThucChi = @HinhThucChi,
            TrangThai = @TrangThai,
            MaNV_Chi = @MaNV_Chi,
            GhiChu = @GhiChu
        WHERE MaCT = @MaCT;

        PRINT N'Cập nhật chi trả bồi thường thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi sửa chi trả bồi thường: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


>>>>>>> 59c5acf48653319ce8c913c2014f62e09ddfb835
-- Không cung cấp thủ tục Xóa cho CHITRABOITHUONG (nghiệp vụ tài chính).