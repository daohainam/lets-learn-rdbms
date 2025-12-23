# Đề bài: Thiết kế CSDL cho hệ thống **Quản lý thư viện đa chi nhánh** (SQL Server)

## 1) Bối cảnh
Thư viện có **nhiều chi nhánh**, mỗi chi nhánh lưu trữ nhiều **bản sao (copy)** của các đầu sách. Bạn đọc có thể **mượn**, **đặt trước**, **trả sách**, và có thể bị **phạt trễ hạn/mất sách/hư hỏng**. Nhân viên thư viện xử lý nghiệp vụ mượn–trả, thu tiền phạt.

**Mục tiêu:** Thiết kế cơ sở dữ liệu quan hệ và triển khai bằng **SQL Server** (tạo bảng, quan hệ, ràng buộc, index, dữ liệu mẫu, truy vấn).

---

## 2) Yêu cầu nghiệp vụ

### A. Quản lý danh mục cơ bản
1. Quản lý **Chi nhánh** (tên, địa chỉ, số điện thoại).
2. Quản lý **Nhân viên** thuộc chi nhánh (họ tên, email, vai trò).
3. Quản lý **Bạn đọc** (họ tên, email, điện thoại, ngày đăng ký, trạng thái hoạt động).

### B. Quản lý sách
4. Quản lý **Nhà xuất bản**, **Thể loại**, **Tác giả**.
5. Quản lý **Đầu sách** (ISBN, tên sách, năm xuất bản, giá bìa, mô tả).
6. Một đầu sách có thể có **nhiều tác giả**; một tác giả có thể viết **nhiều đầu sách** (quan hệ **N–N**).
7. Mỗi đầu sách có thể có nhiều **bản sao** ở nhiều chi nhánh. Mỗi bản sao có **mã vạch/Barcode** riêng, tình trạng:
   - `Available / OnLoan / Lost / Damaged / Maintenance`

### C. Mượn – trả
8. Bạn đọc tạo một **phiếu mượn** tại một chi nhánh (ngày mượn, hạn trả, nhân viên xử lý).
9. Một phiếu mượn có **nhiều dòng chi tiết** (mỗi dòng là 1 bản sao sách).
10. Khi trả, lưu **ngày trả thực tế** theo từng bản sao.
11. Ràng buộc:
   - Mỗi bản sao tại một thời điểm **không thể** được mượn bởi 2 phiếu khác nhau.
   - Một bạn đọc có tối đa **5 bản sao đang mượn** (chưa trả).
   - Hạn trả mặc định: **14 ngày** từ ngày mượn (có thể cấu hình/ghi nhận theo phiếu).

### D. Đặt trước (Reservation/Hold)
12. Khi tất cả bản sao của một đầu sách ở chi nhánh đều đang được mượn, bạn đọc có thể **đặt trước** theo đầu sách tại chi nhánh.
13. Đặt trước có trạng thái:
   - `Waiting / Notified / Cancelled / Fulfilled / Expired`
14. Mỗi đặt trước có **thứ tự ưu tiên** theo thời gian tạo (**FIFO**).

### E. Phạt và thanh toán
15. Nếu trả trễ, mất hoặc hư hỏng, phát sinh **phiếu phạt**:
   - Trễ hạn: **5.000đ/ngày**.
   - Mất sách: phạt = **giá bìa * 150%**.
   - Hư hỏng: phạt theo mức độ (nhập tay) nhưng phải **> 0**.
16. Một phiếu phạt có thể được thanh toán **một phần hoặc nhiều lần** (Payment), và theo dõi **còn nợ**.

---

## 3) Yêu cầu dữ liệu & quy tắc (dùng để thiết kế ràng buộc)
- Email của **bạn đọc** và **nhân viên**: **unique** trong từng nhóm.
- ISBN của đầu sách: **unique**.
- Barcode của bản sao: **unique**.
- Giá bìa, tiền phạt, số tiền thanh toán: **> 0**.
- Trạng thái bản sao chỉ nằm trong tập giá trị cho phép (gợi ý dùng `CHECK` hoặc bảng danh mục).
- Trạng thái của đặt trước/phiếu mượn/phiếu phạt cũng nên có `CHECK`/lookup table.
- Khi xóa dữ liệu: ưu tiên **không xóa cứng** các dữ liệu nghiệp vụ (mượn, trả, phạt, thanh toán). Có thể dùng cột `IsActive`/`Status`.

---

## 4) Yêu cầu triển khai SQL Server (DDL)
1. **ERD** (Crow’s Foot) + mô tả khóa chính/khóa ngoại.
2. Script SQL:
   - `CREATE DATABASE`, `CREATE TABLE` đầy đủ PK/FK.
   - Các ràng buộc: `NOT NULL`, `UNIQUE`, `CHECK`, `DEFAULT`.
   - Index đề xuất (ít nhất 5 index) cho các truy vấn thường gặp (ISBN, Barcode, MemberId, BookId, BranchId, Loan dates…).
3. Tối thiểu **10 câu INSERT mẫu** cho các bảng lõi (Book, BookCopy, Member, Loan…).

---

## 5) Thực hành truy vấn
Viết các câu SQL (SELECT) sau:
1. Danh sách bản sao **đang Available** của một đầu sách (theo ISBN) tại một chi nhánh.
2. Top 10 đầu sách được mượn nhiều nhất trong 30 ngày gần nhất.
3. Danh sách bạn đọc đang mượn > 3 cuốn (chưa trả).
4. Danh sách phiếu mượn quá hạn (hôm nay > DueDate) và số ngày quá hạn.
5. Tính tổng tiền phạt chưa thanh toán theo từng bạn đọc.
6. Danh sách đặt trước đang `Waiting` theo chi nhánh, sắp xếp FIFO.
7. Lịch sử mượn của một bạn đọc: sách gì, mượn ngày nào, trả ngày nào, có phạt không.
8. Đầu sách nào hiện đang “không còn bản sao Available” tại chi nhánh X.
9. Thống kê số bản sao theo trạng thái (Available/OnLoan/Lost/…) theo chi nhánh.
10. Với một phiếu phạt: tổng đã trả và số tiền còn nợ.


