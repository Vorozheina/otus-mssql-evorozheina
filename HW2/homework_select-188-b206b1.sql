/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.
Занятие "02 - Оператор SELECT и простые фильтры, JOIN".

Задания выполняются с использованием базы данных WideWorldImporters.

Бэкап БД WideWorldImporters можно скачать отсюда:
https://github.com/Microsoft/sql-server-samples/releases/download/wide-world-importers-v1.0/WideWorldImporters-Full.bak

Описание WideWorldImporters от Microsoft:
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-what-is
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-oltp-database-catalog
*/

-- ---------------------------------------------------------------------------
-- Задание - написать выборки для получения указанных ниже данных.
-- ---------------------------------------------------------------------------

USE WideWorldImporters

/*
1. Все товары, в названии которых есть "urgent" или название начинается с "Animal".
Вывести: ИД товара (StockItemID), наименование товара (StockItemName).
Таблицы: Warehouse.StockItems.
*/
--1--
SELECT SI.StockItemID, SI.StockItemName
FROM Warehouse.StockItems SI
WHERE SI.StockItemName LIKE '%urgent%' OR SI.StockItemName LIKE 'Animal%';

--2--
SELECT SI.StockItemID, SI.StockItemName
FROM Warehouse.StockItems SI
WHERE SI.StockItemName LIKE '%urgent%'
UNION
SELECT SI.StockItemID, SI.StockItemName
FROM Warehouse.StockItems SI
WHERE SI.StockItemName LIKE 'Animal%';

/*
2. Поставщиков (Suppliers), у которых не было сделано ни одного заказа (PurchaseOrders).
Сделать через JOIN, с подзапросом задание принято не будет.
Вывести: ИД поставщика (SupplierID), наименование поставщика (SupplierName).
Таблицы: Purchasing.Suppliers, Purchasing.PurchaseOrders.
По каким колонкам делать JOIN подумайте самостоятельно.
*/
--1--
SELECT S.SupplierID, S.SupplierName
FROM Purchasing.Suppliers S 
	LEFT JOIN Purchasing.PurchaseOrders PO ON PO.SupplierID = S.SupplierID
WHERE PO.PurchaseOrderID IS NULL;

--2--
SELECT S.SupplierID, S.SupplierName
FROM Purchasing.Suppliers S
WHERE NOT EXISTS (SELECT PO.PurchaseOrderID 
				  FROM Purchasing.PurchaseOrders PO 
				  WHERE PO.SupplierID = S.SupplierID);

/*
3. Заказы (Orders) с ценой товара (UnitPrice) более 100$ 
либо количеством единиц (Quantity) товара более 20 штук
и присутствующей датой комплектации всего заказа (PickingCompletedWhen).
Вывести:
* OrderID
* дату заказа (OrderDate) в формате ДД.ММ.ГГГГ
* название месяца, в котором был сделан заказ
* номер квартала, в котором был сделан заказ
* треть года, к которой относится дата заказа (каждая треть по 4 месяца)
* имя заказчика (Customer)
Добавьте вариант этого запроса с постраничной выборкой,
пропустив первую 1000 и отобразив следующие 100 записей.

Сортировка должна быть по номеру квартала, трети года, дате заказа (везде по возрастанию).

Таблицы: Sales.Orders, Sales.OrderLines, Sales.Customers.
*/
--1--
SELECT O.OrderID, FORMAT(O.OrderDate, 'dd.mm.yyyy') AS [OrderDate], FORMAT(O.OrderDate, 'MMMM') AS [OrderMonth], 
	   DATEPART(QUARTER, O.OrderDate) AS [QuarterOfYear], ((DATEPART(MONTH, O.OrderDate)-1)/4)+1 AS [Trimester], C.CustomerName
FROM Sales.Orders O INNER JOIN Sales.OrderLines OL ON OL.OrderID = O.OrderID 
	INNER JOIN Sales.Customers C ON C.CustomerID = O.CustomerID
WHERE OL.UnitPrice > 100 
	OR OL.Quantity > 20 
	AND O.PickingCompletedWhen IS NOT NULL
ORDER BY [QuarterOfYear], [Trimester], [OrderDate] ASC;

--2--
SELECT O.OrderID, FORMAT(O.OrderDate, 'dd.mm.yyyy') AS [OrderDate], FORMAT(O.OrderDate, 'MMMM') AS [OrderMonth], 
	   DATEPART(QUARTER, O.OrderDate) AS [QuarterOfYear], ((DATEPART(MONTH, O.OrderDate)-1)/4)+1 AS [Trimester], C.CustomerName
FROM Sales.Orders O INNER JOIN Sales.OrderLines OL ON OL.OrderID = O.OrderID 
	INNER JOIN Sales.Customers C ON C.CustomerID = O.CustomerID
WHERE OL.UnitPrice > 100 
	OR OL.Quantity > 20 
	AND O.PickingCompletedWhen IS NOT NULL
ORDER BY [QuarterOfYear], [Trimester], [OrderDate] ASC
OFFSET 1000 ROWS 
	FETCH NEXT 100 ROWS ONLY;
/*
4. Заказы поставщикам (Purchasing.Suppliers),
которые должны быть исполнены (ExpectedDeliveryDate) в январе 2013 года
с доставкой "Air Freight" или "Refrigerated Air Freight" (DeliveryMethodName)
и которые исполнены (IsOrderFinalized).
Вывести:
* способ доставки (DeliveryMethodName)
* дата доставки (ExpectedDeliveryDate)
* имя поставщика
* имя контактного лица принимавшего заказ (ContactPerson)

Таблицы: Purchasing.Suppliers, Purchasing.PurchaseOrders, Application.DeliveryMethods, Application.People.
*/

SELECT DM.DeliveryMethodName, PO.ExpectedDeliveryDate, S.SupplierName, P.FullName AS [ContactPerson]
FROM Purchasing.PurchaseOrders PO 
	INNER JOIN Purchasing.Suppliers S ON PO.SupplierID = S.SupplierID
	INNER JOIN [Application].DeliveryMethods DM ON PO.DeliveryMethodID = DM.DeliveryMethodID
	INNER JOIN [Application].People P ON PO.ContactPersonID = P.PersonID
WHERE YEAR(PO.ExpectedDeliveryDate) = 2013 AND MONTH(PO.ExpectedDeliveryDate) = 1
	AND (DM.DeliveryMethodName = 'Air Freight' OR DM.DeliveryMethodName = 'Refrigerated Air Freight')
	AND PO.IsOrderFinalized = 1;

/*
5. Десять последних продаж (по дате продажи) с именем клиента и именем сотрудника,
который оформил заказ (SalespersonPerson).
Сделать без подзапросов.
*/

SELECT TOP (10) O.OrderDate, C.CustomerName, P.FullName AS [SalesPersonName]
FROM Sales.Orders O 
	INNER JOIN Sales.Customers C ON C.CustomerID = O.CustomerID
	INNER JOIN [Application].People P ON P.PersonID = O.SalespersonPersonID 
ORDER BY O.OrderDate DESC;

/*
6. Все ид и имена клиентов и их контактные телефоны,
которые покупали товар "Chocolate frogs 250g".
Имя товара смотреть в таблице Warehouse.StockItems.
*/
--1--
SELECT C.CustomerID, C.CustomerName, C.PhoneNumber
FROM Sales.Orders O
	INNER JOIN Sales.Customers C ON C.CustomerID = O.CustomerID
	INNER JOIN Sales.OrderLines OL ON OL.OrderID = O.OrderID
	INNER JOIN Warehouse.StockItems SI ON SI.StockItemID = OL.StockItemID
WHERE SI.StockItemName = 'Chocolate frogs 250g'
GROUP BY C.CustomerID, C.CustomerName, C.PhoneNumber
ORDER BY C.CustomerID;

--2--
SELECT DISTINCT C.CustomerID, C.CustomerName, C.PhoneNumber
FROM Sales.Orders O
	INNER JOIN Sales.Customers C ON C.CustomerID = O.CustomerID
	INNER JOIN Sales.OrderLines OL ON OL.OrderID = O.OrderID
	INNER JOIN Warehouse.StockItems SI ON SI.StockItemID = OL.StockItemID
WHERE SI.StockItemName = 'Chocolate frogs 250g'
ORDER BY C.CustomerID;
