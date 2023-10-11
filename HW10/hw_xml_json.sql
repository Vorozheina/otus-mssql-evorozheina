USE WideWorldImporters;
GO

/*1. � ������ �������� ���� ���� StockItems.xml.
��� ������ �� ������� Warehouse.StockItems.
������������� ��� ������ � ������� ������� � ������, ������������ Warehouse.StockItems.
����: StockItemName, SupplierID, UnitPackageID, OuterPackageID, QuantityPerOuter, TypicalWeightPerUnit, LeadTimeDays, IsChillerStock, TaxRate, UnitPrice
��������� ��� ������ � ������� Warehouse.StockItems.
������������ ������ � ������� ��������, ������������� �������� (������������ ������ �� ���� StockItemName).
������� ��� ��������: � ������� OPENXML � ����� XQuery.*/

--1--
DROP TABLE IF EXISTS #AnotherStockItems;
CREATE TABLE #AnotherStockItems
(
	[StockItemName] [nvarchar](100) NULL,
	[SupplierID] [int] NULL,
	[UnitPackageID] [int] NULL,
	[OuterPackageID] [int] NULL,
	[QuantityPerOuter] [int] NULL,
	[TypicalWeightPerUnit] [decimal](18, 3) NULL,
	[LeadTimeDays] [int] NULL,
	[IsChillerStock] [bit] NULL,
	[TaxRate] [decimal](18, 3) NULL,
	[UnitPrice] [decimal](18, 2) NULL
);
GO

DECLARE @xml XML;
SELECT @xml = BulkColumn 
FROM OPENROWSET(BULK 'C:\work\learn\otus-mssql-evorozheina\HW10\StockItems.xml', SINGLE_BLOB) AS x;

INSERT INTO #AnotherStockItems
(
    StockItemName,
    SupplierID,
    UnitPackageID,
    OuterPackageID,
    QuantityPerOuter,
    TypicalWeightPerUnit,
    LeadTimeDays,
    IsChillerStock,
    TaxRate,
    UnitPrice
)
SELECT c.value('@Name', 'NVARCHAR(100)') AS StockItemName,
	   c.value('(SupplierID/text())[1]', 'INT') AS SupplierID,
	   c.value('(Package/UnitPackageID/text())[1]', 'INT') AS UnitPackageID,
	   c.value('(Package/OuterPackageID/text())[1]', 'INT') AS OuterPackageID,
	   c.value('(Package/QuantityPerOuter/text())[1]', 'INT') AS QuantityPerOuter,
	   c.value('(Package/TypicalWeightPerUnit/text())[1]', 'DECIMAL(18, 3)') AS TypicalWeightPerUnit,
	   c.value('(LeadTimeDays/text())[1]', 'INT') AS LeadTimeDays,
	   c.value('(IsChillerStock/text())[1]', 'BIT') AS IsChillerStock,
	   c.value('(TaxRate/text())[1]', 'DECIMAL(18, 3)') AS TaxRate,
	   c.value('(UnitPrice/text())[1]', 'DECIMAL(18, 2)') AS UnitPrice
FROM @xml.nodes('/StockItems/Item') AS t(c);

MERGE Warehouse.StockItems AS Target
USING #AnotherStockItems AS Source
    ON Target.StockItemName = Source.StockItemName COLLATE Latin1_General_100_CI_AI
WHEN MATCHED 
    THEN UPDATE 
        SET Target.SupplierID = Source.SupplierID,
			Target.UnitPackageID = Source.UnitPackageID,
			Target.OuterPackageID = Source.OuterPackageID,
			Target.QuantityPerOuter = Source.QuantityPerOuter,
			Target.TypicalWeightPerUnit = Source.TypicalWeightPerUnit,
			Target.LeadTimeDays = Source.LeadTimeDays,
			Target.IsChillerStock = Source.IsChillerStock,
			Target.TaxRate = Source.TaxRate,
			Target.UnitPrice = Source.UnitPrice
WHEN NOT MATCHED 
    THEN INSERT(
	[StockItemName],
	[SupplierID],
	[ColorID],
	[UnitPackageID],
	[OuterPackageID],
	[Brand],
	[Size],
	[LeadTimeDays],
	[QuantityPerOuter],
	[IsChillerStock],
	[Barcode],
	[TaxRate],
	[UnitPrice],
	[RecommendedRetailPrice],
	[TypicalWeightPerUnit],
	[MarketingComments],
	[InternalComments],
	[Photo],
	[CustomFields],
	[LastEditedBy]
	)
		VALUES(
	Source.StockItemName,
    Source.SupplierID,
	NULL,
    Source.UnitPackageID,
    Source.OuterPackageID,
	NULL,
	NULL,
	Source.LeadTimeDays,
    Source.QuantityPerOuter,
	Source.IsChillerStock,
	NULL,
	Source.TaxRate,
	Source.UnitPrice,
	NULL,
    Source.TypicalWeightPerUnit,
    NULL,
    NULL,
	NULL,
	NULL,
	1);
SELECT * FROM Warehouse.StockItems
GO

--2--
DROP TABLE IF EXISTS #AnotherStockItems;
CREATE TABLE #AnotherStockItems
(
	[StockItemName] [nvarchar](100) NULL,
	[SupplierID] [int] NULL,
	[UnitPackageID] [int] NULL,
	[OuterPackageID] [int] NULL,
	[QuantityPerOuter] [int] NULL,
	[TypicalWeightPerUnit] [decimal](18, 3) NULL,
	[LeadTimeDays] [int] NULL,
	[IsChillerStock] [bit] NULL,
	[TaxRate] [decimal](18, 3) NULL,
	[UnitPrice] [decimal](18, 2) NULL
);
GO

DECLARE @xml XML, @handle INT;
SELECT @xml = BulkColumn 
FROM OPENROWSET(BULK 'C:\work\learn\otus-mssql-evorozheina\HW10\StockItems.xml', SINGLE_BLOB) AS x;

EXEC sp_xml_preparedocument @handle OUTPUT, @xml;

INSERT INTO #AnotherStockItems
(
    StockItemName,
    SupplierID,
    UnitPackageID,
    OuterPackageID,
    QuantityPerOuter,
    TypicalWeightPerUnit,
    LeadTimeDays,
    IsChillerStock,
    TaxRate,
    UnitPrice
)
SELECT *
FROM OPENXML(@handle, '/StockItems/Item', 2) WITH (
        StockItemName NVARCHAR(100) '@Name',
		SupplierID INT 'SupplierID',
        UnitPackageID INT 'Package/UnitPackageID',
		OuterPackageID INT 'Package/OuterPackageID',
		QuantityPerOuter INT 'Package/QuantityPerOuter',
		TypicalWeightPerUnit DECIMAL(18, 3) 'Package/TypicalWeightPerUnit',
		LeadTimeDays INT 'LeadTimeDays',
		IsChillerStock BIT 'IsChillerStock',
		TaxRate DECIMAL(18, 3) 'TaxRate',
		UnitPrice DECIMAL(18, 2) 'UnitPrice'
    );

SELECT * 
FROM #AnotherStockItems;

/*2. ��������� ������ �� ������� StockItems � ����� �� xml-����, ��� StockItems.xml
���������� � �������� 1, 2:
���� � ��������� � ���� ����� ��������, �� ����� ������� ������ SELECT c ����������� � ���� XML.
���� � ��� � ������� ������������ �������/������ � XML, �� ������ ����� ���� XML � ���� �������.
���� � ���� XML ��� ����� ������, �� ������ ����� ����� �������� ������ � ������������� �� � ������� (��������, � https://data.gov.ru).
������ ��������/������� � ���� https://docs.microsoft.com/en-us/sql/relational-databases/import-export/examples-of-bulk-import-and-export-of-xml-documents-sql-server
*/
EXEC master.dbo.sp_configure 'show advanced options', 1
RECONFIGURE
EXEC master.dbo.sp_configure 'xp_cmdshell', 1
RECONFIGURE
GO

DECLARE @sql VARCHAR(8000);

SELECT @sql = 'bcp "SELECT StockItemName AS ''@Name'',' +
'SupplierID AS ''SupplierID'',' +
'UnitPackageID AS ''Package/UnitPackageID'',' + 
'OuterPackageID AS ''Package/OuterPackageID'',' + 
'QuantityPerOuter AS ''Package/QuantityPerOuter'',' + 
'TypicalWeightPerUnit AS ''Package/TypicalWeightPerUnit'',' + 
'LeadTimeDays AS ''LeadTimeDays'',' + 
'IsChillerStock AS ''IsChillerStock'',' + 
'TaxRate AS ''TaxRate'',' +
'UnitPrice AS ''UnitPrice''' +
'FROM [WideWorldImporters].[Warehouse].StockItems FOR XML PATH(''Item''), ROOT(''StockItems'')"' +
' queryout "C:\Temp\myStockItems.xml" -S ' + @@SERVERNAME + ' -w -T';
PRINT @sql
EXEC master..xp_cmdshell @sql;

/*3. � ������� Warehouse.StockItems � ������� CustomFields ���� ������ � JSON.
�������� SELECT ��� ������:
StockItemID
StockItemName
CountryOfManufacture (�� CustomFields)
FirstTag (�� ���� CustomFields, ������ �������� �� ������� Tags)*/

SELECT StockItemID, StockItemName, JsonData.CountryOfManufacture, JsonData.FirstTag
FROM Warehouse.StockItems
	CROSS APPLY OPENJSON(CustomFields)
	WITH
	(
		CountryOfManufacture VARCHAR(50) '$.CountryOfManufacture',
		FirstTag VARCHAR(50) '$.Tags[0]' 
	) AS JsonData;


/*4. ����� � StockItems ������, ��� ���� ��� "Vintage".
�������:
StockItemID
StockItemName
(�����������) ��� ���� (�� CustomFields) ����� ������� � ����� ����
���� ������ � ���� CustomFields, � �� � Tags.
������ �������� ����� ������� ������ � JSON.
��� ������ ������������ ���������, ������������ LIKE ���������.
������ ���� � ����� ����:
... where ... = 'Vintage'
��� ������� �� �����:
... where ... Tags like '%Vintage%'
... where ... CustomFields like '%Vintage%'*/

;WITH JsonParseCTE
AS
(	SELECT StockItemID, StockItemName, REPLACE(SUBSTRING(JsonData.Value, 2, LEN(JsonData.Value) - 2), '"', '') AS Tags, CustomFields
	FROM Warehouse.StockItems
		CROSS APPLY OPENJSON(CustomFields) AS JsonData
	WHERE JsonData.[Key] = 'Tags'
)
SELECT JsonParseCTE.StockItemID, JsonParseCTE.StockItemName, JsonParseCTE.Tags, JsonData.Value AS VintageTag
FROM JsonParseCTE
	CROSS APPLY OPENJSON(JsonParseCTE.CustomFields, '$.Tags') AS JsonData
WHERE JsonData.Value = 'Vintage';
