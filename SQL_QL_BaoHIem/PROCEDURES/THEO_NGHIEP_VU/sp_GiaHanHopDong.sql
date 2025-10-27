CREATE OR ALTER PROCEDURE sp_GiaHanHopDong
    @MaHD INT,
    @SoThangGiaHan INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DECLARE @NgayHetHanCu DATE;
        DECLARE @TrangThaiHienTai NVARCHAR(30);

        -- Kiểm tra hợp đồng tồn tại và số tháng hợp lệ
        IF @SoThangGiaHan <= 0
        BEGIN
            RAISERROR(N'Số tháng gia hạn phải lớn hơn 0.', 16, 1);
            RETURN;
        END

        SELECT @NgayHetHanCu = NgayHetHan, @TrangThaiHienTai = TrangThai
        FROM HOPDONG WHERE MaHD = @MaHD;

        IF @NgayHetHanCu IS NULL
        BEGIN
            RAISERROR(N'Không tìm thấy hợp đồng cần gia hạn.', 16, 1);
            RETURN;
        END

        -- Chỉ cho phép gia hạn hợp đồng sắp hết hạn hoặc đang hiệu lực
        IF @TrangThaiHienTai NOT IN (N'Hiệu lực', N'Hết hạn') -- Có thể thêm các trạng thái khác nếu muốn
        BEGIN
             RAISERROR(N'Chỉ có thể gia hạn hợp đồng đang "Hiệu lực" hoặc đã "Hết hạn".', 16, 1);
            RETURN;
        END

        DECLARE @NgayHetHanMoi DATE = DATEADD(MONTH, @SoThangGiaHan, @NgayHetHanCu);

        -- Cập nhật ngày hết hạn và trạng thái thành 'Hiệu lực'
        UPDATE HOPDONG
        SET NgayHetHan = @NgayHetHanMoi,
            TrangThai = N'Hiệu lực' -- Chuyển lại thành hiệu lực nếu đã hết hạn
        WHERE MaHD = @MaHD;

        PRINT N'Gia hạn hợp đồng ' + CAST(@MaHD AS VARCHAR) + N' thành công. Ngày hết hạn mới: ' + CONVERT(VARCHAR, @NgayHetHanMoi, 103);

    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi gia hạn hợp đồng: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- 6. Test sp_GiaHanHopDong
-- Chọn 1 MaHD để test (ví dụ HĐ đã hết hạn)
DECLARE @MaHDTestGiaHan INT = (SELECT TOP 1 MaHD FROM HOPDONG WHERE TrangThai = N'Hết hạn');
-- Xem trạng thái và ngày hết hạn cũ
SELECT MaHD, TrangThai, NgayHetHan AS NgayHetHanCu FROM HOPDONG WHERE MaHD = @MaHDTestGiaHan;
-- TH thành công: Gia hạn 12 tháng
EXEC sp_GiaHanHopDong @MaHD = @MaHDTestGiaHan, @SoThangGiaHan = 12;
-- Xem trạng thái và ngày hết hạn mới
SELECT MaHD, TrangThai, NgayHetHan AS NgayHetHanMoi FROM HOPDONG WHERE MaHD = @MaHDTestGiaHan; -- Dự kiến TrangThai = 'Hiệu lực', NgayHetHan tăng 12 tháng
-- TH lỗi: Số tháng âm
EXEC sp_GiaHanHopDong @MaHD = @MaHDTestGiaHan, @SoThangGiaHan = -6; -- Dự kiến lỗi RAISERROR
-- TH lỗi: HĐ không tồn tại
EXEC sp_GiaHanHopDong @MaHD = 9999, @SoThangGiaHan = 12; -- Dự kiến lỗi RAISERROR
-- TH lỗi: HĐ đã hủy (Nếu có trạng thái Hủy)
-- Giả sử cập nhật 1 HĐ thành Hủy để test
-- UPDATE HOPDONG SET TrangThai = N'Huỷ' WHERE MaHD = <MaHD_Khac>;
-- EXEC sp_GiaHanHopDong @MaHD = <MaHD_Khac>, @SoThangGiaHan = 12; -- Dự kiến lỗi RAISERROR
GO