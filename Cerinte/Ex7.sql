--ex 7 
CREATE OR REPLACE PROCEDURE membrii_Plante IS
    
    --cursor simplu
    CURSOR c_membrii IS
        SELECT * 
        FROM membrii;
    
    --cursor parametrizat
    CURSOR c_plante(p_membru_id NUMBER) IS
        SELECT  pl.nume
            FROM plante pl
            JOIN plante_parcele pp ON pp.planta_id = pl.planta_id
            JOIN atribuiri_parcele ap ON pp.atribuire_parcela_id = ap.atribuire_id
            WHERE ap.membru_id = p_membru_id;
    BEGIN
    
        FOR membru IN c_membrii LOOP
            DBMS_OUTPUT.PUT_LINE(membru.Nume || ' ' || membru.prenume || ' cultiva: ');
            FOR planta in c_plante(membru.membru_id) LOOP
                
                DBMS_OUTPUT.PUT_LINE(planta.nume);
                
            END LOOP;
            DBMS_OUTPUT.PUT_LINE(' ');
        END LOOP;
    
    
    END membrii_plante; 
            
            
/

BEGIN
    membrii_plante();
END;
/