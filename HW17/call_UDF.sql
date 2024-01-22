USE WideWorldImporters
GO

SET NOCOUNT ON
GO


SELECT P.PersonID, P.FullName, P.EmailAddress
FROM Application.People P
	CROSS APPLY dbo.IsSalesPerson_IL(P.PersonID) udf_sales
WHERE udf_sales.[Check] = 1
