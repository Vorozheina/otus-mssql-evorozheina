USE [LittleLozon]
GO
/****** Object:  StoredProcedure [dbo].[ArticleInDocumentNewNumberGet]    Script Date: 30.01.2024 18:07:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--------------------------------------------------------------------------------------------------------------------------------------------
-- НАЗНАЧЕНИЕ:    Формирование нового номера предмета в перечне.
--------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR ALTER       PROCEDURE [dbo].[ArticleInDocumentNewNumberGet]
  @ID BIGINT OUTPUT
AS
BEGIN
  SET NOCOUNT ON;

  --
  SET @ID = (NEXT VALUE FOR [dbo].[Sequence_ArticleInDocument]);
END;