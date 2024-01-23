
EXEC sys.sp_configure @configname = 'show advanced', -- varchar(35)
                      @configvalue = 1  -- int

RECONFIGURE
GO

EXEC sys.sp_configure 'clr enabled'
EXEC sys.sp_configure 'clr enabled', 1

RECONFIGURE

EXEC sys.sp_configure 'clr enabled'


ALTER AUTHORIZATION ON DATABASE :: [WideWorldImporters] TO SA;
GO

USE WideWorldImporters;
GO

ALTER DATABASE WideWorldImporters SET TRUSTWORTHY ON;
GO

CREATE ASSEMBLY MyCLRFunctions
FROM 'C:\work\learn\otus-mssql-evorozheina\HW20\source\MyCLRFunctions\MyCLRFunctions\bin\Debug\MyCLRFunctions.dll' --путь к dll
WITH PERMISSION_SET = SAFE;
GO


CREATE FUNCTION dbo.GetHashByPersonFullName( @FullName AS NVARCHAR(50)) 
RETURNS NVARCHAR(255) 
AS EXTERNAL NAME [MyCLRFunctions].UserDefinedFunctions.GetHashByPersonFullName
GO

SELECT dbo.GetHashByPersonFullName('Kayla Woodcock') AS 'result';
GO