CREATE OR ALTER FUNCTION fn_KiemTraHopDongConHan (@MaHD INT)
RETURNS INT
AS
BEGIN
    DECLARE @TrangThai NVARCHAR(30);
    DECLARE @NgayHetHan DATE;

    SELECT @TrangThai = TrangThai, @NgayHetHan = NgayHetHan
    FROM HOPDONG
    WHERE MaHD = @MaHD;

    IF @TrangThai IS NULL OR @NgayHetHan IS NULL
        RETURN NULL;

    IF @TrangThai = N'Hiệu lực' AND @NgayHetHan >= GETDATE()
        RETURN 1;

    RETURN 0;
END;
GO


-- Test fn_KiemTraHopDongConHan
-- Chọn 1 MaHD đang hiệu lực, 1 đã hết hạn, và 1 không tồn tại
DECLARE @MaHDHieuLuc INT = (SELECT TOP 1 MaHD FROM HOPDONG WHERE TrangThai = N'Hiệu lực' AND NgayHetHan >= GETDATE());
DECLARE @MaHDHetHan INT = (SELECT TOP 1 MaHD FROM HOPDONG WHERE TrangThai = N'Hết hạn' OR NgayHetHan < GETDATE());
DECLARE @MaHDKhongTonTai INT = 9999;
SELECT dbo.fn_KiemTraHopDongConHan(@MaHDHieuLuc) AS HDHieuLuc; -- Dự kiến 1
SELECT dbo.fn_KiemTraHopDongConHan(@MaHDHetHan) AS HDHetHan;   -- Dự kiến 0
SELECT dbo.fn_KiemTraHopDongConHan(@MaHDKhongTonTai) AS HDNotExist; -- Dự kiến NULL
GO