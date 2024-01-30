USE [LittleLozon]
GO

/****** Object:  Table [dbo].[Carriage]    Script Date: 30.01.2024 18:01:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Carriage](
	[ID] [BIGINT] NOT NULL,
	[Barcode] [VARCHAR](50) NULL,
	[Number] [VARCHAR](255) NOT NULL,
	[Date] [DATETIME] NULL,
	[CarType] [VARCHAR](255) NULL,
	[CarNum] [VARCHAR](255) NULL,
	[RouteID] [BIGINT] NULL,
	[Trucker] [VARCHAR](255) NULL,
	[SendDate] [DATETIME] NULL,
	[ArriveDate] [DATETIME] NULL,
	[CarriageState] [VARCHAR](255) NOT NULL,
	[Num] [VARCHAR](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Carriage]  WITH CHECK ADD FOREIGN KEY([RouteID])
REFERENCES [dbo].[Route] ([ID])
GO

ALTER TABLE [dbo].[Carriage]  WITH CHECK ADD CHECK  (([CarriageState]='Arrived' OR [CarriageState]='Sent' OR [CarriageState]='Banded' OR [CarriageState]='Created'))
GO


