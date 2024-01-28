USE LittleLozon
GO

CREATE INDEX IX_Place_OwnerObjectID ON [Place] ([OwnerObjectID]);--������ �� ������� ����
CREATE INDEX IX_Place_ContractID ON [Place] ([ContractID]);--������ �� ������� ����
GO

CREATE INDEX IX_Contract_Date ON [Contract] ([Date]);
CREATE INDEX IX_Contract_CustomerID ON [Contract] ([CustomerID]);--������ �� ������� ����
CREATE INDEX IX_Contract_PerformerID ON [Contract] ([PerformerID]);--������ �� ������� ����
GO

CREATE INDEX IX_Route_MinPlaceID ON [Route] ([MinPlaceID]);--������ �� ������� ����
CREATE INDEX IX_Route_MaxPlaceID ON [Route] ([MaxPlaceID]);--������ �� ������� ����
GO

CREATE INDEX IX_Carriage_Date ON [Carriage] ([Date]);--����� �� ����/�������
CREATE INDEX IX_Carriage_RouteID ON [Carriage] ([RouteID]);--������ �� ������� ����
GO

CREATE INDEX IX_Documents_DateIn ON [Documents] ([DateIn]);--����� �� ����/�������
CREATE INDEX IX_Documents_SenderPersonID ON [Documents] ([SenderPersonID]);--������ �� ������� ����
CREATE INDEX IX_Documents_ReceiverPersonID ON [Documents] ([ReceiverPersonID]);--������ �� ������� ����
CREATE INDEX IX_Documents_ContractID ON [Documents] ([ContractID]);--������ �� ������� ����
CREATE INDEX IX_Documents_CarriageID ON [Documents] ([CarriageID]);--������ �� ������� ����
GO

CREATE INDEX IX_Article_ItemID ON [Article] ([ItemID]);--������ �� ������� ����
CREATE INDEX IX_Article_PlaceID ON [Article] ([PlaceID]);--������ �� ������� ����
CREATE INDEX IX_Article_DstPlaceID ON [Article] ([DstPlaceID]);--������ �� ������� ����
CREATE INDEX IX_Article_ContractorID ON [Article] ([ContractorID]);--������ �� ������� ����
CREATE INDEX IX_Article_ContainerID ON [Article] ([ContainerID]);--������ �� ������� ����
CREATE INDEX IX_Article_RouteID ON [Article] ([RouteID]);--������ �� ������� ����
CREATE INDEX IX_Article_ContractID ON [Article] ([ContractID]);--������ �� ������� ����
GO

CREATE INDEX IX_PersonHuman_LastName ON [PersonHuman] ([LastName]);--������ ��� ������ �� ������
CREATE INDEX IX_PersonHuman_Phone ON [PersonHuman] ([Phone]);--������ ��� ������ �� ������
CREATE INDEX IX_PersonHuman_Email ON [PersonHuman] ([Email]);--������ ��� ������ �� ������
GO

CREATE NONCLUSTERED INDEX IX_CarriagePlace_PlaceID_MomentIn ON [CarriagePlace] (PlaceID, MomentIn);--������ ��� ������ �� ������ � ����/������� ����������� �� ��� (������)
CREATE NONCLUSTERED INDEX IX_CarriagePlace_PlaceID_MomentOut ON [CarriagePlace] (PlaceID, MomentOut);--������ ��� ������ �� ������ � ����/������� ����������� �� ��� (����)
GO

CREATE NONCLUSTERED INDEX IX_ArticleInCarriage_CarriageID_MomentIn ON [ArticleInCarriage] (CarriageID, MomentIn);--������ ��� ������ �� ��������� � ����/������� ����������� � ��� (����������)
CREATE NONCLUSTERED INDEX IX_ArticleInCarriage_CarriageID_MomentOut ON [ArticleInCarriage] (CarriageID, MomentOut);--������ ��� ������ �� ��������� � ����/������� ����������� � ��� (�������)
GO

CREATE NONCLUSTERED INDEX IX_ArticlePlace_PlaceID_MomentIn ON [ArticlePlace] (PlaceID, MomentIn);--������ ��� ������ �� ������ � ����/������� ����������� �� ��� (������)
CREATE NONCLUSTERED INDEX IX_ArticlePlace_PlaceID_MomentOut ON [ArticlePlace] (PlaceID, MomentOut);--������ ��� ������ �� ������ � ����/������� ����������� �� ��� (����)
GO

CREATE INDEX IX_ArticleInDocument_ArticleID ON [ArticleInDocument] ([ArticleID]);--������ �� ������� ����
CREATE INDEX IX_ArticleInDocument_DocumentID ON [ArticleInDocument] ([DocumentID]);--������ �� ������� ����
GO