USE WideWorldImporters
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER FUNCTION CustomersShortInfoByCustomerCategoryNameGetLst_udf
	(
		@CustomerCategoryName		NVARCHAR(100),
		@RCnt				INT = 500
	)
RETURNS TABLE
AS
RETURN
(
  SELECT TOP (@RCnt) SC.CustomerName, SCC.CustomerCategoryName,
	SBG.BuyingGroupName, AP1.FullName PrimaryContactPerson, 
	ADM.DeliveryMethodName, AC2.CityName PostalCity,
	SC.PhoneNumber, SC.WebsiteURL, SC.PostalAddressLine1, SC.PostalAddressLine2
  FROM Sales.Customers SC
		INNER JOIN Sales.CustomerCategories SCC ON SCC.CustomerCategoryID = SC.CustomerCategoryID
		INNER JOIN Sales.BuyingGroups SBG ON SBG.BuyingGroupID = SC.BuyingGroupID
		INNER JOIN Application.People AP1 ON AP1.PersonID = SC.PrimaryContactPersonID
		INNER JOIN Application.DeliveryMethods ADM ON ADM.DeliveryMethodID = SC.DeliveryMethodID
		INNER JOIN Application.Cities AC2 ON AC2.CityID = SC.PostalCityID
  WHERE SCC.CustomerCategoryName LIKE N'%'+ @CustomerCategoryName + N'%'
  ORDER BY SC.CustomerName
)
GO