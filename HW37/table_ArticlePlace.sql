USE [LittleLozon]
GO

/****** Object:  Table [dbo].[ArticlePlace]    Script Date: 30.01.2024 18:00:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ArticlePlace](
	[ArticleID] [BIGINT] NOT NULL,
	[PlaceID] [BIGINT] NOT NULL,
	[MomentIn] [DATETIME] NOT NULL,
	[MomentOut] [DATETIME] NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ArticlePlace]  WITH CHECK ADD FOREIGN KEY([ArticleID])
REFERENCES [dbo].[Article] ([ID])
GO

ALTER TABLE [dbo].[ArticlePlace]  WITH CHECK ADD FOREIGN KEY([PlaceID])
REFERENCES [dbo].[Place] ([ID])
GO


