 --PHẦN 1: HỢP ĐỒNG & KHÁCH HÀNG 
SELECT * FROM V_ThongTinHopDong;
SELECT * FROM V_HopDongSapHetHan;
SELECT * FROM V_KhachHang_TongQuan;

--  PHẦN 2: THANH TOÁN & TÀI CHÍNH 
SELECT * FROM V_ThanhToanPhi_ChiTiet;
SELECT * FROM V_DoanhThu_TheoThang;
SELECT * FROM V_DoanhThu_TheoLoaiBaoHiem;
SELECT * FROM V_CongNo_HopDong;

-- ====================== PHẦN 3: BỒI THƯỜNG ======================
SELECT * FROM V_YeuCauBoiThuong_ChiTiet;
SELECT * FROM V_ThongKe_BoiThuong_TheoLoai;
SELECT * FROM V_ChiTraBoiThuong_ChiTiet;

--  PHẦN 4: NHÂN VIÊN & HIỆU SUẤT 
SELECT * FROM V_HieuSuat_NhanVien;
SELECT * FROM V_NhanVien_TheoPhongBan;

--  PHẦN 5: KHUYẾN MÃI 
SELECT * FROM V_KhuyenMai_DangApDung;
SELECT * FROM V_HopDong_KhuyenMai;

-- PHẦN 
SELECT * FROM V_TaiKhoan_ThongTin;
SELECT * FROM V_LichSuTruyCap_GanDay;

-- PHẦN 7: TỔNG HỢP & BÁO CÁO
SELECT * FROM V_TongQuan_HeThong;
SELECT * FROM V_Top_KhachHang_DoanhThu;
SELECT * FROM V_GoiBaoHiem_PhoBien;