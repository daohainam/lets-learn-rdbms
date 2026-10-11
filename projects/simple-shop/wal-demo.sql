/*
================================================================================
BÀI THỰC HÀNH: WRITE-AHEAD LOGGING (WAL), DIRTY PAGES & CHECKPOINT
Database: SimpleShop
Công cụ: sys.fn_dblog, sys.dm_os_buffer_descriptors, CHECKPOINT
================================================================================
*/

USE SimpleShop;
GO

-- =============================================================================
-- BƯỚC 1: DỌN DẸP SẠCH RAM ĐỂ BẮT ĐẦU QUAN SÁT (MÔI TRƯỜNG THỰC NGHIỆM)
-- =============================================================================

-- Đưa toàn bộ dirty pages hiện tại xuống đĩa
CHECKPOINT;
GO

-- =============================================================================
-- BƯỚC 2: QUAN SÁT CÁC TRANG DỮ LIỆU CỦA BẢNG PRODUCT TRÊN BỘ NHỚ RAM
-- Sử dụng DMV sys.dm_os_buffer_descriptors
-- =============================================================================

SELECT 
    OBJECT_NAME(p.object_id) AS TableName,
    b.page_id,
    b.page_type,
    b.is_modified AS IsDirtyPage, -- 1 = Dirty Page (chỉ có trên RAM), 0 = Clean Page (đã đồng bộ xuống đĩa)
    b.numa_node
FROM sys.dm_os_buffer_descriptors b
JOIN sys.allocation_units a ON b.allocation_unit_id = a.allocation_unit_id
JOIN sys.partitions p ON a.container_id = p.hobt_id
WHERE b.database_id = DB_ID('SimpleShop')
  AND p.object_id = OBJECT_ID('Product');
GO


-- =============================================================================
-- BƯỚC 3: THỰC THI THAY ĐỔI DỮ LIỆU & QUAN SÁT WAL
-- =============================================================================

-- Kiểm tra giá trị hiện tại của sản phẩm Id = 1
SELECT Id, Name, UnitPrice FROM Product WHERE Id = 1;
GO

-- Bắt đầu một Transaction rõ ràng
BEGIN TRANSACTION;

-- Thực hiện sửa giá sản phẩm
UPDATE Product
SET UnitPrice = UnitPrice + 10000
WHERE Id = 1;

-- LÚC NÀY TRANSACTION CHƯA COMMIT:
-- 1. Trang dữ liệu chứa sản phẩm 1 trên RAM đã biến thành Dirty Page (is_modified = 1).
-- 2. Thay đổi đã được ghi vào Log Buffer.
GO

-- =============================================================================
-- BƯỚC 4: "SOI" BÊN TRONG TRANSACTION LOG BẰNG HÀM ẨN sys.fn_dblog
-- =============================================================================

-- Xem các bản ghi log vừa sinh ra cho transaction hiện tại
SELECT 
    [Current LSN],              -- Log Sequence Number (Số thứ tự nhật ký)
    [Operation],                -- Loại thao tác (LOP_MODIFY_ROW, LOP_BEGIN_XACT,...)
    [Context],                  -- Ngữ cảnh (LCX_HEAP, LCX_CLUSTERED,...)
    [Transaction ID],
    [AllocUnitName],            -- Tên bảng/index bị tác động
    [Page ID],                  -- ID của trang bị sửa đổi
    [Slot ID]                   -- Vị trí dòng bị sửa đổi trong trang
FROM sys.fn_dblog(NULL, NULL)
WHERE [AllocUnitName] LIKE '%Product%'
   OR [Operation] = 'LOP_BEGIN_XACT';
GO

-- Xác nhận lưu giao dịch
COMMIT TRANSACTION;
GO

-- =============================================================================
-- BƯỚC 5: CHỨNG MINH DỮ LIỆU ĐÃ COMMIT NHƯNG VẪN LÀ DIRTY PAGE (CHƯA VÀO .MDF)
-- =============================================================================

SELECT 
    OBJECT_NAME(p.object_id) AS TableName,
    b.page_id,
    b.page_type,
    b.is_modified AS IsDirtyPage -- Quan sát: Giá trị VẪN LÀ 1!
FROM sys.dm_os_buffer_descriptors b
JOIN sys.allocation_units a ON b.allocation_unit_id = a.allocation_unit_id
JOIN sys.partitions p ON a.container_id = p.hobt_id
WHERE b.database_id = DB_ID('SimpleShop')
  AND p.object_id = OBJECT_ID('Product');
GO


-- =============================================================================
-- BƯỚC 6: KÍCH HOẠT CHECKPOINT THỦ CÔNG ĐỂ ÉP ĐẨY DỮ LIỆU XUỐNG FILE .MDF
-- =============================================================================

-- Lệnh Checkpoint buộc SQL Server quét tất cả Dirty Pages và ghi xuống đĩa .mdf
CHECKPOINT;
GO

-- Kiểm tra lại trạng thái trang trong RAM:
-- Lúc này IsDirtyPage đã chuyển thành 0 (Clean Page)!
SELECT 
    OBJECT_NAME(p.object_id) AS TableName,
    b.page_id,
    b.page_type,
    b.is_modified AS IsDirtyPage -- Giá trị BÂY GIỜ LÀ 0!
FROM sys.dm_os_buffer_descriptors b
JOIN sys.allocation_units a ON b.allocation_unit_id = a.allocation_unit_id
JOIN sys.partitions p ON a.container_id = p.hobt_id
WHERE b.database_id = DB_ID('SimpleShop')
  AND p.object_id = OBJECT_ID('Product');
GO


-- =============================================================================
-- BƯỚC 7: XEM CƠ CHẾ ROLLBACK TRONG TRANSACTION LOG
-- Khi ROLLBACK xảy ra, WAL ghi nhận điều gì?
-- =============================================================================

BEGIN TRANSACTION;

UPDATE Product
SET UnitPrice = 99999999
WHERE Id = 1;

-- Hủy bỏ giao dịch
ROLLBACK TRANSACTION;
GO

-- Xem lại log: SQL Server không xóa log cũ, mà ghi thêm các dòng bù trừ 
-- (Compensation Log Records - LOP_MODIFY_ROW đảo ngược và LOP_ABORT_XACT)
SELECT TOP 10
    [Current LSN],
    [Operation],
    [Context],
    [Transaction ID],
    [Description]
FROM sys.fn_dblog(NULL, NULL)
ORDER BY [Current LSN] DESC;
GO
