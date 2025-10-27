CREATE OR ALTER PROCEDURE sp_CapNhatTrangThaiHopDongHetHan
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DECLARE @RowsAffected INT = 0;

        UPDATE HOPDONG
        SET TrangThai = N'Hết hạn'
        WHERE NgayHetHan < GETDATE() AND TrangThai = N'Hiệu lực'; -- Chỉ cập nhật HĐ đang hiệu lực

        SET @RowsAffected = @@ROWCOUNT;

        PRINT N'Đã cập nhật trạng thái "Hết hạn" cho ' + CAST(@RowsAffected AS VARCHAR) + N' hợp đồng.';
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi cập nhật trạng thái hợp đồng hết hạn: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Test sp_CapNhatTrangThaiHopDongHetHan
PRINT N'--- Test sp_CapNhatTrangThaiHopDongHetHan ---';
SELECT COUNT(*) AS SoHDHieuLucQuaHan_Truoc FROM HOPDONG WHERE TrangThai = N'Hiệu lực' AND NgayHetHan < GETDATE();
EXEC sp_CapNhatTrangThaiHopDongHetHan;
SELECT COUNT(*) AS SoHDHieuLucQuaHan_Sau FROM HOPDONG WHERE TrangThai = N'Hiệu lực' AND NgayHetHan < GETDATE(); -- Dự kiến = 0
SELECT MaHD, MaSoHD, TrangThai FROM HOPDONG WHERE TrangThai = N'Hết hạn' AND NgayHetHan < GETDATE() AND MaHD IN (SELECT TOP 5 MaHD FROM HOPDONG WHERE TrangThai = N'Hết hạn' AND NgayHetHan < GETDATE() ORDER BY NgayHetHan DESC); -- Xem vài HĐ ví dụ
GO