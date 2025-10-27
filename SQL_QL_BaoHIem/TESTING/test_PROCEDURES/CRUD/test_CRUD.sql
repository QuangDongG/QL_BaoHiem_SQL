<<<<<<< HEAD
USE QL_BaoHiem;
-- HÌNH THỨC THANH TOÁN
EXEC SP_Them_HinhThucThanhToan N'Tiền mặt', N'Thanh toán trực tiếp bằng tiền mặt.';
EXEC SP_Sua_HinhThucThanhToan 1, N'Chuyển khoản', N'Thanh toán qua ngân hàng.';
EXEC SP_Xoa_HinhThucThanhToan 3;

--TÌNH TRẠNG YÊU CẦU
EXEC SP_Them_TinhTrangYeuCau N'Đang xử lý', N'Yêu cầu đang được xem xét.';
EXEC SP_Them_TinhTrangYeuCau N'Đã duyệt', N'Yêu cầu đã được phê duyệt.';
EXEC SP_Them_TinhTrangYeuCau N'Từ chối', N'Yêu cầu bị từ chối.';
EXEC SP_Sua_TinhTrangYeuCau 2, N'Đã phê duyệt', N'Yêu cầu đã hoàn tất xử lý.';
EXEC SP_Xoa_TinhTrangYeuCau 3;

-- PHÒNG BAN
EXEC SP_Them_PhongBan N'Phòng Quản lí cấp cao', N'Phụ trách tất cả quản lí phòng ban.';
EXEC SP_Them_PhongBan N'Phòng Giám đốc', N'Quản lý mọi quyền hạn của công ty.';
EXEC SP_Sua_PhongBan 1, N'Phòng Tư vấn khách hàng', N'Hỗ trợ khách hàng mua bảo hiểm.';
EXEC SP_Xoa_PhongBan 2;

-- NHÂN VIÊN
EXEC SP_Them_NhanVien 
    @HoTen = N'Lê Thái Hiếu', 
    @GioiTinh = N'Nam',
    @NgaySinh = '1980-06-04',
    @SDT = '0902571945',
    @Email = 'lethaihieu@corp.baohiem.vn',
    @DiaChi = N'Hà Nội',
    @ChucVu = N'Trưởng nhóm kinh doanh',
    @Luong = 17020000,
    @MaPhong = 1;
EXEC SP_Sua_NhanVien 
    @MaNV = 1,
    @HoTen = N'Lê Thái Hiếu',
    @GioiTinh = N'Nam',
    @NgaySinh = '1980-06-04',
    @SDT = '0912345678',
    @Email = 'lethaihieu@corp.baohiem.vn',
    @DiaChi = N'Hà Nội',
    @ChucVu = N'Giám sát kinh doanh',
    @Luong = 20000000,
    @MaPhong = 1;
EXEC SP_Xoa_NhanVien 2;

-- KHÁCH HÀNG
EXEC SP_Them_KhachHang 
    @HoTen = N'Nguyễn Thị Mai',
    @NgaySinh = '1990-05-10',
    @GioiTinh = N'Nữ',
    @CCCD = '012345678901',
    @DiaChi = N'Hà Nội',
    @SDT = '0905123456',
    @Email = 'nguyenthimai@example.com',
    @NgheNghiep = N'Giáo viên',
    @ThuNhap = 15000000;
EXEC SP_Sua_KhachHang 
    @MaKH = 1,
    @HoTen = N'Nguyễn Thị Mai',
    @NgaySinh = '1990-05-10',
    @GioiTinh = N'Nữ',
    @CCCD = '012345678901',
    @DiaChi = N'Hà Đông, Hà Nội',
    @SDT = '0905123456',
    @Email = 'nguyenthimai@example.com',
    @NgheNghiep = N'Giáo viên THPT',
    @ThuNhap = 16000000;
EXEC SP_Xoa_KhachHang 2;

-- GÓi BẢO HIỂM
EXEC SP_Them_GoiBaoHiem 
    @MaLoai = 1,
    @TenGoi = N'Gói Bảo hiểm Nhân thọ Toàn diện',
    @PhiDinhKy = 1500000,
    @SoTienBaoHiem = 500000000,
    @ThoiHanThang = 120,
    @DieuKien = N'Tuổi từ 18–60, sức khỏe tốt.',
    @QuyenLoi = N'Chi trả toàn phần khi tử vong hoặc bệnh hiểm nghèo.';
EXEC SP_Sua_GoiBaoHiem 
    @MaGoi = 1,
    @MaLoai = 1,
    @TenGoi = N'Gói Bảo hiểm Nhân thọ Cao cấp',
    @PhiDinhKy = 2000000,
    @SoTienBaoHiem = 1000000000,
    @ThoiHanThang = 180,
    @DieuKien = N'Tuổi từ 18–65, sức khỏe tốt.',
    @QuyenLoi = N'Chi trả tử vong, thương tật và bệnh hiểm nghèo.';
EXEC SP_Xoa_GoiBaoHiem 2;

--HỢP ĐỒNG
EXEC SP_Them_HopDong 
    @MaKH = 1,
    @MaGoi = 1,
    @MaNV_TuVan = 3,
    @MaSoHD = 'HD001',
    @NgayKy = '2024-05-10',
    @NgayHieuLuc = '2024-05-15',
    @NgayHetHan = '2027-05-15',
    @TrangThai = N'Hiệu lực',
    @GhiChu = N'Hợp đồng 3 năm, thanh toán định kỳ.';
EXEC SP_Sua_HopDong 
    @MaHD = 1,
    @MaKH = 1,
    @MaGoi = 1,
    @MaNV_TuVan = 3,
    @MaSoHD = 'HD001',
    @NgayKy = '2024-05-10',
    @NgayHieuLuc = '2024-05-15',
    @NgayHetHan = '2028-05-15',
    @TrangThai = N'Tạm dừng',
    @GhiChu = N'Gia hạn thêm 1 năm.';
EXEC SP_Xoa_HopDong 2;

-- KHUYẾN MÃI
EXEC SP_Them_KhuyenMai 
    @TenKM = N'Giảm 10% phí bảo hiểm đầu tiên',
    @NoiDung = N'Áp dụng cho khách hàng ký mới trong tháng 5.',
    @GiaTri = 10,
    @DonVi = N'%',
    @NgayBD = '2024-05-01',
    @NgayKT = '2024-05-31';
EXEC SP_Sua_KhuyenMai 
    @MaKM = 1,
    @TenKM = N'Giảm 15% phí bảo hiểm đầu tiên',
    @NoiDung = N'Áp dụng cho khách hàng ký mới trong tháng 6.',
    @GiaTri = 15,
    @DonVi = N'%',
    @NgayBD = '2024-06-01',
    @NgayKT = '2024-06-30';
EXEC SP_Xoa_KhuyenMai 2;

-- HỢP ĐỒNG KHUYẾN MÃI
EXEC SP_Them_HopDong_KhuyenMai 
    @MaHD = 1,
    @MaKM = 2;
EXEC SP_Xoa_HopDong_KhuyenMai 
    @MaHD = 1,
    @MaKM = 2;
EXEC SP_XoaTatCa_KhuyenMai_TheoHopDong 
    @MaHD = 1;

-- THANH TOÁN PHÍ
EXEC SP_Them_ThanhToanPhi
    @MaHD = 1,
    @NgayTT = '2024-06-01',
    @SoTien = 1500000,
    @MaHT = 2,
    @MaNV_Thu = 3,
    @TrangThai = N'Đã nhận',
    @MaGiaoDich = 'GD0001';
EXEC SP_Sua_ThanhToanPhi
    @MaTT = 1,
    @MaHD = 1,
    @NgayTT = '2024-06-05',
    @SoTien = 1600000,
    @MaHT = 2,
    @MaNV_Thu = 3,
    @TrangThai = N'Đã cập nhật',
    @MaGiaoDich = 'GD0001';

-- YÊU CẦU BỒI THƯỜNG
EXEC SP_Them_YeuCauBoiThuong
    @MaHD = 1,
    @NgayYeuCau = '2024-08-01',
    @NgaySuKien = '2024-07-25',
    @LoaiSuKien = N'Tai nạn giao thông',
    @SoTienYC = 20000000,
    @MaTT_TrangThai = 1,
    @GhiChu = N'Khách hàng nộp giấy xác nhận thương tật.';
EXEC SP_Sua_YeuCauBoiThuong
    @MaYC = 1,
    @MaHD = 1,
    @NgayYeuCau = '2024-08-03',
    @NgaySuKien = '2024-07-25',
    @LoaiSuKien = N'Tai nạn lao động',
    @SoTienYC = 25000000,
    @MaTT_TrangThai = 2,
    @GhiChu = N'Cập nhật hồ sơ thương tật.';
EXEC SP_Xoa_YeuCauBoiThuong 2;

--CHI TRẢ BỒI THƯỜNG
EXEC SP_Them_ChiTraBoiThuong
    @MaYC = 1,
    @NgayChiTra = '2024-09-01',
    @SoTienChi = 10000000,
    @HinhThucChi = N'Chuyển khoản',
    @TrangThai = N'Đã chi trả',
    @MaNV_Chi = 3,
    @GhiChu = N'Chi lần 1, khách hàng xác nhận nhận tiền.';
EXEC SP_Sua_ChiTraBoiThuong
    @MaCT = 1,
    @MaYC = 1,
    @NgayChiTra = '2024-09-05',
    @SoTienChi = 15000000,
    @HinhThucChi = N'Chuyển khoản',
    @TrangThai = N'Đã chi hoàn tất',
    @MaNV_Chi = 3,
    @GhiChu = N'Chi lần 2, hoàn tất chi trả.';


--TÀI KHOẢN
EXEC SP_Them_TaiKhoan 
    @TenDangNhap = 'KH667',
    @MatKhauHash ='34fa5b6c7d8e9f0a1b2c3d4e5f6071829',
    @LoaiTK = N'KH',
    @MaKH = 667,
    @MaNV = NULL,
    @TrangThai = N'Hoạt động';
EXEC SP_Them_TaiKhoan 
    @TenDangNhap = 'NV666',
    @MatKhauHash = 'avddadadad',
    @LoaiTK = N'NV',
    @MaKH = NULL,
    @MaNV = 666,
    @TrangThai = N'Hoạt động';
EXEC SP_Sua_TaiKhoan 
    @MaTK = 666,
    @TenDangNhap = 'NV666',
    @MatKhauHash = '0xabcdefdef',
    @LoaiTK = N'NV',
    @MaKH = NULL,
    @MaNV = 1,
    @TrangThai = N'Tạm khóa';
EXEC SP_Xoa_TaiKhoan 666;

-- LỊCH SỬ TRUY CẬP
EXEC SP_Them_LichSuTruyCap 
    @MaTK = 1,
    @HanhDong = N'Đăng nhập hệ thống',
    @MoTa = N'Thành công',
    @DiaChiIP = '192.168.1.10';
EXEC SP_Them_LichSuTruyCap 
    @MaTK = 1,
    @HanhDong = N'Thanh toán hợp đồng',
    @MoTa = N'Hợp đồng số HD001',
    @DiaChiIP = '192.168.1.10';
EXEC SP_Xoa_LichSuTruyCap_TheoTaiKhoan @MaTK = 1;
EXEC SP_Xoa_LichSuTruyCap_CuHonNgay @SoNgay = 30;
=======
USE QL_BaoHiem;
-- HÌNH THỨC THANH TOÁN
EXEC SP_Them_HinhThucThanhToan N'Tiền mặt', N'Thanh toán trực tiếp bằng tiền mặt.';
EXEC SP_Sua_HinhThucThanhToan 1, N'Chuyển khoản', N'Thanh toán qua ngân hàng.';
EXEC SP_Xoa_HinhThucThanhToan 3;

--TÌNH TRẠNG YÊU CẦU
EXEC SP_Them_TinhTrangYeuCau N'Đang xử lý', N'Yêu cầu đang được xem xét.';
EXEC SP_Them_TinhTrangYeuCau N'Đã duyệt', N'Yêu cầu đã được phê duyệt.';
EXEC SP_Them_TinhTrangYeuCau N'Từ chối', N'Yêu cầu bị từ chối.';
EXEC SP_Sua_TinhTrangYeuCau 2, N'Đã phê duyệt', N'Yêu cầu đã hoàn tất xử lý.';
EXEC SP_Xoa_TinhTrangYeuCau 3;

-- PHÒNG BAN
EXEC SP_Them_PhongBan N'Phòng Quản lí cấp cao', N'Phụ trách tất cả quản lí phòng ban.';
EXEC SP_Them_PhongBan N'Phòng Giám đốc', N'Quản lý mọi quyền hạn của công ty.';
EXEC SP_Sua_PhongBan 1, N'Phòng Tư vấn khách hàng', N'Hỗ trợ khách hàng mua bảo hiểm.';
EXEC SP_Xoa_PhongBan 2;

-- NHÂN VIÊN
EXEC SP_Them_NhanVien 
    @HoTen = N'Lê Thái Hiếu', 
    @GioiTinh = N'Nam',
    @NgaySinh = '1980-06-04',
    @SDT = '0902571945',
    @Email = 'lethaihieu@corp.baohiem.vn',
    @DiaChi = N'Hà Nội',
    @ChucVu = N'Trưởng nhóm kinh doanh',
    @Luong = 17020000,
    @MaPhong = 1;
EXEC SP_Sua_NhanVien 
    @MaNV = 1,
    @HoTen = N'Lê Thái Hiếu',
    @GioiTinh = N'Nam',
    @NgaySinh = '1980-06-04',
    @SDT = '0912345678',
    @Email = 'lethaihieu@corp.baohiem.vn',
    @DiaChi = N'Hà Nội',
    @ChucVu = N'Giám sát kinh doanh',
    @Luong = 20000000,
    @MaPhong = 1;
EXEC SP_Xoa_NhanVien 2;

-- KHÁCH HÀNG
EXEC SP_Them_KhachHang 
    @HoTen = N'Nguyễn Thị Mai',
    @NgaySinh = '1990-05-10',
    @GioiTinh = N'Nữ',
    @CCCD = '012345678901',
    @DiaChi = N'Hà Nội',
    @SDT = '0905123456',
    @Email = 'nguyenthimai@example.com',
    @NgheNghiep = N'Giáo viên',
    @ThuNhap = 15000000;
EXEC SP_Sua_KhachHang 
    @MaKH = 1,
    @HoTen = N'Nguyễn Thị Mai',
    @NgaySinh = '1990-05-10',
    @GioiTinh = N'Nữ',
    @CCCD = '012345678901',
    @DiaChi = N'Hà Đông, Hà Nội',
    @SDT = '0905123456',
    @Email = 'nguyenthimai@example.com',
    @NgheNghiep = N'Giáo viên THPT',
    @ThuNhap = 16000000;
EXEC SP_Xoa_KhachHang 2;

-- GÓi BẢO HIỂM
EXEC SP_Them_GoiBaoHiem 
    @MaLoai = 1,
    @TenGoi = N'Gói Bảo hiểm Nhân thọ Toàn diện',
    @PhiDinhKy = 1500000,
    @SoTienBaoHiem = 500000000,
    @ThoiHanThang = 120,
    @DieuKien = N'Tuổi từ 18–60, sức khỏe tốt.',
    @QuyenLoi = N'Chi trả toàn phần khi tử vong hoặc bệnh hiểm nghèo.';
EXEC SP_Sua_GoiBaoHiem 
    @MaGoi = 1,
    @MaLoai = 1,
    @TenGoi = N'Gói Bảo hiểm Nhân thọ Cao cấp',
    @PhiDinhKy = 2000000,
    @SoTienBaoHiem = 1000000000,
    @ThoiHanThang = 180,
    @DieuKien = N'Tuổi từ 18–65, sức khỏe tốt.',
    @QuyenLoi = N'Chi trả tử vong, thương tật và bệnh hiểm nghèo.';
EXEC SP_Xoa_GoiBaoHiem 2;

--HỢP ĐỒNG
EXEC SP_Them_HopDong 
    @MaKH = 1,
    @MaGoi = 1,
    @MaNV_TuVan = 3,
    @MaSoHD = 'HD001',
    @NgayKy = '2024-05-10',
    @NgayHieuLuc = '2024-05-15',
    @NgayHetHan = '2027-05-15',
    @TrangThai = N'Hiệu lực',
    @GhiChu = N'Hợp đồng 3 năm, thanh toán định kỳ.';
EXEC SP_Sua_HopDong 
    @MaHD = 1,
    @MaKH = 1,
    @MaGoi = 1,
    @MaNV_TuVan = 3,
    @MaSoHD = 'HD001',
    @NgayKy = '2024-05-10',
    @NgayHieuLuc = '2024-05-15',
    @NgayHetHan = '2028-05-15',
    @TrangThai = N'Tạm dừng',
    @GhiChu = N'Gia hạn thêm 1 năm.';
EXEC SP_Xoa_HopDong 2;

-- KHUYẾN MÃI
EXEC SP_Them_KhuyenMai 
    @TenKM = N'Giảm 10% phí bảo hiểm đầu tiên',
    @NoiDung = N'Áp dụng cho khách hàng ký mới trong tháng 5.',
    @GiaTri = 10,
    @DonVi = N'%',
    @NgayBD = '2024-05-01',
    @NgayKT = '2024-05-31';
EXEC SP_Sua_KhuyenMai 
    @MaKM = 1,
    @TenKM = N'Giảm 15% phí bảo hiểm đầu tiên',
    @NoiDung = N'Áp dụng cho khách hàng ký mới trong tháng 6.',
    @GiaTri = 15,
    @DonVi = N'%',
    @NgayBD = '2024-06-01',
    @NgayKT = '2024-06-30';
EXEC SP_Xoa_KhuyenMai 2;

-- HỢP ĐỒNG KHUYẾN MÃI
EXEC SP_Them_HopDong_KhuyenMai 
    @MaHD = 1,
    @MaKM = 2;
EXEC SP_Xoa_HopDong_KhuyenMai 
    @MaHD = 1,
    @MaKM = 2;
EXEC SP_XoaTatCa_KhuyenMai_TheoHopDong 
    @MaHD = 1;

-- THANH TOÁN PHÍ
EXEC SP_Them_ThanhToanPhi
    @MaHD = 1,
    @NgayTT = '2024-06-01',
    @SoTien = 1500000,
    @MaHT = 2,
    @MaNV_Thu = 3,
    @TrangThai = N'Đã nhận',
    @MaGiaoDich = 'GD0001';
EXEC SP_Sua_ThanhToanPhi
    @MaTT = 1,
    @MaHD = 1,
    @NgayTT = '2024-06-05',
    @SoTien = 1600000,
    @MaHT = 2,
    @MaNV_Thu = 3,
    @TrangThai = N'Đã cập nhật',
    @MaGiaoDich = 'GD0001';

-- YÊU CẦU BỒI THƯỜNG
EXEC SP_Them_YeuCauBoiThuong
    @MaHD = 1,
    @NgayYeuCau = '2024-08-01',
    @NgaySuKien = '2024-07-25',
    @LoaiSuKien = N'Tai nạn giao thông',
    @SoTienYC = 20000000,
    @MaTT_TrangThai = 1,
    @GhiChu = N'Khách hàng nộp giấy xác nhận thương tật.';
EXEC SP_Sua_YeuCauBoiThuong
    @MaYC = 1,
    @MaHD = 1,
    @NgayYeuCau = '2024-08-03',
    @NgaySuKien = '2024-07-25',
    @LoaiSuKien = N'Tai nạn lao động',
    @SoTienYC = 25000000,
    @MaTT_TrangThai = 2,
    @GhiChu = N'Cập nhật hồ sơ thương tật.';
EXEC SP_Xoa_YeuCauBoiThuong 2;

--CHI TRẢ BỒI THƯỜNG
EXEC SP_Them_ChiTraBoiThuong
    @MaYC = 1,
    @NgayChiTra = '2024-09-01',
    @SoTienChi = 10000000,
    @HinhThucChi = N'Chuyển khoản',
    @TrangThai = N'Đã chi trả',
    @MaNV_Chi = 3,
    @GhiChu = N'Chi lần 1, khách hàng xác nhận nhận tiền.';
EXEC SP_Sua_ChiTraBoiThuong
    @MaCT = 1,
    @MaYC = 1,
    @NgayChiTra = '2024-09-05',
    @SoTienChi = 15000000,
    @HinhThucChi = N'Chuyển khoản',
    @TrangThai = N'Đã chi hoàn tất',
    @MaNV_Chi = 3,
    @GhiChu = N'Chi lần 2, hoàn tất chi trả.';


--TÀI KHOẢN
EXEC SP_Them_TaiKhoan 
    @TenDangNhap = 'KH667',
    @MatKhauHash ='34fa5b6c7d8e9f0a1b2c3d4e5f6071829',
    @LoaiTK = N'KH',
    @MaKH = 667,
    @MaNV = NULL,
    @TrangThai = N'Hoạt động';
EXEC SP_Them_TaiKhoan 
    @TenDangNhap = 'NV666',
    @MatKhauHash = 'avddadadad',
    @LoaiTK = N'NV',
    @MaKH = NULL,
    @MaNV = 666,
    @TrangThai = N'Hoạt động';
EXEC SP_Sua_TaiKhoan 
    @MaTK = 666,
    @TenDangNhap = 'NV666',
    @MatKhauHash = '0xabcdefdef',
    @LoaiTK = N'NV',
    @MaKH = NULL,
    @MaNV = 1,
    @TrangThai = N'Tạm khóa';
EXEC SP_Xoa_TaiKhoan 666;

-- LỊCH SỬ TRUY CẬP
EXEC SP_Them_LichSuTruyCap 
    @MaTK = 1,
    @HanhDong = N'Đăng nhập hệ thống',
    @MoTa = N'Thành công',
    @DiaChiIP = '192.168.1.10';
EXEC SP_Them_LichSuTruyCap 
    @MaTK = 1,
    @HanhDong = N'Thanh toán hợp đồng',
    @MoTa = N'Hợp đồng số HD001',
    @DiaChiIP = '192.168.1.10';
EXEC SP_Xoa_LichSuTruyCap_TheoTaiKhoan @MaTK = 1;
EXEC SP_Xoa_LichSuTruyCap_CuHonNgay @SoNgay = 30;
>>>>>>> 59c5acf48653319ce8c913c2014f62e09ddfb835
