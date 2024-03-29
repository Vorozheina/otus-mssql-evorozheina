USE [LittleLozon]
GO
/****** Object:  StoredProcedure [dbo].[CarriageFromBandedToSent]    Script Date: 30.01.2024 18:09:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Процедура отправки перевозки
CREATE OR ALTER     PROCEDURE [dbo].[CarriageFromBandedToSent]
  @CarriageID                 BIGINT

AS
BEGIN
  SET NOCOUNT, XACT_ABORT ON;

  DECLARE
    @PlaceID			BIGINT
  , @CarriageState		VARCHAR(255)
  , @DateOut				DATETIME;

  SELECT @CarriageState = C.CarriageState,
		@PlaceID = P.ID
  FROM dbo.Carriage C
      INNER JOIN dbo.Route R ON (R.ID = C.RouteID)
      INNER JOIN dbo.Place P ON (P.ID = R.MinPlaceID) 
  WHERE C.ID = @CarriageID;

  --проверили, что перевозка в подходящем статусе
  IF @CarriageState <> 'Banded'
  BEGIN
    EXECUTE dbo.[Abort]
      @Code = @@PROCID
    , @Message = 'Перевозка "%s" находится в неподходящем статусе "%s"!'
    , @p1 = @CarriageID
	, @p2 = @CarriageState;
  END;
  
  
 
  BEGIN TRANSACTION;
  SET @DateOut = GETDATE();

  UPDATE dbo.Carriage
  SET CarriageState = 'Sent',
  SendDate = @DateOut
  WHERE ID = @CarriageID;
  
  
  UPDATE dbo.CarriagePlace
  SET MomentOut = @DateOut
  WHERE CarriageID = @CarriageID AND PlaceID = @PlaceID
  
  COMMIT TRANSACTION;
END;
