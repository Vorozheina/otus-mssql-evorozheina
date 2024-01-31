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
����������� �������� ������:
1) ���� ��������� � �����, � ����� ���������� ������ �� �� �������
2) ���� ������� �������, ������� �������������� ������ (Sales.CustomerTransactions (97147 �������),  Warehouse.StockItemTransactions (236667 �������))
3) � ����� ���� Nested Loops ��� ���������� JOIN
4) � ������� ���� ������������� ��������:
 AND (Select SupplierId
		FROM Warehouse.StockItems AS It
		WHERE It.StockItemID = det.StockItemID) = 12
5) ����� ����, ��� �������� �����������?
6) ����� ����������, ��������� ���������� ������������ �������
7) ��������, ������������� �� ��������� ������� �������� ���������� �������
*/

--1--���������� FORCE ORDER, ����� ����������� ���������� ������
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
--���������: �������� ������ ��� ��� ����� ���������, �� ������ � ����� ��� Nested Loops. 
--�� �����������: ��������� �����������, ��������� ��� ������. ��������� �. 7 MAXDOP
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
--�������������� ����, �� ������ ��-�������� ���� ��������� � ���� ������� ���� �����������������
--��������� ���������� � ��������� ���, ����� ��� index seek
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
--� �����, WITH (FORCESEEK) ������� �������� ������. ����������: 33% �������� ������, 42% "����������", 25% ������ � ��������� WITH (FORCESEEK)