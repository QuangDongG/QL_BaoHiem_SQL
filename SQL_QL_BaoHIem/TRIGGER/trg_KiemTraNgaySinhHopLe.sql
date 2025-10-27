CREATE OR ALTER TRIGGER trg_KiemTraNgaySinhHopLe_KH_NV
ON KHACHHANG -- Trigger này áp dụng cho KHACHHANG
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF UPDATE(NgaySinh) -- Chỉ kiểm tra nếu cột NgaySinh được cập nhật hoặc khi INSERT
    BEGIN
        IF EXISTS (SELECT 1 FROM inserted WHERE NgaySinh > GETDATE())
        BEGIN
            ROLLBACK TRANSACTION;
            DECLARE @MaKH_Loi INT = (SELECT TOP 1 MaKH FROM inserted WHERE NgaySinh > GETDATE());
             DECLARE @ErrorMessage NVARCHAR(200) = N'Lỗi tại khách hàng ' + ISNULL(CAST(@MaKH_Loi AS VARCHAR),'mới') + N': Ngày sinh không được ở tương lai.';
            THROW 51005, @ErrorMessage, 1;
            RETURN;
        END
    END
END;
GO

-- Tạo trigger tương tự cho bảng NHANVIEN
CREATE OR ALTER TRIGGER trg_KiemTraNgaySinhHopLe_NV
ON NHANVIEN
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF UPDATE(NgaySinh)
    BEGIN
        IF EXISTS (SELECT 1 FROM inserted WHERE NgaySinh > GETDATE())
        BEGIN
            ROLLBACK TRANSACTION;
            DECLARE @MaNV_Loi INT = (SELECT TOP 1 MaNV FROM inserted WHERE NgaySinh > GETDATE());
            DECLARE @ErrorMessage NVARCHAR(200) = N'Lỗi tại nhân viên ' + ISNULL(CAST(@MaNV_Loi AS VARCHAR),'mới') + N': Ngày sinh không được ở tương lai.';
            THROW 51006, @ErrorMessage, 1;
            RETURN;
        END
    END
END;
GO

-- 18. Test trg_KiemTraNgaySinhHopLe_KH_NV / trg_KiemTraNgaySinhHopLe_NV
PRINT N'--- Test trg_KiemTraNgaySinhHopLe_KH_NV / trg_KiemTraNgaySinhHopLe_NV ---';
-- Test lỗi với KHACHHANG
BEGIN TRY
    PRINT N'Thử INSERT KH với ngày sinh tương lai';
    INSERT INTO KHACHHANG(HoTen, NgaySinh, GioiTinh, CCCD, DiaChi, SDT, Email)
    VALUES (N'KH Lỗi Ngày Sinh', DATEADD(YEAR, 1, GETDATE()), N'Khác', '000000000000', N'Test', '000', 'loingaysinh@email.com');
    PRINT N'LỖI LOGIC: Lẽ ra phải báo lỗi ngày sinh KH!';
END TRY
BEGIN CATCH
    PRINT N'Thành công (KH): Đã bắt lỗi ngày sinh tương lai: ' + ERROR_MESSAGE();
END CATCH;
-- Test lỗi với NHANVIEN
BEGIN TRY
     PRINT N'Thử INSERT NV với ngày sinh tương lai';
    INSERT INTO NHANVIEN (HoTen, NgaySinh, MaPhong)
    VALUES (N'NV Lỗi Ngày Sinh', DATEADD(DAY, 1, GETDATE()), 1);
     PRINT N'LỖI LOGIC: Lẽ ra phải báo lỗi ngày sinh NV!';
END TRY
BEGIN CATCH
    PRINT N'Thành công (NV): Đã bắt lỗi ngày sinh tương lai: ' + ERROR_MESSAGE();
END CATCH;
GO