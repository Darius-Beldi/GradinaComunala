
CREATE OR REPLACE TRIGGER trg_validare_calitate_unealta
BEFORE INSERT OR UPDATE ON UNELTE_SARCINI
FOR EACH ROW
DECLARE
    v_id_unealta NUMBER := :NEW.unealta_id;
    v_calitate VARCHAR2(20) ;
BEGIN

            SELECT u.stare
                INTO v_calitate
                FROM unelte u
                WHERE u.unealta_id = v_id_unealta;
                
    IF v_calitate = 'Necesita Reparatii' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Unealta este stricata.');
    END IF;
END;
/
INSERT INTO UNELTE_SARCINI (unealta_id, sarcina_id, cantitate)
VALUES (5, 10, 1); 
/
