USE LittleLozon
-- For Request
CREATE MESSAGE TYPE
[//LL/SB/RequestMessage]
VALIDATION=WELL_FORMED_XML;
-- For Reply
CREATE MESSAGE TYPE
[//LL/SB/ReplyMessage]
VALIDATION=WELL_FORMED_XML; 

GO

CREATE CONTRACT [//LL/SB/Contract]
      ([//LL/SB/RequestMessage]
         SENT BY INITIATOR,
       [//LL/SB/ReplyMessage]
         SENT BY TARGET
      );
GO
----------------------------------------------------------------------------------------

CREATE QUEUE TargetQueueLL;

CREATE SERVICE [//LL/SB/TargetService]
       ON QUEUE TargetQueueLL
       ([//LL/SB/Contract]);
GO


CREATE QUEUE InitiatorQueueLL;

CREATE SERVICE [//LL/SB/InitiatorService]
       ON QUEUE InitiatorQueueLL
       ([//LL/SB/Contract]);
GO
-----------------------------------------------------------------------------------------
