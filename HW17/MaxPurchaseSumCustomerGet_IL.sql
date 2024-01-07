USE WideWorldImporters;
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION MaxPurchaseSumCustomerGet_IL ()
RETURNS NVARCHAR(100)
AS
BEGIN
	RETURN
		(
			SELECT TOP (1) t.CustomerName 
			FROM
				(
					SELECT SUM(SIL.ExtendedPrice) PurchaseSum, SC.CustomerName
					FROM Sales.InvoiceLines SIL
							INNER JOIN Sales.Invoices SI ON SI.InvoiceID = SIL.InvoiceID
							INNER JOIN Sales.Customers SC ON SC.CustomerID = SI.CustomerID
					GROUP BY SC.CustomerName
				) t
			ORDER BY t.PurchaseSum DESC
		);
END;