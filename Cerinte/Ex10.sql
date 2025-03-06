CREATE OR REPLACE TRIGGER trg_validare_cantitate_cmd
BEFORE INSERT OR UPDATE ON UNELTE_SARCINI
DECLARE
    v_invalid_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_invalid_count
    FROM UNELTE_SARCINI
    WHERE cantitate < 1
    AND ROWID IN (
        SELECT ROWID
        FROM UNELTE_SARCINI
        MINUS
        SELECT ROWID
        FROM UNELTE_SARCINI
        WHERE cantitate >= 1
    );
    IF v_invalid_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Cantitatea de unelte trebuie s? fie mai mare decât 0.');
    END IF;
END;
/

INSERT INTO UNELTE_SARCINI (unealta_id, sarcina_id, cantitate)
VALUES (1, 1, 0); 
/