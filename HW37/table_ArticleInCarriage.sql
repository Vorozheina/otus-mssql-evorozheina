USE [LittleLozon]
GO

/****** Object:  Table [dbo].[ArticleInCarriage]    Script Date: 30.01.2024 17:59:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ArticleInCarriage](
	[ArticleID] [BIGINT] NOT NULL,
	[CarriageID] [BIGINT] NOT NULL,
	[MomentIn] [DATETIME] NOT NULL,
	[MomentOut] [DATETIME] NULL,
	[TakeOffPlaceID] [BIGINT] NULL,
	[PutInPlaceID] [BIGINT] NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ArticleInCarriage]  WITH CHECK ADD FOREIGN KEY([ArticleID])
REFERENCES [dbo].[Article] ([ID])
GO

ALTER TABLE [dbo].[ArticleInCarriage]  WITH CHECK ADD FOREIGN KEY([CarriageID])
REFERENCES [dbo].[Carriage] ([ID])
GO

ALTER TABLE [dbo].[ArticleInCarriage]  WITH CHECK ADD FOREIGN KEY([PutInPlaceID])
REFERENCES [dbo].[Place] ([ID])
GO

ALTER TABLE [dbo].[ArticleInCarriage]  WITH CHECK ADD FOREIGN KEY([TakeOffPlaceID])
REFERENCES [dbo].[Place] ([ID])
GO


