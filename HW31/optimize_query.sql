USE WideWorldImporters
GO

SET NOCOUNT ON;
GO

SET STATISTICS IO, TIME ON;
GO

Select ord.CustomerID, det.StockItemID, SUM(det.UnitPrice), SUM(det.Quantity), COUNT(ord.OrderID)
FROM Sales.Orders AS ord
	JOIN Sales.OrderLines AS det ON det.OrderID = ord.OrderID
	JOIN Sales.Invoices AS Inv ON Inv.OrderID = ord.OrderID
	JOIN Sales.CustomerTransactions AS Trans ON Trans.InvoiceID = Inv.InvoiceID
	JOIN Warehouse.StockItemTransactions AS ItemTrans ON ItemTrans.StockItemID = det.StockItemID
WHERE Inv.BillToCustomerID != ord.CustomerID
	AND (Select SupplierId
		FROM Warehouse.StockItems AS It
		WHERE It.StockItemID = det.StockItemID) = 12
	AND (SELECT SUM(Total.UnitPrice*Total.Quantity)
		FROM Sales.OrderLines AS Total
			JOIN Sales.Orders AS ordTotal On ordTotal.OrderID = Total.OrderID
		WHERE ordTotal.CustomerID = Inv.CustomerID) > 250000
	AND DATEDIFF(dd, Inv.InvoiceDate, ord.OrderDate) = 0
GROUP BY ord.CustomerID, det.StockItemID
ORDER BY ord.CustomerID, det.StockItemID

/*
Анализируем исходный запрос:
1) есть ветвления в плане, и видны соединения таблиц не по порядку
2) есть большие таблицы, которые присоединяются справа (Sales.CustomerTransactions (97147 записей),  Warehouse.StockItemTransactions (236667 записей))
3) в плане есть Nested Loops при соединении JOIN
4) в запросе есть использование констант:
 AND (Select SupplierId
		FROM Warehouse.StockItems AS It
		WHERE It.StockItemID = det.StockItemID) = 12
5) может быть, все тормозит группировка?
6) нужно посмотреть, насколько эффективно используются индексы
7) возможно, распределение на несколько потоков ухудшает выполнение запроса
*/

--1--используем FORCE ORDER, чтобы упорядочить соединение таблиц
Select ord.CustomerID, det.StockItemID, SUM(det.UnitPrice), SUM(det.Quantity), COUNT(ord.OrderID)
FROM Sales.Orders AS ord
	JOIN Sales.OrderLines AS det ON det.OrderID = ord.OrderID
	JOIN Sales.Invoices AS Inv ON Inv.OrderID = ord.OrderID
	JOIN Sales.CustomerTransactions AS Trans ON Trans.InvoiceID = Inv.InvoiceID
	JOIN Warehouse.StockItemTransactions AS ItemTrans ON ItemTrans.StockItemID = det.StockItemID
WHERE Inv.BillToCustomerID != ord.CustomerID
	AND (Select SupplierId
		FROM Warehouse.StockItems AS It
		WHERE It.StockItemID = det.StockItemID) = 12
	AND (SELECT SUM(Total.UnitPrice*Total.Quantity)
		FROM Sales.OrderLines AS Total
			JOIN Sales.Orders AS ordTotal On ordTotal.OrderID = Total.OrderID
		WHERE ordTotal.CustomerID = Inv.CustomerID) > 250000
	AND DATEDIFF(dd, Inv.InvoiceDate, ord.OrderDate) = 0
GROUP BY ord.CustomerID, det.StockItemID
ORDER BY ord.CustomerID, det.StockItemID
OPTION (FORCE ORDER);
--результат: исходный запрос все еще менее затратный, но теперь в плане нет Nested Loops. 
--Из недостатков: добавился параллелизм, попробуем его убрать. Применяем п. 7 MAXDOP
Select ord.CustomerID, det.StockItemID, SUM(det.UnitPrice), SUM(det.Quantity), COUNT(ord.OrderID)
FROM Sales.Orders AS ord
	JOIN Sales.OrderLines AS det ON det.OrderID = ord.OrderID
	JOIN Sales.Invoices AS Inv ON Inv.OrderID = ord.OrderID
	JOIN Sales.CustomerTransactions AS Trans ON Trans.InvoiceID = Inv.InvoiceID
	JOIN Warehouse.StockItemTransactions AS ItemTrans ON ItemTrans.StockItemID = det.StockItemID
WHERE Inv.BillToCustomerID != ord.CustomerID
	AND (Select SupplierId
		FROM Warehouse.StockItems AS It
		WHERE It.StockItemID = det.StockItemID) = 12
	AND (SELECT SUM(Total.UnitPrice*Total.Quantity)
		FROM Sales.OrderLines AS Total
			JOIN Sales.Orders AS ordTotal On ordTotal.OrderID = Total.OrderID
		WHERE ordTotal.CustomerID = Inv.CustomerID) > 250000
	AND DATEDIFF(dd, Inv.InvoiceDate, ord.OrderDate) = 0
GROUP BY ord.CustomerID, det.StockItemID
ORDER BY ord.CustomerID, det.StockItemID
OPTION (FORCE ORDER, MAXDOP 1);
--параллельность ушла, но запрос по-прежнему хуже исходного и даже немного хуже распараллеленного
--попробуем поработать с индексами так, чтобы был index seek
Select ord.CustomerID, det.StockItemID, SUM(det.UnitPrice), SUM(det.Quantity), COUNT(ord.OrderID)
FROM Sales.Orders AS ord WITH (FORCESEEK)
	JOIN Sales.OrderLines AS det ON det.OrderID = ord.OrderID
	JOIN Sales.Invoices AS Inv ON Inv.OrderID = ord.OrderID
	JOIN Sales.CustomerTransactions AS Trans ON Trans.InvoiceID = Inv.InvoiceID
	JOIN Warehouse.StockItemTransactions AS ItemTrans ON ItemTrans.StockItemID = det.StockItemID
WHERE Inv.BillToCustomerID != ord.CustomerID
	AND (Select SupplierId
		FROM Warehouse.StockItems AS It
		WHERE It.StockItemID = det.StockItemID) = 12
	AND (SELECT SUM(Total.UnitPrice*Total.Quantity)
		FROM Sales.OrderLines AS Total
			JOIN Sales.Orders AS ordTotal On ordTotal.OrderID = Total.OrderID
		WHERE ordTotal.CustomerID = Inv.CustomerID) > 250000
	AND DATEDIFF(dd, Inv.InvoiceDate, ord.OrderDate) = 0
GROUP BY ord.CustomerID, det.StockItemID
ORDER BY ord.CustomerID, det.StockItemID;
--в итоге, WITH (FORCESEEK) помогло улучшить запрос. Результаты: 33% исходный запрос, 42% "улучшенный", 25% запрос с указанием WITH (FORCESEEK)