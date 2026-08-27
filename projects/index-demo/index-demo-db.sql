/*
================================================================================
BÀI TẬP THỰC HÀNH: THIẾT KẾ & TỐI ƯU HÓA INDEX TRONG SQL SERVER
================================================================================
*/

-- =============================================================================
-- PHẦN 0: BẬT CÔNG CỤ ĐO LƯỜNG HIỆU NĂNG
-- Lưu ý: Trong SSMS, bấm Ctrl + M (hoặc bật nút 'Include Actual Execution Plan')
-- =============================================================================
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

-- =============================================================================
-- PHẦN 1: TẠO DATABASE VÀ CẤU TRÚC BẢNG DEMO
-- =============================================================================
IF DB_ID('IndexDemoDB') IS NOT NULL
BEGIN
    ALTER DATABASE IndexDemoDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE IndexDemoDB;
END
GO

CREATE DATABASE IndexDemoDB;
GO

USE IndexDemoDB;
GO

-- 1.1 Tạo bảng Orders (Bảng cha - Đơn hàng)
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY, -- Clustered Index mặc định
    CustomerID INT NOT NULL,
    OrderDate DATETIME NOT NULL,
    Status VARCHAR(20) NOT NULL,           -- 'Pending', 'Shipping', 'Completed', 'Cancelled'
    TotalAmount DECIMAL(18,2) NOT NULL,
    Notes NVARCHAR(200) NULL
);
GO

-- 1.2 Tạo bảng OrderDetails (Bảng con - Chi tiết đơn hàng)
CREATE TABLE OrderDetails (
    DetailID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(18,2) NOT NULL
);
GO

-- =============================================================================
-- PHẦN 2: SCRIPT SINH NHANH DỮ LIỆU DEMO (500.000 Orders, 1.500.000 Details)
-- =============================================================================
SET NOCOUNT ON;

PRINT N'Đang chèn 500.000 dòng vào bảng Orders...';

;WITH Numbers AS (
    SELECT TOP (500000) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM master.dbo.spt_values a
    CROSS JOIN master.dbo.spt_values b
)
INSERT INTO Orders (CustomerID, OrderDate, Status, TotalAmount, Notes)
SELECT 
    (n % 10000) + 1 AS CustomerID,                          -- 10.000 khách hàng
    DATEADD(MINUTE, -(n % 525600), GETDATE()) AS OrderDate, -- Dữ liệu trải trong 1 năm
    CASE 
        WHEN n % 100 < 5 THEN 'Pending'                     -- 5% Pending
        WHEN n % 100 < 15 THEN 'Shipping'                   -- 10% Shipping
        WHEN n % 100 < 95 THEN 'Completed'                  -- 80% Completed
        ELSE 'Cancelled'                                    -- 5% Cancelled
    END AS Status,
    CAST((n % 500) + 10.50 AS DECIMAL(18,2)) AS TotalAmount,
    CONCAT(N'Ghi chú đơn hàng số ', n) AS Notes
FROM Numbers;

PRINT N'Đang chèn 1.500.000 dòng vào bảng OrderDetails...';

INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice)
SELECT 
    o.OrderID,
    (o.OrderID % 500) + 1 AS ProductID,
    (o.OrderID % 5) + 1 AS Quantity,
    CAST((o.OrderID % 100) + 5.0 AS DECIMAL(18,2)) AS UnitPrice
FROM Orders o
CROSS JOIN (VALUES (1), (2), (3)) AS x(item);
GO

PRINT N'Khởi tạo dữ liệu hoàn tất!';
GO


-- =============================================================================
-- TÌNH HUỐNG 1: TÌM KIẾM NHIỀU ĐIỀU KIỆN & THỨ TỰ CỘT TRONG COMPOSITE INDEX
-- =============================================================================

SELECT OrderID, CustomerID, OrderDate, TotalAmount
FROM Orders
WHERE CustomerID = 1428 
  AND OrderDate BETWEEN '2026-01-01' AND '2026-06-30';
GO

CREATE NONCLUSTERED INDEX IX_Orders_Date_Cust 
ON Orders(OrderDate, CustomerID);
GO

SELECT OrderID, CustomerID, OrderDate, TotalAmount
FROM Orders
WHERE CustomerID = 1428 
  AND OrderDate BETWEEN '2026-01-01' AND '2026-06-30';
GO

DROP INDEX IX_Orders_Date_Cust ON Orders;
GO

CREATE NONCLUSTERED INDEX IX_Orders_Cust_Date 
ON Orders(CustomerID, OrderDate);
GO

SELECT OrderID, CustomerID, OrderDate, TotalAmount
FROM Orders
WHERE CustomerID = 1428 
  AND OrderDate BETWEEN '2026-01-01' AND '2026-06-30';
GO


-- =============================================================================
-- TÌNH HUỐNG 2: TRIỆT TIÊU KEY LOOKUP BẰNG COVERING INDEX (INCLUDE)
-- =============================================================================

SELECT OrderID, CustomerID, OrderDate, Status, TotalAmount
FROM Orders
WHERE CustomerID = 1428 
  AND OrderDate BETWEEN '2026-01-01' AND '2026-06-30';
GO

DROP INDEX IX_Orders_Cust_Date ON Orders;
GO

CREATE NONCLUSTERED INDEX IX_Orders_Covering_Cust_Date 
ON Orders(CustomerID, OrderDate)
INCLUDE (Status, TotalAmount);
GO

SELECT OrderID, CustomerID, OrderDate, Status, TotalAmount
FROM Orders
WHERE CustomerID = 1428 
  AND OrderDate BETWEEN '2026-01-01' AND '2026-06-30';
GO


-- =============================================================================
-- TÌNH HUỐNG 3: TỐI ƯU 'ORDER BY' + 'TOP N' (LOẠI BỎ TOÁN TỬ SORT)
-- =============================================================================

SELECT TOP 10 OrderID, OrderDate, CustomerID, TotalAmount
FROM Orders
WHERE Status = 'Completed'
ORDER BY OrderDate DESC;
GO

CREATE NONCLUSTERED INDEX IX_Orders_Status_OrderDate
ON Orders(Status, OrderDate DESC)
INCLUDE (CustomerID, TotalAmount);
GO

SELECT TOP 10 OrderID, OrderDate, CustomerID, TotalAmount
FROM Orders
WHERE Status = 'Completed'
ORDER BY OrderDate DESC;
GO


-- =============================================================================
-- TÌNH HUỐNG 4: TỐI ƯU FOREIGN KEY JOIN (BẢNG CHA - BẢNG CON)
-- =============================================================================

SELECT o.OrderID, o.OrderDate, d.ProductID, d.Quantity, d.UnitPrice
FROM Orders o
JOIN OrderDetails d ON o.OrderID = d.OrderID
WHERE o.CustomerID = 500;
GO

CREATE NONCLUSTERED INDEX IX_OrderDetails_OrderID 
ON OrderDetails(OrderID)
INCLUDE (ProductID, Quantity, UnitPrice);
GO

SELECT o.OrderID, o.OrderDate, d.ProductID, d.Quantity, d.UnitPrice
FROM Orders o
JOIN OrderDetails d ON o.OrderID = d.OrderID
WHERE o.CustomerID = 500;
GO


-- =============================================================================
-- TÌNH HUỐNG 5: FILTERED INDEX CHO DỮ LIỆU PHÂN BỐ KHÔNG ĐỀU (SKEWED DATA)
-- Mục tiêu: Tiết kiệm dung lượng Index và giảm tải ghi (INSERT/UPDATE)
-- =============================================================================

SELECT OrderID, OrderDate, CustomerID, TotalAmount
FROM Orders
WHERE Status = 'Pending';
GO

CREATE NONCLUSTERED INDEX IX_Orders_Pending
ON Orders(OrderDate)
INCLUDE (CustomerID, TotalAmount)
WHERE Status = 'Pending';
GO

SELECT OrderID, OrderDate, CustomerID, TotalAmount
FROM Orders
WHERE Status = 'Pending';
GO


-- =============================================================================
-- PHẦN 6: TRUY VẤN KIỂM TRA DUNG LƯỢNG VÀ THÔNG SỐ CỦA CÁC INDEX ĐÃ TẠO
-- =============================================================================
SELECT 
    i.name AS IndexName,
    t.name AS TableName,
    i.type_desc AS IndexType,
    i.has_filter AS IsFiltered,
    i.filter_definition AS FilterCondition,
    ps.page_count AS PagesUsed,
    CAST((ps.page_count * 8.0) / 1024 AS DECIMAL(10,2)) AS Size_MB,
    ps.record_count AS TotalRows
FROM sys.indexes i
JOIN sys.tables t ON i.object_id = t.object_id
CROSS APPLY sys.dm_db_index_physical_stats(DB_ID(), i.object_id, i.index_id, NULL, 'SAMPLED') ps
WHERE t.name IN ('Orders', 'OrderDetails')
ORDER BY t.name, i.name;
GO
