USE [LittleLozon]
GO
/****** Object:  StoredProcedure [dbo].[CarriageToBanded]    Script Date: 30.01.2024 18:12:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Процедура формирования перевозки, внутри также создаются документы для перевозки: транспортная накладная и товарная накладная
-- Кандидат на рефакторинг!!
CREATE OR ALTER   PROCEDURE [dbo].[CarriageToBanded]
  @CarriageID                 BIGINT

AS
BEGIN
  SET NOCOUNT, XACT_ABORT ON;

  DECLARE
    @ArticleList		dbo.IdList
  , @ArticleInDocument  dbo.ArticleInDocumentList
  , @CarriageState		VARCHAR(255)
  , @ContractID			BIGINT
  , @SenderPersonID		BIGINT
  , @ReceiverPersonID	BIGINT
  , @DateIn				DATETIME
  , @Amount				MONEY
  , @GoodsDocumentID	BIGINT
  , @ID_ArticleInGoodsDocument BIGINT
  , @WaybillDocumentID	BIGINT
  , @ID_ArticleInWaybillDocument BIGINT
  , @i					BIGINT;

  SELECT @CarriageState = C.CarriageState
  FROM dbo.Carriage C 
  WHERE C.ID = @CarriageID;
  --проверили, что перевозка в подходящем статусе
  IF @CarriageState <> 'Created'
  BEGIN
    EXECUTE dbo.[Abort]
      @Code = @@PROCID
    , @Message = 'Перевозка "%s" находится в неподходящем статусе "%s"!'
    , @p1 = @CarriageID
	, @p2 = @CarriageState;
  END;
  --собрали ID всех предметов в перевозке
  INSERT INTO @ArticleList (ID)
  SELECT AIC.ArticleID
  FROM dbo.ArticleInCarriage AIC
  WHERE AIC.CarriageID = @CarriageID AND AIC.MomentOut IS NULL

  
  SELECT
      @ContractID = CT.ID
    , @SenderPersonID = CT.CustomerID
    , @ReceiverPersonID = CT.PerformerID
    FROM
      dbo.Carriage C
      INNER JOIN dbo.Route R ON (R.ID = C.RouteID)
      INNER JOIN dbo.Place P ON (P.ID = R.MinPlaceID)
      INNER JOIN dbo.[Contract] CT ON (CT.ID = P.ContractID)
 
	SELECT @Amount = SUM(ISNULL(A.Cost, 0))
	FROM dbo.Article A
		INNER JOIN @ArticleList AA ON AA.ID = A.ID


	INSERT INTO @ArticleInDocument
	(
	    ArticleID,
	    DocQty,
	    FactQty,
	    DefectQty,
	    Price,
	    Cost,
	    VATRate,
	    VAT,
	    Name,
		ObjectType,
		Descript
	)
	SELECT A.ID, 1, 1, 0, A.Price, A.Cost, 20, A.Cost*0.2, A.Name, A.ArticleType, A.Descript
	FROM dbo.Article A
		INNER JOIN @ArticleList AA ON AA.ID = A.ID
 
	SELECT @i = COUNT(AL.ID)
	FROM @ArticleList AL

  BEGIN TRANSACTION;

  UPDATE dbo.Carriage
  SET CarriageState = 'Banded'
  WHERE ID = @CarriageID;
  
  SET @DateIn = GETDATE();
  --выделить в отдельную ХП
  EXEC dbo.DocumentsAdd @ID = @GoodsDocumentID OUTPUT,                -- bigint
                        @ObjectTypeSysName = 'Товарная накладная',         -- varchar(255)
                        @Name = NULL,                      -- varchar(255)
                        @Descript = NULL,                  -- varchar(255)
                        @DateIn = @DateIn, -- datetime
                        @Amount = @Amount,                  -- money
                        @Num = NULL,                       -- varchar(255)
                        @SenderPersonID = @SenderPersonID,             -- bigint
                        @ReceiverPersonID = @ReceiverPersonID,           -- bigint
                        @ContractID = @ContractID,                 -- bigint
                        @CarriageID = @CarriageID                  -- bigint
  
  EXEC dbo.ArticleInDocumentNewNumberGet @ID = @ID_ArticleInGoodsDocument OUTPUT -- bigint
  
 INSERT INTO dbo.ArticleInDocument
  (
      ID,
      DocumentID,
	  ArticleID,
      DocQty,
      FactQty,
      DefectQty,
      Price,
      Cost,
      NDS,
	  NDSValue,
      Name,
      ObjectType,
      Descript
  )
  SELECT
      @ID_ArticleInGoodsDocument + (ROW_NUMBER() OVER (ORDER BY aid.ArticleID ASC)) AS ID
    , @GoodsDocumentID
    , aid.ArticleID
    , aid.DocQty
    , aid.FactQty
    , aid.DefectQty
    , aid.Price
    , aid.Cost
    , aid.VATRate
    , aid.VAT
    , aid.[Name] 
	, aid.ObjectType
	, aid.Descript
    FROM
      @ArticleInDocument aid;

	SET @i = @i + @ID_ArticleInGoodsDocument;
	
	DECLARE @s nvarchar(1000);

	SET @s = N'
	ALTER SEQUENCE
		dbo.Sequence_ArticleInDocument
	RESTART WITH ' + CAST(@i AS nvarchar(10));
	EXEC (@s);
--выделить в отдельную ХП
  EXEC dbo.DocumentsAdd @ID = @WaybillDocumentID OUTPUT,                -- bigint
                        @ObjectTypeSysName = 'Транспортная накладная',         -- varchar(255)
                        @Name = NULL,                      -- varchar(255)
                        @Descript = NULL,                  -- varchar(255)
                        @DateIn = @DateIn, -- datetime
                        @Amount = @Amount,                  -- money
                        @Num = NULL,                       -- varchar(255)
                        @SenderPersonID = @SenderPersonID,             -- bigint
                        @ReceiverPersonID = @ReceiverPersonID,           -- bigint
                        @ContractID = @ContractID,                 -- bigint
                        @CarriageID = @CarriageID                  -- bigint
  
  EXEC dbo.ArticleInDocumentNewNumberGet @ID = @ID_ArticleInWaybillDocument OUTPUT -- bigint
  
 INSERT INTO dbo.ArticleInDocument
  (
      ID,
      DocumentID,
	  ArticleID,
      DocQty,
      FactQty,
      DefectQty,
      Price,
      Cost,
      NDS,
	  NDSValue,
      Name,
      ObjectType,
      Descript
  )
  SELECT
      @ID_ArticleInWaybillDocument + (ROW_NUMBER() OVER (ORDER BY aid.ArticleID ASC)) AS ID
    , @WaybillDocumentID
    , aid.ArticleID
    , aid.DocQty
    , aid.FactQty
    , aid.DefectQty
    , aid.Price
    , aid.Cost
    , aid.VATRate
    , aid.VAT
    , aid.[Name] 
	, aid.ObjectType
	, aid.Descript
    FROM
      @ArticleInDocument aid;
  
  COMMIT TRANSACTION;
END;
