CREATE TABLE Customer (
	CustomerId		INT PRIMARY KEY IDENTITY,
	CustomerName	NVARCHAR(100) NOT NULL,
	Email			NVARCHAR(60) NOT NULL,
	Phone			NVARCHAR(20) NOT NULL
)

CREATE TABLE Category (
	CategoryId		INT PRIMARY KEY IDENTITY,
	CategoryName	NVARCHAR(200) NOT NULL
)

CREATE TABLE Product (
	ProductId		INT PRIMARY KEY IDENTITY,
	ProductName		NVARCHAR(200) NOT NULL,
	SKU				NVARCHAR(30) NOT NULL,
	CategoryId		INT NOT NULL,
	UnitPrice		MONEY NOT NULL,
	IsActive		BIT NOT NULL,

	CONSTRAINT FK_Product_CategoryId FOREIGN KEY (CategoryId) REFERENCES Category(CategoryId)
)

CREATE TABLE [Order] (
	OrderId			INT PRIMARY KEY IDENTITY,
	CustomerId		INT NOT NULL,
	OrderDate		DATETIME NOT NULL,
	Status			NVARCHAR(10) NOT NULL, -- Pending | Paid | Shipped | Delivered | Cancelled

	CONSTRAINT FK_Order_CustomerId FOREIGN KEY (CustomerId) REFERENCES Customer(CustomerId)
)

CREATE TABLE OrderItem (
	OrderId			INT NOT NULL,
	ProductId		INT NOT NULL,
	Quantity		INT NOT NULL,
	UnitPrice		MONEY NOT NULL,
	Discount		FLOAT NOT NULL,
	LineTotal		MONEY NOT NULL,

	CONSTRAINT FK_OrderItem_OrderId FOREIGN KEY (OrderId) REFERENCES [Order](OrderId),
	CONSTRAINT FK_OrderItem_ProductId FOREIGN KEY (ProductId) REFERENCES Product(ProductId)
)

CREATE TABLE Payment (
	PaymentId		INT PRIMARY KEY IDENTITY,
	OrderId			INT NOT NULL,
	Amount			MONEY NOT NULL,
	Method			NVARCHAR(10) NOT NULL,
	PaidAt			DATETIME NOT NULL

	CONSTRAINT FK_Payment_OrderId FOREIGN KEY (OrderId) REFERENCES [Order](OrderId),
)

CREATE TABLE Shipper (
	ShipperId		INT PRIMARY KEY IDENTITY,
	ShipperName		NVARCHAR(100) NOT NULL,
	Phone			NVARCHAR(20) NOT NULL
)

CREATE TABLE Shipment (
	ShipmentId		INT PRIMARY KEY IDENTITY,
	OrderId			INT NOT NULL,
	ShipperId		INT NOT NULL,
	TrackingNo		NVARCHAR(50) NOT NULL,
	ShippedAt		DATETIME,
	DeliveredAt		DATETIME,

	CONSTRAINT FK_Shipment_OrderId FOREIGN KEY (OrderId) REFERENCES [Order](OrderId),
	CONSTRAINT FK_Shipment_ShipperId FOREIGN KEY (ShipperId) REFERENCES Shipper(ShipperId),

)
