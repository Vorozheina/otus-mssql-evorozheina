USE LittleLozon
GO

SET NOCOUNT, XACT_ABORT ON;
GO

CREATE OR ALTER PROCEDURE dbo.ConfirmDocument
AS
BEGIN
	--Receiving Reply Message from the Target.	
	DECLARE @InitiatorReplyDlgHandle UNIQUEIDENTIFIER,
			@ReplyReceivedMessage NVARCHAR(1000) 
	
	BEGIN TRAN; 

		RECEIVE TOP(1)
			@InitiatorReplyDlgHandle=Conversation_Handle
			,@ReplyReceivedMessage=Message_Body
		FROM dbo.InitiatorQueueLL; 
		
		END CONVERSATION @InitiatorReplyDlgHandle; 
		
		SELECT @ReplyReceivedMessage AS ReceivedRepliedMessage;

	COMMIT TRAN; 
END;
GO