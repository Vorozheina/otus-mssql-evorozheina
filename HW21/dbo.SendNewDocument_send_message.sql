USE LittleLozon
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE dbo.SendNewDocument
	@document	BIGINT
AS
BEGIN
	SET NOCOUNT ON;

    --Sending a Request Message to the Target	
	DECLARE @InitDlgHandle UNIQUEIDENTIFIER;
	DECLARE @RequestMessage NVARCHAR(4000);
	
	BEGIN TRAN 

	--Prepare the Message
	SELECT @RequestMessage = (SELECT D.ID
							  FROM dbo.Documents AS D
							  WHERE D.ID = @document
							  FOR XML AUTO, ROOT('RequestMessage')); 
	
	--Determine the Initiator Service, Target Service and the Contract 
	BEGIN DIALOG @InitDlgHandle
	FROM SERVICE
	[//LL/SB/InitiatorService]
	TO SERVICE
	'//LL/SB/TargetService'
	ON CONTRACT
	[//LL/SB/Contract]
	WITH ENCRYPTION=OFF; 

	--Send the Message
	SEND ON CONVERSATION @InitDlgHandle 
	MESSAGE TYPE
	[//LL/SB/RequestMessage]
	(@RequestMessage);
	
	SELECT @RequestMessage AS SentRequestMessage;
	
	COMMIT TRAN 
END
GO