USE LittleLozon
GO

SELECT * FROM sys.service_contract_message_usages; 
SELECT * FROM sys.service_contract_usages;
SELECT * FROM sys.service_queue_usages;
 
SELECT * FROM sys.transmission_queue;

/*SELECT * 
FROM dbo.InitiatorQueueLL;

SELECT * 
FROM dbo.TargetQueueLL;*/

SELECT name, is_broker_enabled
FROM sys.databases;

SELECT conversation_handle, is_initiator, s.name AS 'local service', 
far_service, sc.name 'contract', ce.state_desc
FROM sys.conversation_endpoints ce
LEFT JOIN sys.services s
ON ce.service_id = s.service_id
LEFT JOIN sys.service_contracts sc
ON ce.service_contract_id = sc.service_contract_id
ORDER BY conversation_handle;

ALTER TABLE dbo.Documents
ADD DocumentConfirmedForProcessing	DATETIME;


USE master
ALTER DATABASE LittleLozon
SET ENABLE_BROKER  WITH ROLLBACK IMMEDIATE; --NO WAIT --prod

ALTER DATABASE LittleLozon SET TRUSTWORTHY ON;