USE LittleLozon
GO

SET NOCOUNT ON;
GO


SELECT D.ID, D.[DocumentConfirmedForProcessing], D.*
FROM dbo.Documents D
WHERE D.ID IN (3000031, 3000032) ;

--Send message
EXEC dbo.SendNewDocument 
		@document = 3000031 -- bigint


SELECT D.ID
FROM dbo.Documents D
WHERE D.ID = 3000031
FOR XML AUTO, root('RequestMessage')

SELECT CAST(message_body AS XML),*
FROM dbo.TargetQueueLL;

SELECT CAST(message_body AS XML),*
FROM dbo.InitiatorQueueLL;

--Target
EXEC dbo.GetNewDocument;

--Initiator
EXEC dbo.ConfirmDocument;


