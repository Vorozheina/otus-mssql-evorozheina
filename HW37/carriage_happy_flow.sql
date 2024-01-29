USE LittleLozon
GO

SET NOCOUNT, XACT_ABORT ON
GO

DECLARE
		@carriage			BIGINT,--ID ���������
		@posting_1			BIGINT = 290000001623000,--ID ����������� 1
		@posting_2			BIGINT = 290000001624000,--ID ����������� 2
		@contract			BIGINT = 14830357361000,--ID ��������
		@route				BIGINT = 18033611823000,--ID ��������
		@car_type			VARCHAR(255) = 'Scania Super',--������ ������
		@car_num			VARCHAR(255) = '�314��69',--���.����� ������
		@trucker			VARCHAR(255) = '������ ����� �������������',--��������
		@moment DATETIME = GETDATE();--������� ����/�����

--BEGIN TRANSACTION
--�������� ���������--
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
--���������� ���������--
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
--������������ ���������--

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
--�������� ���������--
EXEC dbo.CarriageFromBandedToSent @CarriageID = @carriage -- bigint
----------------------------------------------------------------------------
SELECT *
FROM dbo.Carriage
WHERE ID = @carriage

SELECT *
FROM dbo.CarriagePlace
WHERE CarriageID = @carriage
------------------------------------------------------------------------------
--������� ���������--
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