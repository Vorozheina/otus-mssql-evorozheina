USE [LittleLozon]
GO

/****** Object:  Table [dbo].[CarriagePlace]    Script Date: 30.01.2024 18:01:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CarriagePlace](
	[CarriageID] [BIGINT] NOT NULL,
	[PlaceID] [BIGINT] NOT NULL,
	[MomentIn] [DATETIME] NOT NULL,
	[MomentOut] [DATETIME] NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[CarriagePlace]  WITH CHECK ADD FOREIGN KEY([CarriageID])
REFERENCES [dbo].[Carriage] ([ID])
GO

ALTER TABLE [dbo].[CarriagePlace]  WITH CHECK ADD FOREIGN KEY([PlaceID])
REFERENCES [dbo].[Place] ([ID])
GO


