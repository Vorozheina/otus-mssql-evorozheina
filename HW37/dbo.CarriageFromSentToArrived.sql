USE [LittleLozon]
GO
/****** Object:  StoredProcedure [dbo].[CarriageFromSentToArrived]    Script Date: 30.01.2024 18:10:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Процедура прибытия перевозки
CREATE OR ALTER       PROCEDURE [dbo].[CarriageFromSentToArrived]
  @CarriageID                 BIGINT

AS
BEGIN
  SET NOCOUNT, XACT_ABORT ON;

  DECLARE
    @PlaceID			BIGINT
  , @CarriageState		VARCHAR(255)
  , @DateIn				DATETIME;

  SELECT @CarriageState = C.CarriageState,
		@PlaceID = P.ID
  FROM dbo.Carriage C
      INNER JOIN dbo.Route R ON (R.ID = C.RouteID)
      INNER JOIN dbo.Place P ON (P.ID = R.MaxPlaceID) 
  WHERE C.ID = @CarriageID;

  --проверили, что перевозка в подходящем статусе
  IF @CarriageState <> 'Sent'
  BEGIN
    EXECUTE dbo.[Abort]
      @Code = @@PROCID
    , @Message = 'Перевозка "%s" находится в неподходящем статусе "%s"!'
    , @p1 = @CarriageID
	, @p2 = @CarriageState;
  END;
  
  
 
  BEGIN TRANSACTION;
  SET @DateIn = GETDATE();

  UPDATE dbo.Carriage
  SET CarriageState = 'Arrived',
	ArriveDate = @DateIn
  WHERE ID = @CarriageID;
  
  INSERT INTO dbo.CarriagePlace
  (
      CarriageID,
      PlaceID,
      MomentIn,
      MomentOut
  )
  VALUES
  (   @CarriageID,         -- CarriageID - bigint
      @PlaceID,         -- PlaceID - bigint
      @DateIn, -- MomentIn - datetime
      NULL       -- MomentOut - datetime
      )
  
  COMMIT TRANSACTION;
END;
