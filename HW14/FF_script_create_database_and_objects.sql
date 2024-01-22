USE [master]
GO

DROP DATABASE IF EXISTS LittleLozon
GO

CREATE DATABASE LittleLozon
COLLATE Cyrillic_General_CI_AS
GO

USE LittleLozon;
GO

CREATE TABLE [Item] (
  [ID] bigint PRIMARY KEY NOT NULL,
  [Name] varchar(max) NOT NULL,
  [Descript] VARCHAR(MAX),
  [ItemType] VARCHAR(MAX)
)
GO

CREATE TABLE [Place] (
  [ID] BIGINT PRIMARY KEY NOT NULL,
  [Barcode] VARCHAR(50) NULL,
  [ContractID] BIGINT NULL,
  [OwnerObjectID] BIGINT NULL,
  [Name] VARCHAR(MAX) NOT NULL,
  [Descript] VARCHAR(MAX) NULL,
  [PlaceType] VARCHAR(MAX) NULL
)

GO

CREATE TABLE [Contract] (
  [ID] BIGINT PRIMARY KEY NOT NULL,
  [Date] DATETIME NULL,
  [Num] VARCHAR(MAX) NULL,
  [CustomerID] BIGINT NOT NULL,
  [PerformerID] BIGINT NOT NULL,
  [StopDate] DATETIME NULL,
  [NDSFree] TINYINT NULL,
  [Name] VARCHAR(MAX) NOT NULL,
  [Descript] VARCHAR(MAX) NULL,
  [ContractType] VARCHAR(MAX) NULL
)

GO

CREATE TABLE [Contractor] (
  [ID] BIGINT PRIMARY KEY NOT NULL,
  [Name] VARCHAR(MAX) NOT NULL,
  [INN] VARCHAR(255) NULL,
  [KPP] VARCHAR(255) NULL,
  [LegalAddressStr] VARCHAR(MAX) NULL,
  [ShortName] VARCHAR(255) NULL,
  [Descript] VARCHAR(MAX) NULL,
  [ContractorType] VARCHAR(MAX) NULL
)
GO

CREATE TABLE [Route] (
  [ID] BIGINT PRIMARY KEY NOT NULL,
  [Name] VARCHAR(MAX) NOT NULL,
  [Descript] VARCHAR(MAX) NULL,
  [MinPlaceID] BIGINT NOT NULL,
  [MaxPlaceID] BIGINT NOT NULL
)

GO

CREATE TABLE [Carriage] (
  [ID] bigint PRIMARY KEY  NOT NULL,
  [Barcode] varchar(50) NULL,
  [Number] varchar(max) NOT NULL,
  [Date] DATETIME NULL,
  [CarType] varchar(max) NULL,
  [CarNum] varchar(max) NULL,
  [RouteID] BIGINT NULL,
  [Trucker] varchar(max) NULL,
  [SendDate] DATETIME NULL,
  [ArriveDate] DATETIME NULL,
  [CarriageState] varchar(255) NOT NULL CHECK ([CarriageState] IN ('Created', 'Banded', 'Sent', 'Arrived'))
)

GO

CREATE TABLE [Documents] (
  [ID] bigint PRIMARY KEY,
  [DateIn] datetime NOT NULL,
  [IntNum] [int] IDENTITY(1,1) NOT NULL,
  [Amount] MONEY NULL,
  [SenderPersonID] BIGINT NULL,
  [ReceiverPersonID] BIGINT NULL,
  [ContractID] BIGINT NULL,
  [CarriageID] BIGINT NULL,
  [Name] varchar(max) NOT NULL,
  [Descript] varchar(max) NULL,
  [DocumentType] varchar(max) NULL
)

GO

CREATE TABLE [Article] (
  [ID] bigint PRIMARY KEY,
  [ItemID] bigint NOT NULL,
  [PlaceID] BIGINT NULL,
  [DstPlaceID] BIGINT NULL,
  [Price] MONEY NULL,
  [Cost] MONEY NULL,
  [ContractorID] bigint NOT NULL,
  [ContainerID] BIGINT NULL,
  [RouteID] BIGINT NULL,
  [Barcode] varchar(50) NULL,
  [Weight] BIGINT NULL,
  [DeliveryPrice] MONEY NULL,
  [IsReturn] TINYINT NOT NULL CHECK ([IsReturn] IN (0, 1)),
  [ContractID] BIGINT NULL,
  [Name] varchar(max) NOT NULL,
  [Descript] varchar(max) NULL
)

GO

CREATE TABLE [PersonHuman] (
  [ID] bigint PRIMARY KEY,
  [LastName] varchar(255) NOT NULL,
  [FirstName] varchar(255) NOT NULL,
  [MiddleName] varchar(255) NULL,
  [Address] varchar(max) NULL,
  [Phone] varchar(12) NULL,
  [Email] varchar(255) NULL,
  [Passport] varchar(max) NULL,
  [Descript] varchar(max) NULL
)

GO

CREATE TABLE [CarriagePlace] (
  [CarriageID] bigint NOT NULL,
  [PlaceID] bigint NOT NULL,
  [MomentIn] datetime NOT NULL,
  [MomentOut] DATETIME NULL
)

GO

CREATE TABLE [ArticleInCarriage] (
  [ArticleID] bigint NOT NULL,
  [CarriageID] bigint NOT NULL,
  [MomentIn] datetime NOT NULL,
  [MomentOut] DATETIME NULL,
  [TakeOffPlaceID] BIGINT NULL,
  [PutInPlaceID] BIGINT NULL
)

GO

CREATE TABLE [ArticlePlace] (
  [ArticleID] bigint NOT NULL,
  [PlaceID] bigint NOT NULL,
  [MomentIn] datetime NOT NULL,
  [MomentOut] DATETIME NULL
)

GO

CREATE TABLE [ArticleInDocument] (
  [ID] bigint PRIMARY KEY NOT NULL,
  [ArticleID] bigint NOT NULL,
  [DocQty] INT NULL,
  [FactQty] int NULL,
  [DefectQty] int NULL,
  [Price] money NULL,
  [Cost] money NULL,
  [NDS] float NULL,
  [DocumentID] bigint NULL,
  [ObjectType] varchar(max) NULL,
  [NDSValue] money NULL,
  [Name] varchar(MAX) NOT NULL,
  [Descript] varchar(max) NULL
)

GO

ALTER TABLE [Place] ADD FOREIGN KEY ([ContractID]) REFERENCES [Contract] ([ID])
GO

ALTER TABLE [Place] ADD FOREIGN KEY ([OwnerObjectID]) REFERENCES [Place] ([ID])
GO

ALTER TABLE [Contract] ADD FOREIGN KEY ([CustomerID]) REFERENCES [Contractor] ([ID])
GO

ALTER TABLE [Contract] ADD FOREIGN KEY ([PerformerID]) REFERENCES [Contractor] ([ID])
GO

ALTER TABLE [Route] ADD FOREIGN KEY ([MinPlaceID]) REFERENCES [Place] ([ID])
GO

ALTER TABLE [Route] ADD FOREIGN KEY ([MaxPlaceID]) REFERENCES [Place] ([ID])
GO

ALTER TABLE [Carriage] ADD FOREIGN KEY ([RouteID]) REFERENCES [Route] ([ID])
GO

ALTER TABLE [Documents] ADD FOREIGN KEY ([SenderPersonID]) REFERENCES [PersonHuman] ([ID])
GO

ALTER TABLE [Documents] ADD FOREIGN KEY ([ReceiverPersonID]) REFERENCES [PersonHuman] ([ID])
GO

ALTER TABLE [Documents] ADD FOREIGN KEY ([ContractID]) REFERENCES [Contract] ([ID])
GO

ALTER TABLE [Documents] ADD FOREIGN KEY ([CarriageID]) REFERENCES [Carriage] ([ID])
GO

ALTER TABLE [Article] ADD FOREIGN KEY ([ItemID]) REFERENCES [Item] ([ID])
GO

ALTER TABLE [Article] ADD FOREIGN KEY ([PlaceID]) REFERENCES [Place] ([ID])
GO

ALTER TABLE [Article] ADD FOREIGN KEY ([DstPlaceID]) REFERENCES [Place] ([ID])
GO

ALTER TABLE [Article] ADD FOREIGN KEY ([ContractorID]) REFERENCES [Contractor] ([ID])
GO

ALTER TABLE [Article] ADD FOREIGN KEY ([ContainerID]) REFERENCES [Article] ([ID])
GO

ALTER TABLE [Article] ADD FOREIGN KEY ([RouteID]) REFERENCES [Route] ([ID])
GO

ALTER TABLE [Article] ADD FOREIGN KEY ([ContractID]) REFERENCES [Contract] ([ID])
GO

ALTER TABLE [CarriagePlace] ADD FOREIGN KEY ([CarriageID]) REFERENCES [Carriage] ([ID])
GO

ALTER TABLE [CarriagePlace] ADD FOREIGN KEY ([PlaceID]) REFERENCES [Place] ([ID])
GO

ALTER TABLE [ArticleInCarriage] ADD FOREIGN KEY ([ArticleID]) REFERENCES [Article] ([ID])
GO

ALTER TABLE [ArticleInCarriage] ADD FOREIGN KEY ([CarriageID]) REFERENCES [Carriage] ([ID])
GO

ALTER TABLE [ArticleInCarriage] ADD FOREIGN KEY ([TakeOffPlaceID]) REFERENCES [Place] ([ID])
GO

ALTER TABLE [ArticleInCarriage] ADD FOREIGN KEY ([PutInPlaceID]) REFERENCES [Place] ([ID])
GO

ALTER TABLE [ArticlePlace] ADD FOREIGN KEY ([ArticleID]) REFERENCES [Article] ([ID])
GO

ALTER TABLE [ArticlePlace] ADD FOREIGN KEY ([PlaceID]) REFERENCES [Place] ([ID])
GO

ALTER TABLE [ArticleInDocument] ADD FOREIGN KEY ([ArticleID]) REFERENCES [Article] ([ID])
GO

ALTER TABLE [ArticleInDocument] ADD FOREIGN KEY ([DocumentID]) REFERENCES [Documents] ([ID])
GO

CREATE INDEX IX_Place_OwnerObjectID ON [Place] ([OwnerObjectID]);
CREATE INDEX IX_Place_ContractID ON [Place] ([ContractID]);
GO

CREATE INDEX IX_Contract_Date ON [Contract] ([Date]);
CREATE INDEX IX_Contract_CustomerID ON [Contract] ([CustomerID]);
CREATE INDEX IX_Contract_PerformerID ON [Contract] ([PerformerID]);
GO

CREATE INDEX IX_Route_MinPlaceID ON [Route] ([MinPlaceID]);
CREATE INDEX IX_Route_MaxPlaceID ON [Route] ([MaxPlaceID]);
GO

CREATE INDEX IX_Carriage_Date ON [Carriage] ([Date]);
CREATE INDEX IX_Carriage_RouteID ON [Carriage] ([RouteID]);
GO

CREATE INDEX IX_Documents_DateIn ON [Documents] ([DateIn]);
CREATE INDEX IX_Documents_SenderPersonID ON [Documents] ([SenderPersonID]);
CREATE INDEX IX_Documents_ReceiverPersonID ON [Documents] ([ReceiverPersonID]);
CREATE INDEX IX_Documents_ContractID ON [Documents] ([ContractID]);
CREATE INDEX IX_Documents_CarriageID ON [Documents] ([CarriageID]);
GO

CREATE INDEX IX_Article_ItemID ON [Article] ([ItemID]);
CREATE INDEX IX_Article_PlaceID ON [Article] ([PlaceID]);
CREATE INDEX IX_Article_DstPlaceID ON [Article] ([DstPlaceID]);
CREATE INDEX IX_Article_ContractorID ON [Article] ([ContractorID]);
CREATE INDEX IX_Article_ContainerID ON [Article] ([ContainerID]);
CREATE INDEX IX_Article_RouteID ON [Article] ([RouteID]);
CREATE INDEX IX_Article_ContractID ON [Article] ([ContractID]);
GO

CREATE INDEX IX_PersonHuman_LastName ON [PersonHuman] ([LastName]);
CREATE INDEX IX_PersonHuman_Phone ON [PersonHuman] ([Phone]);
CREATE INDEX IX_PersonHuman_Email ON [PersonHuman] ([Email]);
GO

CREATE NONCLUSTERED INDEX IX_CarriagePlace_PlaceID_MomentIn ON [CarriagePlace] (PlaceID, MomentIn);
CREATE NONCLUSTERED INDEX IX_CarriagePlace_PlaceID_MomentOut ON [CarriagePlace] (PlaceID, MomentOut);
GO

CREATE NONCLUSTERED INDEX IX_ArticleInCarriage_CarriageID_MomentIn ON [ArticleInCarriage] (CarriageID, MomentIn);
CREATE NONCLUSTERED INDEX IX_ArticleInCarriage_CarriageID_MomentOut ON [ArticleInCarriage] (CarriageID, MomentOut);
GO

CREATE NONCLUSTERED INDEX IX_ArticlePlace_PlaceID_MomentIn ON [ArticlePlace] (PlaceID, MomentIn);
CREATE NONCLUSTERED INDEX IX_ArticlePlace_PlaceID_MomentOut ON [ArticlePlace] (PlaceID, MomentOut);
GO

CREATE INDEX IX_ArticleInDocument_ArticleID ON [ArticleInDocument] ([ArticleID]);
CREATE INDEX IX_ArticleInDocument_DocumentID ON [ArticleInDocument] ([DocumentID]);
GO