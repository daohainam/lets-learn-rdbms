CREATE OR ALTER PROCEDURE dbo.proc_GenerateRandomProducts
    @catId      INT,
    @totalRows  INT
AS
BEGIN
    SET NOCOUNT ON;

    IF @totalRows IS NULL OR @totalRows <= 0
        RETURN;

    ;WITH n AS
    (
        -- Tạo dãy số 1..@totalRows (không cần bảng numbers)
        SELECT TOP (@totalRows)
               ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn
        FROM sys.all_objects a
        CROSS JOIN sys.all_objects b
    )
    INSERT INTO dbo.Product (ProductName, SKU, CategoryId, UnitPrice, IsActive)
    SELECT
        -- ProductName ngẫu nhiên
        N'Product ' + CAST(n.rn AS NVARCHAR(20)) + N' - ' + LEFT(CONVERT(NVARCHAR(36), NEWID()), 8),

        -- SKU ngẫu nhiên (30 ký tự max)
        N'SKU-' + LEFT(REPLACE(CONVERT(NVARCHAR(36), NEWID()), N'-', N''), 10),

        -- CategoryId theo tham số
        @catId,

        -- UnitPrice ngẫu nhiên: 1.00 .. 999.99 (MONEY)
        CAST(1 + (ABS(CHECKSUM(NEWID())) % 999) + (ABS(CHECKSUM(NEWID())) % 100) / 100.0 AS MONEY),

        -- IsActive luôn 1
        CAST(1 AS BIT)
    FROM n;
END;
GO

-- EXEC dbo.proc_GenerateRandomProducts @catId = 3, @totalRows = 50000;
