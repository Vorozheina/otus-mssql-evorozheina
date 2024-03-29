USE [LittleLozon]
GO
/****** Object:  StoredProcedure [dbo].[Abort]    Script Date: 30.01.2024 18:06:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER    PROCEDURE [dbo].[Abort]
  @Code    int         = 1
, @Message VARCHAR(MAX)  = NULL
, @p1      sql_variant = NULL
, @p2      sql_variant = NULL
, @p3      sql_variant = NULL
, @p4      sql_variant = NULL
, @p5      sql_variant = NULL
, @p6      sql_variant = NULL
, @p7      sql_variant = NULL
, @p8      sql_variant = NULL
, @p9      sql_variant = NULL
, @p10     sql_variant = NULL
, @p11     sql_variant = NULL
, @p12     sql_variant = NULL
, @p13     sql_variant = NULL
, @p14     sql_variant = NULL
, @p15     sql_variant = NULL
, @p16     sql_variant = NULL
WITH EXECUTE AS OWNER
AS
BEGIN
  SET NOCOUNT, XACT_ABORT ON;

  DECLARE @errmsg VARCHAR(MAX);

  BEGIN TRY
    IF ISNULL(@Message, '') <> ''
    BEGIN
      SET @Message = REPLACE(
                       FORMATMESSAGE(
                         @Message
                       , CAST(@p1 AS varchar(8000))
                       , CAST(@p2 AS varchar(8000))
                       , CAST(@p3 AS varchar(8000))
                       , CAST(@p4 AS varchar(8000))
                       , CAST(@p5 AS varchar(8000))
                       , CAST(@p6 AS varchar(8000))
                       , CAST(@p7 AS varchar(8000))
                       , CAST(@p8 AS varchar(8000))
                       , CAST(@p9 AS varchar(8000))
                       , CAST(@p10 AS varchar(8000))
                       , CAST(@p11 AS varchar(8000))
                       , CAST(@p12 AS varchar(8000))
                       , CAST(@p13 AS varchar(8000))
                       , CAST(@p14 AS varchar(8000))
                       , CAST(@p15 AS varchar(8000))
                       , CAST(@p16 AS varchar(8000)))
                     , '%'
                     , '%%');
    END;

    IF @Code < 2
    BEGIN
      SET @Code = NULL;
    END;

    SET @errmsg = ISNULL(OBJECT_NAME(@Code) + ': ', '') + ' Операция отменена. ';

    IF (@Message IS NOT NULL)
       AND RTRIM(@Message) <> ' '
    BEGIN
      SET @errmsg = ISNULL(LTRIM(@errmsg), '') + @Message;
    END;
  END TRY
  BEGIN CATCH
    SET @errmsg = ISNULL(@errmsg, 'Операция отменена : ' + ERROR_MESSAGE());
  END CATCH;

  IF @@TRANCOUNT > 0
    ROLLBACK TRAN;

  THROW 50000, @errmsg, 0;

END;
