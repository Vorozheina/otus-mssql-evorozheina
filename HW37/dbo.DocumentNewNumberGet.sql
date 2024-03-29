USE [LittleLozon]
GO
/****** Object:  StoredProcedure [dbo].[DocumentNewNumberGet]    Script Date: 30.01.2024 18:17:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--------------------------------------------------------------------------------------------------------------------------------------------
-- НАЗНАЧЕНИЕ:    Формирование нового номера для документа.
--------------------------------------------------------------------------------------------------------------------------------------------

ALTER     PROCEDURE [dbo].[DocumentNewNumberGet]
  @ID BIGINT OUTPUT
AS
BEGIN
  SET NOCOUNT ON;

  --
  SET @ID = (NEXT VALUE FOR [dbo].[Sequence_Documents]);
END;