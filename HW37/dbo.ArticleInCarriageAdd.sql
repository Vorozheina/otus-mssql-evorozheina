USE [LittleLozon]
GO
/****** Object:  StoredProcedure [dbo].[ArticleInCarriageAdd]    Script Date: 30.01.2024 18:06:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Добавление предмета в перевозку
CREATE OR ALTER     PROCEDURE [dbo].[ArticleInCarriageAdd]
  @ArticleID   BIGINT
, @CarriageID  BIGINT
, @TakeOffPlaceID BIGINT = NULL
AS
BEGIN
  SET NOCOUNT, XACT_ABORT ON;

  BEGIN TRY
    DECLARE 
		@RouteID		BIGINT
		, @PlaceID		BIGINT
		, @WarehouseID	BIGINT
		, @DstPlaceID	BIGINT;

    --проверяем, что предмет может быть добавлен в перевозку
    SELECT @RouteID = C.RouteID
	FROM dbo.Carriage C
	WHERE C.ID = @CarriageID
	
	SELECT @PlaceID = A.PlaceID,
			@DstPlaceID = A.DstPlaceID
	FROM dbo.Article A
	WHERE A.ID = @ArticleID;

	;WITH PlaceCTE AS
	(
		SELECT P.ID,
				P.OwnerObjectID, 
				0 AS level
		FROM dbo.Place P
		WHERE P.ID = @PlaceID
		UNION ALL
		SELECT PP.ID,
				PP.OwnerObjectID, 
				level + 1
		FROM dbo.Place PP
			INNER JOIN PlaceCTE  
				ON PP.ID = PlaceCTE.OwnerObjectID
	)
	SELECT @WarehouseID = PlaceCTE.ID
	FROM PlaceCTE
	WHERE PlaceCTE.OwnerObjectID IS NULL

	IF NOT EXISTS (SELECT 1 
					FROM dbo.Route R 
					WHERE R.MinPlaceID = @WarehouseID AND R.MaxPlaceID = @DstPlaceID AND R.ID = @RouteID)
	BEGIN
		EXECUTE dbo.[Abort]
			@Code = @@PROCID
			, @Message = 'Предмет "%s" не может быть добавлен в перевозку "%s"! Он находится на другом месте (ID = %s)!'
			, @p1 = @ArticleID
			, @p2 = @CarriageID
			, @p3 = @WarehouseID;
	END;

	IF EXISTS (SELECT 1 FROM dbo.ArticleInCarriage AIC WHERE AIC.ArticleID = @ArticleID)
	BEGIN
		EXECUTE dbo.[Abort]
			@Code = @@PROCID
			, @Message = 'Предмет "%s" не может быть добавлен в перевозку "%s"! Он находится в другой перевозке!'
			, @p1 = @ArticleID
			, @p2 = @CarriageID;
	END;

    BEGIN TRANSACTION;

    INSERT INTO dbo.ArticleInCarriage
    (
      ArticleID
    , CarriageID
    , MomentIn
    , PutInPlaceID
    , TakeOffPlaceID
    )
    VALUES
    (
      @ArticleID
    , @CarriageID
    , GETDATE()
    , @WarehouseID
    , @DstPlaceID
    );

    

    COMMIT TRANSACTION;
  END TRY
  BEGIN CATCH
    IF @@TRANCOUNT > 0
      ROLLBACK TRANSACTION;

    THROW;
  END CATCH
END;