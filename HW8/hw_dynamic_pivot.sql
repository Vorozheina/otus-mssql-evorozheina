USE WideWorldImporters;
GO
/*
����� ������������ PIVOT �� ������� �� ������� "��������� CROSS APPLY,
PIVOT, UNPIVOT".
��������� �������� ������, ������� � ���������� ������ ���������� ���������
������ �� ���������� ������� � ������� �������� � �������.
� ������� ������ ���� ������ (���� ������ ������), � �������� - �������.
����� �������� ������, ������� ����� ������������ ���������� ��� ���� ��������.
��� ������� ��������� ��������� �� ���� CustomerName.
*/


DECLARE @columns NVARCHAR(MAX), 
		@query NVARCHAR(MAX);

SELECT @columns = STRING_AGG(CONVERT(NVARCHAR(MAX), '[' + CustomerName + ']'), ',') FROM Sales.Customers;

SET @query = 'SELECT FORMAT(P.InvoiceMonth, ''dd.MM.yyyy'') AS InvoiceMonth, ' + @columns +
'FROM (SELECT Customers.CustomerName, 
			 Sales.InvoiceLines.InvoiceID, 
			 DATEADD(MONTH, DATEDIFF(MONTH, 0, InvoiceDate), 0) AS InvoiceMonth 
	  FROM Sales.Invoices
			INNER JOIN Sales.Customers ON Customers.CustomerID = Invoices.CustomerID
			INNER JOIN Sales.InvoiceLines ON InvoiceLines.InvoiceID = Invoices.InvoiceID) AS S
PIVOT (COUNT(S.InvoiceID) FOR S.CustomerName IN (' + @columns + ')) AS P
ORDER BY YEAR(P.InvoiceMonth), MONTH(P.InvoiceMonth);'

PRINT @query;
EXEC sp_executesql @query;

EXEC(@query);
GO

EXEC dbo.PivotCustomersCountOfInvoicesByMonth;
GO