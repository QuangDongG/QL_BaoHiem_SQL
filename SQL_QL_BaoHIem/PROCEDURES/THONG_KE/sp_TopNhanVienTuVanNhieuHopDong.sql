CREATE OR ALTER PROCEDURE sp_TopNhanVienTuVanNhieuHopDong
    @TopN INT = 10
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF @TopN <= 0
        BEGIN
             RAISERROR(N'Số lượng top phải là số dương.', 16, 1);
            RETURN;
        END

        SELECT TOP (@TopN)
            nv.MaNV,
            nv.HoTen,
            nv.Email,
            pb.TenPhong,
            COUNT(hd.MaHD) AS SoLuongHopDongTuVan
        FROM NHANVIEN nv
        LEFT JOIN HOPDONG hd ON nv.MaNV = hd.MaNV_TuVan
        LEFT JOIN PHONGBAN pb ON nv.MaPhong = pb.MaPhong
        GROUP BY nv.MaNV, nv.HoTen, nv.Email, pb.TenPhong
        ORDER BY SoLuongHopDongTuVan DESC;
    END TRY
    BEGIN CATCH
         PRINT N'Lỗi khi thống kê top nhân viên tư vấn: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- 15. Test sp_TopNhanVienTuVanNhieuHopDong
PRINT N'--- Test sp_TopNhanVienTuVanNhieuHopDong ---';
-- Top 10 (mặc định)
EXEC sp_TopNhanVienTuVanNhieuHopDong;
-- Top 3
EXEC sp_TopNhanVienTuVanNhieuHopDong @TopN = 3;
GO
