USE [LittleLozon]
GO
/****** Object:  StoredProcedure [dbo].[DocumentsAdd]    Script Date: 30.01.2024 18:18:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--ХП создания документа
CREATE OR ALTER     PROCEDURE [dbo].[DocumentsAdd]
  @ID                 BIGINT OUTPUT
, @ObjectTypeSysName  VARCHAR(255)
, @Name               VARCHAR(255)
, @Descript           VARCHAR(255) = NULL
, @DateIn             DATETIME   = NULL
, @Amount             MONEY      = NULL
, @Num                VARCHAR(255) = NULL
, @SenderPersonID     BIGINT = NULL
, @ReceiverPersonID   BIGINT = NULL
, @ContractID         BIGINT = NULL
, @CarriageID         BIGINT = NULL
AS
BEGIN
  SET NOCOUNT, XACT_ABORT ON;

  BEGIN TRY
    DECLARE @Number BIGINT;

    IF @DateIn IS NULL
    BEGIN
      SET @DateIn = GETDATE();
    END;

	EXECUTE [dbo].[DocumentNewNumberGet]
			@ID = @Number OUTPUT;
	-- Нумерация документов
    IF NULLIF(TRIM(@Num), '') IS NULL
    BEGIN
		
      SET @Num = ISNULL(NULLIF(RTRIM(@Num), ''), RIGHT('000000000' + CAST(@Number AS varchar(9)), 9));
    END;

    -- Нумерация документов
    SET @Name = @Num + ISNULL(' от ' + CONVERT(VARCHAR(10), @DateIn, 104), '');

    

    BEGIN TRANSACTION;

    -- Получаем ID

    INSERT INTO dbo.Documents
    (
      ID
    , DateIn
    , Amount
    , Num
    , SenderPersonID
    , ReceiverPersonID
    , ContractID
    , CarriageID
    --
    , DocumentType
    , [Name]
    , Descript
    )
    VALUES
    (
      @Number
    , @DateIn
    , @Amount
    , @Num
    , @SenderPersonID
    , @ReceiverPersonID
    , @ContractID
    , @CarriageID
    --
    , @ObjectTypeSysName
    , @Name
    , @Descript
    );

	SET @ID = @Number;

    COMMIT TRANSACTION;
  END TRY
  BEGIN CATCH
    IF @@TRANCOUNT > 0
    BEGIN
      ROLLBACK TRANSACTION;
    END;

    THROW;
  END CATCH;
END;
