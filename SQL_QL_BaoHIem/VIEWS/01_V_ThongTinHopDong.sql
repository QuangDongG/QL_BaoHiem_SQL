USE QL_BaoHiem;  
GO  
  
CREATE OR ALTER VIEW V_ThongTinHopDong
AS
SELECT 
    HD.MaHD,
    HD.MaSoHD,
    KH.MaKH,
    KH.HoTen AS TenKhachHang,
    KH.CCCD,
    KH.SDT AS SDT_KhachHang,
    KH.Email AS Email_KhachHang,
    GB.MaGoi,
    GB.TenGoi AS TenGoiBaoHiem,
    LBH.TenLoai AS LoaiBaoHiem,
    GB.PhiDinhKy,
    GB.SoTienBaoHiem,
    GB.ThoiHanThang,
    NV.MaNV AS MaNV_TuVan,
    NV.HoTen AS TenNhanVienTuVan,
    NV.SDT AS SDT_NhanVien,
    HD.NgayKy,
    HD.NgayHieuLuc,
    HD.NgayHetHan,
    DATEDIFF(MONTH, HD.NgayHieuLuc, HD.NgayHetHan) AS SoThangConLai,
    HD.TrangThai,
    HD.GhiChu
FROM HOPDONG HD
INNER JOIN KHACHHANG KH ON HD.MaKH = KH.MaKH
INNER JOIN GOIBAOHIEM GB ON HD.MaGoi = GB.MaGoi
INNER JOIN LOAIBAOHIEM LBH ON GB.MaLoai = LBH.MaLoai
LEFT JOIN NHANVIEN NV ON HD.MaNV_TuVan = NV.MaNV;
GO