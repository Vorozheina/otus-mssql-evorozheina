USE [LittleLozon]
GO
/****** Object:  ServiceQueue [InitiatorQueueLL]    Script Date: 30.01.2024 18:34:50 ******/
ALTER QUEUE [dbo].[InitiatorQueueLL] WITH STATUS = ON , RETENTION = OFF , ACTIVATION (  STATUS = ON , PROCEDURE_NAME = [dbo].[ConfirmDocument] , MAX_QUEUE_READERS = 1 , EXECUTE AS OWNER  ), POISON_MESSAGE_HANDLING (STATUS = OFF) 