USE WideWorldImporters
GO

SET NOCOUNT, XACT_ABORT ON;
GO

SET STATISTICS io, time on;

select distinct t.name
from sys.partitions p
inner join sys.tables t
	on p.object_id = t.object_id
where p.partition_number <> 1


--выбираем таблицу-кандидат (секции примерно одинаковы, за исключением секции за 2016 год, скорее всего, просто нет записей за весь год)
SELECT COUNT(*), YEAR(OrderDate)
FROM Sales.Orders
GROUP BY YEAR(OrderDate)



--создадим файловую группу
ALTER DATABASE [WideWorldImporters] ADD FILEGROUP [YearData]
GO

--добавляем файл БД
ALTER DATABASE [WideWorldImporters] ADD FILE 
( NAME = N'Years', FILENAME = N'C:\work\learn\otus-mssql-evorozheina\HW32\Yeardata.ndf' , 
SIZE = 1097152KB , FILEGROWTH = 65536KB ) TO FILEGROUP [YearData]
GO


DROP TABLE IF EXISTS [Sales].[OrdersYears];
DROP PARTITION SCHEME [schmYearPartition];
DROP PARTITION FUNCTION [fnYearPartition];

--создаем функцию партиционирования по годам

CREATE PARTITION FUNCTION [fnYearPartition](DATE) AS RANGE RIGHT FOR VALUES
('20130101','20140101','20150101','20160101', '20170101', '20180101', '20190101', '20200101', '20210101', '20220101', '20230101', '20240101');																																																									
GO

-- партиционируем, используя созданную нами функцию
CREATE PARTITION SCHEME [schmYearPartition] AS PARTITION [fnYearPartition] 
ALL TO ([YearData])
GO

CREATE TABLE [Sales].[OrdersYears](
	[OrderID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[SalespersonPersonID] [int] NOT NULL,
	[PickedByPersonID] [int] NULL,
	[ContactPersonID] [int] NOT NULL,
	[BackorderOrderID] [int] NULL,
	[OrderDate] [date] NOT NULL,
	[ExpectedDeliveryDate] [date] NOT NULL,
	[CustomerPurchaseOrderNumber] [nvarchar](20) NULL,
	[IsUndersupplyBackordered] [bit] NOT NULL,
	[Comments] [nvarchar](max) NULL,
	[DeliveryInstructions] [nvarchar](max) NULL,
	[InternalComments] [nvarchar](max) NULL,
	[PickingCompletedWhen] [datetime2](7) NULL,
	[LastEditedBy] [int] NOT NULL,
	[LastEditedWhen] [datetime2](7) NOT NULL,
) ON [schmYearPartition]([OrderDate])
GO

ALTER TABLE [Sales].[OrdersYears] ADD CONSTRAINT PK_Sales_OrdersYears 
PRIMARY KEY CLUSTERED  (OrderDate, OrderID)
 ON [schmYearPartition]([OrderDate]);

INSERT INTO Sales.OrdersYears
(
    OrderID,
    CustomerID,
    SalespersonPersonID,
    PickedByPersonID,
    ContactPersonID,
    BackorderOrderID,
    OrderDate,
    ExpectedDeliveryDate,
    CustomerPurchaseOrderNumber,
    IsUndersupplyBackordered,
    Comments,
    DeliveryInstructions,
    InternalComments,
    PickingCompletedWhen,
    LastEditedBy,
    LastEditedWhen
)
SELECT OrderID, CustomerID, SalespersonPersonID, PickedByPersonID, ContactPersonID, BackorderOrderID, OrderDate, ExpectedDeliveryDate,
	CustomerPurchaseOrderNumber, IsUndersupplyBackordered, Comments, DeliveryInstructions, InternalComments, PickingCompletedWhen,
	LastEditedBy, LastEditedWhen
FROM Sales.Orders
GO

SELECT 
	OrdYears.OrderID, OrdYears.OrderDate, 
	OrdLines.Quantity, OrdLines.StockItemID
FROM Sales.OrdersYears AS OrdYears
	JOIN Sales.OrderLines AS OrdLines
		ON OrdYears.OrderID = OrdLines.OrderID
WHERE OrdYears.OrderDate > '20160101'
		AND OrdYears.OrderDate < '20160501'; 
