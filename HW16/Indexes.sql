USE LittleLozon
GO

CREATE INDEX IX_Place_OwnerObjectID ON [Place] ([OwnerObjectID]);--индекс на внешний ключ
CREATE INDEX IX_Place_ContractID ON [Place] ([ContractID]);--индекс на внешний ключ
GO

CREATE INDEX IX_Contract_Date ON [Contract] ([Date]);
CREATE INDEX IX_Contract_CustomerID ON [Contract] ([CustomerID]);--индекс на внешний ключ
CREATE INDEX IX_Contract_PerformerID ON [Contract] ([PerformerID]);--индекс на внешний ключ
GO

CREATE INDEX IX_Route_MinPlaceID ON [Route] ([MinPlaceID]);--индекс на внешний ключ
CREATE INDEX IX_Route_MaxPlaceID ON [Route] ([MaxPlaceID]);--индекс на внешний ключ
GO

CREATE INDEX IX_Carriage_Date ON [Carriage] ([Date]);--поиск по дате/времени
CREATE INDEX IX_Carriage_RouteID ON [Carriage] ([RouteID]);--индекс на внешний ключ
GO

CREATE INDEX IX_Documents_DateIn ON [Documents] ([DateIn]);--поиск по дате/времени
CREATE INDEX IX_Documents_SenderPersonID ON [Documents] ([SenderPersonID]);--индекс на внешний ключ
CREATE INDEX IX_Documents_ReceiverPersonID ON [Documents] ([ReceiverPersonID]);--индекс на внешний ключ
CREATE INDEX IX_Documents_ContractID ON [Documents] ([ContractID]);--индекс на внешний ключ
CREATE INDEX IX_Documents_CarriageID ON [Documents] ([CarriageID]);--индекс на внешний ключ
GO

CREATE INDEX IX_Article_ItemID ON [Article] ([ItemID]);--индекс на внешний ключ
CREATE INDEX IX_Article_PlaceID ON [Article] ([PlaceID]);--индекс на внешний ключ
CREATE INDEX IX_Article_DstPlaceID ON [Article] ([DstPlaceID]);--индекс на внешний ключ
CREATE INDEX IX_Article_ContractorID ON [Article] ([ContractorID]);--индекс на внешний ключ
CREATE INDEX IX_Article_ContainerID ON [Article] ([ContainerID]);--индекс на внешний ключ
CREATE INDEX IX_Article_RouteID ON [Article] ([RouteID]);--индекс на внешний ключ
CREATE INDEX IX_Article_ContractID ON [Article] ([ContractID]);--индекс на внешний ключ
GO

CREATE INDEX IX_PersonHuman_LastName ON [PersonHuman] ([LastName]);--индекс для поиска по строке
CREATE INDEX IX_PersonHuman_Phone ON [PersonHuman] ([Phone]);--индекс для поиска по строке
CREATE INDEX IX_PersonHuman_Email ON [PersonHuman] ([Email]);--индекс для поиска по строке
GO

CREATE NONCLUSTERED INDEX IX_CarriagePlace_PlaceID_MomentIn ON [CarriagePlace] (PlaceID, MomentIn);--индекс для поиска по складу и дате/времени регистрации на нем (приход)
CREATE NONCLUSTERED INDEX IX_CarriagePlace_PlaceID_MomentOut ON [CarriagePlace] (PlaceID, MomentOut);--индекс для поиска по складу и дате/времени регистрации на нем (уход)
GO

CREATE NONCLUSTERED INDEX IX_ArticleInCarriage_CarriageID_MomentIn ON [ArticleInCarriage] (CarriageID, MomentIn);--индекс для поиска по перевозке и дате/времени регистрации в ней (наполнение)
CREATE NONCLUSTERED INDEX IX_ArticleInCarriage_CarriageID_MomentOut ON [ArticleInCarriage] (CarriageID, MomentOut);--индекс для поиска по перевозке и дате/времени регистрации в ней (приемка)
GO

CREATE NONCLUSTERED INDEX IX_ArticlePlace_PlaceID_MomentIn ON [ArticlePlace] (PlaceID, MomentIn);--индекс для поиска по складу и дате/времени регистрации на нем (приход)
CREATE NONCLUSTERED INDEX IX_ArticlePlace_PlaceID_MomentOut ON [ArticlePlace] (PlaceID, MomentOut);--индекс для поиска по складу и дате/времени регистрации на нем (уход)
GO

CREATE INDEX IX_ArticleInDocument_ArticleID ON [ArticleInDocument] ([ArticleID]);--индекс на внешний ключ
CREATE INDEX IX_ArticleInDocument_DocumentID ON [ArticleInDocument] ([DocumentID]);--индекс на внешний ключ
GO