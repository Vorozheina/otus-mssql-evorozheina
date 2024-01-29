USE LittleLozon
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE dbo.GetNewDocument
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @TargetDlgHandle UNIQUEIDENTIFIER,
			@Message NVARCHAR(4000),
			@MessageType Sysname,
			@ReplyMessage NVARCHAR(4000),
			@ReplyMessageName Sysname,
			@Document BIGINT,
			@xml XML; 
	
	BEGIN TRAN; 

	--Receive message from Initiator
	RECEIVE TOP(1)
		@TargetDlgHandle = Conversation_Handle,
		@Message = Message_Body,
		@MessageType = Message_Type_Name
	FROM dbo.TargetQueueLL; 

	SELECT @Message;

	SET @xml = CAST(@Message AS XML);

	SELECT @Document = R.Iv.value('@ID','BIGINT')
	FROM @xml.nodes('/RequestMessage/Inv') as R(Iv);

	IF EXISTS (SELECT * FROM dbo.Documents WHERE ID = @Document)
	BEGIN
		UPDATE dbo.Documents
		SET [DocumentConfirmedForProcessing] = GETUTCDATE()
		WHERE ID = @Document;
	END;
	
	SELECT @Message AS ReceivedRequestMessage, @MessageType; 
	
	-- Confirm and Send a reply
	IF @MessageType=N'//LL/SB/RequestMessage'
	BEGIN
		SET @ReplyMessage =N'<ReplyMessage> Message received</ReplyMessage>'; 
	
		SEND ON CONVERSATION @TargetDlgHandle
		MESSAGE TYPE
		[//LL/SB/ReplyMessage]
		(@ReplyMessage);
		END CONVERSATION @TargetDlgHandle;
	END 
	
	SELECT @ReplyMessage AS SentReplyMessage; 

	COMMIT TRAN;
END