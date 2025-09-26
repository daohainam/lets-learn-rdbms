-- Dữ liệu mẫu: 20 sách, 20 luận văn, 20 sinh viên, 5 giảng viên
GO
INSERT INTO DOCGIA (HoTen, NgaySinh, DiaChi, Email, DienThoai, LoaiDocGia)
VALUES (N'Nguyen Van A', '2000-01-15', N'Ha Noi', 'sv1@univ.vn', '090100000', 'SV');
GO
INSERT INTO DOCGIA (HoTen, NgaySinh, DiaChi, Email, DienThoai, LoaiDocGia)
VALUES (N'Tran Thi B', '2001-02-15', N'Ha Noi', 'sv2@univ.vn', '090100001', 'SV');
GO
INSERT INTO DOCGIA (HoTen, NgaySinh, DiaChi, Email, DienThoai, LoaiDocGia)
VALUES (N'Le Van C', '2002-03-15', N'Ha Noi', 'sv3@univ.vn', '090100002', 'SV');
GO
INSERT INTO DOCGIA (HoTen, NgaySinh, DiaChi, Email, DienThoai, LoaiDocGia)
VALUES (N'Pham Thi D', '2003-04-15', N'Ha Noi', 'sv4@univ.vn', '090100003', 'SV');
GO
INSERT INTO DOCGIA (HoTen, NgaySinh, DiaChi, Email, DienThoai, LoaiDocGia)
VALUES (N'Hoang Van E', '2004-05-15', N'Ha Noi', 'sv5@univ.vn', '090100004', 'SV');
GO
INSERT INTO DOCGIA (HoTen, NgaySinh, DiaChi, Email, DienThoai, LoaiDocGia)
VALUES (N'Nguyen Thi F', '2005-06-15', N'Ha Noi', 'sv6@univ.vn', '090100005', 'SV');
GO
INSERT INTO DOCGIA (HoTen, NgaySinh, DiaChi, Email, DienThoai, LoaiDocGia)
VALUES (N'Tran Van G', '2006-07-15', N'Ha Noi', 'sv7@univ.vn', '090100006', 'SV');
GO
INSERT INTO DOCGIA (HoTen, NgaySinh, DiaChi, Email, DienThoai, LoaiDocGia)
VALUES (N'Le Thi H', '2007-08-15', N'Ha Noi', 'sv8@univ.vn', '090100007', 'SV');
GO
INSERT INTO DOCGIA (HoTen, NgaySinh, DiaChi, Email, DienThoai, LoaiDocGia)
VALUES (N'Pham Van I', '2008-09-15', N'Ha Noi', 'sv9@univ.vn', '090100008', 'SV');
GO
INSERT INTO DOCGIA (HoTen, NgaySinh, DiaChi, Email, DienThoai, LoaiDocGia)
VALUES (N'Hoang Thi J', '2009-01-15', N'Ha Noi', 'sv10@univ.vn', '090100009', 'SV');
GO
INSERT INTO DOCGIA (HoTen, NgaySinh, DiaChi, Email, DienThoai, LoaiDocGia)
VALUES (N'Nguyen Van K', '2000-02-15', N'Ha Noi', 'sv11@univ.vn', '090100010', 'SV');
GO
INSERT INTO DOCGIA (HoTen, NgaySinh, DiaChi, Email, DienThoai, LoaiDocGia)
VALUES (N'Tran Thi L', '2001-03-15', N'Ha Noi', 'sv12@univ.vn', '090100011', 'SV');
GO
INSERT INTO DOCGIA (HoTen, NgaySinh, DiaChi, Email, DienThoai, LoaiDocGia)
VALUES (N'Le Van M', '2002-04-15', N'Ha Noi', 'sv13@univ.vn', '090100012', 'SV');
GO
INSERT INTO DOCGIA (HoTen, NgaySinh, DiaChi, Email, DienThoai, LoaiDocGia)
VALUES (N'Pham Thi N', '2003-05-15', N'Ha Noi', 'sv14@univ.vn', '090100013', 'SV');
GO
INSERT INTO DOCGIA (HoTen, NgaySinh, DiaChi, Email, DienThoai, LoaiDocGia)
VALUES (N'Hoang Van O', '2004-06-15', N'Ha Noi', 'sv15@univ.vn', '090100014', 'SV');
GO
INSERT INTO DOCGIA (HoTen, NgaySinh, DiaChi, Email, DienThoai, LoaiDocGia)
VALUES (N'Nguyen Thi P', '2005-07-15', N'Ha Noi', 'sv16@univ.vn', '090100015', 'SV');
GO
INSERT INTO DOCGIA (HoTen, NgaySinh, DiaChi, Email, DienThoai, LoaiDocGia)
VALUES (N'Tran Van Q', '2006-08-15', N'Ha Noi', 'sv17@univ.vn', '090100016', 'SV');
GO
INSERT INTO DOCGIA (HoTen, NgaySinh, DiaChi, Email, DienThoai, LoaiDocGia)
VALUES (N'Le Thi R', '2007-09-15', N'Ha Noi', 'sv18@univ.vn', '090100017', 'SV');
GO
INSERT INTO DOCGIA (HoTen, NgaySinh, DiaChi, Email, DienThoai, LoaiDocGia)
VALUES (N'Pham Van S', '2008-01-15', N'Ha Noi', 'sv19@univ.vn', '090100018', 'SV');
GO
INSERT INTO DOCGIA (HoTen, NgaySinh, DiaChi, Email, DienThoai, LoaiDocGia)
VALUES (N'Hoang Thi T', '2009-02-15', N'Ha Noi', 'sv20@univ.vn', '090100019', 'SV');
GO
INSERT INTO SINHVIEN (MaDocGia, MSSV, NganhHoc, KhoaHoc)
SELECT MaDocGia, 'SV001', N'CNTT', 'K16' FROM DOCGIA WHERE Email='sv1@univ.vn';
GO
INSERT INTO SINHVIEN (MaDocGia, MSSV, NganhHoc, KhoaHoc)
SELECT MaDocGia, 'SV002', N'CNTT', 'K17' FROM DOCGIA WHERE Email='sv2@univ.vn';
GO
INSERT INTO SINHVIEN (MaDocGia, MSSV, NganhHoc, KhoaHoc)
SELECT MaDocGia, 'SV003', N'CNTT', 'K18' FROM DOCGIA WHERE Email='sv3@univ.vn';
GO
INSERT INTO SINHVIEN (MaDocGia, MSSV, NganhHoc, KhoaHoc)
SELECT MaDocGia, 'SV004', N'CNTT', 'K19' FROM DOCGIA WHERE Email='sv4@univ.vn';
GO
INSERT INTO SINHVIEN (MaDocGia, MSSV, NganhHoc, KhoaHoc)
SELECT MaDocGia, 'SV005', N'CNTT', 'K20' FROM DOCGIA WHERE Email='sv5@univ.vn';
GO
INSERT INTO SINHVIEN (MaDocGia, MSSV, NganhHoc, KhoaHoc)
SELECT MaDocGia, 'SV006', N'CNTT', 'K16' FROM DOCGIA WHERE Email='sv6@univ.vn';
GO
INSERT INTO SINHVIEN (MaDocGia, MSSV, NganhHoc, KhoaHoc)
SELECT MaDocGia, 'SV007', N'CNTT', 'K17' FROM DOCGIA WHERE Email='sv7@univ.vn';
GO
INSERT INTO SINHVIEN (MaDocGia, MSSV, NganhHoc, KhoaHoc)
SELECT MaDocGia, 'SV008', N'CNTT', 'K18' FROM DOCGIA WHERE Email='sv8@univ.vn';
GO
INSERT INTO SINHVIEN (MaDocGia, MSSV, NganhHoc, KhoaHoc)
SELECT MaDocGia, 'SV009', N'CNTT', 'K19' FROM DOCGIA WHERE Email='sv9@univ.vn';
GO
INSERT INTO SINHVIEN (MaDocGia, MSSV, NganhHoc, KhoaHoc)
SELECT MaDocGia, 'SV010', N'CNTT', 'K20' FROM DOCGIA WHERE Email='sv10@univ.vn';
GO
INSERT INTO SINHVIEN (MaDocGia, MSSV, NganhHoc, KhoaHoc)
SELECT MaDocGia, 'SV011', N'CNTT', 'K16' FROM DOCGIA WHERE Email='sv11@univ.vn';
GO
INSERT INTO SINHVIEN (MaDocGia, MSSV, NganhHoc, KhoaHoc)
SELECT MaDocGia, 'SV012', N'CNTT', 'K17' FROM DOCGIA WHERE Email='sv12@univ.vn';
GO
INSERT INTO SINHVIEN (MaDocGia, MSSV, NganhHoc, KhoaHoc)
SELECT MaDocGia, 'SV013', N'CNTT', 'K18' FROM DOCGIA WHERE Email='sv13@univ.vn';
GO
INSERT INTO SINHVIEN (MaDocGia, MSSV, NganhHoc, KhoaHoc)
SELECT MaDocGia, 'SV014', N'CNTT', 'K19' FROM DOCGIA WHERE Email='sv14@univ.vn';
GO
INSERT INTO SINHVIEN (MaDocGia, MSSV, NganhHoc, KhoaHoc)
SELECT MaDocGia, 'SV015', N'CNTT', 'K20' FROM DOCGIA WHERE Email='sv15@univ.vn';
GO
INSERT INTO SINHVIEN (MaDocGia, MSSV, NganhHoc, KhoaHoc)
SELECT MaDocGia, 'SV016', N'CNTT', 'K16' FROM DOCGIA WHERE Email='sv16@univ.vn';
GO
INSERT INTO SINHVIEN (MaDocGia, MSSV, NganhHoc, KhoaHoc)
SELECT MaDocGia, 'SV017', N'CNTT', 'K17' FROM DOCGIA WHERE Email='sv17@univ.vn';
GO
INSERT INTO SINHVIEN (MaDocGia, MSSV, NganhHoc, KhoaHoc)
SELECT MaDocGia, 'SV018', N'CNTT', 'K18' FROM DOCGIA WHERE Email='sv18@univ.vn';
GO
INSERT INTO SINHVIEN (MaDocGia, MSSV, NganhHoc, KhoaHoc)
SELECT MaDocGia, 'SV019', N'CNTT', 'K19' FROM DOCGIA WHERE Email='sv19@univ.vn';
GO
INSERT INTO SINHVIEN (MaDocGia, MSSV, NganhHoc, KhoaHoc)
SELECT MaDocGia, 'SV020', N'CNTT', 'K20' FROM DOCGIA WHERE Email='sv20@univ.vn';
GO
INSERT INTO DOCGIA (HoTen, NgaySinh, DiaChi, Email, DienThoai, LoaiDocGia)
VALUES (N'Do Van U', '1970-01-20', N'HCM', 'gv1@univ.vn', '091200000', 'GV');
GO
INSERT INTO DOCGIA (HoTen, NgaySinh, DiaChi, Email, DienThoai, LoaiDocGia)
VALUES (N'Bui Thi V', '1971-02-20', N'HCM', 'gv2@univ.vn', '091200001', 'GV');
GO
INSERT INTO DOCGIA (HoTen, NgaySinh, DiaChi, Email, DienThoai, LoaiDocGia)
VALUES (N'Dang Van W', '1972-03-20', N'HCM', 'gv3@univ.vn', '091200002', 'GV');
GO
INSERT INTO DOCGIA (HoTen, NgaySinh, DiaChi, Email, DienThoai, LoaiDocGia)
VALUES (N'Ngo Thi X', '1973-04-20', N'HCM', 'gv4@univ.vn', '091200003', 'GV');
GO
INSERT INTO DOCGIA (HoTen, NgaySinh, DiaChi, Email, DienThoai, LoaiDocGia)
VALUES (N'Vu Van Y', '1974-05-20', N'HCM', 'gv5@univ.vn', '091200004', 'GV');
GO
INSERT INTO GIANGVIEN (MaDocGia, MaGV, KhoaCongTac)
SELECT MaDocGia, 'GV001', N'CNTT' FROM DOCGIA WHERE Email='gv1@univ.vn';
GO
INSERT INTO GIANGVIEN (MaDocGia, MaGV, KhoaCongTac)
SELECT MaDocGia, 'GV002', N'CNTT' FROM DOCGIA WHERE Email='gv2@univ.vn';
GO
INSERT INTO GIANGVIEN (MaDocGia, MaGV, KhoaCongTac)
SELECT MaDocGia, 'GV003', N'CNTT' FROM DOCGIA WHERE Email='gv3@univ.vn';
GO
INSERT INTO GIANGVIEN (MaDocGia, MaGV, KhoaCongTac)
SELECT MaDocGia, 'GV004', N'CNTT' FROM DOCGIA WHERE Email='gv4@univ.vn';
GO
INSERT INTO GIANGVIEN (MaDocGia, MaGV, KhoaCongTac)
SELECT MaDocGia, 'GV005', N'CNTT' FROM DOCGIA WHERE Email='gv5@univ.vn';
GO
INSERT INTO TAILIEU (TieuDe, NamXB, NhaXuatBan, LoaiTL)
VALUES (N'Sach chuyen nganh 1', 2010, N'NXB Giao duc', 'SACH');
GO
INSERT INTO SACH (MaTL, SoTrang, ISBN)
SELECT MaTL, 100, 'ISBN100' FROM TAILIEU WHERE TieuDe=N'Sach chuyen nganh 1';
GO
INSERT INTO TAILIEU (TieuDe, NamXB, NhaXuatBan, LoaiTL)
VALUES (N'Sach chuyen nganh 2', 2011, N'NXB Giao duc', 'SACH');
GO
INSERT INTO SACH (MaTL, SoTrang, ISBN)
SELECT MaTL, 110, 'ISBN101' FROM TAILIEU WHERE TieuDe=N'Sach chuyen nganh 2';
GO
INSERT INTO TAILIEU (TieuDe, NamXB, NhaXuatBan, LoaiTL)
VALUES (N'Sach chuyen nganh 3', 2012, N'NXB Giao duc', 'SACH');
GO
INSERT INTO SACH (MaTL, SoTrang, ISBN)
SELECT MaTL, 120, 'ISBN102' FROM TAILIEU WHERE TieuDe=N'Sach chuyen nganh 3';
GO
INSERT INTO TAILIEU (TieuDe, NamXB, NhaXuatBan, LoaiTL)
VALUES (N'Sach chuyen nganh 4', 2013, N'NXB Giao duc', 'SACH');
GO
INSERT INTO SACH (MaTL, SoTrang, ISBN)
SELECT MaTL, 130, 'ISBN103' FROM TAILIEU WHERE TieuDe=N'Sach chuyen nganh 4';
GO
INSERT INTO TAILIEU (TieuDe, NamXB, NhaXuatBan, LoaiTL)
VALUES (N'Sach chuyen nganh 5', 2014, N'NXB Giao duc', 'SACH');
GO
INSERT INTO SACH (MaTL, SoTrang, ISBN)
SELECT MaTL, 140, 'ISBN104' FROM TAILIEU WHERE TieuDe=N'Sach chuyen nganh 5';
GO
INSERT INTO TAILIEU (TieuDe, NamXB, NhaXuatBan, LoaiTL)
VALUES (N'Sach chuyen nganh 6', 2015, N'NXB Giao duc', 'SACH');
GO
INSERT INTO SACH (MaTL, SoTrang, ISBN)
SELECT MaTL, 150, 'ISBN105' FROM TAILIEU WHERE TieuDe=N'Sach chuyen nganh 6';
GO
INSERT INTO TAILIEU (TieuDe, NamXB, NhaXuatBan, LoaiTL)
VALUES (N'Sach chuyen nganh 7', 2016, N'NXB Giao duc', 'SACH');
GO
INSERT INTO SACH (MaTL, SoTrang, ISBN)
SELECT MaTL, 160, 'ISBN106' FROM TAILIEU WHERE TieuDe=N'Sach chuyen nganh 7';
GO
INSERT INTO TAILIEU (TieuDe, NamXB, NhaXuatBan, LoaiTL)
VALUES (N'Sach chuyen nganh 8', 2017, N'NXB Giao duc', 'SACH');
GO
INSERT INTO SACH (MaTL, SoTrang, ISBN)
SELECT MaTL, 170, 'ISBN107' FROM TAILIEU WHERE TieuDe=N'Sach chuyen nganh 8';
GO
INSERT INTO TAILIEU (TieuDe, NamXB, NhaXuatBan, LoaiTL)
VALUES (N'Sach chuyen nganh 9', 2018, N'NXB Giao duc', 'SACH');
GO
INSERT INTO SACH (MaTL, SoTrang, ISBN)
SELECT MaTL, 180, 'ISBN108' FROM TAILIEU WHERE TieuDe=N'Sach chuyen nganh 9';
GO
INSERT INTO TAILIEU (TieuDe, NamXB, NhaXuatBan, LoaiTL)
VALUES (N'Sach chuyen nganh 10', 2019, N'NXB Giao duc', 'SACH');
GO
INSERT INTO SACH (MaTL, SoTrang, ISBN)
SELECT MaTL, 190, 'ISBN109' FROM TAILIEU WHERE TieuDe=N'Sach chuyen nganh 10';
GO
INSERT INTO TAILIEU (TieuDe, NamXB, NhaXuatBan, LoaiTL)
VALUES (N'Sach chuyen nganh 11', 2010, N'NXB Giao duc', 'SACH');
GO
INSERT INTO SACH (MaTL, SoTrang, ISBN)
SELECT MaTL, 200, 'ISBN110' FROM TAILIEU WHERE TieuDe=N'Sach chuyen nganh 11';
GO
INSERT INTO TAILIEU (TieuDe, NamXB, NhaXuatBan, LoaiTL)
VALUES (N'Sach chuyen nganh 12', 2011, N'NXB Giao duc', 'SACH');
GO
INSERT INTO SACH (MaTL, SoTrang, ISBN)
SELECT MaTL, 210, 'ISBN111' FROM TAILIEU WHERE TieuDe=N'Sach chuyen nganh 12';
GO
INSERT INTO TAILIEU (TieuDe, NamXB, NhaXuatBan, LoaiTL)
VALUES (N'Sach chuyen nganh 13', 2012, N'NXB Giao duc', 'SACH');
GO
INSERT INTO SACH (MaTL, SoTrang, ISBN)
SELECT MaTL, 220, 'ISBN112' FROM TAILIEU WHERE TieuDe=N'Sach chuyen nganh 13';
GO
INSERT INTO TAILIEU (TieuDe, NamXB, NhaXuatBan, LoaiTL)
VALUES (N'Sach chuyen nganh 14', 2013, N'NXB Giao duc', 'SACH');
GO
INSERT INTO SACH (MaTL, SoTrang, ISBN)
SELECT MaTL, 230, 'ISBN113' FROM TAILIEU WHERE TieuDe=N'Sach chuyen nganh 14';
GO
INSERT INTO TAILIEU (TieuDe, NamXB, NhaXuatBan, LoaiTL)
VALUES (N'Sach chuyen nganh 15', 2014, N'NXB Giao duc', 'SACH');
GO
INSERT INTO SACH (MaTL, SoTrang, ISBN)
SELECT MaTL, 240, 'ISBN114' FROM TAILIEU WHERE TieuDe=N'Sach chuyen nganh 15';
GO
INSERT INTO TAILIEU (TieuDe, NamXB, NhaXuatBan, LoaiTL)
VALUES (N'Sach chuyen nganh 16', 2015, N'NXB Giao duc', 'SACH');
GO
INSERT INTO SACH (MaTL, SoTrang, ISBN)
SELECT MaTL, 250, 'ISBN115' FROM TAILIEU WHERE TieuDe=N'Sach chuyen nganh 16';
GO
INSERT INTO TAILIEU (TieuDe, NamXB, NhaXuatBan, LoaiTL)
VALUES (N'Sach chuyen nganh 17', 2016, N'NXB Giao duc', 'SACH');
GO
INSERT INTO SACH (MaTL, SoTrang, ISBN)
SELECT MaTL, 260, 'ISBN116' FROM TAILIEU WHERE TieuDe=N'Sach chuyen nganh 17';
GO
INSERT INTO TAILIEU (TieuDe, NamXB, NhaXuatBan, LoaiTL)
VALUES (N'Sach chuyen nganh 18', 2017, N'NXB Giao duc', 'SACH');
GO
INSERT INTO SACH (MaTL, SoTrang, ISBN)
SELECT MaTL, 270, 'ISBN117' FROM TAILIEU WHERE TieuDe=N'Sach chuyen nganh 18';
GO
INSERT INTO TAILIEU (TieuDe, NamXB, NhaXuatBan, LoaiTL)
VALUES (N'Sach chuyen nganh 19', 2018, N'NXB Giao duc', 'SACH');
GO
INSERT INTO SACH (MaTL, SoTrang, ISBN)
SELECT MaTL, 280, 'ISBN118' FROM TAILIEU WHERE TieuDe=N'Sach chuyen nganh 19';
GO
INSERT INTO TAILIEU (TieuDe, NamXB, NhaXuatBan, LoaiTL)
VALUES (N'Sach chuyen nganh 20', 2019, N'NXB Giao duc', 'SACH');
GO
INSERT INTO SACH (MaTL, SoTrang, ISBN)
SELECT MaTL, 290, 'ISBN119' FROM TAILIEU WHERE TieuDe=N'Sach chuyen nganh 20';
GO
INSERT INTO TAILIEU (TieuDe, NamXB, NhaXuatBan, LoaiTL)
VALUES (N'Luan van Thac si 1', 2020, N'DH Quoc Gia', 'LUANVAN');
GO
INSERT INTO LUANVAN (MaTL, CapDo, MaDocGiaTacGia, MaGVHuongDan)
SELECT t.MaTL, 'ThacSi', sv.MaDocGia, gv.MaDocGia
FROM TAILIEU t
JOIN SINHVIEN sv ON sv.MSSV='SV001'
JOIN GIANGVIEN gv ON gv.MaGV='GV001'
WHERE t.TieuDe=N'Luan van Thac si 1';
GO
INSERT INTO TAILIEU (TieuDe, NamXB, NhaXuatBan, LoaiTL)
VALUES (N'Luan van Thac si 2', 2021, N'DH Quoc Gia', 'LUANVAN');
GO
INSERT INTO LUANVAN (MaTL, CapDo, MaDocGiaTacGia, MaGVHuongDan)
SELECT t.MaTL, 'ThacSi', sv.MaDocGia, gv.MaDocGia
FROM TAILIEU t
JOIN SINHVIEN sv ON sv.MSSV='SV002'
JOIN GIANGVIEN gv ON gv.MaGV='GV002'
WHERE t.TieuDe=N'Luan van Thac si 2';
GO
INSERT INTO TAILIEU (TieuDe, NamXB, NhaXuatBan, LoaiTL)
VALUES (N'Luan van Thac si 3', 2022, N'DH Quoc Gia', 'LUANVAN');
GO
INSERT INTO LUANVAN (MaTL, CapDo, MaDocGiaTacGia, MaGVHuongDan)
SELECT t.MaTL, 'ThacSi', sv.MaDocGia, gv.MaDocGia
FROM TAILIEU t
JOIN SINHVIEN sv ON sv.MSSV='SV003'
JOIN GIANGVIEN gv ON gv.MaGV='GV003'
WHERE t.TieuDe=N'Luan van Thac si 3';
GO
INSERT INTO TAILIEU (TieuDe, NamXB, NhaXuatBan, LoaiTL)
VALUES (N'Luan van Thac si 4', 2023, N'DH Quoc Gia', 'LUANVAN');
GO
INSERT INTO LUANVAN (MaTL, CapDo, MaDocGiaTacGia, MaGVHuongDan)
SELECT t.MaTL, 'ThacSi', sv.MaDocGia, gv.MaDocGia
FROM TAILIEU t
JOIN SINHVIEN sv ON sv.MSSV='SV004'
JOIN GIANGVIEN gv ON gv.MaGV='GV004'
WHERE t.TieuDe=N'Luan van Thac si 4';
GO
INSERT INTO TAILIEU (TieuDe, NamXB, NhaXuatBan, LoaiTL)
VALUES (N'Luan van Thac si 5', 2024, N'DH Quoc Gia', 'LUANVAN');
GO
INSERT INTO LUANVAN (MaTL, CapDo, MaDocGiaTacGia, MaGVHuongDan)
SELECT t.MaTL, 'ThacSi', sv.MaDocGia, gv.MaDocGia
FROM TAILIEU t
JOIN SINHVIEN sv ON sv.MSSV='SV005'
JOIN GIANGVIEN gv ON gv.MaGV='GV005'
WHERE t.TieuDe=N'Luan van Thac si 5';
GO
INSERT INTO TAILIEU (TieuDe, NamXB, NhaXuatBan, LoaiTL)
VALUES (N'Luan van Thac si 6', 2020, N'DH Quoc Gia', 'LUANVAN');
GO
INSERT INTO LUANVAN (MaTL, CapDo, MaDocGiaTacGia, MaGVHuongDan)
SELECT t.MaTL, 'ThacSi', sv.MaDocGia, gv.MaDocGia
FROM TAILIEU t
JOIN SINHVIEN sv ON sv.MSSV='SV006'
JOIN GIANGVIEN gv ON gv.MaGV='GV001'
WHERE t.TieuDe=N'Luan van Thac si 6';
GO
INSERT INTO TAILIEU (TieuDe, NamXB, NhaXuatBan, LoaiTL)
VALUES (N'Luan van Thac si 7', 2021, N'DH Quoc Gia', 'LUANVAN');
GO
INSERT INTO LUANVAN (MaTL, CapDo, MaDocGiaTacGia, MaGVHuongDan)
SELECT t.MaTL, 'ThacSi', sv.MaDocGia, gv.MaDocGia
FROM TAILIEU t
JOIN SINHVIEN sv ON sv.MSSV='SV007'
JOIN GIANGVIEN gv ON gv.MaGV='GV002'
WHERE t.TieuDe=N'Luan van Thac si 7';
GO
INSERT INTO TAILIEU (TieuDe, NamXB, NhaXuatBan, LoaiTL)
VALUES (N'Luan van Thac si 8', 2022, N'DH Quoc Gia', 'LUANVAN');
GO
INSERT INTO LUANVAN (MaTL, CapDo, MaDocGiaTacGia, MaGVHuongDan)
SELECT t.MaTL, 'ThacSi', sv.MaDocGia, gv.MaDocGia
FROM TAILIEU t
JOIN SINHVIEN sv ON sv.MSSV='SV008'
JOIN GIANGVIEN gv ON gv.MaGV='GV003'
WHERE t.TieuDe=N'Luan van Thac si 8';
GO
INSERT INTO TAILIEU (TieuDe, NamXB, NhaXuatBan, LoaiTL)
VALUES (N'Luan van Thac si 9', 2023, N'DH Quoc Gia', 'LUANVAN');
GO
INSERT INTO LUANVAN (MaTL, CapDo, MaDocGiaTacGia, MaGVHuongDan)
SELECT t.MaTL, 'ThacSi', sv.MaDocGia, gv.MaDocGia
FROM TAILIEU t
JOIN SINHVIEN sv ON sv.MSSV='SV009'
JOIN GIANGVIEN gv ON gv.MaGV='GV004'
WHERE t.TieuDe=N'Luan van Thac si 9';
GO
INSERT INTO TAILIEU (TieuDe, NamXB, NhaXuatBan, LoaiTL)
VALUES (N'Luan van Thac si 10', 2024, N'DH Quoc Gia', 'LUANVAN');
GO
INSERT INTO LUANVAN (MaTL, CapDo, MaDocGiaTacGia, MaGVHuongDan)
SELECT t.MaTL, 'ThacSi', sv.MaDocGia, gv.MaDocGia
FROM TAILIEU t
JOIN SINHVIEN sv ON sv.MSSV='SV010'
JOIN GIANGVIEN gv ON gv.MaGV='GV005'
WHERE t.TieuDe=N'Luan van Thac si 10';
GO
INSERT INTO TAILIEU (TieuDe, NamXB, NhaXuatBan, LoaiTL)
VALUES (N'Luan van Thac si 11', 2020, N'DH Quoc Gia', 'LUANVAN');
GO
INSERT INTO LUANVAN (MaTL, CapDo, MaDocGiaTacGia, MaGVHuongDan)
SELECT t.MaTL, 'ThacSi', sv.MaDocGia, gv.MaDocGia
FROM TAILIEU t
JOIN SINHVIEN sv ON sv.MSSV='SV011'
JOIN GIANGVIEN gv ON gv.MaGV='GV001'
WHERE t.TieuDe=N'Luan van Thac si 11';
GO
INSERT INTO TAILIEU (TieuDe, NamXB, NhaXuatBan, LoaiTL)
VALUES (N'Luan van Thac si 12', 2021, N'DH Quoc Gia', 'LUANVAN');
GO
INSERT INTO LUANVAN (MaTL, CapDo, MaDocGiaTacGia, MaGVHuongDan)
SELECT t.MaTL, 'ThacSi', sv.MaDocGia, gv.MaDocGia
FROM TAILIEU t
JOIN SINHVIEN sv ON sv.MSSV='SV012'
JOIN GIANGVIEN gv ON gv.MaGV='GV002'
WHERE t.TieuDe=N'Luan van Thac si 12';
GO
INSERT INTO TAILIEU (TieuDe, NamXB, NhaXuatBan, LoaiTL)
VALUES (N'Luan van Thac si 13', 2022, N'DH Quoc Gia', 'LUANVAN');
GO
INSERT INTO LUANVAN (MaTL, CapDo, MaDocGiaTacGia, MaGVHuongDan)
SELECT t.MaTL, 'ThacSi', sv.MaDocGia, gv.MaDocGia
FROM TAILIEU t
JOIN SINHVIEN sv ON sv.MSSV='SV013'
JOIN GIANGVIEN gv ON gv.MaGV='GV003'
WHERE t.TieuDe=N'Luan van Thac si 13';
GO
INSERT INTO TAILIEU (TieuDe, NamXB, NhaXuatBan, LoaiTL)
VALUES (N'Luan van Thac si 14', 2023, N'DH Quoc Gia', 'LUANVAN');
GO
INSERT INTO LUANVAN (MaTL, CapDo, MaDocGiaTacGia, MaGVHuongDan)
SELECT t.MaTL, 'ThacSi', sv.MaDocGia, gv.MaDocGia
FROM TAILIEU t
JOIN SINHVIEN sv ON sv.MSSV='SV014'
JOIN GIANGVIEN gv ON gv.MaGV='GV004'
WHERE t.TieuDe=N'Luan van Thac si 14';
GO
INSERT INTO TAILIEU (TieuDe, NamXB, NhaXuatBan, LoaiTL)
VALUES (N'Luan van Thac si 15', 2024, N'DH Quoc Gia', 'LUANVAN');
GO
INSERT INTO LUANVAN (MaTL, CapDo, MaDocGiaTacGia, MaGVHuongDan)
SELECT t.MaTL, 'ThacSi', sv.MaDocGia, gv.MaDocGia
FROM TAILIEU t
JOIN SINHVIEN sv ON sv.MSSV='SV015'
JOIN GIANGVIEN gv ON gv.MaGV='GV005'
WHERE t.TieuDe=N'Luan van Thac si 15';
GO
INSERT INTO TAILIEU (TieuDe, NamXB, NhaXuatBan, LoaiTL)
VALUES (N'Luan van Thac si 16', 2020, N'DH Quoc Gia', 'LUANVAN');
GO
INSERT INTO LUANVAN (MaTL, CapDo, MaDocGiaTacGia, MaGVHuongDan)
SELECT t.MaTL, 'ThacSi', sv.MaDocGia, gv.MaDocGia
FROM TAILIEU t
JOIN SINHVIEN sv ON sv.MSSV='SV016'
JOIN GIANGVIEN gv ON gv.MaGV='GV001'
WHERE t.TieuDe=N'Luan van Thac si 16';
GO
INSERT INTO TAILIEU (TieuDe, NamXB, NhaXuatBan, LoaiTL)
VALUES (N'Luan van Thac si 17', 2021, N'DH Quoc Gia', 'LUANVAN');
GO
INSERT INTO LUANVAN (MaTL, CapDo, MaDocGiaTacGia, MaGVHuongDan)
SELECT t.MaTL, 'ThacSi', sv.MaDocGia, gv.MaDocGia
FROM TAILIEU t
JOIN SINHVIEN sv ON sv.MSSV='SV017'
JOIN GIANGVIEN gv ON gv.MaGV='GV002'
WHERE t.TieuDe=N'Luan van Thac si 17';
GO
INSERT INTO TAILIEU (TieuDe, NamXB, NhaXuatBan, LoaiTL)
VALUES (N'Luan van Thac si 18', 2022, N'DH Quoc Gia', 'LUANVAN');
GO
INSERT INTO LUANVAN (MaTL, CapDo, MaDocGiaTacGia, MaGVHuongDan)
SELECT t.MaTL, 'ThacSi', sv.MaDocGia, gv.MaDocGia
FROM TAILIEU t
JOIN SINHVIEN sv ON sv.MSSV='SV018'
JOIN GIANGVIEN gv ON gv.MaGV='GV003'
WHERE t.TieuDe=N'Luan van Thac si 18';
GO
INSERT INTO TAILIEU (TieuDe, NamXB, NhaXuatBan, LoaiTL)
VALUES (N'Luan van Thac si 19', 2023, N'DH Quoc Gia', 'LUANVAN');
GO
INSERT INTO LUANVAN (MaTL, CapDo, MaDocGiaTacGia, MaGVHuongDan)
SELECT t.MaTL, 'ThacSi', sv.MaDocGia, gv.MaDocGia
FROM TAILIEU t
JOIN SINHVIEN sv ON sv.MSSV='SV019'
JOIN GIANGVIEN gv ON gv.MaGV='GV004'
WHERE t.TieuDe=N'Luan van Thac si 19';
GO
INSERT INTO TAILIEU (TieuDe, NamXB, NhaXuatBan, LoaiTL)
VALUES (N'Luan van Thac si 20', 2024, N'DH Quoc Gia', 'LUANVAN');
GO
INSERT INTO LUANVAN (MaTL, CapDo, MaDocGiaTacGia, MaGVHuongDan)
SELECT t.MaTL, 'ThacSi', sv.MaDocGia, gv.MaDocGia
FROM TAILIEU t
JOIN SINHVIEN sv ON sv.MSSV='SV020'
JOIN GIANGVIEN gv ON gv.MaGV='GV005'
WHERE t.TieuDe=N'Luan van Thac si 20';