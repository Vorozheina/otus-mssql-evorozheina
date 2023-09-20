USE [WideWorldImporters]
GO
/****** Object:  StoredProcedure [dbo].[OrdersSearch_KitchenSink]    Script Date: 3/21/2019 11:44:25 PM ******/
USE [WideWorldImporters]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PivotCustomersCountOfInvoicesByMonth]
AS
	BEGIN
		SET NOCOUNT ON;
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
					  ORDER BY YEAR(P.InvoiceMonth), MONTH(P.InvoiceMonth);';
		EXEC sys.sp_executesql @query;
	END;	