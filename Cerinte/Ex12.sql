
CREATE TABLE Schema_Change_Logs (
    Event_Type VARCHAR2(50),
    Object_Type VARCHAR2(50),
    Object_Name VARCHAR2(255),
    Event_Time TIMESTAMP
);
/
CREATE OR REPLACE TRIGGER Schema_Change_Log_Trigger
AFTER CREATE OR ALTER OR DROP ON SCHEMA
DECLARE
BEGIN
    INSERT INTO Schema_Change_Logs (Event_Type, Object_Type, Object_Name, Event_Time)
    VALUES (ORA_SYSEVENT, ORA_DICT_OBJ_TYPE, ORA_DICT_OBJ_NAME, SYSDATE);
END;
/

CREATE TABLE test_trigger2(test_coloana NUMBER(1));

SELECT * FROM Schema_Change_Logs;
/