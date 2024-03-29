USE [LittleLozon]
GO
/****** Object:  StoredProcedure [dbo].[CarriageAdd]    Script Date: 30.01.2024 18:08:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Добавление перевозки
CREATE OR ALTER     PROCEDURE [dbo].[CarriageAdd]
  @ID                 BIGINT OUTPUT
, @OwnerObjectID      BIGINT  = NULL
, @RouteID            BIGINT  = NULL
, @Date               DATETIME    = NULL
, @Num                VARCHAR(255)  = NULL
, @BarCode            VARCHAR(50) = NULL
, @PlaceID            BIGINT  = NULL
, @CarType            VARCHAR(255)  = NULL
, @CarNum             VARCHAR(255)  = NULL
, @Trucker            VARCHAR(255)  = NULL
, @NoCheck            BIT         = NULL

AS
BEGIN
  SET NOCOUNT, XACT_ABORT ON;

  DECLARE
    @Number       int
  , @CustomerID   BIGINT
  , @PerformerID  BIGINT
  , @CurDate      datetime                 = GETDATE()
  , @ObjectTypeSysName VARCHAR(255)
  , @Name				VARCHAR(255);

  SELECT
	@PlaceID = ISNULL(@PlaceID, (SELECT MinPlaceID FROM dbo.Route WHERE ID = @RouteID))
  , @Date = ISNULL(@Date, @CurDate)
  , @ObjectTypeSysName = 'Перевозка'
  , @NoCheck = ISNULL(@NoCheck, 0)
  , @CarType = TRIM(@CarType)
  , @CarNum = TRIM(@CarNum)
  , @Trucker = TRIM(@Trucker);

  IF LEN(@CarNum) > 50
  BEGIN
    EXECUTE dbo.[Abort]
      @Code = @@PROCID
    , @Message = 'Госномер "%s" не может быть с кол-вом символов более 50!'
    , @p1 = @CarNum;
  END;

  IF (@NoCheck = 0)
  BEGIN
    IF (CAST(@Date AS date) < CAST(@CurDate AS date))
       OR (CAST(@Date AS date) > CAST(DATEADD(DAY, 7, @CurDate) AS date))
    BEGIN
      EXECUTE dbo.[Abort]
        @Code = @@PROCID
      , @Message = 'Запрещено создавать перевозки с датой меньше текущей даты и больше 7ми дней от текущей даты';
    END;

    IF (@PlaceID IS NULL)
    BEGIN
      EXECUTE dbo.[Abort]
        @Code = @@PROCID
      , @Message = 'Не определено исходное место перевозки %s';
    END;

   

    -- Если не указан договор
    IF (ISNULL(@OwnerObjectID, 0) = 0)
    BEGIN
      -- Берем договор из маршрута
      SELECT
        @OwnerObjectID = R_O.OwnerObjectID
      FROM
        dbo.Route R_O
      WHERE
        (R_O.ID = @RouteID);
    END;

    IF (ISNULL(@OwnerObjectID, 0) = 0)
    BEGIN
      EXECUTE dbo.[Abort]
        @Code = @@PROCID
      , @Message = 'Не найден договор для перевозки!';
    END;
  END;

  SELECT
    @CustomerID = C.CustomerID
  , @PerformerID = C.PerformerID
  FROM
    dbo.[Contract] C
  WHERE
    (C.ID = @OwnerObjectID);

  BEGIN TRANSACTION;

  -- Формируем номер
  EXECUTE dbo.CarriageNewNumberGet
    @ID = @Number OUTPUT;

  SET @Num = ISNULL(NULLIF(RTRIM(@Num), ''), RIGHT('000000000' + CAST(@Number AS varchar(9)), 9));
  SET @Name = 'Контракт для перевозки '+ @Num;

  EXECUTE dbo.ContractAdd
    @ID = @ID OUTPUT
  , @ObjectTypeSysName = @ObjectTypeSysName
  , @Name = @Name
  , @Descript = NULL
  , @Date = @Date
  , @Num = @Num
  , @CustomerID = @CustomerID
  , @PerformerID = @PerformerID;

  SET @BarCode = dbo.GetDefaultBarcode(@ID);

  INSERT INTO dbo.Carriage
  (
    ID
  , RouteID
  
  , [Date]
  , Num
  , Barcode
  
  , CarType
  , CarNum
  , Trucker
  , Number
  , CarriageState
  )
  VALUES
  (
    @ID
  , @RouteID
  
  , @Date
  , @Num
  , @BarCode
  
  , @CarType
  , @CarNum
  , @Trucker
  , @Number
  , 'Created'
  );
  
  INSERT INTO dbo.CarriagePlace
  (
    CarriageID
  , PlaceID
  , MomentIn
  , MomentOut
  )
  VALUES
  (
    @ID
  , @PlaceID
  , @CurDate
  , NULL
  );

  
  COMMIT TRANSACTION;
END;
