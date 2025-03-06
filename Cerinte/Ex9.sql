
CREATE OR REPLACE PROCEDURE verificare_membru_plante(

        p_membru_id NUMBER,
        p_locatie VARCHAR2,
        p_sezon VARCHAR2 DEFAULT NULL
)
IS
    TYPE t_membru IS RECORD(
          v_nume            VARCHAR2(50),
          v_prenume         VARCHAR2(50),
          v_nume_planta     VARCHAR2(50),
          v_locatie_parcela VARCHAR2(100)
    );
    
    TYPE t_plante IS TABLE OF t_membru;
    membru_plante t_plante := t_plante();
    
    exceptie_parcela_invalida EXCEPTION;
    exceptie_sezon_invalid EXCEPTION;
    
    v_count_parcele NUMBER := 0;
    v_count_plante NUMBER := 0;

    CURSOR c_plante IS
        SELECT m.nume, m.prenume, pl.nume AS nume_planta, p.locatie AS locatie_parcela
        FROM MEMBRII m
        JOIN ATRIBUIRI_PARCELE ap ON ap.membru_id = m.membru_id
        JOIN PARCELE p ON p.parcela_id = ap.parcela_id
        JOIN PLANTE_PARCELE pp ON pp.atribuire_parcela_id = ap.atribuire_id
        JOIN PLANTE pl ON pl.planta_id = pp.planta_id
        WHERE m.membru_id = p_membru_id
              AND p.locatie = p_locatie
              AND (p_sezon IS NULL OR pl.sezon = p_sezon);
BEGIN

    SELECT COUNT(*)
        INTO v_count_parcele
        FROM MEMBRII m
        JOIN ATRIBUIRI_PARCELE ap ON ap.membru_id = m.membru_id
        JOIN PARCELE p ON p.parcela_id = ap.parcela_id
        WHERE m.membru_id = p_membru_id AND p.locatie = p_locatie;
    
    IF v_count_parcele = 0 THEN
        RAISE exceptie_parcela_invalida;
    END IF;

    
    IF p_sezon IS NULL THEN
        SELECT COUNT(*)
            INTO v_count_plante
            FROM MEMBRII m
            JOIN ATRIBUIRI_PARCELE ap ON ap.membru_id = m.membru_id
            JOIN PARCELE p ON p.parcela_id = ap.parcela_id
            JOIN PLANTE_PARCELE pp ON pp.atribuire_parcela_id = ap.atribuire_id
            JOIN PLANTE pl ON pl.planta_id = pp.planta_id
            WHERE m.membru_id = p_membru_id AND p.locatie = p_locatie AND (pl.sezon IS NULL);
    ELSE
        SELECT COUNT(*)
            INTO v_count_plante
            FROM MEMBRII m
            JOIN ATRIBUIRI_PARCELE ap ON ap.membru_id = m.membru_id
            JOIN PARCELE p ON p.parcela_id = ap.parcela_id
            JOIN PLANTE_PARCELE pp ON pp.atribuire_parcela_id = ap.atribuire_id
            JOIN PLANTE pl ON pl.planta_id = pp.planta_id
            WHERE m.membru_id = p_membru_id AND p.locatie = p_locatie AND pl.sezon = p_sezon;
    END IF;
    
    IF v_count_plante = 0 THEN
        RAISE exceptie_sezon_invalid;
    END IF;
    
    FOR r_planta IN c_plante LOOP
    DBMS_OUTPUT.PUT_LINE('Nume: ' || r_planta.nume || ', Prenume: ' || r_planta.prenume ||
                         ', Planta: ' || r_planta.nume_planta || ', Locatie: ' || r_planta.locatie_parcela);
    END LOOP;

    
     EXCEPTION 
     
            WHEN exceptie_parcela_invalida THEN
                RAISE_APPLICATION_ERROR(-20004, 'Membrul introdus nu are parcela respectiva.');
            WHEN exceptie_sezon_invalid THEN
                RAISE_APPLICATION_ERROR(-20005, 'Pe parcela respectiva, membrul respectiv nu cultiva plante pentru sezonul respectiv.');
            
            
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20001, 'NO_DATA_FOUND.');
            WHEN TOO_MANY_ROWS THEN
                RAISE_APPLICATION_ERROR(-20002, 'TOO_MANY_ROWS.');
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR(-20003, 'A aparut o eroare');
end verificare_membru_plante;
/

BEGIN
    verificare_membru_plante(1, 'Zona A1', 'Vara');
END;
/
BEGIN
    verificare_membru_plante(5, 'Zona B1', NULL);
END;
/
BEGIN
    verificare_membru_plante(3, 'Zona B1', NULL);
END;
/
