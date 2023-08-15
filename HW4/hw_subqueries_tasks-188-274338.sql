/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "03 - Подзапросы, CTE, временные таблицы".

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
-- Для всех заданий, где возможно, сделайте два варианта запросов:
--  1) через вложенный запрос
--  2) через WITH (для производных таблиц)
-- ---------------------------------------------------------------------------

USE WideWorldImporters;

/*
1. Выберите сотрудников (Application.People), которые являются продажниками (IsSalesPerson), 
и не сделали ни одной продажи 04 июля 2015 года. 
Вывести ИД сотрудника и его полное имя. 
Продажи смотреть в таблице Sales.Invoices.
*/

--1--
SELECT PP.FullName
FROM Application.People PP
WHERE PP.IsSalesperson = 1 AND 
NOT EXISTS (SELECT 1 
			FROM Sales.Invoices I 
				INNER JOIN Application.People P ON P.PersonID = I.SalespersonPersonID
												AND I.InvoiceDate = '20150704' 
												AND PP.PersonID = P.PersonID);


--2--
WITH PersonCTE(PersonID)
AS
(
	SELECT P.PersonID 
	FROM Sales.Invoices I 
		INNER JOIN Application.People P ON P.PersonID = I.SalespersonPersonID
										AND I.InvoiceDate = '20150704'
)
SELECT PP.FullName
FROM Application.People PP
WHERE PP.IsSalesperson = 1 AND PP.PersonID NOT IN (SELECT PersonCTE.PersonID FROM PersonCTE);

/*
2. Выберите товары с минимальной ценой (подзапросом). Сделайте два варианта подзапроса. 
Вывести: ИД товара, наименование товара, цена.
*/

--1--
SELECT DISTINCT SII.StockItemID, SII.StockItemName, IL.UnitPrice 
FROM Warehouse.StockItems SII 
	INNER JOIN Sales.InvoiceLines IL ON IL.StockItemID = SII.StockItemID 
WHERE IL.UnitPrice = (SELECT MIN(Sales.InvoiceLines.UnitPrice) FROM Sales.InvoiceLines);

--2--
SELECT DISTINCT SII.StockItemID, SII.StockItemName, IL.UnitPrice 
FROM Warehouse.StockItems SII 
	INNER JOIN Sales.InvoiceLines IL ON IL.StockItemID = SII.StockItemID 
WHERE IL.UnitPrice <= ALL (SELECT Sales.InvoiceLines.UnitPrice FROM Sales.InvoiceLines);



/*
3. Выберите информацию по клиентам, которые перевели компании пять максимальных платежей 
из Sales.CustomerTransactions. 
Представьте несколько способов (в том числе с CTE). 
*/
--1--
SELECT TOP(5) Customers.CustomerName, SUM(CustomerTransactions.TransactionAmount) MaxAmount
FROM Sales.CustomerTransactions
	INNER JOIN Sales.Customers ON Customers.CustomerID = CustomerTransactions.CustomerID
GROUP BY Customers.CustomerName
ORDER BY MaxAmount DESC;

--2--
WITH CustomersCTE(CustomerName, CustomerAmount)
AS
(
	SELECT Customers.CustomerName, SUM(CustomerTransactions.TransactionAmount) CustomerAmount
	FROM Sales.CustomerTransactions
		INNER JOIN Sales.Customers ON Customers.CustomerID = CustomerTransactions.CustomerID
	GROUP BY Customers.CustomerName
)
SELECT TOP(5) CustomerName, CustomerAmount
FROM CustomersCTE
ORDER BY CustomerAmount DESC;

/*
4. Выберите города (ид и название), в которые были доставлены товары, 
входящие в тройку самых дорогих товаров, а также имя сотрудника, 
который осуществлял упаковку заказов (PackedByPersonID).
*/
--1--
WITH StockItemsCTE(StockItemID)
AS 
(
	SELECT TOP (3) StockItems.StockItemID
	FROM Warehouse.StockItems
	ORDER BY StockItems.UnitPrice DESC
)
SELECT DISTINCT Customers.DeliveryCityID, Cities.CityName, People.FullName AS [PackedByPerson]
FROM Sales.Invoices
	INNER JOIN Sales.Customers ON Customers.CustomerID = Invoices.CustomerID
	INNER JOIN Application.People ON People.PersonID = Invoices.PackedByPersonID
	INNER JOIN Application.Cities ON Cities.CityID = Customers.DeliveryCityID
	INNER JOIN Sales.InvoiceLines ON InvoiceLines.InvoiceID = Invoices.InvoiceID
WHERE Sales.InvoiceLines.StockItemID IN (SELECT StockItemID FROM StockItemsCTE)
ORDER BY DeliveryCityID ASC;



-- ---------------------------------------------------------------------------
-- Опциональное задание
-- ---------------------------------------------------------------------------
-- Можно двигаться как в сторону улучшения читабельности запроса, 
-- так и в сторону упрощения плана\ускорения. 
-- Сравнить производительность запросов можно через SET STATISTICS IO, TIME ON. 
-- Если знакомы с планами запросов, то используйте их (тогда к решению также приложите планы). 
-- Напишите ваши рассуждения по поводу оптимизации. 

-- 5. Объясните, что делает и оптимизируйте запрос

SELECT 
	Invoices.InvoiceID, 
	Invoices.InvoiceDate,
	(SELECT People.FullName
		FROM Application.People
		WHERE People.PersonID = Invoices.SalespersonPersonID
	) AS SalesPersonName,
	SalesTotals.TotalSumm AS TotalSummByInvoice, 
	(SELECT SUM(OrderLines.PickedQuantity*OrderLines.UnitPrice)
		FROM Sales.OrderLines
		WHERE OrderLines.OrderId = (SELECT Orders.OrderId 
			FROM Sales.Orders
			WHERE Orders.PickingCompletedWhen IS NOT NULL	
				AND Orders.OrderId = Invoices.OrderId)	
	) AS TotalSummForPickedItems
FROM Sales.Invoices 
	JOIN
	(SELECT InvoiceId, SUM(Quantity*UnitPrice) AS TotalSumm
	FROM Sales.InvoiceLines
	GROUP BY InvoiceId
	HAVING SUM(Quantity*UnitPrice) > 27000) AS SalesTotals
		ON Invoices.InvoiceID = SalesTotals.InvoiceID
ORDER BY TotalSumm DESC;

-- --
/*Запрос выводит номер счета, дату счета, ФИ сотрудника, общую сумму счета (без налога), 
общую стоимость собранных по счету товаров (без налога), отсортированные по общей сумме счета.
В запрос попадают те данные, где:
1) сотрудник является продавцом;
2) общая сумма счета без налога больше, чем 27000 у.е.;
3) общая стоимость собранных товаров включает только те товары, заказ по которым был собран.
*/



WITH InvoicesMore27000CTE(InvoiceId, TotalSumm)
AS(
	SELECT InvoiceId, SUM(Quantity*UnitPrice) AS TotalSumm
	FROM Sales.InvoiceLines
	GROUP BY InvoiceId
	HAVING SUM(Quantity*UnitPrice) > 27000
),
OrdersCTE(InvoiceID, TotalSummForPickedItems)
AS(
	SELECT InvoiceID, SUM(OrderLines.PickedQuantity*OrderLines.UnitPrice) TotalSummForPickedItems
	FROM Sales.OrderLines
		INNER JOIN Sales.Invoices ON Invoices.OrderID = OrderLines.OrderID
	WHERE Sales.OrderLines.PickingCompletedWhen IS NOT NULL
	GROUP BY Invoices.InvoiceID
)
SELECT Invoices.InvoiceID, Invoices.InvoiceDate, Application.People.FullName SalesPersonName,
	InvoicesMore27000CTE.TotalSumm, OrdersCTE.TotalSummForPickedItems
FROM Sales.Invoices
	INNER JOIN InvoicesMore27000CTE ON InvoicesMore27000CTE.InvoiceId = Invoices.InvoiceID
	INNER JOIN OrdersCTE ON OrdersCTE.InvoiceID = Invoices.InvoiceID
	INNER JOIN Application.People ON People.PersonID = Invoices.SalespersonPersonID
ORDER BY TotalSumm DESC;



