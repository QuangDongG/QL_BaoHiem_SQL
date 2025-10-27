<<<<<<< HEAD
﻿-- 1. Loại bảo hiểm
USE QL_BAOHIEM;
GO

/* === PHẦN 1.1: LOẠI BẢO HIỂM === */
DROP PROCEDURE IF EXISTS SP_ThemLOAIBAOHIEM;
GO
CREATE PROCEDURE SP_ThemLOAIBAOHIEM
    @TenLoai NVARCHAR(100),
    @MoTa NVARCHAR(255)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM LOAIBAOHIEM WHERE TenLoai = @TenLoai)
    BEGIN
        RAISERROR(N' Loại bảo hiểm đã tồn tại.',16,1);
        RETURN;
    END
    INSERT INTO LOAIBAOHIEM (TenLoai, MoTa)
    VALUES (@TenLoai, @MoTa);
    PRINT N' Thêm loại bảo hiểm thành công.';
END;
GO

DROP PROCEDURE IF EXISTS SP_SuaLOAIBAOHIEM;
GO
CREATE PROCEDURE SP_SuaLOAIBAOHIEM
    @MaLoai INT,
    @TenLoai NVARCHAR(100),
    @MoTa NVARCHAR(255)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM LOAIBAOHIEM WHERE MaLoai = @MaLoai)
    BEGIN
        RAISERROR(N' Không tìm thấy loại bảo hiểm cần sửa.',16,1);
        RETURN;
    END
    UPDATE LOAIBAOHIEM
    SET TenLoai = @TenLoai, MoTa = @MoTa
    WHERE MaLoai = @MaLoai;
    PRINT N' Cập nhật loại bảo hiểm thành công.';
END;
GO

DROP PROCEDURE IF EXISTS SP_XoaLOAIBAOHIEM;
GO
CREATE PROCEDURE SP_XoaLOAIBAOHIEM
    @MaLoai INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM LOAIBAOHIEM WHERE MaLoai = @MaLoai)
    BEGIN
        RAISERROR(N' Không tìm thấy loại bảo hiểm cần xóa.',16,1);
        RETURN;
    END
    DELETE FROM LOAIBAOHIEM WHERE MaLoai = @MaLoai;
    PRINT N' Đã xóa loại bảo hiểm.';
END;
GO

/* === PHẦN 1.2: GÓI BẢO HIỂM === */
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


/* === PHẦN 1.3: PHÒNG BAN === */
CREATE OR ALTER PROCEDURE SP_Them_PhongBan
    @TenPhong NVARCHAR(100),
    @MoTa NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra trùng tên phòng
        IF EXISTS (SELECT 1 FROM PHONGBAN WHERE TenPhong = @TenPhong)
        BEGIN
            RAISERROR(N'Tên phòng ban đã tồn tại.', 16, 1);
            RETURN;
        END;

        INSERT INTO PHONGBAN (TenPhong, MoTa)
        VALUES (@TenPhong, @MoTa);

        PRINT N'Thêm phòng ban thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi thêm phòng ban: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

--Sửa
CREATE OR ALTER PROCEDURE SP_Sua_PhongBan
    @MaPhong INT,
    @TenPhong NVARCHAR(100),
    @MoTa NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra tồn tại mã cần sửa
        IF NOT EXISTS (SELECT 1 FROM PHONGBAN WHERE MaPhong = @MaPhong)
        BEGIN
            RAISERROR(N'Không tìm thấy phòng ban cần sửa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra trùng tên với bản ghi khác
        IF EXISTS (SELECT 1 FROM PHONGBAN WHERE TenPhong = @TenPhong AND MaPhong <> @MaPhong)
        BEGIN
            RAISERROR(N'Tên phòng ban đã tồn tại ở bản ghi khác.', 16, 1);
            RETURN;
        END;

        UPDATE PHONGBAN
        SET TenPhong = @TenPhong,
            MoTa = @MoTa
        WHERE MaPhong = @MaPhong;

        PRINT N'Sửa thông tin phòng ban thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi sửa phòng ban: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


--Xóa
CREATE OR ALTER PROCEDURE SP_Xoa_PhongBan
    @MaPhong INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra tồn tại
        IF NOT EXISTS (SELECT 1 FROM PHONGBAN WHERE MaPhong = @MaPhong)
        BEGIN
            RAISERROR(N'Không tìm thấy phòng ban cần xóa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra có nhân viên thuộc phòng này không
        IF EXISTS (SELECT 1 FROM NHANVIEN WHERE MaPhong = @MaPhong)
        BEGIN
            RAISERROR(N'Không thể xóa phòng ban vì đang có nhân viên thuộc phòng này.', 16, 1);
            RETURN;
        END;

        DELETE FROM PHONGBAN WHERE MaPhong = @MaPhong;

        PRINT N'Xóa phòng ban thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi xóa phòng ban: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


/* === PHẦN 2.1: NHÂN VIÊN === */
/* Thêm nhân viên */
CREATE OR ALTER PROCEDURE SP_Them_NhanVien
    @HoTen NVARCHAR(120),
    @GioiTinh NCHAR(3),
    @NgaySinh DATE = NULL,
    @SDT VARCHAR(20) = NULL,
    @Email VARCHAR(150),
    @DiaChi NVARCHAR(255) = NULL,
    @ChucVu NVARCHAR(100) = NULL,
    @Luong DECIMAL(18,2) = 0,
    @MaPhong INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra trùng email
        IF EXISTS (SELECT 1 FROM NHANVIEN WHERE Email = @Email)
        BEGIN
            RAISERROR(N'Email nhân viên đã tồn tại.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra giới tính hợp lệ
        IF @GioiTinh NOT IN (N'Nam', N'Nữ', N'Khác')
        BEGIN
            RAISERROR(N'Giới tính không hợp lệ. Chỉ được nhập Nam, Nữ hoặc Khác.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra phòng ban nếu có
        IF @MaPhong IS NOT NULL AND NOT EXISTS (SELECT 1 FROM PHONGBAN WHERE MaPhong = @MaPhong)
        BEGIN
            RAISERROR(N'Mã phòng ban không tồn tại.', 16, 1);
            RETURN;
        END;

        INSERT INTO NHANVIEN (HoTen, GioiTinh, NgaySinh, SDT, Email, DiaChi, ChucVu, Luong, MaPhong)
        VALUES (@HoTen, @GioiTinh, @NgaySinh, @SDT, @Email, @DiaChi, @ChucVu, @Luong, @MaPhong);

        PRINT N'Thêm nhân viên thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi thêm nhân viên: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


/* Sửa thông tin nhân viên */
CREATE OR ALTER PROCEDURE SP_Sua_NhanVien
    @MaNV INT,
    @HoTen NVARCHAR(120),
    @GioiTinh NCHAR(3),
    @NgaySinh DATE = NULL,
    @SDT VARCHAR(20) = NULL,
    @Email VARCHAR(150),
    @DiaChi NVARCHAR(255) = NULL,
    @ChucVu NVARCHAR(100) = NULL,
    @Luong DECIMAL(18,2) = 0,
    @MaPhong INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra tồn tại nhân viên
        IF NOT EXISTS (SELECT 1 FROM NHANVIEN WHERE MaNV = @MaNV)
        BEGIN
            RAISERROR(N'Không tìm thấy nhân viên cần sửa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra trùng email với người khác
        IF EXISTS (SELECT 1 FROM NHANVIEN WHERE Email = @Email AND MaNV <> @MaNV)
        BEGIN
            RAISERROR(N'Email này đã được sử dụng bởi nhân viên khác.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra giới tính hợp lệ
        IF @GioiTinh NOT IN (N'Nam', N'Nữ', N'Khác')
        BEGIN
            RAISERROR(N'Giới tính không hợp lệ. Chỉ được nhập Nam, Nữ hoặc Khác.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra mã phòng hợp lệ nếu có
        IF @MaPhong IS NOT NULL AND NOT EXISTS (SELECT 1 FROM PHONGBAN WHERE MaPhong = @MaPhong)
        BEGIN
            RAISERROR(N'Mã phòng ban không tồn tại.', 16, 1);
            RETURN;
        END;

        UPDATE NHANVIEN
        SET HoTen = @HoTen,
            GioiTinh = @GioiTinh,
            NgaySinh = @NgaySinh,
            SDT = @SDT,
            Email = @Email,
            DiaChi = @DiaChi,
            ChucVu = @ChucVu,
            Luong = @Luong,
            MaPhong = @MaPhong
        WHERE MaNV = @MaNV;

        PRINT N'Cập nhật thông tin nhân viên thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi sửa nhân viên: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


/*Xóa nhân viên */
CREATE OR ALTER PROCEDURE SP_Xoa_NhanVien
    @MaNV INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra nhân viên tồn tại
        IF NOT EXISTS (SELECT 1 FROM NHANVIEN WHERE MaNV = @MaNV)
        BEGIN
            RAISERROR(N'Không tìm thấy nhân viên cần xóa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra nhân viên có liên kết với bảng khác không
        IF EXISTS (SELECT 1 FROM HOPDONG WHERE MaNV_TuVan = @MaNV)
            OR EXISTS (SELECT 1 FROM THANHTOANPHI WHERE MaNV_Thu = @MaNV)
            OR EXISTS (SELECT 1 FROM CHITRABOITHUONG WHERE MaNV_Chi = @MaNV)
            OR EXISTS (SELECT 1 FROM TAIKHOAN WHERE MaNV = @MaNV)
        BEGIN
            RAISERROR(N'Không thể xóa nhân viên này vì đang được sử dụng trong các bảng liên quan.', 16, 1);
            RETURN;
        END;

        DELETE FROM NHANVIEN WHERE MaNV = @MaNV;

        PRINT N'Xóa nhân viên thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi xóa nhân viên: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

/* === PHẦN 2.2: KHÁCH HÀNG === */

/* Thêm khách hàng */
CREATE OR ALTER PROCEDURE SP_Them_KhachHang
    @HoTen NVARCHAR(120),
    @NgaySinh DATE = NULL,
    @GioiTinh NCHAR(3),
    @CCCD VARCHAR(20) = NULL,
    @DiaChi NVARCHAR(255) = NULL,
    @SDT VARCHAR(20) = NULL,
    @Email VARCHAR(150) = NULL,
    @NgheNghiep NVARCHAR(100) = NULL,
    @ThuNhap DECIMAL(18,2) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra giới tính hợp lệ
        IF @GioiTinh NOT IN (N'Nam', N'Nữ', N'Khác')
        BEGIN
            RAISERROR(N'Giới tính không hợp lệ. Chỉ được nhập Nam, Nữ hoặc Khác.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra trùng CCCD
        IF @CCCD IS NOT NULL AND EXISTS (SELECT 1 FROM KHACHHANG WHERE CCCD = @CCCD)
        BEGIN
            RAISERROR(N'CCCD đã tồn tại.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra trùng Email
        IF @Email IS NOT NULL AND EXISTS (SELECT 1 FROM KHACHHANG WHERE Email = @Email)
        BEGIN
            RAISERROR(N'Email khách hàng đã tồn tại.', 16, 1);
            RETURN;
        END;

        INSERT INTO KHACHHANG (HoTen, NgaySinh, GioiTinh, CCCD, DiaChi, SDT, Email, NgheNghiep, ThuNhap)
        VALUES (@HoTen, @NgaySinh, @GioiTinh, @CCCD, @DiaChi, @SDT, @Email, @NgheNghiep, @ThuNhap);

        PRINT N'Thêm khách hàng thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi thêm khách hàng: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


/* Sửa thông tin khách hàng */
CREATE OR ALTER PROCEDURE SP_Sua_KhachHang
    @MaKH INT,
    @HoTen NVARCHAR(120),
    @NgaySinh DATE = NULL,
    @GioiTinh NCHAR(3),
    @CCCD VARCHAR(20) = NULL,
    @DiaChi NVARCHAR(255) = NULL,
    @SDT VARCHAR(20) = NULL,
    @Email VARCHAR(150) = NULL,
    @NgheNghiep NVARCHAR(100) = NULL,
    @ThuNhap DECIMAL(18,2) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra tồn tại khách hàng
        IF NOT EXISTS (SELECT 1 FROM KHACHHANG WHERE MaKH = @MaKH)
        BEGIN
            RAISERROR(N'Không tìm thấy khách hàng cần sửa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra giới tính hợp lệ
        IF @GioiTinh NOT IN (N'Nam', N'Nữ', N'Khác')
        BEGIN
            RAISERROR(N'Giới tính không hợp lệ. Chỉ được nhập Nam, Nữ hoặc Khác.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra trùng CCCD với khách khác
        IF @CCCD IS NOT NULL AND EXISTS (SELECT 1 FROM KHACHHANG WHERE CCCD = @CCCD AND MaKH <> @MaKH)
        BEGIN
            RAISERROR(N'CCCD đã tồn tại ở khách hàng khác.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra trùng Email với khách khác
        IF @Email IS NOT NULL AND EXISTS (SELECT 1 FROM KHACHHANG WHERE Email = @Email AND MaKH <> @MaKH)
        BEGIN
            RAISERROR(N'Email này đã được sử dụng bởi khách hàng khác.', 16, 1);
            RETURN;
        END;

        UPDATE KHACHHANG
        SET HoTen = @HoTen,
            NgaySinh = @NgaySinh,
            GioiTinh = @GioiTinh,
            CCCD = @CCCD,
            DiaChi = @DiaChi,
            SDT = @SDT,
            Email = @Email,
            NgheNghiep = @NgheNghiep,
            ThuNhap = @ThuNhap
        WHERE MaKH = @MaKH;

        PRINT N'Cập nhật thông tin khách hàng thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi sửa khách hàng: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


/* Xóa khách hàng */
CREATE OR ALTER PROCEDURE SP_Xoa_KhachHang
    @MaKH INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra tồn tại
        IF NOT EXISTS (SELECT 1 FROM KHACHHANG WHERE MaKH = @MaKH)
        BEGIN
            RAISERROR(N'Không tìm thấy khách hàng cần xóa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra có liên kết dữ liệu ở bảng khác
        IF EXISTS (SELECT 1 FROM HOPDONG WHERE MaKH = @MaKH)
            OR EXISTS (SELECT 1 FROM YEUCAUBOITHUONG YC JOIN HOPDONG HD ON YC.MaHD = HD.MaHD WHERE HD.MaKH = @MaKH)
            OR EXISTS (SELECT 1 FROM TAIKHOAN WHERE MaKH = @MaKH)
        BEGIN
            RAISERROR(N'Không thể xóa khách hàng này vì đang có dữ liệu liên quan trong Hợp đồng, Bồi thường hoặc Tài khoản.', 16, 1);
            RETURN;
        END;

        DELETE FROM KHACHHANG WHERE MaKH = @MaKH;

        PRINT N'Xóa khách hàng thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi xóa khách hàng: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


/* === PHẦN 2.3: TÀI KHOẢN === */

/*Thêm tài khoản */
CREATE OR ALTER PROCEDURE SP_Them_TaiKhoan
    @TenDangNhap VARCHAR(100),
    @MatKhauHash VARBINARY(256),
    @LoaiTK NVARCHAR(20),
    @MaKH INT = NULL,
    @MaNV INT = NULL,
    @TrangThai NVARCHAR(20) = N'Hoạt động'
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        --Kiểm tra trùng tên đăng nhập
        IF EXISTS (SELECT 1 FROM TAIKHOAN WHERE TenDangNhap = @TenDangNhap)
        BEGIN
            RAISERROR(N'Tên đăng nhập đã tồn tại.', 16, 1);
            RETURN;
        END;

        --Kiểm tra loại tài khoản hợp lệ
        IF @LoaiTK NOT IN (N'KH', N'NV')
        BEGIN
            RAISERROR(N'Loại tài khoản không hợp lệ. Chỉ chấp nhận KH hoặc NV.', 16, 1);
            RETURN;
        END;

        --Kiểm tra ràng buộc loại tài khoản
        IF @LoaiTK = N'KH' AND @MaKH IS NULL
        BEGIN
            RAISERROR(N'Tài khoản loại KH phải liên kết với mã khách hàng.', 16, 1);
            RETURN;
        END;
        IF @LoaiTK = N'NV' AND @MaNV IS NULL
        BEGIN
            RAISERROR(N'Tài khoản loại NV phải liên kết với mã nhân viên.', 16, 1);
            RETURN;
        END;

        --Kiểm tra tồn tại của KH hoặc NV
        IF @MaKH IS NOT NULL AND NOT EXISTS (SELECT 1 FROM KHACHHANG WHERE MaKH = @MaKH)
        BEGIN
            RAISERROR(N'Mã khách hàng không tồn tại.', 16, 1);
            RETURN;
        END;
        IF @MaNV IS NOT NULL AND NOT EXISTS (SELECT 1 FROM NHANVIEN WHERE MaNV = @MaNV)
        BEGIN
            RAISERROR(N'Mã nhân viên không tồn tại.', 16, 1);
            RETURN;
        END;

        INSERT INTO TAIKHOAN (TenDangNhap, MatKhauHash, LoaiTK, MaKH, MaNV, NgayTao, TrangThai)
        VALUES (@TenDangNhap, @MatKhauHash, @LoaiTK, @MaKH, @MaNV, GETDATE(), @TrangThai);

        PRINT N'Thêm tài khoản thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi thêm tài khoản: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


/*Sửa tài khoản */
CREATE OR ALTER PROCEDURE SP_Sua_TaiKhoan
    @MaTK INT,
    @TenDangNhap VARCHAR(100),
    @MatKhauHash VARBINARY(256),
    @LoaiTK NVARCHAR(20),
    @MaKH INT = NULL,
    @MaNV INT = NULL,
    @TrangThai NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        --Kiểm tra tồn tại tài khoản
        IF NOT EXISTS (SELECT 1 FROM TAIKHOAN WHERE MaTK = @MaTK)
        BEGIN
            RAISERROR(N'Không tìm thấy tài khoản cần sửa.', 16, 1);
            RETURN;
        END;

        --Kiểm tra trùng tên đăng nhập
        IF EXISTS (SELECT 1 FROM TAIKHOAN WHERE TenDangNhap = @TenDangNhap AND MaTK <> @MaTK)
        BEGIN
            RAISERROR(N'Tên đăng nhập đã tồn tại ở tài khoản khác.', 16, 1);
            RETURN;
        END;

        --Kiểm tra loại tài khoản hợp lệ
        IF @LoaiTK NOT IN (N'KH', N'NV')
        BEGIN
            RAISERROR(N'Loại tài khoản không hợp lệ.', 16, 1);
            RETURN;
        END;

        --Kiểm tra ràng buộc loại tài khoản
        IF @LoaiTK = N'KH' AND @MaKH IS NULL
        BEGIN
            RAISERROR(N'Tài khoản KH phải có mã khách hàng.', 16, 1);
            RETURN;
        END;
        IF @LoaiTK = N'NV' AND @MaNV IS NULL
        BEGIN
            RAISERROR(N'Tài khoản NV phải có mã nhân viên.', 16, 1);
            RETURN;
        END;

        --Kiểm tra tồn tại khách hàng hoặc nhân viên
        IF @MaKH IS NOT NULL AND NOT EXISTS (SELECT 1 FROM KHACHHANG WHERE MaKH = @MaKH)
        BEGIN
            RAISERROR(N'Mã khách hàng không tồn tại.', 16, 1);
            RETURN;
        END;
        IF @MaNV IS NOT NULL AND NOT EXISTS (SELECT 1 FROM NHANVIEN WHERE MaNV = @MaNV)
        BEGIN
            RAISERROR(N'Mã nhân viên không tồn tại.', 16, 1);
            RETURN;
        END;

        UPDATE TAIKHOAN
        SET TenDangNhap = @TenDangNhap,
            MatKhauHash = @MatKhauHash,
            LoaiTK = @LoaiTK,
            MaKH = @MaKH,
            MaNV = @MaNV,
            TrangThai = @TrangThai
        WHERE MaTK = @MaTK;

        PRINT N'Cập nhật tài khoản thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi sửa tài khoản: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


/*Xóa tài khoản */
CREATE OR ALTER PROCEDURE SP_Xoa_TaiKhoan
    @MaTK INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        --Kiểm tra tồn tại
        IF NOT EXISTS (SELECT 1 FROM TAIKHOAN WHERE MaTK = @MaTK)
        BEGIN
            RAISERROR(N'Không tìm thấy tài khoản cần xóa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra có lịch sử truy cập (nếu có)
        IF EXISTS (SELECT 1 FROM LICHSU_TRUY_CAP WHERE MaTK = @MaTK)
        BEGIN
            RAISERROR(N'Không thể xóa tài khoản vì đã có lịch sử truy cập.', 16, 1);
            RETURN;
        END;

        DELETE FROM TAIKHOAN WHERE MaTK = @MaTK;

        PRINT N'Xóa tài khoản thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi xóa tài khoản: ' + ERROR_MESSAGE();
    END CATCH
END;
GO



/* =========================================================
   PHẦN 3.1 — HÌNH THỨC THANH TOÁN (HINHTHUC_THANHTOAN)
   Giả định cột: MaHT (PK), TenHT, MoTa
   ========================================================= */
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


/* =========================================================
   PHẦN 3.2 — THANHTOANPHI
   Cấu trúc đã cho: MaTT (ID), MaHD, NgayTT, SoTien, MaHT, MaNV_Thu, TrangThai, MaGiaoDich (UNIQUE)
   ========================================================= */ 
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


/* =========================================================
   PHẦN 3.3 — KHUYENMAI
   Giả định cột: MaKM (PK), TenKM, GiaTriKM (DECIMAL), NgayBatDau, NgayKetThuc, GhiChu
   ========================================================= */
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


/* =========================================================
   PHẦN 3.4 — HỢP ĐỒNG (HOPDONG)
   Cột đã dùng: MaHD, MaKH, MaGoi, MaNV_TuVan, MaSoHD, NgayKy, NgayHieuLuc, NgayHetHan, TrangThai, GhiChu
   ========================================================= */
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


/* =========================================================
   PHẦN 3.5 — HOPDONG_KHUYENMAI (bảng liên kết n-n)
   Cột: MaHD, MaKM
   ========================================================= */
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


/* =========================================================
   PHẦN 3.6 — TÌNH TRẠNG YÊU CẦU (TINHTRANG_YEUCAU)
   Cột: MaTT (PK), TenTT, MoTa
   ========================================================= */

CREATE PROCEDURE SP_Them_TinhTrangYeuCau
    @TenTT NVARCHAR(100),
    @MoTa NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra trùng tên tình trạng
        IF EXISTS (SELECT 1 FROM TINHTRANG_YEUCAU WHERE TenTT = @TenTT)
        BEGIN
            RAISERROR(N'Tên tình trạng yêu cầu đã tồn tại.', 16, 1);
            RETURN;
        END;

        INSERT INTO TINHTRANG_YEUCAU (TenTT, MoTa)
        VALUES (@TenTT, @MoTa);

        PRINT N'Thêm tình trạng yêu cầu thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi thêm tình trạng yêu cầu: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
--Sửa
CREATE PROCEDURE SP_Sua_TinhTrangYeuCau
    @MaTT INT,
    @TenTT NVARCHAR(100),
    @MoTa NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra tồn tại mã cần sửa
        IF NOT EXISTS (SELECT 1 FROM TINHTRANG_YEUCAU WHERE MaTT = @MaTT)
        BEGIN
            RAISERROR(N'Không tìm thấy tình trạng yêu cầu cần sửa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra trùng tên với bản ghi khác
        IF EXISTS (SELECT 1 FROM TINHTRANG_YEUCAU WHERE TenTT = @TenTT AND MaTT <> @MaTT)
        BEGIN
            RAISERROR(N'Tên tình trạng yêu cầu đã tồn tại ở bản ghi khác.', 16, 1);
            RETURN;
        END;

        UPDATE TINHTRANG_YEUCAU
        SET TenTT = @TenTT,
            MoTa = @MoTa
        WHERE MaTT = @MaTT;

        PRINT N'Cập nhật tình trạng yêu cầu thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi sửa tình trạng yêu cầu: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
--Xóa
CREATE PROCEDURE SP_Xoa_TinhTrangYeuCau
    @MaTT INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra tồn tại mã cần xóa
        IF NOT EXISTS (SELECT 1 FROM TINHTRANG_YEUCAU WHERE MaTT = @MaTT)
        BEGIN
            RAISERROR(N'Không tìm thấy tình trạng yêu cầu cần xóa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra có đang được sử dụng trong bảng YEUCAUBOITHUONG không
        IF EXISTS (SELECT 1 FROM YEUCAUBOITHUONG WHERE MaTT_TrangThai = @MaTT)
        BEGIN
            RAISERROR(N'Không thể xóa tình trạng này vì đang được sử dụng trong bảng YEUCAUBOITHUONG.', 16, 1);
            RETURN;
        END;

        DELETE FROM TINHTRANG_YEUCAU WHERE MaTT = @MaTT;

        PRINT N'Xóa tình trạng yêu cầu thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi xóa tình trạng yêu cầu: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


/* =========================================================
   PHẦN 3.8 — CHI TRẢ BỒI THƯỜNG (CHITRABOITHUONG)
   Cột đã cho: MaCT (ID), MaYC, NgayChiTra, SoTienChi, HinhThucChi, TrangThai, MaNV_Chi, GhiChu
   ========================================================= */
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
-- Không cung cấp thủ tục Xóa cho CHITRABOITHUONG (nghiệp vụ tài chính).
/* =========================================================
   PHẦN 4 — LỊCH SỬ TRUY CẬP (LICHSU_TRUY_CAP)
   Cột: MaLS, MaTK, ThoiGian, HanhDong, MoTa, DiaChiIP
   ========================================================= */
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

--

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
=======
﻿-- 1. Loại bảo hiểm
USE QL_BAOHIEM;
GO

/* === PHẦN 1.1: LOẠI BẢO HIỂM === */
DROP PROCEDURE IF EXISTS SP_ThemLOAIBAOHIEM;
GO
CREATE PROCEDURE SP_ThemLOAIBAOHIEM
    @TenLoai NVARCHAR(100),
    @MoTa NVARCHAR(255)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM LOAIBAOHIEM WHERE TenLoai = @TenLoai)
    BEGIN
        RAISERROR(N' Loại bảo hiểm đã tồn tại.',16,1);
        RETURN;
    END
    INSERT INTO LOAIBAOHIEM (TenLoai, MoTa)
    VALUES (@TenLoai, @MoTa);
    PRINT N' Thêm loại bảo hiểm thành công.';
END;
GO

DROP PROCEDURE IF EXISTS SP_SuaLOAIBAOHIEM;
GO
CREATE PROCEDURE SP_SuaLOAIBAOHIEM
    @MaLoai INT,
    @TenLoai NVARCHAR(100),
    @MoTa NVARCHAR(255)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM LOAIBAOHIEM WHERE MaLoai = @MaLoai)
    BEGIN
        RAISERROR(N' Không tìm thấy loại bảo hiểm cần sửa.',16,1);
        RETURN;
    END
    UPDATE LOAIBAOHIEM
    SET TenLoai = @TenLoai, MoTa = @MoTa
    WHERE MaLoai = @MaLoai;
    PRINT N' Cập nhật loại bảo hiểm thành công.';
END;
GO

DROP PROCEDURE IF EXISTS SP_XoaLOAIBAOHIEM;
GO
CREATE PROCEDURE SP_XoaLOAIBAOHIEM
    @MaLoai INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM LOAIBAOHIEM WHERE MaLoai = @MaLoai)
    BEGIN
        RAISERROR(N' Không tìm thấy loại bảo hiểm cần xóa.',16,1);
        RETURN;
    END
    DELETE FROM LOAIBAOHIEM WHERE MaLoai = @MaLoai;
    PRINT N' Đã xóa loại bảo hiểm.';
END;
GO

/* === PHẦN 1.2: GÓI BẢO HIỂM === */
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


/* === PHẦN 1.3: PHÒNG BAN === */
CREATE OR ALTER PROCEDURE SP_Them_PhongBan
    @TenPhong NVARCHAR(100),
    @MoTa NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra trùng tên phòng
        IF EXISTS (SELECT 1 FROM PHONGBAN WHERE TenPhong = @TenPhong)
        BEGIN
            RAISERROR(N'Tên phòng ban đã tồn tại.', 16, 1);
            RETURN;
        END;

        INSERT INTO PHONGBAN (TenPhong, MoTa)
        VALUES (@TenPhong, @MoTa);

        PRINT N'Thêm phòng ban thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi thêm phòng ban: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

--Sửa
CREATE OR ALTER PROCEDURE SP_Sua_PhongBan
    @MaPhong INT,
    @TenPhong NVARCHAR(100),
    @MoTa NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra tồn tại mã cần sửa
        IF NOT EXISTS (SELECT 1 FROM PHONGBAN WHERE MaPhong = @MaPhong)
        BEGIN
            RAISERROR(N'Không tìm thấy phòng ban cần sửa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra trùng tên với bản ghi khác
        IF EXISTS (SELECT 1 FROM PHONGBAN WHERE TenPhong = @TenPhong AND MaPhong <> @MaPhong)
        BEGIN
            RAISERROR(N'Tên phòng ban đã tồn tại ở bản ghi khác.', 16, 1);
            RETURN;
        END;

        UPDATE PHONGBAN
        SET TenPhong = @TenPhong,
            MoTa = @MoTa
        WHERE MaPhong = @MaPhong;

        PRINT N'Sửa thông tin phòng ban thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi sửa phòng ban: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


--Xóa
CREATE OR ALTER PROCEDURE SP_Xoa_PhongBan
    @MaPhong INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra tồn tại
        IF NOT EXISTS (SELECT 1 FROM PHONGBAN WHERE MaPhong = @MaPhong)
        BEGIN
            RAISERROR(N'Không tìm thấy phòng ban cần xóa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra có nhân viên thuộc phòng này không
        IF EXISTS (SELECT 1 FROM NHANVIEN WHERE MaPhong = @MaPhong)
        BEGIN
            RAISERROR(N'Không thể xóa phòng ban vì đang có nhân viên thuộc phòng này.', 16, 1);
            RETURN;
        END;

        DELETE FROM PHONGBAN WHERE MaPhong = @MaPhong;

        PRINT N'Xóa phòng ban thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi xóa phòng ban: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


/* === PHẦN 2.1: NHÂN VIÊN === */
/* Thêm nhân viên */
CREATE OR ALTER PROCEDURE SP_Them_NhanVien
    @HoTen NVARCHAR(120),
    @GioiTinh NCHAR(3),
    @NgaySinh DATE = NULL,
    @SDT VARCHAR(20) = NULL,
    @Email VARCHAR(150),
    @DiaChi NVARCHAR(255) = NULL,
    @ChucVu NVARCHAR(100) = NULL,
    @Luong DECIMAL(18,2) = 0,
    @MaPhong INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra trùng email
        IF EXISTS (SELECT 1 FROM NHANVIEN WHERE Email = @Email)
        BEGIN
            RAISERROR(N'Email nhân viên đã tồn tại.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra giới tính hợp lệ
        IF @GioiTinh NOT IN (N'Nam', N'Nữ', N'Khác')
        BEGIN
            RAISERROR(N'Giới tính không hợp lệ. Chỉ được nhập Nam, Nữ hoặc Khác.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra phòng ban nếu có
        IF @MaPhong IS NOT NULL AND NOT EXISTS (SELECT 1 FROM PHONGBAN WHERE MaPhong = @MaPhong)
        BEGIN
            RAISERROR(N'Mã phòng ban không tồn tại.', 16, 1);
            RETURN;
        END;

        INSERT INTO NHANVIEN (HoTen, GioiTinh, NgaySinh, SDT, Email, DiaChi, ChucVu, Luong, MaPhong)
        VALUES (@HoTen, @GioiTinh, @NgaySinh, @SDT, @Email, @DiaChi, @ChucVu, @Luong, @MaPhong);

        PRINT N'Thêm nhân viên thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi thêm nhân viên: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


/* Sửa thông tin nhân viên */
CREATE OR ALTER PROCEDURE SP_Sua_NhanVien
    @MaNV INT,
    @HoTen NVARCHAR(120),
    @GioiTinh NCHAR(3),
    @NgaySinh DATE = NULL,
    @SDT VARCHAR(20) = NULL,
    @Email VARCHAR(150),
    @DiaChi NVARCHAR(255) = NULL,
    @ChucVu NVARCHAR(100) = NULL,
    @Luong DECIMAL(18,2) = 0,
    @MaPhong INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra tồn tại nhân viên
        IF NOT EXISTS (SELECT 1 FROM NHANVIEN WHERE MaNV = @MaNV)
        BEGIN
            RAISERROR(N'Không tìm thấy nhân viên cần sửa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra trùng email với người khác
        IF EXISTS (SELECT 1 FROM NHANVIEN WHERE Email = @Email AND MaNV <> @MaNV)
        BEGIN
            RAISERROR(N'Email này đã được sử dụng bởi nhân viên khác.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra giới tính hợp lệ
        IF @GioiTinh NOT IN (N'Nam', N'Nữ', N'Khác')
        BEGIN
            RAISERROR(N'Giới tính không hợp lệ. Chỉ được nhập Nam, Nữ hoặc Khác.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra mã phòng hợp lệ nếu có
        IF @MaPhong IS NOT NULL AND NOT EXISTS (SELECT 1 FROM PHONGBAN WHERE MaPhong = @MaPhong)
        BEGIN
            RAISERROR(N'Mã phòng ban không tồn tại.', 16, 1);
            RETURN;
        END;

        UPDATE NHANVIEN
        SET HoTen = @HoTen,
            GioiTinh = @GioiTinh,
            NgaySinh = @NgaySinh,
            SDT = @SDT,
            Email = @Email,
            DiaChi = @DiaChi,
            ChucVu = @ChucVu,
            Luong = @Luong,
            MaPhong = @MaPhong
        WHERE MaNV = @MaNV;

        PRINT N'Cập nhật thông tin nhân viên thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi sửa nhân viên: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


/*Xóa nhân viên */
CREATE OR ALTER PROCEDURE SP_Xoa_NhanVien
    @MaNV INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra nhân viên tồn tại
        IF NOT EXISTS (SELECT 1 FROM NHANVIEN WHERE MaNV = @MaNV)
        BEGIN
            RAISERROR(N'Không tìm thấy nhân viên cần xóa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra nhân viên có liên kết với bảng khác không
        IF EXISTS (SELECT 1 FROM HOPDONG WHERE MaNV_TuVan = @MaNV)
            OR EXISTS (SELECT 1 FROM THANHTOANPHI WHERE MaNV_Thu = @MaNV)
            OR EXISTS (SELECT 1 FROM CHITRABOITHUONG WHERE MaNV_Chi = @MaNV)
            OR EXISTS (SELECT 1 FROM TAIKHOAN WHERE MaNV = @MaNV)
        BEGIN
            RAISERROR(N'Không thể xóa nhân viên này vì đang được sử dụng trong các bảng liên quan.', 16, 1);
            RETURN;
        END;

        DELETE FROM NHANVIEN WHERE MaNV = @MaNV;

        PRINT N'Xóa nhân viên thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi xóa nhân viên: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

/* === PHẦN 2.2: KHÁCH HÀNG === */

/* Thêm khách hàng */
CREATE OR ALTER PROCEDURE SP_Them_KhachHang
    @HoTen NVARCHAR(120),
    @NgaySinh DATE = NULL,
    @GioiTinh NCHAR(3),
    @CCCD VARCHAR(20) = NULL,
    @DiaChi NVARCHAR(255) = NULL,
    @SDT VARCHAR(20) = NULL,
    @Email VARCHAR(150) = NULL,
    @NgheNghiep NVARCHAR(100) = NULL,
    @ThuNhap DECIMAL(18,2) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra giới tính hợp lệ
        IF @GioiTinh NOT IN (N'Nam', N'Nữ', N'Khác')
        BEGIN
            RAISERROR(N'Giới tính không hợp lệ. Chỉ được nhập Nam, Nữ hoặc Khác.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra trùng CCCD
        IF @CCCD IS NOT NULL AND EXISTS (SELECT 1 FROM KHACHHANG WHERE CCCD = @CCCD)
        BEGIN
            RAISERROR(N'CCCD đã tồn tại.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra trùng Email
        IF @Email IS NOT NULL AND EXISTS (SELECT 1 FROM KHACHHANG WHERE Email = @Email)
        BEGIN
            RAISERROR(N'Email khách hàng đã tồn tại.', 16, 1);
            RETURN;
        END;

        INSERT INTO KHACHHANG (HoTen, NgaySinh, GioiTinh, CCCD, DiaChi, SDT, Email, NgheNghiep, ThuNhap)
        VALUES (@HoTen, @NgaySinh, @GioiTinh, @CCCD, @DiaChi, @SDT, @Email, @NgheNghiep, @ThuNhap);

        PRINT N'Thêm khách hàng thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi thêm khách hàng: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


/* Sửa thông tin khách hàng */
CREATE OR ALTER PROCEDURE SP_Sua_KhachHang
    @MaKH INT,
    @HoTen NVARCHAR(120),
    @NgaySinh DATE = NULL,
    @GioiTinh NCHAR(3),
    @CCCD VARCHAR(20) = NULL,
    @DiaChi NVARCHAR(255) = NULL,
    @SDT VARCHAR(20) = NULL,
    @Email VARCHAR(150) = NULL,
    @NgheNghiep NVARCHAR(100) = NULL,
    @ThuNhap DECIMAL(18,2) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra tồn tại khách hàng
        IF NOT EXISTS (SELECT 1 FROM KHACHHANG WHERE MaKH = @MaKH)
        BEGIN
            RAISERROR(N'Không tìm thấy khách hàng cần sửa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra giới tính hợp lệ
        IF @GioiTinh NOT IN (N'Nam', N'Nữ', N'Khác')
        BEGIN
            RAISERROR(N'Giới tính không hợp lệ. Chỉ được nhập Nam, Nữ hoặc Khác.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra trùng CCCD với khách khác
        IF @CCCD IS NOT NULL AND EXISTS (SELECT 1 FROM KHACHHANG WHERE CCCD = @CCCD AND MaKH <> @MaKH)
        BEGIN
            RAISERROR(N'CCCD đã tồn tại ở khách hàng khác.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra trùng Email với khách khác
        IF @Email IS NOT NULL AND EXISTS (SELECT 1 FROM KHACHHANG WHERE Email = @Email AND MaKH <> @MaKH)
        BEGIN
            RAISERROR(N'Email này đã được sử dụng bởi khách hàng khác.', 16, 1);
            RETURN;
        END;

        UPDATE KHACHHANG
        SET HoTen = @HoTen,
            NgaySinh = @NgaySinh,
            GioiTinh = @GioiTinh,
            CCCD = @CCCD,
            DiaChi = @DiaChi,
            SDT = @SDT,
            Email = @Email,
            NgheNghiep = @NgheNghiep,
            ThuNhap = @ThuNhap
        WHERE MaKH = @MaKH;

        PRINT N'Cập nhật thông tin khách hàng thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi sửa khách hàng: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


/* Xóa khách hàng */
CREATE OR ALTER PROCEDURE SP_Xoa_KhachHang
    @MaKH INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra tồn tại
        IF NOT EXISTS (SELECT 1 FROM KHACHHANG WHERE MaKH = @MaKH)
        BEGIN
            RAISERROR(N'Không tìm thấy khách hàng cần xóa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra có liên kết dữ liệu ở bảng khác
        IF EXISTS (SELECT 1 FROM HOPDONG WHERE MaKH = @MaKH)
            OR EXISTS (SELECT 1 FROM YEUCAUBOITHUONG YC JOIN HOPDONG HD ON YC.MaHD = HD.MaHD WHERE HD.MaKH = @MaKH)
            OR EXISTS (SELECT 1 FROM TAIKHOAN WHERE MaKH = @MaKH)
        BEGIN
            RAISERROR(N'Không thể xóa khách hàng này vì đang có dữ liệu liên quan trong Hợp đồng, Bồi thường hoặc Tài khoản.', 16, 1);
            RETURN;
        END;

        DELETE FROM KHACHHANG WHERE MaKH = @MaKH;

        PRINT N'Xóa khách hàng thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi xóa khách hàng: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


/* === PHẦN 2.3: TÀI KHOẢN === */

/*Thêm tài khoản */
CREATE OR ALTER PROCEDURE SP_Them_TaiKhoan
    @TenDangNhap VARCHAR(100),
    @MatKhauHash VARBINARY(256),
    @LoaiTK NVARCHAR(20),
    @MaKH INT = NULL,
    @MaNV INT = NULL,
    @TrangThai NVARCHAR(20) = N'Hoạt động'
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        --Kiểm tra trùng tên đăng nhập
        IF EXISTS (SELECT 1 FROM TAIKHOAN WHERE TenDangNhap = @TenDangNhap)
        BEGIN
            RAISERROR(N'Tên đăng nhập đã tồn tại.', 16, 1);
            RETURN;
        END;

        --Kiểm tra loại tài khoản hợp lệ
        IF @LoaiTK NOT IN (N'KH', N'NV')
        BEGIN
            RAISERROR(N'Loại tài khoản không hợp lệ. Chỉ chấp nhận KH hoặc NV.', 16, 1);
            RETURN;
        END;

        --Kiểm tra ràng buộc loại tài khoản
        IF @LoaiTK = N'KH' AND @MaKH IS NULL
        BEGIN
            RAISERROR(N'Tài khoản loại KH phải liên kết với mã khách hàng.', 16, 1);
            RETURN;
        END;
        IF @LoaiTK = N'NV' AND @MaNV IS NULL
        BEGIN
            RAISERROR(N'Tài khoản loại NV phải liên kết với mã nhân viên.', 16, 1);
            RETURN;
        END;

        --Kiểm tra tồn tại của KH hoặc NV
        IF @MaKH IS NOT NULL AND NOT EXISTS (SELECT 1 FROM KHACHHANG WHERE MaKH = @MaKH)
        BEGIN
            RAISERROR(N'Mã khách hàng không tồn tại.', 16, 1);
            RETURN;
        END;
        IF @MaNV IS NOT NULL AND NOT EXISTS (SELECT 1 FROM NHANVIEN WHERE MaNV = @MaNV)
        BEGIN
            RAISERROR(N'Mã nhân viên không tồn tại.', 16, 1);
            RETURN;
        END;

        INSERT INTO TAIKHOAN (TenDangNhap, MatKhauHash, LoaiTK, MaKH, MaNV, NgayTao, TrangThai)
        VALUES (@TenDangNhap, @MatKhauHash, @LoaiTK, @MaKH, @MaNV, GETDATE(), @TrangThai);

        PRINT N'Thêm tài khoản thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi thêm tài khoản: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


/*Sửa tài khoản */
CREATE OR ALTER PROCEDURE SP_Sua_TaiKhoan
    @MaTK INT,
    @TenDangNhap VARCHAR(100),
    @MatKhauHash VARBINARY(256),
    @LoaiTK NVARCHAR(20),
    @MaKH INT = NULL,
    @MaNV INT = NULL,
    @TrangThai NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        --Kiểm tra tồn tại tài khoản
        IF NOT EXISTS (SELECT 1 FROM TAIKHOAN WHERE MaTK = @MaTK)
        BEGIN
            RAISERROR(N'Không tìm thấy tài khoản cần sửa.', 16, 1);
            RETURN;
        END;

        --Kiểm tra trùng tên đăng nhập
        IF EXISTS (SELECT 1 FROM TAIKHOAN WHERE TenDangNhap = @TenDangNhap AND MaTK <> @MaTK)
        BEGIN
            RAISERROR(N'Tên đăng nhập đã tồn tại ở tài khoản khác.', 16, 1);
            RETURN;
        END;

        --Kiểm tra loại tài khoản hợp lệ
        IF @LoaiTK NOT IN (N'KH', N'NV')
        BEGIN
            RAISERROR(N'Loại tài khoản không hợp lệ.', 16, 1);
            RETURN;
        END;

        --Kiểm tra ràng buộc loại tài khoản
        IF @LoaiTK = N'KH' AND @MaKH IS NULL
        BEGIN
            RAISERROR(N'Tài khoản KH phải có mã khách hàng.', 16, 1);
            RETURN;
        END;
        IF @LoaiTK = N'NV' AND @MaNV IS NULL
        BEGIN
            RAISERROR(N'Tài khoản NV phải có mã nhân viên.', 16, 1);
            RETURN;
        END;

        --Kiểm tra tồn tại khách hàng hoặc nhân viên
        IF @MaKH IS NOT NULL AND NOT EXISTS (SELECT 1 FROM KHACHHANG WHERE MaKH = @MaKH)
        BEGIN
            RAISERROR(N'Mã khách hàng không tồn tại.', 16, 1);
            RETURN;
        END;
        IF @MaNV IS NOT NULL AND NOT EXISTS (SELECT 1 FROM NHANVIEN WHERE MaNV = @MaNV)
        BEGIN
            RAISERROR(N'Mã nhân viên không tồn tại.', 16, 1);
            RETURN;
        END;

        UPDATE TAIKHOAN
        SET TenDangNhap = @TenDangNhap,
            MatKhauHash = @MatKhauHash,
            LoaiTK = @LoaiTK,
            MaKH = @MaKH,
            MaNV = @MaNV,
            TrangThai = @TrangThai
        WHERE MaTK = @MaTK;

        PRINT N'Cập nhật tài khoản thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi sửa tài khoản: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


/*Xóa tài khoản */
CREATE OR ALTER PROCEDURE SP_Xoa_TaiKhoan
    @MaTK INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        --Kiểm tra tồn tại
        IF NOT EXISTS (SELECT 1 FROM TAIKHOAN WHERE MaTK = @MaTK)
        BEGIN
            RAISERROR(N'Không tìm thấy tài khoản cần xóa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra có lịch sử truy cập (nếu có)
        IF EXISTS (SELECT 1 FROM LICHSU_TRUY_CAP WHERE MaTK = @MaTK)
        BEGIN
            RAISERROR(N'Không thể xóa tài khoản vì đã có lịch sử truy cập.', 16, 1);
            RETURN;
        END;

        DELETE FROM TAIKHOAN WHERE MaTK = @MaTK;

        PRINT N'Xóa tài khoản thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi xóa tài khoản: ' + ERROR_MESSAGE();
    END CATCH
END;
GO



/* =========================================================
   PHẦN 3.1 — HÌNH THỨC THANH TOÁN (HINHTHUC_THANHTOAN)
   Giả định cột: MaHT (PK), TenHT, MoTa
   ========================================================= */
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


/* =========================================================
   PHẦN 3.2 — THANHTOANPHI
   Cấu trúc đã cho: MaTT (ID), MaHD, NgayTT, SoTien, MaHT, MaNV_Thu, TrangThai, MaGiaoDich (UNIQUE)
   ========================================================= */ 
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


/* =========================================================
   PHẦN 3.3 — KHUYENMAI
   Giả định cột: MaKM (PK), TenKM, GiaTriKM (DECIMAL), NgayBatDau, NgayKetThuc, GhiChu
   ========================================================= */
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


/* =========================================================
   PHẦN 3.4 — HỢP ĐỒNG (HOPDONG)
   Cột đã dùng: MaHD, MaKH, MaGoi, MaNV_TuVan, MaSoHD, NgayKy, NgayHieuLuc, NgayHetHan, TrangThai, GhiChu
   ========================================================= */
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


/* =========================================================
   PHẦN 3.5 — HOPDONG_KHUYENMAI (bảng liên kết n-n)
   Cột: MaHD, MaKM
   ========================================================= */
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


/* =========================================================
   PHẦN 3.6 — TÌNH TRẠNG YÊU CẦU (TINHTRANG_YEUCAU)
   Cột: MaTT (PK), TenTT, MoTa
   ========================================================= */

CREATE PROCEDURE SP_Them_TinhTrangYeuCau
    @TenTT NVARCHAR(100),
    @MoTa NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra trùng tên tình trạng
        IF EXISTS (SELECT 1 FROM TINHTRANG_YEUCAU WHERE TenTT = @TenTT)
        BEGIN
            RAISERROR(N'Tên tình trạng yêu cầu đã tồn tại.', 16, 1);
            RETURN;
        END;

        INSERT INTO TINHTRANG_YEUCAU (TenTT, MoTa)
        VALUES (@TenTT, @MoTa);

        PRINT N'Thêm tình trạng yêu cầu thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi thêm tình trạng yêu cầu: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
--Sửa
CREATE PROCEDURE SP_Sua_TinhTrangYeuCau
    @MaTT INT,
    @TenTT NVARCHAR(100),
    @MoTa NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra tồn tại mã cần sửa
        IF NOT EXISTS (SELECT 1 FROM TINHTRANG_YEUCAU WHERE MaTT = @MaTT)
        BEGIN
            RAISERROR(N'Không tìm thấy tình trạng yêu cầu cần sửa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra trùng tên với bản ghi khác
        IF EXISTS (SELECT 1 FROM TINHTRANG_YEUCAU WHERE TenTT = @TenTT AND MaTT <> @MaTT)
        BEGIN
            RAISERROR(N'Tên tình trạng yêu cầu đã tồn tại ở bản ghi khác.', 16, 1);
            RETURN;
        END;

        UPDATE TINHTRANG_YEUCAU
        SET TenTT = @TenTT,
            MoTa = @MoTa
        WHERE MaTT = @MaTT;

        PRINT N'Cập nhật tình trạng yêu cầu thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi sửa tình trạng yêu cầu: ' + ERROR_MESSAGE();
    END CATCH
END;
GO
--Xóa
CREATE PROCEDURE SP_Xoa_TinhTrangYeuCau
    @MaTT INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Kiểm tra tồn tại mã cần xóa
        IF NOT EXISTS (SELECT 1 FROM TINHTRANG_YEUCAU WHERE MaTT = @MaTT)
        BEGIN
            RAISERROR(N'Không tìm thấy tình trạng yêu cầu cần xóa.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra có đang được sử dụng trong bảng YEUCAUBOITHUONG không
        IF EXISTS (SELECT 1 FROM YEUCAUBOITHUONG WHERE MaTT_TrangThai = @MaTT)
        BEGIN
            RAISERROR(N'Không thể xóa tình trạng này vì đang được sử dụng trong bảng YEUCAUBOITHUONG.', 16, 1);
            RETURN;
        END;

        DELETE FROM TINHTRANG_YEUCAU WHERE MaTT = @MaTT;

        PRINT N'Xóa tình trạng yêu cầu thành công!';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi xóa tình trạng yêu cầu: ' + ERROR_MESSAGE();
    END CATCH
END;
GO


/* =========================================================
   PHẦN 3.8 — CHI TRẢ BỒI THƯỜNG (CHITRABOITHUONG)
   Cột đã cho: MaCT (ID), MaYC, NgayChiTra, SoTienChi, HinhThucChi, TrangThai, MaNV_Chi, GhiChu
   ========================================================= */
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
-- Không cung cấp thủ tục Xóa cho CHITRABOITHUONG (nghiệp vụ tài chính).
/* =========================================================
   PHẦN 4 — LỊCH SỬ TRUY CẬP (LICHSU_TRUY_CAP)
   Cột: MaLS, MaTK, ThoiGian, HanhDong, MoTa, DiaChiIP
   ========================================================= */
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

--

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
>>>>>>> 59c5acf48653319ce8c913c2014f62e09ddfb835
