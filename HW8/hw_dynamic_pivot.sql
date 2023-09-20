USE WideWorldImporters;
GO
/*
Пишем динамический PIVOT по заданию из занятия "Операторы CROSS APPLY,
PIVOT, UNPIVOT".
Требуется написать запрос, который в результате своего выполнения формирует
сводку по количеству покупок в разрезе клиентов и месяцев.
В строках должны быть месяцы (дата начала месяца), в столбцах - клиенты.
Нужно написать запрос, который будет генерировать результаты для всех клиентов.
Имя клиента указывать полностью из поля CustomerName.
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