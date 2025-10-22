# Đề bài: Hệ thống quản lý bán hàng **SimpleShop**

> Mục tiêu: học viên **tự phân tích–thiết kế–cài đặt** CSDL (≤ 10 bảng), chuẩn hoá tới **≥ 3NF** (khuyến khích **BCNF**), có **PK/FK**, **ràng buộc toàn vẹn**, **index** cơ bản và **truy vấn báo cáo**.

---

## 1) Mô tả nghiệp vụ (tóm tắt)
SimpleShop bán các **sản phẩm** thuộc **danh mục**. **Khách hàng** đặt **đơn hàng** gồm nhiều **dòng hàng**. Mỗi đơn có thể có **nhiều lần thanh toán** (trả góp/chi nhiều lần). Đơn được giao qua **đơn vị vận chuyển**; mỗi đơn **tối đa một lần giao** với **mã vận đơn**.  
**Trạng thái đơn:** `Pending | Paid | Shipped | Delivered | Cancelled`.

---

## 2) Phạm vi & giới hạn
- Số bảng gợi ý (**≤ 10**): `Customers`, `Categories`, `Products`, `Orders`, `OrderItems`, `Payments`, `Shippers`, `Shipments`.
- Không làm quản lý tồn kho phức tạp/nhập hàng.
- Chỉ yêu cầu **database + SQL script** (không cần UI/app).

---

## 3) Yêu cầu chức năng
1. **Khách hàng (Customers)**
   - Lưu `CustomerName`, `Email`, `Phone`.
   - `Email` nếu có thì **duy nhất**.
2. **Danh mục & sản phẩm**
   - Mỗi `Products` thuộc **đúng 1** `Categories`.
   - `SKU` **duy nhất**; `UnitPrice ≥ 0`; `IsActive` (cờ hoạt động).
3. **Đơn hàng (Orders)**
   - Mỗi đơn thuộc **1** khách hàng.
   - Có `OrderDate` (UTC) và `Status ∈ {Pending, Paid, Shipped, Delivered, Cancelled}`.
   - **Quy tắc trạng thái (đơn giản):**
     - `Paid` ⇒ có **≥ 1** thanh toán, tổng `Payments.Amount` **≥** tổng tiền hàng.
     - `Shipped`/`Delivered` ⇒ **phải có** bản ghi `Shipments`.
     - `Cancelled` ⇒ **không được** có thanh toán dương.
4. **Dòng hàng (OrderItems)**
   - Thuộc tính: `ProductID`, `Quantity > 0`, `UnitPrice ≥ 0`, `Discount ∈ [0,1]`.
   - `LineTotal = Quantity * UnitPrice * (1 - Discount)` (**computed column** khuyến nghị).
5. **Thanh toán (Payments)**
   - Gắn với `OrderID`; `Amount > 0`; `Method ∈ {Cash, Card, Transfer, E-Wallet}`.
   - Tổng thanh toán **không vượt quá** tổng tiền hàng (xử lý bằng SP/transaction).
6. **Vận chuyển (Shippers & Shipments)**
   - Danh mục `Shippers`.
   - `Shipments`: **0..1** cho mỗi `Order`, `TrackingNo` **duy nhất**, có `ShippedAt`, `DeliveredAt`.

---

## 4) Yêu cầu phi chức năng & quy ước
- **Chuẩn hoá:** tối thiểu **3NF** (khuyến khích **BCNF** nếu có FD đặc thù).
- **Đặt tên:** PascalCase cho **bảng**, camelCase cho **cột** (hoặc quy ước riêng nhưng **nhất quán**).
- **Khoá:**
  - **PK:** số nguyên `IDENTITY` cho thực thể; **PK ghép** cho bảng nối (nếu cần).
  - **FK:** khai báo rõ hành vi xoá/phụ thuộc (`NO ACTION`/`CASCADE`) hợp lý.
- **Ràng buộc:** dùng `CHECK`, `NOT NULL`, `UNIQUE` nơi cần (status, method, SKU, email…).
- **Hiệu năng:** tạo **index** phù hợp truy vấn (ví dụ `Orders(CustomerID, OrderDate)`, `OrderItems(ProductID)`, `Shipments(OrderID)`).

---

## 5) Đầu việc học viên phải nộp (Deliverables)
1. **ERD** (PNG/SVG/PDF): bảng, PK/FK, bội số (1–N, 0..1).
2. **Script DDL**: `SimpleShopDB_Create.sql` — tạo DB, bảng, PK/FK, ràng buộc, **indexes**.
3. **Script seed (nhẹ để chấm tay)**: `SimpleShopDB_Seed.sql`
   - Tối thiểu: **10 categories**, **50–100 products**, **50 customers**, **200 orders** (mỗi đơn 1–4 dòng), **0–1 shipment**, **payments** hợp lý.
   - *(Tuỳ chọn)* bản lớn để tự test hiệu năng: **1k products**, **10k customers**, **100k orders**.
4. **Script thủ tục/transaction** *(bắt buộc)*:
   - `usp_CreateOrder`: tạo **1 order + nhiều order items** trong **1 transaction** (rollback nếu lỗi).
   - `usp_AddPayment`: thêm thanh toán; **chặn** tổng thanh toán vượt tổng tiền; **tự cập nhật** `Status` sang `Paid` nếu đủ.
5. **Script truy vấn demo**: `SimpleShopDB_DemoQueries.sql` (≥ 5 truy vấn)
   - Doanh thu theo **ngày** (30 ngày gần nhất).
   - **Top 10 sản phẩm** theo doanh thu 90 ngày.
   - **Top 10 khách hàng** theo tổng chi tiêu (LTV).
   - Phân bố **trạng thái đơn hàng**.
   - Trung bình **số dòng hàng/đơn**.
6. **README.md**: cách chạy script, mô tả cấu trúc, giả định nghiệp vụ.

---

## 6) Ràng buộc & luật nghiệp vụ chi tiết (để tự kiểm)
- `Products.SKU` **UNIQUE**; `Categories.CategoryName` **UNIQUE**; `Shippers.ShipperName` **UNIQUE**.
- `Orders.Status` trong tập cho phép; `Payments.Method` trong tập cho phép.
- `OrderItems.Quantity > 0`; `UnitPrice ≥ 0`; `0 ≤ Discount ≤ 1`.
- `Payments.Amount > 0`.
- `Shipments.TrackingNo` **UNIQUE** (nếu không null).
- `Orders` trạng thái `Shipped/Delivered` ⇒ có **1** `Shipments`.
- `Orders` trạng thái `Cancelled` ⇒ **không** có `Payments.Amount > 0`.
- `Orders` trạng thái `Paid/Shipped/Delivered` ⇒ tổng `Payments.Amount` **≥** tổng tiền hàng.

> **Lưu ý:** Ràng buộc về **tổng thanh toán vs tổng tiền đơn** nên kiểm soát bằng **transaction** trong `usp_AddPayment` (và/hoặc trigger).

---

## 7) Yêu cầu về chỉ mục (Indexes)
- Bắt buộc tối thiểu:
  - `IX_Orders_Customer_Date (CustomerID, OrderDate DESC) INCLUDE (Status)`
  - `IX_OrderItems_Product (ProductID) INCLUDE (Quantity, UnitPrice, Discount, LineTotal)`
  - `IX_Shipments_Order (OrderID) INCLUDE (ShippedAt, DeliveredAt, TrackingNo)`
- **Giải thích ngắn** vì sao cần các index trên (liên hệ truy vấn demo).

---

## 8) Bài kiểm thử tối thiểu (Acceptance checks)
- [ ] Không có 2 khách hàng cùng `Email` khác `NULL`.
- [ ] Không có 2 sản phẩm trùng `SKU`.
- [ ] Mỗi đơn: tổng `OrderItems.LineTotal` **≥ 0**.
- [ ] Đơn **`Cancelled`**: **không** có `Payments.Amount > 0`.
- [ ] Đơn **`Paid/Shipped/Delivered`**: tổng `Payments.Amount` **≥** tổng tiền hàng.
- [ ] Đơn **`Shipped/Delivered`**: có **đúng 1** `Shipments` (theo phạm vi đề này).

---

## 9) Lộ trình thực hiện gợi ý
1. Xác định thực thể–quan hệ → vẽ **ERD** (≥ 3NF).
2. Viết **DDL**: schema + ràng buộc + index.
3. Viết **seed nhỏ** để kiểm thử và chạy truy vấn demo.
4. Viết **stored procedures** với **transaction**; thử case lỗi/rollback.
5. Viết **acceptance checks** để tự chấm.
6. Soạn **README**.

---

## 10) Tiêu chí chấm điểm (tham khảo)
- **Thiết kế & chuẩn hoá** – *40%*: ERD rõ, 3NF/BCNF, PK/FK hợp lý.  
- **Ràng buộc & đúng nghiệp vụ** – *30%*: CHECK/UNIQUE/DEFAULT, SP/transaction đảm bảo quy tắc.  
- **Chất lượng SQL** – *15%*: đặt tên rõ, script idempotent, dễ chạy.  
- **Hiệu năng cơ bản** – *10%*: index hợp lý, truy vấn tận dụng index.  
- **Tài liệu** – *5%*: README, ghi chú assumptions.

---

### Gợi ý cấu trúc thư mục nộp
```text
/submission/
  ├─ ERD_SimpleShop.png
  ├─ SimpleShopDB_Create.sql
  ├─ SimpleShopDB_Seed.sql
  ├─ SimpleShopDB_StoredProcs.sql   -- usp_CreateOrder, usp_AddPayment (+ optional triggers)
  ├─ SimpleShopDB_DemoQueries.sql
  └─ README.md
```
