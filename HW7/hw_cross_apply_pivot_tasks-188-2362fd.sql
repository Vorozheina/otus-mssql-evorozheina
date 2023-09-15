/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "05 - Операторы CROSS APPLY, PIVOT, UNPIVOT".

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

USE WideWorldImporters

/*
1. Требуется написать запрос, который в результате своего выполнения 
формирует сводку по количеству покупок в разрезе клиентов и месяцев.
В строках должны быть месяцы (дата начала месяца), в столбцах - клиенты.

Клиентов взять с ID 2-6, это все подразделение Tailspin Toys.
Имя клиента нужно поменять так чтобы осталось только уточнение.
Например, исходное значение "Tailspin Toys (Gasport, NY)" - вы выводите только "Gasport, NY".
Дата должна иметь формат dd.mm.yyyy, например, 25.12.2019.

Пример, как должны выглядеть результаты:
-------------+--------------------+--------------------+-------------+--------------+------------
InvoiceMonth | Peeples Valley, AZ | Medicine Lodge, KS | Gasport, NY | Sylvanite, MT | Jessie, ND
-------------+--------------------+--------------------+-------------+--------------+------------
01.01.2013   |      3             |        1           |      4      |      2        |     2
01.02.2013   |      7             |        3           |      4      |      2        |     1
-------------+--------------------+--------------------+-------------+--------------+------------
*/
DROP TABLE IF EXISTS #SpecialCustomerName;
CREATE TABLE #SpecialCustomerName
( 
	CName NVARCHAR(100) NULL
);

INSERT INTO #SpecialCustomerName
(CName)
SELECT SUBSTRING(Customers.CustomerName, CHARINDEX('(', Customers.CustomerName) + 1, LEN(Customers.CustomerName) - CHARINDEX('(', Customers.CustomerName) - 1) AS SpecialName
FROM Sales.Customers
WHERE CustomerID BETWEEN 2 AND 6;

SELECT *
FROM #SpecialCustomerName;
--1--
SELECT FORMAT(P.InvoiceMonth, 'dd.MM.yyyy') AS InvoiceMonth, 
	   P.[Jessie, ND], 
	   P.[Gasport, NY], 
	   P.[Medicine Lodge, KS], 
	   P.[Peeples Valley, AZ], 
	   P.[Sylvanite, MT]
FROM (SELECT SUBSTRING(Customers.CustomerName, CHARINDEX('(', Customers.CustomerName) + 1, LEN(Customers.CustomerName) - CHARINDEX('(', Customers.CustomerName) - 1) AS SpecialName, 
			 Sales.InvoiceLines.InvoiceID, 
			 DATEADD(MONTH, DATEDIFF(MONTH, 0, InvoiceDate), 0) AS InvoiceMonth 
	  FROM Sales.Invoices
			INNER JOIN Sales.Customers ON Customers.CustomerID = Invoices.CustomerID
			INNER JOIN Sales.InvoiceLines ON InvoiceLines.InvoiceID = Invoices.InvoiceID
	  WHERE Customers.CustomerID BETWEEN 2 AND 6) AS S
PIVOT (COUNT(S.InvoiceID) FOR S.SpecialName IN ([Sylvanite, MT], [Peeples Valley, AZ], [Medicine Lodge, KS], [Gasport, NY], [Jessie, ND])) AS P
ORDER BY YEAR(P.InvoiceMonth), MONTH(P.InvoiceMonth);

--2--
SELECT FORMAT(P.InvoiceMonth, 'dd.MM.yyyy') AS InvoiceMonth, 
	   P.[Jessie, ND], 
	   P.[Gasport, NY], 
	   P.[Medicine Lodge, KS], 
	   P.[Peeples Valley, AZ], 
	   P.[Sylvanite, MT]
FROM (SELECT SUBSTRING(C.CustomerName, CHARINDEX('(', C.CustomerName) + 1, LEN(C.CustomerName) - CHARINDEX('(', C.CustomerName) - 1) AS SpecialName, 
			 Sales.InvoiceLines.InvoiceID, 
			 DATEADD(MONTH, DATEDIFF(MONTH, 0, InvoiceDate), 0) AS InvoiceMonth 
	  FROM Sales.Invoices
			INNER JOIN Sales.InvoiceLines ON InvoiceLines.InvoiceID = Invoices.InvoiceID
			CROSS APPLY (SELECT Customers.CustomerName 
						 FROM Sales.Customers 
						 WHERE Customers.CustomerID = Invoices.CustomerID 
							AND Customers.CustomerID BETWEEN 2 AND 6) C
			) AS S
PIVOT (COUNT(S.InvoiceID) FOR S.SpecialName IN ([Sylvanite, MT], [Peeples Valley, AZ], [Medicine Lodge, KS], [Gasport, NY], [Jessie, ND])) AS P
ORDER BY YEAR(P.InvoiceMonth), MONTH(P.InvoiceMonth);

/*
2. Для всех клиентов с именем, в котором есть "Tailspin Toys"
вывести все адреса, которые есть в таблице, в одной колонке.

Пример результата:
----------------------------+--------------------
CustomerName                | AddressLine
----------------------------+--------------------
Tailspin Toys (Head Office) | Shop 38
Tailspin Toys (Head Office) | 1877 Mittal Road
Tailspin Toys (Head Office) | PO Box 8975
Tailspin Toys (Head Office) | Ribeiroville
----------------------------+--------------------
*/

SELECT CustomersAllAddress.CustomerName, CustomersAllAddress.AddressLine
FROM (
		SELECT CustomerName,
			   DeliveryAddressLine1,
			   DeliveryAddressLine2,
			   PostalAddressLine1,
			   PostalAddressLine2
		FROM Sales.Customers
		WHERE CustomerName LIKE '%Tailspin Toys%'
	  ) AS Customers
UNPIVOT (AddressLine FOR CustomerAddressLine IN (DeliveryAddressLine1, DeliveryAddressLine2, PostalAddressLine1, PostalAddressLine2)) AS CustomersAllAddress;

/*
3. В таблице стран (Application.Countries) есть поля с цифровым кодом страны и с буквенным.
Сделайте выборку ИД страны, названия и ее кода так, 
чтобы в поле с кодом был либо цифровой либо буквенный код.

Пример результата:
--------------------------------
CountryId | CountryName | Code
----------+-------------+-------
1         | Afghanistan | AFG
1         | Afghanistan | 4
3         | Albania     | ALB
3         | Albania     | 8
----------+-------------+-------
*/

SELECT CountryWithCodes.CountryID, CountryWithCodes.CountryName, CountryWithCodes.Code
FROM (
		SELECT CountryID,
			   CountryName,
			   IsoAlpha3Code,
			   CONVERT(NVARCHAR(3), IsoNumericCode) AS IsoNumCode
		FROM Application.Countries
	  ) AS Countries
UNPIVOT (Code FOR CountryCode IN (IsoAlpha3Code, IsoNumCode)) AS CountryWithCodes;

/*
4. Выберите по каждому клиенту два самых дорогих товара, которые он покупал.
В результатах должно быть ид клиета, его название, ид товара, цена, дата покупки.
*/
--1--
SELECT C.CustomerID, C.CustomerName, SI.*
FROM Sales.Customers C
CROSS APPLY (SELECT TOP (2)  I.CustomerID, IL.StockItemID, MAX(IL.UnitPrice) ExpPrice, MAX(I.InvoiceDate) AS InvoiceDate
                FROM Sales.Invoices I
					INNER JOIN Sales.InvoiceLines IL ON IL.InvoiceID = I.InvoiceID 
                WHERE I.CustomerID = C.CustomerID
				GROUP BY I.CustomerID, IL.StockItemID
                ORDER BY I.CustomerID ASC, ExpPrice DESC) AS SI
ORDER BY C.CustomerName;