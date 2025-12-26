
USE SimpleShop;
GO
SET NOCOUNT ON;

PRINT '=== Seed (SMALL) for SimpleShopDB ===';

------------------------------------------------------------
-- 1) Master data: Categories, Products, Customers, Shippers
------------------------------------------------------------
-- Categories (6)
IF NOT EXISTS (SELECT 1 FROM dbo.Category)
BEGIN
  INSERT dbo.Category(CategoryName) VALUES
    (N'Beverages'),
    (N'Snacks'),
    (N'Bakery'),
    (N'Dairy'),
    (N'Household'),
    (N'Personal Care'),
  	(N'Electronics'),
	  (N'Garden');
END

-- Products (12) with explicit SKUs
;WITH P AS (
  SELECT * FROM (VALUES
    (N'BEV001', N'Cà phê lon',  N'Beverages', 18000.00),
    (N'BEV002', N'Trà chanh',    N'Beverages', 15000.00),
    (N'BEV003', N'Nước cam',     N'Beverages', 17000.00),
    (N'SNK001', N'Khoai tây',    N'Snacks',    22000.00),
    (N'SNK002', N'Bánh quy',     N'Snacks',    25000.00),
    (N'BAK001', N'Bánh mì',      N'Bakery',    12000.00),
    (N'BAK002', N'Bánh bông lan',N'Bakery',    18000.00),
    (N'DAI001', N'Sữa tươi',     N'Dairy',     23000.00),
    (N'DAI002', N'Sữa chua',     N'Dairy',     19000.00),
    (N'HHD001', N'Nước rửa chén',N'Household', 34000.00),
    (N'HHD002', N'Nước lau sàn', N'Household', 36000.00),
    (N'PRC001', N'Bàn chải',     N'Personal Care', 15000.00)
  ) AS t(SKU, ProductName, CategoryName, UnitPrice)
)
INSERT dbo.Product(ProductName, SKU, CategoryID, UnitPrice, IsActive)
SELECT p.ProductName, p.SKU, c.CategoryID, p.UnitPrice, 1
FROM P p
JOIN dbo.Category c ON c.CategoryName = p.CategoryName
WHERE NOT EXISTS (SELECT 1 FROM dbo.Product x WHERE x.SKU = p.SKU);

-- Customers (10)
;WITH C AS (
  SELECT * FROM (VALUES
    (N'Nguyễn An',   N'an@example.com',    N'0901000111'),
    (N'Trần Bình',   N'binh@example.com',  N'0902000222'),
    (N'Lê Chi',      N'chi@example.com',   N'0903000333'),
    (N'Phạm Dũng',   N'dung@example.com',  N'0904000444'),
    (N'Võ Em',       N'em@example.com',    N'0905000555'),
    (N'Đỗ Gia',      N'gia@example.com',   N'0906000666'),
    (N'Bùi Hạnh',    N'hanh@example.com',  N'0907000777'),
    (N'Đặng Khoa',   N'khoa@example.com',  N'0908000888'),
    (N'Phan Lan',    N'lan@example.com',   N'0909000999'),
    (N'Vũ Minh',     N'minh@example.com',  N'0910000111')
  ) AS t(CustomerName, Email, Phone)
)
INSERT dbo.Customer(CustomerName, Email, Phone)
SELECT c.CustomerName, c.Email, c.Phone
FROM C c
WHERE NOT EXISTS (SELECT 1 FROM dbo.Customer x WHERE x.Email = c.Email);

-- Shippers (3)
INSERT dbo.Shipper(ShipperName, Phone)
SELECT v.ShipperName, v.Phone
FROM (VALUES
  (N'GiaoNhanNhanh', N'0933000333'),
  (N'NhanhShip',     N'0933111222'),
  (N'VietShip',      N'0933333444')
) AS v(ShipperName, Phone)
WHERE NOT EXISTS (SELECT 1 FROM dbo.Shipper s WHERE s.ShipperName = v.ShipperName);

------------------------------------------------------------
-- 2) Orders + OrderItems + Payments + Shipments
--    12 orders across multiple statuses
------------------------------------------------------------
DECLARE @now DATETIME2(0) = SYSUTCDATETIME();

-- Helper: get IDs by natural keys
DECLARE @cust1 INT = (SELECT CustomerID FROM dbo.Customer WHERE Email = N'an@example.com');
DECLARE @cust2 INT = (SELECT CustomerID FROM dbo.Customer WHERE Email = N'binh@example.com');
DECLARE @cust3 INT = (SELECT CustomerID FROM dbo.Customer WHERE Email = N'chi@example.com');
DECLARE @cust4 INT = (SELECT CustomerID FROM dbo.Customer WHERE Email = N'dung@example.com');
DECLARE @cust5 INT = (SELECT CustomerID FROM dbo.Customer WHERE Email = N'em@example.com');
DECLARE @cust6 INT = (SELECT CustomerID FROM dbo.Customer WHERE Email = N'gia@example.com');

DECLARE @sku_bev1 INT = (SELECT ProductID FROM dbo.Product WHERE SKU = N'BEV001');
DECLARE @sku_bev2 INT = (SELECT ProductID FROM dbo.Product WHERE SKU = N'BEV002');
DECLARE @sku_bev3 INT = (SELECT ProductID FROM dbo.Product WHERE SKU = N'BEV003');
DECLARE @sku_snk1 INT = (SELECT ProductID FROM dbo.Product WHERE SKU = N'SNK001');
DECLARE @sku_snk2 INT = (SELECT ProductID FROM dbo.Product WHERE SKU = N'SNK002');
DECLARE @sku_bak1 INT = (SELECT ProductID FROM dbo.Product WHERE SKU = N'BAK001');
DECLARE @sku_bak2 INT = (SELECT ProductID FROM dbo.Product WHERE SKU = N'BAK002');
DECLARE @sku_dai1 INT = (SELECT ProductID FROM dbo.Product WHERE SKU = N'DAI001');
DECLARE @sku_dai2 INT = (SELECT ProductID FROM dbo.Product WHERE SKU = N'DAI002');
DECLARE @sku_hhd1 INT = (SELECT ProductID FROM dbo.Product WHERE SKU = N'HHD001');
DECLARE @sku_hhd2 INT = (SELECT ProductID FROM dbo.Product WHERE SKU = N'HHD002');
DECLARE @sku_prc1 INT = (SELECT ProductID FROM dbo.Product WHERE SKU = N'PRC001');

-- Only seed orders if table is empty (fresh DB)
IF NOT EXISTS (SELECT 1 FROM dbo.[Order])
BEGIN
  SET XACT_ABORT ON;

  --------------------------------------
  -- O1: Pending (no payment, no shipment)
  --------------------------------------
  BEGIN TRAN;
    DECLARE @o1 INT;
    INSERT dbo.[Order](CustomerID, OrderDate, Status) VALUES (@cust1, DATEADD(day,-2,@now), N'Pending');
    SET @o1 = SCOPE_IDENTITY();
    INSERT dbo.OrderItem(OrderID, ProductID, Quantity, UnitPrice, Discount, LineTotal)
    SELECT @o1, p.ProductID, v.Qty, p.UnitPrice, v.Discount, v.Qty * p.UnitPrice * (1.0 - v.Discount)
    FROM dbo.Product p
    JOIN (VALUES
      (@sku_bev1, 2, 0.00),
      (@sku_snk1, 1, 0.05)
    ) AS v(ProductID, Qty, Discount) ON v.ProductID = p.ProductID;
  COMMIT;

  --------------------------------------
  -- O2: Paid (payments == total, no shipment)
  --------------------------------------
  BEGIN TRAN;
    DECLARE @o2 INT, @tot2 DECIMAL(18,2);
    INSERT dbo.[Order](CustomerID, OrderDate, Status) VALUES (@cust2, DATEADD(day,-3,@now), N'Pending');
    SET @o2 = SCOPE_IDENTITY();
    INSERT dbo.OrderItem(OrderID, ProductID, Quantity, UnitPrice, Discount, LineTotal)
    SELECT @o2, p.ProductID, v.Qty, p.UnitPrice, v.Discount, v.Qty * p.UnitPrice * (1.0 - v.Discount)
    FROM dbo.Product p
    JOIN (VALUES
      (@sku_bak1, 3, 0.00),
      (@sku_bev2, 1, 0.10)
    ) AS v(ProductID, Qty, Discount) ON v.ProductID = p.ProductID;
    SELECT @tot2 = SUM(LineTotal) FROM dbo.OrderItem WHERE OrderID = @o2;
    INSERT dbo.Payment(OrderID, Amount, Method, PaidAt) VALUES (@o2, @tot2, N'Card', DATEADD(hour,-48,@now));
    UPDATE dbo.[Order] SET Status = N'Paid' WHERE OrderID = @o2;
  COMMIT;

  --------------------------------------
  -- O3: Shipped (has shipment, fully paid)
  --------------------------------------
  BEGIN TRAN;
    DECLARE @o3 INT, @tot3 DECIMAL(18,2);
    INSERT dbo.[Order](CustomerID, OrderDate, Status) VALUES (@cust3, DATEADD(day,-5,@now), N'Pending');
    SET @o3 = SCOPE_IDENTITY();
    INSERT dbo.OrderItem(OrderID, ProductID, Quantity, UnitPrice, Discount, LineTotal)
    SELECT @o3, p.ProductID, v.Qty, p.UnitPrice, v.Discount, v.Qty * p.UnitPrice * (1.0 - v.Discount)
    FROM dbo.Product p
    JOIN (VALUES
      (@sku_dai1, 2, 0.00),
      (@sku_bak2, 2, 0.05)
    ) AS v(ProductID, Qty, Discount) ON v.ProductID = p.ProductID;
    SELECT @tot3 = SUM(LineTotal) FROM dbo.OrderItem WHERE OrderID = @o3;
    INSERT dbo.Payment(OrderID, Amount, Method, PaidAt) VALUES (@o3, @tot3, N'Transfer', DATEADD(day,-4,@now));
    INSERT dbo.Shipment(OrderID, ShipperID, TrackingNo, ShippedAt)
    VALUES (@o3, (SELECT TOP 1 ShipperID FROM dbo.Shipper ORDER BY ShipperID),
            CONCAT(N'TRK-', RIGHT('0000000'+CAST(@o3 AS NVARCHAR(7)),7)), DATEADD(day,-3,@now));
    UPDATE dbo.[Order] SET Status = N'Shipped' WHERE OrderID = @o3;
  COMMIT;

  --------------------------------------
  -- O4: Delivered (has shipment with DeliveredAt, paid)
  --------------------------------------
  BEGIN TRAN;
    DECLARE @o4 INT, @tot4 DECIMAL(18,2);
    INSERT dbo.[Order](CustomerID, OrderDate, Status) VALUES (@cust4, DATEADD(day,-10,@now), N'Pending');
    SET @o4 = SCOPE_IDENTITY();
    INSERT dbo.OrderItem(OrderID, ProductID, Quantity, UnitPrice, Discount, LineTotal)
    SELECT @o4, p.ProductID, v.Qty, p.UnitPrice, v.Discount, v.Qty * p.UnitPrice * (1.0 - v.Discount)
    FROM dbo.Product p
    JOIN (VALUES
      (@sku_hhd1, 1, 0.00),
      (@sku_prc1, 2, 0.00),
      (@sku_bev3, 1, 0.05)
    ) AS v(ProductID, Qty, Discount) ON v.ProductID = p.ProductID;
    SELECT @tot4 = SUM(LineTotal) FROM dbo.OrderItem WHERE OrderID = @o4;
    INSERT dbo.Payment(OrderID, Amount, Method, PaidAt) VALUES (@o4, @tot4, N'Cash', DATEADD(day,-9,@now));
    INSERT dbo.Shipment(OrderID, ShipperID, TrackingNo, ShippedAt, DeliveredAt)
    VALUES (@o4, (SELECT TOP 1 ShipperID FROM dbo.Shipper ORDER BY ShipperID DESC),
            CONCAT(N'TRK-', RIGHT('0000000'+CAST(@o4 AS NVARCHAR(7)),7)),
            DATEADD(day,-8,@now), DATEADD(day,-7,@now));
    UPDATE dbo.[Order] SET Status = N'Delivered' WHERE OrderID = @o4;
  COMMIT;

  --------------------------------------
  -- O5: Cancelled (no payments, no shipment)
  --------------------------------------
  BEGIN TRAN;
    DECLARE @o5 INT;
    INSERT dbo.[Order](CustomerID, OrderDate, Status) VALUES (@cust5, DATEADD(day,-1,@now), N'Cancelled');
    SET @o5 = SCOPE_IDENTITY();
    INSERT dbo.OrderItem(OrderID, ProductID, Quantity, UnitPrice, Discount, LineTotal)
    SELECT @o5, p.ProductID, v.Qty, p.UnitPrice, v.Discount, v.Qty * p.UnitPrice * (1.0 - v.Discount)
    FROM dbo.Product p
    JOIN (VALUES
      (@sku_snk2, 2, 0.00),
      (@sku_bak1, 1, 0.00)
    ) AS v(ProductID, Qty, Discount) ON v.ProductID = p.ProductID;
  COMMIT;

  --------------------------------------
  -- O6: Pending (variety)
  --------------------------------------
  BEGIN TRAN;
    DECLARE @o6 INT;
    INSERT dbo.[Order](CustomerID, OrderDate, Status) VALUES (@cust6, DATEADD(hour,-12,@now), N'Pending');
    SET @o6 = SCOPE_IDENTITY();
    INSERT dbo.OrderItem(OrderID, ProductID, Quantity, UnitPrice, Discount, LineTotal)
    SELECT @o6, p.ProductID, v.Qty, p.UnitPrice, v.Discount, v.Qty * p.UnitPrice * (1.0 - v.Discount)
    FROM dbo.Product p
    JOIN (VALUES
      (@sku_dai2, 3, 0.00)
    ) AS v(ProductID, Qty, Discount) ON v.ProductID = p.ProductID;
  COMMIT;

  --------------------------------------
  -- Add 6 more orders via loop (Paid or Delivered)
  --------------------------------------
  DECLARE @i INT = 1;
  WHILE @i <= 6
  BEGIN
    BEGIN TRAN;
      DECLARE @oid INT, @tot DECIMAL(18,2), @cust INT, @pid1 INT, @pid2 INT;
      SET @cust = CASE WHEN @i % 2 = 0 THEN @cust1 ELSE @cust2 END;
      INSERT dbo.[Order](CustomerID, OrderDate, Status)
      VALUES (@cust, DATEADD(day, - (7 + @i), @now), N'Pending');
      SET @oid = SCOPE_IDENTITY();

      -- two items
      SET @pid1 = CASE WHEN @i IN (1,3,5) THEN @sku_bev1 ELSE @sku_hhd2 END;
      SET @pid2 = CASE WHEN @i IN (2,4,6) THEN @sku_snk1 ELSE @sku_bak2 END;

      INSERT dbo.OrderItem(OrderID, ProductID, Quantity, UnitPrice, Discount, LineTotal)
      SELECT @oid, p.ProductID, v.Qty, p.UnitPrice, v.Discount, v.Qty * p.UnitPrice * (1.0 - v.Discount)
      FROM dbo.Product p
      JOIN (VALUES
        (@pid1, 1, 0.00),
        (@pid2, 2, 0.05)
      ) AS v(ProductID, Qty, Discount) ON v.ProductID = p.ProductID;

      SELECT @tot = SUM(LineTotal) FROM dbo.OrderItem WHERE OrderID = @oid;
      INSERT dbo.Payment(OrderID, Amount, Method, PaidAt)
      VALUES (@oid, @tot, N'E-Wallet', DATEADD(day, - (6 + @i), @now));

      IF @i % 3 = 0
      BEGIN
        INSERT dbo.Shipment(OrderID, ShipperID, TrackingNo, ShippedAt, DeliveredAt)
        VALUES (@oid, (SELECT TOP 1 ShipperID FROM dbo.Shipper ORDER BY NEWID()),
                CONCAT(N'TRK-', RIGHT('0000000'+CAST(@oid AS NVARCHAR(7)),7)),
                DATEADD(day, - (5 + @i), @now), DATEADD(day, - (4 + @i), @now));
        UPDATE dbo.[Order] SET Status = N'Delivered' WHERE OrderID = @oid;
      END
      ELSE
      BEGIN
        UPDATE dbo.[Order] SET Status = N'Paid' WHERE OrderID = @oid;
      END
    COMMIT;
    SET @i += 1;
  END
END

PRINT '=== Seed SMALL completed ===';
GO

-- Quick sanity checks
SELECT COUNT(*) AS Categories FROM dbo.Category;
SELECT COUNT(*) AS Products   FROM dbo.Product;
SELECT COUNT(*) AS Customers  FROM dbo.Customer;
SELECT COUNT(*) AS Orders     FROM dbo.[Order];
SELECT COUNT(*) AS OrderItems FROM dbo.OrderItem;
SELECT COUNT(*) AS Payments   FROM dbo.Payment;
SELECT COUNT(*) AS Shippers   FROM dbo.Shipper;
SELECT COUNT(*) AS Shipments  FROM dbo.Shipment;
