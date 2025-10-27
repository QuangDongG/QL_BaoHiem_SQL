CREATE OR ALTER FUNCTION fn_TongPhiDaThanhToan (@MaKhachHang INT)
RETURNS DECIMAL(18, 2)
AS
BEGIN
    DECLARE @TongPhi DECIMAL(18, 2);

    SELECT @TongPhi = SUM(ISNULL(tt.SoTien, 0))
    FROM HOPDONG hd
    JOIN THANHTOANPHI tt ON hd.MaHD = tt.MaHD
    WHERE hd.MaKH = @MaKhachHang AND tt.TrangThai = N'Đã nhận';

    RETURN ISNULL(@TongPhi, 0); -- Trả về 0 nếu chưa có thanh toán nào được ghi nhận
END;
GO

-- 2. Test fn_TongPhiDaThanhToan
-- Giả sử KH 1 có thanh toán, KH 10000000 không có hoặc không tồn tại
SELECT dbo.fn_TongPhiDaThanhToan(1) AS TongPhiKH1;
SELECT dbo.fn_TongPhiDaThanhToan(10000000) AS TongPhiKH10000000; -- Dự kiến trả về 0
GO