USE [LittleLozon]
GO
/****** Object:  StoredProcedure [dbo].[CarriageNewNumberGet]    Script Date: 30.01.2024 18:11:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--------------------------------------------------------------------------------------------------------------------------------------------
-- НАЗНАЧЕНИЕ:    Формирование нового номера перевозки по порядку.
--------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR ALTER   PROCEDURE [dbo].[CarriageNewNumberGet]
  @ID BIGINT OUTPUT
AS
BEGIN
  SET NOCOUNT ON;

  --
  SET @ID = (NEXT VALUE FOR dbo.Sequence_CarriageNumber);
END;