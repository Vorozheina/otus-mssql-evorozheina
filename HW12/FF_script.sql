CREATE TABLE [Item] (
  [ID] bigint PRIMARY KEY,
  [Name] varchar(max),
  [Descript] varchar(max),
  [StateID] bigint,
  [ItemType] varchar(max)
)
GO

CREATE TABLE [State] (
  [ID] bigint PRIMARY KEY,
  [Name] varchar(max),
  [Descript] varchar(max),
  [SysName] varchar(max)
)
GO

CREATE TABLE [Place] (
  [ID] bigint PRIMARY KEY,
  [Barcode] varchar(50),
  [ContractID] bigint,
  [OwnerObjectID] bigint,
  [StateID] bigint,
  [Name] varchar(max),
  [Descript] varchar(max),
  [PlaceType] varchar(max)
)
GO

CREATE TABLE [Contract] (
  [ID] bigint PRIMARY KEY,
  [Date] datetime,
  [Num] varchar(max),
  [CustomerID] bigint,
  [PerformerID] bigint,
  [StopDate] datetime,
  [NDSFree] tinyint,
  [Name] varchar(max),
  [Descript] varchar(max),
  [StateID] bigint,
  [ContractType] varchar(max)
)
GO

CREATE TABLE [Contractor] (
  [ID] bigint PRIMARY KEY,
  [Name] varchar(max),
  [INN] varchar(255),
  [KPP] varchar(255),
  [LegalAddressStr] varchar(max),
  [ShortName] varchar(255),
  [Descript] varchar(max),
  [StateID] bigint,
  [ContractorType] varchar(max)
)
GO

CREATE TABLE [Route] (
  [ID] bigint PRIMARY KEY,
  [Name] varchar(max),
  [Descript] varchar(max),
  [MinPlaceID] bigint,
  [MaxPlaceID] bigint,
  [StateID] bigint
)
GO

CREATE TABLE [Carriage] (
  [ID] bigint PRIMARY KEY,
  [Barcode] varchar(50),
  [Number] varchar(max),
  [Date] datetime,
  [CarType] varchar(max),
  [CarNum] varchar(max),
  [RouteID] bigint,
  [Trucker] varchar(max),
  [SendDate] datetime,
  [ArriveDate] datetime,
  [StateID] bigint
)
GO

CREATE TABLE [Documents] (
  [ID] bigint PRIMARY KEY,
  [Num] varchar(max),
  [Name] varchar(max),
  [Amount] money,
  [SenderPersonID] bigint,
  [ReceiverPersonID] bigint,
  [DateIn] datetime,
  [IntNum] varchar(max),
  [ContractID] bigint,
  [CarriageID] bigint,
  [Descript] varchar(max),
  [StateID] bigint,
  [DocumentType] varchar(max)
)
GO

CREATE TABLE [Article] (
  [ID] bigint PRIMARY KEY,
  [ItemID] bigint,
  [PlaceID] bigint,
  [DstPlaceID] bigint,
  [Price] money,
  [Cost] money,
  [ContractorID] bigint,
  [ContainerID] bigint,
  [RouteID] bigint,
  [Barcode] varchar(50),
  [Weight] bigint,
  [DeliveryPrice] money,
  [IsReturn] tinyint,
  [ContractID] bigint,
  [StateID] bigint
)
GO

CREATE TABLE [HumanPerson] (
  [ID] bigint PRIMARY KEY,
  [LastName] varchar(max),
  [FirstName] varchar(max),
  [MiddleName] varchar(max),
  [Address] varchar(max),
  [Phone] varchar(max),
  [Email] varchar(max),
  [Passport] varchar(max)
)
GO

CREATE TABLE [CarriagePlace] (
  [CarriageID] bigint NOT NULL,
  [PlaceID] bigint NOT NULL,
  [MomentIn] datetime NOT NULL,
  [MomentOut] datetime
)
GO

CREATE TABLE [ArticleInCarriage] (
  [ArticleID] bigint NOT NULL,
  [CarriageID] bigint NOT NULL,
  [PlaceID] bigint,
  [MomentIn] datetime NOT NULL,
  [MomentOut] datetime,
  [TakeOffPlaceID] bigint,
  [PutInPlaceID] bigint
)
GO

CREATE TABLE [ArticlePlace] (
  [ArticleID] bigint NOT NULL,
  [PlaceID] bigint NOT NULL,
  [MomentIn] datetime NOT NULL,
  [MomentOut] datetime
)
GO

CREATE TABLE [ArticleInDocument] (
  [ID] bigint PRIMARY KEY,
  [ArticleID] bigint NOT NULL,
  [DocQty] int,
  [FactQty] int,
  [DefectQty] int,
  [Price] money,
  [Cost] money,
  [NDS] float,
  [DocumentID] bigint NOT NULL,
  [ObjectType] varchar(max),
  [NDSValue] money,
  [Name] varchar(max),
  [Descript] varchar(max)
)
GO

ALTER TABLE [Item] ADD FOREIGN KEY ([StateID]) REFERENCES [State] ([ID])
GO

ALTER TABLE [Place] ADD FOREIGN KEY ([OwnerObjectID]) REFERENCES [Place] ([ID])
GO

ALTER TABLE [Place] ADD FOREIGN KEY ([StateID]) REFERENCES [State] ([ID])
GO

ALTER TABLE [Contract] ADD FOREIGN KEY ([CustomerID]) REFERENCES [Contractor] ([ID])
GO

ALTER TABLE [Contract] ADD FOREIGN KEY ([PerformerID]) REFERENCES [Contractor] ([ID])
GO

ALTER TABLE [Contract] ADD FOREIGN KEY ([StateID]) REFERENCES [State] ([ID])
GO

ALTER TABLE [Contractor] ADD FOREIGN KEY ([StateID]) REFERENCES [State] ([ID])
GO

ALTER TABLE [Route] ADD FOREIGN KEY ([MinPlaceID]) REFERENCES [Place] ([ID])
GO

ALTER TABLE [Route] ADD FOREIGN KEY ([MaxPlaceID]) REFERENCES [Place] ([ID])
GO

ALTER TABLE [Route] ADD FOREIGN KEY ([StateID]) REFERENCES [State] ([ID])
GO

ALTER TABLE [Carriage] ADD FOREIGN KEY ([RouteID]) REFERENCES [Route] ([ID])
GO

ALTER TABLE [Carriage] ADD FOREIGN KEY ([StateID]) REFERENCES [State] ([ID])
GO

ALTER TABLE [Documents] ADD FOREIGN KEY ([SenderPersonID]) REFERENCES [HumanPerson] ([ID])
GO

ALTER TABLE [Documents] ADD FOREIGN KEY ([ReceiverPersonID]) REFERENCES [HumanPerson] ([ID])
GO

ALTER TABLE [Documents] ADD FOREIGN KEY ([ContractID]) REFERENCES [Contract] ([ID])
GO

ALTER TABLE [Documents] ADD FOREIGN KEY ([CarriageID]) REFERENCES [Carriage] ([ID])
GO

ALTER TABLE [Documents] ADD FOREIGN KEY ([StateID]) REFERENCES [State] ([ID])
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

ALTER TABLE [Article] ADD FOREIGN KEY ([StateID]) REFERENCES [State] ([ID])
GO

ALTER TABLE [CarriagePlace] ADD FOREIGN KEY ([CarriageID]) REFERENCES [Carriage] ([ID])
GO

ALTER TABLE [CarriagePlace] ADD FOREIGN KEY ([PlaceID]) REFERENCES [Place] ([ID])
GO

ALTER TABLE [ArticleInCarriage] ADD FOREIGN KEY ([ArticleID]) REFERENCES [Article] ([ID])
GO

ALTER TABLE [ArticleInCarriage] ADD FOREIGN KEY ([CarriageID]) REFERENCES [Carriage] ([ID])
GO

ALTER TABLE [ArticleInCarriage] ADD FOREIGN KEY ([PlaceID]) REFERENCES [Place] ([ID])
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
