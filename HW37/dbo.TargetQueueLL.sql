USE [LittleLozon]
GO
/****** Object:  ServiceQueue [TargetQueueLL]    Script Date: 30.01.2024 18:35:16 ******/
ALTER QUEUE [dbo].[TargetQueueLL] WITH STATUS = ON , RETENTION = OFF , ACTIVATION (  STATUS = ON , PROCEDURE_NAME = [dbo].[GetNewDocument] , MAX_QUEUE_READERS = 1 , EXECUTE AS OWNER  ), POISON_MESSAGE_HANDLING (STATUS = OFF) 