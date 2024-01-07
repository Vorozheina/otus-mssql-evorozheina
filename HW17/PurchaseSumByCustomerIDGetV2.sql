USE WideWorldImporters
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE PurchaseSumByCustomerIDGetV2
	  @CustomerID		INT = NULL
	, @PurchaseSum		DECIMAL(18, 2)		OUTPUT
AS
BEGIN
  SET NOCOUNT, XACT_ABORT ON;
  IF @CustomerID IS NULL
  BEGIN
		RETURN 0; 
  END;
  SELECT @PurchaseSum = ISNULL(SUM(SIL.ExtendedPrice), 0)
  FROM Sales.InvoiceLines SIL
	INNER JOIN Sales.Invoices SI ON SI.InvoiceID = SIL.InvoiceID
	INNER JOIN Sales.Customers SC ON SC.CustomerID = SI.CustomerID
  WHERE SC.CustomerID = @CustomerID;

END;
GO