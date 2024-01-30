USE [LittleLozon]
GO

/****** Object:  Table [dbo].[ArticleInDocument]    Script Date: 30.01.2024 17:59:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ArticleInDocument](
	[ID] [BIGINT] NOT NULL,
	[ArticleID] [BIGINT] NOT NULL,
	[DocQty] [INT] NULL,
	[FactQty] [INT] NULL,
	[DefectQty] [INT] NULL,
	[Price] [MONEY] NULL,
	[Cost] [MONEY] NULL,
	[NDS] [FLOAT] NULL,
	[DocumentID] [BIGINT] NULL,
	[ObjectType] [VARCHAR](255) NULL,
	[NDSValue] [MONEY] NULL,
	[Name] [VARCHAR](255) NOT NULL,
	[Descript] [VARCHAR](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ArticleInDocument]  WITH CHECK ADD FOREIGN KEY([ArticleID])
REFERENCES [dbo].[Article] ([ID])
GO

ALTER TABLE [dbo].[ArticleInDocument]  WITH CHECK ADD FOREIGN KEY([DocumentID])
REFERENCES [dbo].[Documents] ([ID])
GO


