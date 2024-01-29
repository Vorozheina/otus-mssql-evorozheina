  USE LittleLozon
  GO

  SET NOCOUNT, XACT_ABORT ON
  GO
  SELECT  o.type_desc AS Object_Type, s.name AS Schema_Name, o.name AS Object_Name
    FROM  sys.objects o 
    JOIN  sys.schemas s
      ON  s.schema_id = o.schema_id
   WHERE  o.type NOT IN ('S'  --SYSTEM_TABLE,
                        ,'D'  --DEFAULT_CONSTRAINT
                        ,'C'  --CHECK_CONSTRAINT
                        ,'F'  --FOREIGN_KEY_CONSTRAINT
                        ,'IT' --INTERNAL_TABLE
                        ,'SQ' --SERVICE_QUEUE
                        ,'TR' --SQL_TRIGGER
                        ,'UQ' --UNIQUE_CONSTRAINT
                        )
ORDER BY  Object_Type
       ,  SCHEMA_NAME
       ,  Object_Name