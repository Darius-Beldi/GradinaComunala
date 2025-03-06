CREATE OR REPLACE TRIGGER trg_coloana_recolte2
BEFORE INSERT OR UPDATE ON PARCELE
FOR EACH ROW
DECLARE
    v_stare VARCHAR2(20) := :NEW.stare;
BEGIN

    RAISE_APPLICATION_ERROR(-20001, 'Nu se poate modifica starea unei parcele');
                
END;
/
INSERT INTO PARCELE(parcela_id, locatie, suprafata_mp, acces_apa, taxa_lunara, stare)
VALUES
    (100, 'Zona XY', 120, 1, 120, 'Ocupata');
/
UPDATE PARCELE
SET stare = 'Disponibila'
WHERE parcela_id = 100;
/
