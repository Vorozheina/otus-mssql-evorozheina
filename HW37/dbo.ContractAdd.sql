USE [LittleLozon]
GO
/****** Object:  StoredProcedure [dbo].[ContractAdd]    Script Date: 30.01.2024 18:15:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ХП создания нового контракта для перевозки
--Кандидат на доработку по бизнес-процессу
CREATE OR ALTER     PROCEDURE [dbo].[ContractAdd]
  @ID                  BIGINT OUTPUT
, @ObjectTypeSysName   VARCHAR(255) = NULL
, @Name                VARCHAR(255)
, @Descript            VARCHAR(255) = NULL
, @Date                datetime   = NULL
, @Num                 VARCHAR(255) = NULL
, @CustomerID          BIGINT
, @PerformerID         BIGINT
, @StopDate            datetime   = NULL
, @NDSFree             TINYINT  = NULL
AS
BEGIN
  SET NOCOUNT, XACT_ABORT ON;

  DECLARE @ObjectTypeID BIGINT;

  IF ISNULL(@ObjectTypeSysName, '') = ''
  BEGIN
    SET @ObjectTypeSysName = 'Договор на оказание услуг перевозки';
  END;

  IF @ObjectTypeSysName = 'Перевозка'
  BEGIN
    SET @ObjectTypeSysName = 'Договор на оказание услуг перевозки';
  END;

  SET @ID = (NEXT VALUE FOR dbo.Sequence_Object);

  BEGIN TRANSACTION;

  

  INSERT INTO dbo.[Contract]
  (
    ID
  , [Date]
  , Num
  , CustomerID
  , PerformerID
  
  , StopDate
  , NDSfree
  , Name
  , Descript
  , ContractType
  )
  VALUES
  (
    @ID
  , @Date
  , @Num
  , @CustomerID
  , @PerformerID
 
  , @StopDate
  , @NDSFree
  , @Name
  , @Descript
  , @ObjectTypeSysName
  );

  

  COMMIT TRANSACTION;
END;
