CREATE OR ALTER PROCEDURE sp_LietKeThanhToanChuaXuLy
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SELECT
            tt.MaTT AS MaThanhToan,
            hd.MaSoHD,
            kh.HoTen AS TenKhachHang,
            tt.NgayTT,
            tt.SoTien,
            ht.TenHT AS HinhThucThanhToan,
            tt.TrangThai,
            tt.MaGiaoDich
        FROM THANHTOANPHI tt
        JOIN HOPDONG hd ON tt.MaHD = hd.MaHD
        JOIN KHACHHANG kh ON hd.MaKH = kh.MaKH
        JOIN HINHTHUC_THANHTOAN ht ON tt.MaHT = ht.MaHT
        WHERE tt.TrangThai = N'Đang xử lý'
        ORDER BY tt.NgayTT;
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi khi liệt kê thanh toán chưa xử lý: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- Test sp_LietKeThanhToanChuaXuLy
PRINT N'--- Test sp_LietKeThanhToanChuaXuLy ---';
EXEC sp_LietKeThanhToanChuaXuLy;
GO