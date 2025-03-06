CREATE OR REPLACE FUNCTION nrRecolteExcelente(p_membru_id NUMBER) 
    RETURN NUMBER
    IS
    
   CURSOR c_recolte(p_atribuire_parcela_id NUMBER, p_id NUMBER)IS
        SELECT *
            FROM recolte
            WHERE recolte.atribuire_parcela_id = p_atribuire_parcela_id and recolte.planta_id = p_id;
            
    CURSOR c_plante IS
        SELECT pp.atribuire_parcela_id, pl.planta_id
            FROM plante pl
            JOIN plante_parcele pp ON pp.planta_id = pl.planta_id
            JOIN atribuiri_parcele ap ON pp.atribuire_parcela_id = ap.atribuire_id
            WHERE ap.membru_id = p_membru_id;
    
    v_test_membru_id NUMBER;        
    v_counter NUMBER := 0;
    v_nume VARCHAR2(20);
    v_test_nume VARCHAR2(20);
    BEGIN
    
    --testez daca exista membrul in tabel
        SELECT membru_id 
        INTO v_test_membru_id
        FROM membrii m
        WHERE m.membru_id = p_membru_id;
        
    -- too many rows     TEST: ID = 6/7
        SELECT nume
        INTO v_nume
        FROM membrii m
        WHERE m.membru_id = p_membru_id;
    
    
        SELECT nume
        INTO v_test_nume
        FROM membrii m
        WHERE m.nume = v_nume;
        
        FOR planta in c_plante LOOP
            FOR recolta IN c_recolte(planta.atribuire_parcela_id, planta.planta_id) LOOP
         
                IF recolta.evaluare_calitate = 'Excelenta' THEN
                    v_counter := v_counter + 1;
                END IF;
 
            END LOOP;
            
        END LOOP;
        RETURN v_counter;
        
        EXCEPTION 

            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20001, 'NO_DATA_FOUND.');
            WHEN TOO_MANY_ROWS THEN
                RAISE_APPLICATION_ERROR(-20002, 'TOO_MANY_ROWS. Exista mai multi membrii cu acest nume');
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR(-20003, 'A aparut o eroare');
    END nrRecolteExcelente; 
            
 /  

BEGIN
    --Test Bun
    DBMS_OUTPUT.PUT_LINE(nrRecolteExcelente(1));
    
    --TOO MANY ROWS
    --DBMS_OUTPUT.PUT_LINE(nrRecolteExcelente(7));
    
    --NO DATAFOUND
    --DBMS_OUTPUT.PUT_LINE(nrRecolteExcelente(29));
END;
/
