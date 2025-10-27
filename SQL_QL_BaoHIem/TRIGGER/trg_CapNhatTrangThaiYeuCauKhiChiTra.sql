CREATE OR ALTER TRIGGER trg_CapNhatTrangThaiYeuCauKhiChiTra
ON CHITRABOITHUONG
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DECLARE @MaTrangThaiDaChiTra INT;

        -- Lấy mã trạng thái 'Đã chi trả'
        SELECT @MaTrangThaiDaChiTra = MaTT FROM TINHTRANG_YEUCAU WHERE TenTT = N'Đã chi trả';

        IF @MaTrangThaiDaChiTra IS NOT NULL
        BEGIN
            UPDATE YEUCAUBOITHUONG
            SET MaTT_TrangThai = @MaTrangThaiDaChiTra
            WHERE MaYC IN (SELECT MaYC FROM inserted)
              AND MaTT_TrangThai <> @MaTrangThaiDaChiTra; -- Chỉ cập nhật nếu trạng thái chưa phải là 'Đã chi trả'
        END
        ELSE
        BEGIN
            -- Ghi log hoặc thông báo nếu không tìm thấy trạng thái 'Đã chi trả'
            PRINT N'Cảnh báo: Không tìm thấy mã trạng thái "Đã chi trả" trong bảng TINHTRANG_YEUCAU.';
        END
    END TRY
    BEGIN CATCH
        -- Ghi log lỗi, không nên rollback vì việc chi trả đã xảy ra
         DECLARE @ErrorMessage NVARCHAR(MAX) = ERROR_MESSAGE();
         PRINT N'Lỗi trong trigger trg_CapNhatTrangThaiYeuCauKhiChiTra: ' + @ErrorMessage;
         -- Có thể ghi lỗi vào bảng log lỗi chuyên dụng
    END CATCH
END;
GO

-- 15. Test trg_CapNhatTrangThaiYeuCauKhiChiTra
PRINT N'--- Test trg_CapNhatTrangThaiYeuCauKhiChiTra ---';
-- Chọn 1 yêu cầu chưa được chi trả (ví dụ MaYC=1, giả sử trạng thái đang là 'Đang xử lý')
DECLARE @MaYCTestChiTra INT = 1;
DECLARE @MaTrangThaiTruoc INT;
SELECT @MaTrangThaiTruoc = MaTT_TrangThai FROM YEUCAUBOITHUONG WHERE MaYC = @MaYCTestChiTra;
PRINT N'Trạng thái trước khi chi trả của YC ' + CAST(@MaYCTestChiTra AS VARCHAR) + N': ' + ISNULL(CAST(@MaTrangThaiTruoc AS VARCHAR), 'NULL');
-- Thực hiện INSERT chi trả
INSERT INTO CHITRABOITHUONG (MaYC, NgayChiTra, SoTienChi, HinhThucChi, MaNV_Chi)
VALUES (@MaYCTestChiTra, GETDATE(), 10000000.00, N'Chuyển khoản', 80); -- Giả sử NV 80 thực hiện
DECLARE @MaCTMoi INT = SCOPE_IDENTITY();
PRINT N'Đã INSERT chi trả mới (MaCT=' + CAST(@MaCTMoi AS VARCHAR) + N') cho YC ' + CAST(@MaYCTestChiTra AS VARCHAR);
-- Kiểm tra trạng thái yêu cầu sau khi chi trả
DECLARE @MaTrangThaiSau INT;
DECLARE @TenTrangThaiSau NVARCHAR(100);
SELECT @MaTrangThaiSau = yc.MaTT_TrangThai, @TenTrangThaiSau = tt.TenTT
FROM YEUCAUBOITHUONG yc JOIN TINHTRANG_YEUCAU tt ON yc.MaTT_TrangThai = tt.MaTT
WHERE yc.MaYC = @MaYCTestChiTra;
PRINT N'Trạng thái sau khi chi trả của YC ' + CAST(@MaYCTestChiTra AS VARCHAR) + N': ' + ISNULL(CAST(@MaTrangThaiSau AS VARCHAR), 'NULL') + N' (' + ISNULL(@TenTrangThaiSau, 'NULL') + N')'; -- Dự kiến là trạng thái 'Đã chi trả'
-- Xóa bản ghi chi trả test
DELETE FROM CHITRABOITHUONG WHERE MaCT = @MaCTMoi;
-- Khôi phục trạng thái YC (nếu cần)
UPDATE YEUCAUBOITHUONG SET MaTT_TrangThai = @MaTrangThaiTruoc WHERE MaYC = @MaYCTestChiTra;
GO