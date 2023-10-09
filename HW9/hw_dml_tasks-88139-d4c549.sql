/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "10 - Операторы изменения данных".

Задания выполняются с использованием базы данных WideWorldImporters.

Бэкап БД можно скачать отсюда:
https://github.com/Microsoft/sql-server-samples/releases/tag/wide-world-importers-v1.0
Нужен WideWorldImporters-Full.bak

Описание WideWorldImporters от Microsoft:
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-what-is
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-oltp-database-catalog
*/

-- ---------------------------------------------------------------------------
-- Задание - написать выборки для получения указанных ниже данных.
-- ---------------------------------------------------------------------------

USE WideWorldImporters;

DROP TABLE IF EXISTS #ForInsertCustomers;
CREATE TABLE #ForInsertCustomers
(
	CustomerID							INT,
    CustomerName						NVARCHAR(100),
    BillToCustomerID					INT,
    CustomerCategoryID					INT,
    BuyingGroupID						INT,
    PrimaryContactPersonID				INT,
    AlternateContactPersonID			INT,
    DeliveryMethodID					INT,
    DeliveryCityID						INT,
    PostalCityID						INT,
    CreditLimit							DECIMAL(18, 2),
    AccountOpenedDate					DATE,
    StandardDiscountPercentage			DECIMAL(18, 3),
    IsStatementSent						BIT,
    IsOnCreditHold						BIT,
    PaymentDays							INT,
    PhoneNumber							NVARCHAR(20),
    FaxNumber							NVARCHAR(20),
    DeliveryRun							NVARCHAR(5),
    RunPosition							NVARCHAR(5),
    WebsiteURL							NVARCHAR(256),
    DeliveryAddressLine1				NVARCHAR(60),
    DeliveryAddressLine2				NVARCHAR(60),
    DeliveryPostalCode					NVARCHAR(10),
    DeliveryLocation					GEOGRAPHY,
    PostalAddressLine1					NVARCHAR(60),
    PostalAddressLine2					NVARCHAR(60),
    PostalPostalCode					NVARCHAR(10),
    LastEditedBy						INT
);

INSERT INTO Sales.Customers
(
    CustomerID,
    CustomerName,
    BillToCustomerID,
    CustomerCategoryID,
    BuyingGroupID,
    PrimaryContactPersonID,
    AlternateContactPersonID,
    DeliveryMethodID,
    DeliveryCityID,
    PostalCityID,
    CreditLimit,
    AccountOpenedDate,
    StandardDiscountPercentage,
    IsStatementSent,
    IsOnCreditHold,
    PaymentDays,
    PhoneNumber,
    FaxNumber,
    DeliveryRun,
    RunPosition,
    WebsiteURL,
    DeliveryAddressLine1,
    DeliveryAddressLine2,
    DeliveryPostalCode,
    DeliveryLocation,
    PostalAddressLine1,
    PostalAddressLine2,
    PostalPostalCode,
    LastEditedBy
)
VALUES
(   1062,   -- CustomerID - int
    N'Test Shop Tailspin Toys (1)',       -- CustomerName - nvarchar(100)
    1,         -- BillToCustomerID - int
    3,         -- CustomerCategoryID - int
    1,      -- BuyingGroupID - int
    1002,         -- PrimaryContactPersonID - int
    1003,      -- AlternateContactPersonID - int
    3,         -- DeliveryMethodID - int
    12152,         -- DeliveryCityID - int
    12152,         -- PostalCityID - int
    NULL,      -- CreditLimit - decimal(18, 2)
    GETDATE(), -- AccountOpenedDate - date
    0,      -- StandardDiscountPercentage - decimal(18, 3)
    0,      -- IsStatementSent - bit
    0,      -- IsOnCreditHold - bit
    7,         -- PaymentDays - int
    N'(423) 555-2100',       -- PhoneNumber - nvarchar(20)
    N'(423) 555-2101',       -- FaxNumber - nvarchar(20)
    NULL,      -- DeliveryRun - nvarchar(5)
    NULL,      -- RunPosition - nvarchar(5)
    N'http://www.tailspintoys.com/Frankewing_test_shop_1',       -- WebsiteURL - nvarchar(256)
    N'Shop 27/1',       -- DeliveryAddressLine1 - nvarchar(60)
    NULL,      -- DeliveryAddressLine2 - nvarchar(60)
    N'90761',       -- DeliveryPostalCode - nvarchar(10)
    NULL,      -- DeliveryLocation - geography
    N'PO Box 5684/1',       -- PostalAddressLine1 - nvarchar(60)
    NULL,      -- PostalAddressLine2 - nvarchar(60)
    N'90761',       -- PostalPostalCode - nvarchar(10)
    1          -- LastEditedBy - int
    ),
(   1064,   -- CustomerID - int
    N'Test Shop Tailspin Toys (3A)',       -- CustomerName - nvarchar(100)
    1,         -- BillToCustomerID - int
    3,         -- CustomerCategoryID - int
    1,      -- BuyingGroupID - int
    1006,         -- PrimaryContactPersonID - int
    1007,      -- AlternateContactPersonID - int
    3,         -- DeliveryMethodID - int
    12152,         -- DeliveryCityID - int
    12152,         -- PostalCityID - int
    NULL,      -- CreditLimit - decimal(18, 2)
    GETDATE(), -- AccountOpenedDate - date
    0,      -- StandardDiscountPercentage - decimal(18, 3)
    0,      -- IsStatementSent - bit
    0,      -- IsOnCreditHold - bit
    7,         -- PaymentDays - int
    N'(423) 555-4100',       -- PhoneNumber - nvarchar(20)
    N'(423) 555-4101',       -- FaxNumber - nvarchar(20)
    NULL,      -- DeliveryRun - nvarchar(5)
    NULL,      -- RunPosition - nvarchar(5)
    N'http://www.tailspintoys.com/Frankewing_test_shop_3',       -- WebsiteURL - nvarchar(256)
    N'Shop 27/3',       -- DeliveryAddressLine1 - nvarchar(60)
    NULL,      -- DeliveryAddressLine2 - nvarchar(60)
    N'90761',       -- DeliveryPostalCode - nvarchar(10)
    NULL,      -- DeliveryLocation - geography
    N'PO Box 5684/3',       -- PostalAddressLine1 - nvarchar(60)
    NULL,      -- PostalAddressLine2 - nvarchar(60)
    N'90761',       -- PostalPostalCode - nvarchar(10)
    1          -- LastEditedBy - int
    );





/*
1. Довставлять в базу пять записей используя insert в таблицу Customers или Suppliers 
*/
SELECT *
FROM Sales.Customers;

INSERT INTO Sales.Customers
(
    CustomerID,
    CustomerName,
    BillToCustomerID,
    CustomerCategoryID,
    BuyingGroupID,
    PrimaryContactPersonID,
    AlternateContactPersonID,
    DeliveryMethodID,
    DeliveryCityID,
    PostalCityID,
    CreditLimit,
    AccountOpenedDate,
    StandardDiscountPercentage,
    IsStatementSent,
    IsOnCreditHold,
    PaymentDays,
    PhoneNumber,
    FaxNumber,
    DeliveryRun,
    RunPosition,
    WebsiteURL,
    DeliveryAddressLine1,
    DeliveryAddressLine2,
    DeliveryPostalCode,
    DeliveryLocation,
    PostalAddressLine1,
    PostalAddressLine2,
    PostalPostalCode,
    LastEditedBy
)
VALUES
(   DEFAULT,   -- CustomerID - int
    N'Test Shop Tailspin Toys (1)',       -- CustomerName - nvarchar(100)
    1,         -- BillToCustomerID - int
    3,         -- CustomerCategoryID - int
    1,      -- BuyingGroupID - int
    1002,         -- PrimaryContactPersonID - int
    1003,      -- AlternateContactPersonID - int
    3,         -- DeliveryMethodID - int
    12152,         -- DeliveryCityID - int
    12152,         -- PostalCityID - int
    NULL,      -- CreditLimit - decimal(18, 2)
    GETDATE(), -- AccountOpenedDate - date
    0,      -- StandardDiscountPercentage - decimal(18, 3)
    0,      -- IsStatementSent - bit
    0,      -- IsOnCreditHold - bit
    7,         -- PaymentDays - int
    N'(423) 555-2100',       -- PhoneNumber - nvarchar(20)
    N'(423) 555-2101',       -- FaxNumber - nvarchar(20)
    NULL,      -- DeliveryRun - nvarchar(5)
    NULL,      -- RunPosition - nvarchar(5)
    N'http://www.tailspintoys.com/Frankewing_test_shop_1',       -- WebsiteURL - nvarchar(256)
    N'Shop 27/1',       -- DeliveryAddressLine1 - nvarchar(60)
    NULL,      -- DeliveryAddressLine2 - nvarchar(60)
    N'90761',       -- DeliveryPostalCode - nvarchar(10)
    NULL,      -- DeliveryLocation - geography
    N'PO Box 5684/1',       -- PostalAddressLine1 - nvarchar(60)
    NULL,      -- PostalAddressLine2 - nvarchar(60)
    N'90761',       -- PostalPostalCode - nvarchar(10)
    1          -- LastEditedBy - int
    ),
(   
	DEFAULT,   -- CustomerID - int
    N'Test Shop Tailspin Toys (2)',       -- CustomerName - nvarchar(100)
    1,         -- BillToCustomerID - int
    3,         -- CustomerCategoryID - int
    1,      -- BuyingGroupID - int
    1004,         -- PrimaryContactPersonID - int
    1005,      -- AlternateContactPersonID - int
    3,         -- DeliveryMethodID - int
    12152,         -- DeliveryCityID - int
    12152,         -- PostalCityID - int
    NULL,      -- CreditLimit - decimal(18, 2)
    GETDATE(), -- AccountOpenedDate - date
    0,      -- StandardDiscountPercentage - decimal(18, 3)
    0,      -- IsStatementSent - bit
    0,      -- IsOnCreditHold - bit
    7,         -- PaymentDays - int
    N'(423) 555-3100',       -- PhoneNumber - nvarchar(20)
    N'(423) 555-3101',       -- FaxNumber - nvarchar(20)
    NULL,      -- DeliveryRun - nvarchar(5)
    NULL,      -- RunPosition - nvarchar(5)
    N'http://www.tailspintoys.com/Frankewing_test_shop_2',       -- WebsiteURL - nvarchar(256)
    N'Shop 27/2',       -- DeliveryAddressLine1 - nvarchar(60)
    NULL,      -- DeliveryAddressLine2 - nvarchar(60)
    N'90761',       -- DeliveryPostalCode - nvarchar(10)
    NULL,      -- DeliveryLocation - geography
    N'PO Box 5684/2',       -- PostalAddressLine1 - nvarchar(60)
    NULL,      -- PostalAddressLine2 - nvarchar(60)
    N'90761',       -- PostalPostalCode - nvarchar(10)
    1          -- LastEditedBy - int
    ),
	(   DEFAULT,   -- CustomerID - int
    N'Test Shop Tailspin Toys (3)',       -- CustomerName - nvarchar(100)
    1,         -- BillToCustomerID - int
    3,         -- CustomerCategoryID - int
    1,      -- BuyingGroupID - int
    1006,         -- PrimaryContactPersonID - int
    1007,      -- AlternateContactPersonID - int
    3,         -- DeliveryMethodID - int
    12152,         -- DeliveryCityID - int
    12152,         -- PostalCityID - int
    NULL,      -- CreditLimit - decimal(18, 2)
    GETDATE(), -- AccountOpenedDate - date
    0,      -- StandardDiscountPercentage - decimal(18, 3)
    0,      -- IsStatementSent - bit
    0,      -- IsOnCreditHold - bit
    7,         -- PaymentDays - int
    N'(423) 555-4100',       -- PhoneNumber - nvarchar(20)
    N'(423) 555-4101',       -- FaxNumber - nvarchar(20)
    NULL,      -- DeliveryRun - nvarchar(5)
    NULL,      -- RunPosition - nvarchar(5)
    N'http://www.tailspintoys.com/Frankewing_test_shop_3',       -- WebsiteURL - nvarchar(256)
    N'Shop 27/3',       -- DeliveryAddressLine1 - nvarchar(60)
    NULL,      -- DeliveryAddressLine2 - nvarchar(60)
    N'90761',       -- DeliveryPostalCode - nvarchar(10)
    NULL,      -- DeliveryLocation - geography
    N'PO Box 5684/3',       -- PostalAddressLine1 - nvarchar(60)
    NULL,      -- PostalAddressLine2 - nvarchar(60)
    N'90761',       -- PostalPostalCode - nvarchar(10)
    1          -- LastEditedBy - int
    ),
	(   
	DEFAULT,   -- CustomerID - int
    N'Test Shop Tailspin Toys (4)',       -- CustomerName - nvarchar(100)
    1,         -- BillToCustomerID - int
    3,         -- CustomerCategoryID - int
    1,      -- BuyingGroupID - int
    1008,         -- PrimaryContactPersonID - int
    1009,      -- AlternateContactPersonID - int
    3,         -- DeliveryMethodID - int
    12152,         -- DeliveryCityID - int
    12152,         -- PostalCityID - int
    NULL,      -- CreditLimit - decimal(18, 2)
    GETDATE(), -- AccountOpenedDate - date
    0,      -- StandardDiscountPercentage - decimal(18, 3)
    0,      -- IsStatementSent - bit
    0,      -- IsOnCreditHold - bit
    7,         -- PaymentDays - int
    N'(423) 555-5100',       -- PhoneNumber - nvarchar(20)
    N'(423) 555-5101',       -- FaxNumber - nvarchar(20)
    NULL,      -- DeliveryRun - nvarchar(5)
    NULL,      -- RunPosition - nvarchar(5)
    N'http://www.tailspintoys.com/Frankewing_test_shop_4',       -- WebsiteURL - nvarchar(256)
    N'Shop 27/4',       -- DeliveryAddressLine1 - nvarchar(60)
    NULL,      -- DeliveryAddressLine2 - nvarchar(60)
    N'90761',       -- DeliveryPostalCode - nvarchar(10)
    NULL,      -- DeliveryLocation - geography
    N'PO Box 5684/4',       -- PostalAddressLine1 - nvarchar(60)
    NULL,      -- PostalAddressLine2 - nvarchar(60)
    N'90761',       -- PostalPostalCode - nvarchar(10)
    1          -- LastEditedBy - int
    ),
	(   DEFAULT,   -- CustomerID - int
    N'Test Shop Tailspin Toys (5)',       -- CustomerName - nvarchar(100)
    1,         -- BillToCustomerID - int
    3,         -- CustomerCategoryID - int
    1,      -- BuyingGroupID - int
    1010,         -- PrimaryContactPersonID - int
    1011,      -- AlternateContactPersonID - int
    3,         -- DeliveryMethodID - int
    12152,         -- DeliveryCityID - int
    12152,         -- PostalCityID - int
    NULL,      -- CreditLimit - decimal(18, 2)
    GETDATE(), -- AccountOpenedDate - date
    0,      -- StandardDiscountPercentage - decimal(18, 3)
    0,      -- IsStatementSent - bit
    0,      -- IsOnCreditHold - bit
    7,         -- PaymentDays - int
    N'(423) 555-6100',       -- PhoneNumber - nvarchar(20)
    N'(423) 555-6101',       -- FaxNumber - nvarchar(20)
    NULL,      -- DeliveryRun - nvarchar(5)
    NULL,      -- RunPosition - nvarchar(5)
    N'http://www.tailspintoys.com/Frankewing_test_shop_5',       -- WebsiteURL - nvarchar(256)
    N'Shop 27/5',       -- DeliveryAddressLine1 - nvarchar(60)
    NULL,      -- DeliveryAddressLine2 - nvarchar(60)
    N'90761',       -- DeliveryPostalCode - nvarchar(10)
    NULL,      -- DeliveryLocation - geography
    N'PO Box 5684/5',       -- PostalAddressLine1 - nvarchar(60)
    NULL,      -- PostalAddressLine2 - nvarchar(60)
    N'90761',       -- PostalPostalCode - nvarchar(10)
    1          -- LastEditedBy - int
    );

SELECT *
FROM Sales.Customers;

SELECT *
FROM Application.People
/*
2. Удалите одну запись из Customers, которая была вами добавлена
*/

DELETE FROM Sales.Customers
WHERE CustomerID = 1062;


/*
3. Изменить одну запись, из добавленных через UPDATE
*/
UPDATE Sales.Customers
SET PhoneNumber = N'(423) 555-3120'
WHERE CustomerID = 1063;


/*
4. Написать MERGE, который вставит вставит запись в клиенты, если ее там нет, и изменит если она уже есть
*/
MERGE Sales.Customers AS Target
USING #ForInsertCustomers AS Source
    ON (Target.CustomerID = Source.CustomerID)
WHEN MATCHED 
    THEN UPDATE 
        SET Target.CustomerName = Source.CustomerName
WHEN NOT MATCHED 
    THEN INSERT
		VALUES(Source.CustomerID,
    Source.CustomerName,
    Source.BillToCustomerID,
    Source.CustomerCategoryID,
    Source.BuyingGroupID,
    Source.PrimaryContactPersonID,
    Source.AlternateContactPersonID,
    Source.DeliveryMethodID,
    Source.DeliveryCityID,
    Source.PostalCityID,
    Source.CreditLimit,
    Source.AccountOpenedDate,
    Source.StandardDiscountPercentage,
    Source.IsStatementSent,
    Source.IsOnCreditHold,
    Source.PaymentDays,
    Source.PhoneNumber,
    Source.FaxNumber,
    Source.DeliveryRun,
    Source.RunPosition,
    Source.WebsiteURL,
    Source.DeliveryAddressLine1,
    Source.DeliveryAddressLine2,
    Source.DeliveryPostalCode,
    Source.DeliveryLocation,
    Source.PostalAddressLine1,
    Source.PostalAddressLine2,
    Source.PostalPostalCode,
    Source.LastEditedBy);

/*
5. Напишите запрос, который выгрузит данные через bcp out и загрузить через bulk insert
*/
EXEC sp_configure 'show advanced options', '1'
RECONFIGURE
-- this enables xp_cmdshell
EXEC sp_configure 'xp_cmdshell', '1' 
RECONFIGURE
GO

DECLARE @sql NVARCHAR(4000);
SELECT @sql = 'bcp [WideWorldImporters].[Sales].Invoices out "C:\Temp\myInvoices.txt" -S ' + @@SERVERNAME + ' -w -T -t"$$$" '

PRINT @sql
EXEC master..xp_cmdshell @sql;

DROP TABLE IF EXISTS [Sales].[Invoices_bulk_insert];
CREATE TABLE [Sales].[Invoices_bulk_insert](
	[InvoiceID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[BillToCustomerID] [int] NOT NULL,
	[OrderID] [int] NULL,
	[DeliveryMethodID] [int] NOT NULL,
	[ContactPersonID] [int] NOT NULL,
	[AccountsPersonID] [int] NOT NULL,
	[SalespersonPersonID] [int] NOT NULL,
	[PackedByPersonID] [int] NOT NULL,
	[InvoiceDate] [date] NOT NULL,
	[CustomerPurchaseOrderNumber] [nvarchar](20) NULL,
	[IsCreditNote] [bit] NOT NULL,
	[CreditNoteReason] [nvarchar](max) NULL,
	[Comments] [nvarchar](max) NULL,
	[DeliveryInstructions] [nvarchar](max) NULL,
	[InternalComments] [nvarchar](max) NULL,
	[TotalDryItems] [int] NOT NULL,
	[TotalChillerItems] [int] NOT NULL,
	[DeliveryRun] [nvarchar](5) NULL,
	[RunPosition] [nvarchar](5) NULL,
	[ReturnedDeliveryData] [nvarchar](max) NULL,
	[ConfirmedDeliveryTime]  AS (TRY_CONVERT([datetime2](7),json_value([ReturnedDeliveryData],N'$.DeliveredWhen'),(126))),
	[ConfirmedReceivedBy]  AS (json_value([ReturnedDeliveryData],N'$.ReceivedBy')),
	[LastEditedBy] [int] NOT NULL,
	[LastEditedWhen] [datetime2](7) NOT NULL,
  CONSTRAINT [PK_Sales_Invoices_bulk_insert] PRIMARY KEY CLUSTERED 
(
	[InvoiceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [USERDATA]
) ON [USERDATA] TEXTIMAGE_ON [USERDATA]
GO

BULK INSERT [WideWorldImporters].[Sales].[Invoices_bulk_insert]
	FROM 'C:\Temp\myInvoices.txt'
	WITH (
		DATAFILETYPE = 'widechar',
		FIELDTERMINATOR = '$$$',
		ROWTERMINATOR = '\n',
		KEEPNULLS,
		TABLOCK
		);
SELECT * 
FROM [WideWorldImporters].[Sales].[Invoices_bulk_insert];