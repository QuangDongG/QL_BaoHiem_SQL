-- 14. Tạo bảng Log Lương (nếu chưa có) và Trigger ghi log thay đổi lương nhân viên
-- Tạo bảng Log trước (chỉ chạy 1 lần)
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOG_LUONG_NHANVIEN]') AND type in (N'U'))
BEGIN
CREATE TABLE LOG_LUONG_NHANVIEN(
    MaLog INT IDENTITY(1,1) PRIMARY KEY,
    MaNV INT NOT NULL,
    NgayCapNhat DATETIME2 DEFAULT SYSDATETIME(),
    LuongCu DECIMAL(18,2),
    LuongMoi DECIMAL(18,2),
    NguoiCapNhat NVARCHAR(100) DEFAULT SUSER_SNAME(), -- Lấy user SQL thực hiện
    FOREIGN KEY (MaNV) REFERENCES NHANVIEN(MaNV) ON DELETE CASCADE -- Hoặc SET NULL tùy nghiệp vụ
);
PRINT N'Đã tạo bảng LOG_LUONG_NHANVIEN.'
END
GO

CREATE OR ALTER TRIGGER trg_GhiLogThayDoiLuongNhanVien
ON NHANVIEN
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Chỉ thực hiện nếu cột Luong được cập nhật
    IF UPDATE(Luong)
    BEGIN
        BEGIN TRY
            INSERT INTO LOG_LUONG_NHANVIEN (MaNV, LuongCu, LuongMoi)
            SELECT
                i.MaNV,
                d.Luong, -- Lương cũ từ bảng 'deleted'
                i.Luong  -- Lương mới từ bảng 'inserted'
            FROM
                inserted i
            JOIN
                deleted d ON i.MaNV = d.MaNV
            WHERE
                i.Luong <> d.Luong; -- Chỉ ghi log nếu lương thực sự thay đổi
        END TRY
        BEGIN CATCH
            -- Ghi lỗi vào hệ thống log của SQL Server hoặc bảng log lỗi riêng nếu có
             DECLARE @ErrorMessage NVARCHAR(MAX) = ERROR_MESSAGE();
             DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
             DECLARE @ErrorState INT = ERROR_STATE();
             RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
             -- Cân nhắc có nên rollback không, tùy thuộc việc ghi log có quan trọng hơn việc cập nhật lương hay không
             -- IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        END CATCH
    END
END;
GO

-- 14. Test trg_GhiLogThayDoiLuongNhanVien
PRINT N'--- Test trg_GhiLogThayDoiLuongNhanVien ---';
DECLARE @MaNVTestLuong INT = 1;
DECLARE @LuongCu DECIMAL(18,2);
DECLARE @LuongMoi DECIMAL(18,2) = 20000000.00;
SELECT @LuongCu = Luong FROM NHANVIEN WHERE MaNV = @MaNVTestLuong;
PRINT N'Lương cũ NV ' + CAST(@MaNVTestLuong AS VARCHAR) + N': ' + FORMAT(@LuongCu, 'N', 'vi-VN');
-- Cập nhật lương
UPDATE NHANVIEN SET Luong = @LuongMoi WHERE MaNV = @MaNVTestLuong;
PRINT N'Đã cập nhật lương NV ' + CAST(@MaNVTestLuong AS VARCHAR) + N' thành: ' + FORMAT(@LuongMoi, 'N', 'vi-VN');
-- Kiểm tra Log
SELECT TOP 1 * FROM LOG_LUONG_NHANVIEN WHERE MaNV = @MaNVTestLuong ORDER BY NgayCapNhat DESC;
-- Cập nhật lại lương cũ để hoàn tác test
UPDATE NHANVIEN SET Luong = @LuongCu WHERE MaNV = @MaNVTestLuong;
PRINT N'Hoàn tác lương NV ' + CAST(@MaNVTestLuong AS VARCHAR) + N' về: ' + FORMAT(@LuongCu, 'N', 'vi-VN');
-- Kiểm tra Log lần nữa
SELECT TOP 2 * FROM LOG_LUONG_NHANVIEN WHERE MaNV = @MaNVTestLuong ORDER BY NgayCapNhat DESC;
-- Cập nhật cột khác (không phải lương)
UPDATE NHANVIEN SET ChucVu = N'Test Chức Vụ' WHERE MaNV = @MaNVTestLuong;
PRINT N'Đã cập nhật chức vụ NV ' + CAST(@MaNVTestLuong AS VARCHAR);
-- Kiểm tra log (không nên có bản ghi mới)
SELECT TOP 1 * FROM LOG_LUONG_NHANVIEN WHERE MaNV = @MaNVTestLuong ORDER BY NgayCapNhat DESC;
-- Hoàn tác chức vụ
UPDATE NHANVIEN SET ChucVu = (SELECT TOP 1 ChucVu FROM NHANVIEN WHERE MaNV = @MaNVTestLuong) WHERE MaNV = @MaNVTestLuong;
GO