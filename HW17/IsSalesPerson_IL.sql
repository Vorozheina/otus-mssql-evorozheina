USE [WideWorldImporters]
GO
/****** Object:  UserDefinedFunction [cf_common].[ArticleIsReturn_IL]    Script Date: 22.01.2024 18:31:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  FUNCTION [dbo].[IsSalesPerson_IL] (
  @PersonID INT
)
RETURNS TABLE
AS
RETURN ( SELECT
           CASE
             WHEN EXISTS ( SELECT
                             1
                           FROM
                             Application.People P
                           WHERE
                             P.PersonID = @PersonID AND P.IsSalesperson = 1
                             ) THEN 1
             ELSE 0
           END AS [Check]);