USE [LittleLozon]
GO
/****** Object:  UserDefinedFunction [dbo].[GetDefaultBarcode]    Script Date: 30.01.2024 18:24:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Возвращает штрихкод для объекта, генерируемый по умолчанию
CREATE OR ALTER     FUNCTION [dbo].[GetDefaultBarcode] (
  @ID      BIGINT
)
RETURNS VARCHAR(50)
AS
BEGIN
  RETURN ( SELECT
           CONCAT('%', '301', '%', @ID) AS Barcode);
END;