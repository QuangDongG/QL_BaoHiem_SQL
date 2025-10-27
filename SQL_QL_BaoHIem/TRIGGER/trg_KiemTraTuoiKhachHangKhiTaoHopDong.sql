CREATE OR ALTER TRIGGER trg_KiemTraTuoiKhachHangKhiTaoHopDong
ON HOPDONG
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @MaKH INT, @MaGoi INT, @NgayKy DATE, @TuoiKH INT, @DieuKienTuoi NVARCHAR(255);
    DECLARE @TuoiMin INT, @TuoiMax INT;

    SELECT @MaKH = i.MaKH, @MaGoi = i.MaGoi, @NgayKy = i.NgayKy
    FROM inserted i;

    -- Sử dụng hàm đã tạo
    SELECT @TuoiKH = dbo.fn_TinhTuoi(NgaySinh)
    FROM KHACHHANG
    WHERE MaKH = @MaKH;

    SELECT @DieuKienTuoi = DieuKien
    FROM GOIBAOHIEM
    WHERE MaGoi = @MaGoi;

    BEGIN TRY
        SET @DieuKienTuoi = REPLACE(@DieuKienTuoi, N' tuổi', '');
        DECLARE @DashPos INT = CHARINDEX(N'–', @DieuKienTuoi);
        IF @DashPos = 0 SET @DashPos = CHARINDEX('-', @DieuKienTuoi);

        IF @DashPos > 0 AND ISNUMERIC(LTRIM(RTRIM(SUBSTRING(@DieuKienTuoi, 1, @DashPos - 1)))) = 1 AND ISNUMERIC(LTRIM(RTRIM(SUBSTRING(@DieuKienTuoi, @DashPos + 1, LEN(@DieuKienTuoi))))) = 1
        BEGIN
            SET @TuoiMin = CAST(LTRIM(RTRIM(SUBSTRING(@DieuKienTuoi, 1, @DashPos - 1))) AS INT);
            SET @TuoiMax = CAST(LTRIM(RTRIM(SUBSTRING(@DieuKienTuoi, @DashPos + 1, LEN(@DieuKienTuoi)))) AS INT);

            IF @TuoiKH < @TuoiMin OR @TuoiKH > @TuoiMax
            BEGIN
                ROLLBACK TRANSACTION;
                DECLARE @ErrorMessage NVARCHAR(200) = N'Khách hàng ' + CAST(@MaKH AS VARCHAR) + N' (' + CAST(@TuoiKH AS VARCHAR) + N' tuổi) không đủ điều kiện tuổi (' + @DieuKienTuoi + N') cho gói bảo hiểm này.';
                THROW 51000, @ErrorMessage, 1;
                RETURN;
            END
        END
        -- Else: Không có điều kiện tuổi rõ ràng dạng số-số hoặc không parse được, bỏ qua kiểm tra này
    END TRY
    BEGIN CATCH
         IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
         THROW 51001, N'Lỗi xử lý trigger kiểm tra tuổi.', 1;
         RETURN;
    END CATCH
END;
GO

-- 12. Test trg_KiemTraTuoiKhachHangKhiTaoHopDong
PRINT N'--- Test trg_KiemTraTuoiKhachHangKhiTaoHopDong ---';
BEGIN TRY
    -- Chọn KH có tuổi không phù hợp với Gói 1 (18-60)
    DECLARE @MaKHKhongHopTuoi INT = (SELECT TOP 1 MaKH FROM KHACHHANG WHERE dbo.fn_TinhTuoi(NgaySinh) < 18 OR dbo.fn_TinhTuoi(NgaySinh) > 60);
    DECLARE @MaGoi1 INT = 1;
    IF @MaKHKhongHopTuoi IS NOT NULL
    BEGIN
        PRINT N'Thử INSERT HĐ với KH ' + CAST(@MaKHKhongHopTuoi AS VARCHAR) + N' (tuổi không hợp lệ) cho Gói ' + CAST(@MaGoi1 AS VARCHAR);
        INSERT INTO HOPDONG (MaKH, MaGoi, MaNV_TuVan, MaSoHD, NgayKy, NgayHieuLuc, NgayHetHan, TrangThai)
        VALUES (@MaKHKhongHopTuoi, @MaGoi1, 1, 'HD-TEST-AGEFAIL', GETDATE(), GETDATE()+1, DATEADD(year, 1, GETDATE()), N'Hiệu lực');
        PRINT N'LỖI LOGIC: Lẽ ra phải báo lỗi tuổi!'; -- Sẽ không chạy đến đây nếu trigger hoạt động
    END
    ELSE
    BEGIN
        PRINT N'Không tìm thấy KH có tuổi không phù hợp để test trigger lỗi.';
    END
END TRY
BEGIN CATCH
    PRINT N'Thành công: Đã bắt lỗi từ trigger tuổi không hợp lệ: ' + ERROR_MESSAGE();
END CATCH;
-- TH thành công: Chọn KH phù hợp tuổi
DECLARE @MaKHHopTuoi INT = (SELECT TOP 1 MaKH FROM KHACHHANG WHERE dbo.fn_TinhTuoi(NgaySinh) BETWEEN 18 AND 60);
IF @MaKHHopTuoi IS NOT NULL
BEGIN
    INSERT INTO HOPDONG (MaKH, MaGoi, MaNV_TuVan, MaSoHD, NgayKy, NgayHieuLuc, NgayHetHan, TrangThai)
    VALUES (@MaKHHopTuoi, 1, 1, 'HD-TEST-AGESUCCESS', GETDATE(), GETDATE()+1, DATEADD(year, 1, GETDATE()), N'Hiệu lực');
    PRINT N'Thành công: Đã INSERT HĐ với KH ' + CAST(@MaKHHopTuoi AS VARCHAR) + N' (tuổi hợp lệ).';
    -- Xóa bản ghi test
    DELETE FROM HOPDONG WHERE MaSoHD = 'HD-TEST-AGESUCCESS';
END
ELSE
BEGIN
     PRINT N'Không tìm thấy KH có tuổi phù hợp để test trigger thành công.';
END
GO