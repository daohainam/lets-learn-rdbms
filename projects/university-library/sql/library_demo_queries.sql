DECLARE @Today DATE = GETDATE();
DECLARE @Start DATE = DATEADD(DAY, -60, @Today);
DECLARE @End   DATE = @Today;
GO

/* 1) Danh sách sách + số bản sao + số bản sao đang sẵn sàng */
SELECT 
    tl.MaTL,
    tl.TieuDe,
    COUNT(bs.MaBanSao)                                   AS TongBanSao,
    SUM(CASE WHEN bs.TinhTrang = 'SanSang' THEN 1 ELSE 0 END) AS SanSang,
    SUM(CASE WHEN bs.TinhTrang = 'DangMuon' THEN 1 ELSE 0 END) AS DangMuon
FROM TAILIEU tl
LEFT JOIN BANSAO bs ON bs.MaTL = tl.MaTL
WHERE tl.LoaiTL = 'SACH'
GROUP BY tl.MaTL, tl.TieuDe
ORDER BY tl.TieuDe;
GO

/* 2) Sách đang được mượn (giao dịch mở) */
SELECT 
    m.MaMuonTra, dg.HoTen AS DocGia, sv.MSSV, b.MaBanSao, tl.TieuDe,
    m.NgayMuon, m.HanTra, DATEDIFF(DAY, m.HanTra, GETDATE()) AS SoNgayQuaHan
FROM MUONTRA m
JOIN DOCGIA dg ON dg.MaDocGia = m.MaDocGia
LEFT JOIN SINHVIEN sv ON sv.MaDocGia = dg.MaDocGia
JOIN BANSAO b ON b.MaBanSao = m.MaBanSao
JOIN TAILIEU tl ON tl.MaTL = b.MaTL
WHERE m.NgayTra IS NULL
ORDER BY m.HanTra;
GO

/* 3) Các giao dịch quá hạn (đang mở và đã quá hạn) */
SELECT 
    m.MaMuonTra, dg.HoTen, b.MaBanSao, tl.TieuDe,
    m.NgayMuon, m.HanTra,
    DATEDIFF(DAY, m.HanTra, GETDATE()) AS SoNgayTre
FROM MUONTRA m
JOIN DOCGIA dg ON dg.MaDocGia = m.MaDocGia
JOIN BANSAO b ON b.MaBanSao = m.MaBanSao
JOIN TAILIEU tl ON tl.MaTL = b.MaTL
WHERE m.NgayTra IS NULL AND m.HanTra < GETDATE()
ORDER BY SoNgayTre DESC;
GO

/* 4) Lịch sử mượn-trả của một sinh viên theo MSSV */
DECLARE @MSSV NVARCHAR(50) = 'SV001';
SELECT 
    m.MaMuonTra, tl.TieuDe, m.NgayMuon, m.HanTra, m.NgayTra, m.TienPhat
FROM MUONTRA m
JOIN BANSAO b ON b.MaBanSao = m.MaBanSao
JOIN TAILIEU tl ON tl.MaTL = b.MaTL
JOIN SINHVIEN sv ON sv.MaDocGia = m.MaDocGia
WHERE sv.MSSV = @MSSV
ORDER BY m.NgayMuon DESC;
GO

/* 5) Tổng hợp số lần mượn theo sinh viên (30 ngày gần đây) */
SELECT 
    sv.MSSV, dg.HoTen, COUNT(*) AS SoLanMuon
FROM MUONTRA m
JOIN SINHVIEN sv ON sv.MaDocGia = m.MaDocGia
JOIN DOCGIA dg ON dg.MaDocGia = sv.MaDocGia
WHERE m.NgayMuon BETWEEN @Start AND @End
GROUP BY sv.MSSV, dg.HoTen
ORDER BY SoLanMuon DESC;
GO

/* 6) Danh sách luận văn kèm sinh viên tác giả và giảng viên hướng dẫn */
SELECT 
    lv.MaTL, tl.TieuDe, lv.CapDo,
    sv.MSSV, dgSV.HoTen AS TenSinhVien,
    gv.MaGV, dgGV.HoTen AS TenGiangVien
FROM LUANVAN lv
JOIN TAILIEU tl ON tl.MaTL = lv.MaTL
JOIN SINHVIEN sv ON sv.MaDocGia = lv.MaDocGiaTacGia
JOIN DOCGIA dgSV ON dgSV.MaDocGia = sv.MaDocGia
JOIN GIANGVIEN gv ON gv.MaDocGia = lv.MaGVHuongDan
JOIN DOCGIA dgGV ON dgGV.MaDocGia = gv.MaDocGia
ORDER BY tl.TieuDe;
GO

/* 7) Top 10 đầu sách đang được mượn nhiều nhất (theo số giao dịch mở) */
SELECT TOP (10)
    tl.MaTL, tl.TieuDe, COUNT(*) AS SoBanSaoDangMuon
FROM MUONTRA m
JOIN BANSAO b ON b.MaBanSao = m.MaBanSao
JOIN TAILIEU tl ON tl.MaTL = b.MaTL
WHERE m.NgayTra IS NULL AND tl.LoaiTL = 'SACH'
GROUP BY tl.MaTL, tl.TieuDe
ORDER BY SoBanSaoDangMuon DESC, tl.TieuDe;
GO

/* 8) Tình trạng từng bản sao (dùng view) */
SELECT * FROM v_TinhTrangBanSao ORDER BY MaTL, MaBanSao;
GO

/* 9) Các giao dịch mượn đang mở (dùng view) */
SELECT * FROM v_MuonDangMo ORDER BY HanTra;
GO

/* 10) (Nếu có tác giả) Liệt kê tác giả theo đầu sách */
SELECT tl.MaTL, tl.TieuDe, STRING_AGG(tg.TenTacGia, N'; ') AS TacGia
FROM TAILIEU tl
JOIN TACGIA_TAILIEU tt ON tt.MaTL = tl.MaTL
JOIN TACGIA tg ON tg.MaTG = tt.MaTG
WHERE tl.LoaiTL = 'SACH'
GROUP BY tl.MaTL, tl.TieuDe
ORDER BY tl.TieuDe;
GO
