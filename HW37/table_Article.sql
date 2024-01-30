USE [LittleLozon]
GO

/****** Object:  Table [dbo].[Article]    Script Date: 30.01.2024 17:56:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Article](
	[ID] [BIGINT] NOT NULL,
	[ItemID] [BIGINT] NOT NULL,
	[PlaceID] [BIGINT] NULL,
	[DstPlaceID] [BIGINT] NULL,
	[Price] [MONEY] NULL,
	[Cost] [MONEY] NULL,
	[ContractorID] [BIGINT] NOT NULL,
	[ContainerID] [BIGINT] NULL,
	[RouteID] [BIGINT] NULL,
	[Barcode] [VARCHAR](50) NULL,
	[Weight] [BIGINT] NULL,
	[DeliveryPrice] [MONEY] NULL,
	[IsReturn] [TINYINT] NOT NULL,
	[ContractID] [BIGINT] NULL,
	[Name] [VARCHAR](255) NOT NULL,
	[Descript] [VARCHAR](255) NULL,
	[ArticleType] [VARCHAR](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Article]  WITH CHECK ADD FOREIGN KEY([ContainerID])
REFERENCES [dbo].[Article] ([ID])
GO

ALTER TABLE [dbo].[Article]  WITH CHECK ADD FOREIGN KEY([ContractorID])
REFERENCES [dbo].[Contractor] ([ID])
GO

ALTER TABLE [dbo].[Article]  WITH CHECK ADD FOREIGN KEY([ContractID])
REFERENCES [dbo].[Contract] ([ID])
GO

ALTER TABLE [dbo].[Article]  WITH CHECK ADD FOREIGN KEY([DstPlaceID])
REFERENCES [dbo].[Place] ([ID])
GO

ALTER TABLE [dbo].[Article]  WITH CHECK ADD FOREIGN KEY([ItemID])
REFERENCES [dbo].[Item] ([ID])
GO

ALTER TABLE [dbo].[Article]  WITH CHECK ADD FOREIGN KEY([PlaceID])
REFERENCES [dbo].[Place] ([ID])
GO

ALTER TABLE [dbo].[Article]  WITH CHECK ADD FOREIGN KEY([RouteID])
REFERENCES [dbo].[Route] ([ID])
GO

ALTER TABLE [dbo].[Article]  WITH CHECK ADD CHECK  (([IsReturn]=(1) OR [IsReturn]=(0)))
GO


