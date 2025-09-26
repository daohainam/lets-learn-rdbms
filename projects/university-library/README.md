# Chủ đề: Quản lý Thư viện Đại học
1. Mô tả hệ thống

Một thư viện đại học cần xây dựng hệ thống quản lý nhằm hỗ trợ việc mượn – trả sách, quản lý độc giả và tài liệu. Hệ thống cần đáp ứng các yêu cầu sau:

a) Quản lý độc giả

Độc giả có thể là sinh viên hoặc giảng viên.

Mỗi độc giả có các thông tin chung:

Mã độc giả, Họ tên, Ngày sinh, Địa chỉ, Email, Số điện thoại.

Sinh viên có thêm: Mã số sinh viên, Ngành học, Khóa học.

Giảng viên có thêm: Mã giảng viên, Khoa công tác.

b) Quản lý sách và tài liệu

Tài liệu gồm Sách và Luận văn.

Thông tin chung của tài liệu:

Mã tài liệu, Tên, Năm xuất bản, Nhà xuất bản.

Với Sách: thêm Tên tác giả, Số trang, ISBN.

Với Luận văn: thêm Tên tác giả (sinh viên), Người hướng dẫn (giảng viên), Loại luận văn (Thạc sĩ, Tiến sĩ).

Mỗi tài liệu có thể có nhiều bản sao (copy) với Mã bản sao riêng, có tình trạng: đang mượn, sẵn sàng, hỏng, mất.

c) Quản lý mượn – trả

Một độc giả có thể mượn nhiều bản sao tài liệu.

Một bản sao tại một thời điểm chỉ có thể được mượn bởi một độc giả.

Mỗi lần mượn – trả lưu lại:

Ngày mượn, Hạn trả, Ngày trả thực tế (nếu có).

Nếu trả muộn sẽ phát sinh tiền phạt, tính theo số ngày trễ.

d) Các yêu cầu khác

Một tác giả có thể viết nhiều tài liệu, và một tài liệu có thể có nhiều tác giả (ngoại trừ luận văn).

Hệ thống cho phép tra cứu:

Độc giả đang mượn những bản sao nào.

Tình trạng của từng bản sao.