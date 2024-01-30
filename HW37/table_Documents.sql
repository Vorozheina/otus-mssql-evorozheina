USE [LittleLozon]
GO

/****** Object:  Table [dbo].[Documents]    Script Date: 30.01.2024 18:03:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Documents](
	[ID] [BIGINT] NOT NULL,
	[DateIn] [DATETIME] NOT NULL,
	[Amount] [MONEY] NULL,
	[SenderPersonID] [BIGINT] NULL,
	[ReceiverPersonID] [BIGINT] NULL,
	[ContractID] [BIGINT] NULL,
	[CarriageID] [BIGINT] NULL,
	[Name] [VARCHAR](255) NOT NULL,
	[Descript] [VARCHAR](255) NULL,
	[DocumentType] [VARCHAR](255) NULL,
	[Num] [VARCHAR](255) NULL,
	[DocumentConfirmedForProcessing] [DATETIME] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Documents]  WITH CHECK ADD FOREIGN KEY([CarriageID])
REFERENCES [dbo].[Carriage] ([ID])
GO

ALTER TABLE [dbo].[Documents]  WITH CHECK ADD FOREIGN KEY([ContractID])
REFERENCES [dbo].[Contract] ([ID])
GO

ALTER TABLE [dbo].[Documents]  WITH CHECK ADD FOREIGN KEY([ReceiverPersonID])
REFERENCES [dbo].[Contractor] ([ID])
GO

ALTER TABLE [dbo].[Documents]  WITH CHECK ADD FOREIGN KEY([SenderPersonID])
REFERENCES [dbo].[Contractor] ([ID])
GO


