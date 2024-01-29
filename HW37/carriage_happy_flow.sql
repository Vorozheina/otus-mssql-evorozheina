USE LittleLozon
GO

SET NOCOUNT, XACT_ABORT ON
GO

DECLARE
		@carriage			BIGINT,--ID перевозки
		@posting_1			BIGINT = 290000001623000,--ID отправления 1
		@posting_2			BIGINT = 290000001624000,--ID отправления 2
		@contract			BIGINT = 14830357361000,--ID договора
		@route				BIGINT = 18033611823000,--ID маршрута
		@car_type			VARCHAR(255) = 'Scania Super',--модель машины
		@car_num			VARCHAR(255) = 'А314АУ69',--гос.номер машины
		@trucker			VARCHAR(255) = 'Петров Семен Александрович',--водитель
		@moment DATETIME = GETDATE();--текущая дата/время

--BEGIN TRANSACTION
--создание перевозки--
EXEC dbo.CarriageAdd @ID = @carriage OUTPUT,              -- bigint
                     @OwnerObjectID = @contract,            -- bigint
                     @RouteID = @route,                  -- bigint
                     @Date = @moment, -- datetime
                     @Num = NULL,                     -- varchar(255)
                     @BarCode = NULL,                 -- varchar(50)
                     @PlaceID = NULL,                  -- bigint
                     @CarType = @car_type,                 -- varchar(255)
                     @CarNum = @car_num,                  -- varchar(255)
                     @Trucker = @trucker,                 -- varchar(255)
                     @NoCheck = 1                -- bit
SELECT @carriage AS 'CarriageID';
---------------------------------------------------------------------------
SELECT TOP 1 *
FROM dbo.Contract
ORDER BY Date DESC

SELECT *
FROM dbo.Carriage
WHERE ID = @carriage

SELECT *
FROM dbo.CarriagePlace
WHERE CarriageID = @carriage
---------------------------------------------------------------------------
--наполнение перевозки--
EXEC dbo.ArticleInCarriageAdd @ArticleID = @posting_1,     -- bigint
                              @CarriageID = @carriage,    -- bigint
                              @TakeOffPlaceID = NULL -- bigint

EXEC dbo.ArticleInCarriageAdd @ArticleID = @posting_2,     -- bigint
                              @CarriageID = @carriage,    -- bigint
                              @TakeOffPlaceID = NULL -- bigint
----------------------------------------------------------------------------
SELECT *
FROM dbo.ArticleInCarriage
WHERE ArticleID IN (@posting_1, @posting_2)
AND CarriageID = @carriage
----------------------------------------------------------------------------
--формирование перевозки--

EXEC dbo.CarriageToBanded @CarriageID = @carriage -- bigint
----------------------------------------------------------------------------
SELECT *
FROM dbo.Carriage
WHERE ID = @carriage

SELECT *
FROM dbo.Documents
WHERE CarriageID = @carriage

SELECT *
FROM dbo.ArticleInDocument
WHERE ArticleID IN (@posting_1, @posting_2);
----------------------------------------------------------------------------
--отправка перевозки--
EXEC dbo.CarriageFromBandedToSent @CarriageID = @carriage -- bigint
----------------------------------------------------------------------------
SELECT *
FROM dbo.Carriage
WHERE ID = @carriage

SELECT *
FROM dbo.CarriagePlace
WHERE CarriageID = @carriage
------------------------------------------------------------------------------
--приемка перевозки--
EXEC dbo.CarriageFromSentToArrived @CarriageID = @carriage -- bigint
------------------------------------------------------------------------------
SELECT *
FROM dbo.Carriage
WHERE ID = @carriage

SELECT *
FROM dbo.CarriagePlace
WHERE CarriageID = @carriage
--ROLLBACK;
GO