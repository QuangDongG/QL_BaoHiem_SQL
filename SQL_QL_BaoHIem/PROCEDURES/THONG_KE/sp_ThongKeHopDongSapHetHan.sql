CREATE OR ALTER PROCEDURE sp_ThongKeHopDongSapHetHan
    @SoNgay INT = 30 -- Mặc định là 30 ngày tới
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF @SoNgay < 0
        BEGIN
            RAISERROR(N'Số ngày phải là số không âm.', 16, 1);
            RETURN;
        END

        DECLARE @NgayCanhBao DATE = DATEADD(DAY, @SoNgay, GETDATE());

        SELECT
            hd.MaHD,
            hd.MaSoHD,
            kh.HoTen AS TenKhachHang,
            gbh.TenGoi AS TenGoiBaoHiem,
            hd.NgayHetHan,
            DATEDIFF(DAY, GETDATE(), hd.NgayHetHan) AS SoNgayConLai
        FROM HOPDONG hd
        JOIN KHACHHANG kh ON hd.MaKH = kh.MaKH
        JOIN GOIBAOHIEM gbh ON hd.MaGoi = gbh.MaGoi
        WHERE hd.TrangThai = N'Hiệu lực'
          AND hd.NgayHetHan BETWEEN GETDATE() AND @NgayCanhBao
        ORDER BY hd.NgayHetHan ASC;
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi thống kê hợp đồng sắp hết hạn: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- 16. Test sp_ThongKeHopDongSapHetHan
PRINT N'--- Test sp_ThongKeHopDongSapHetHan ---';
-- 30 ngày tới (mặc định)
EXEC sp_ThongKeHopDongSapHetHan;
-- 90 ngày tới
EXEC sp_ThongKeHopDongSapHetHan @SoNgay = 90;
GO