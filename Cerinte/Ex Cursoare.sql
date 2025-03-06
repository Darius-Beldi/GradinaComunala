--ex 7 

CREATE OR REPLACE PROCEDURE membrii_Plante_ex_2 AS
    

    TYPE t_membrii IS VARRAY(100) OF NUMBER;    
    v_membrii t_membrii := t_membrii();
    
    --cursor simplu
    CURSOR c_membrii IS
        SELECT membru_id
        FROM membrii;
    
        v_nume VARCHAR2(20);
        v_prenume VARCHAR2(20);
    
    BEGIN
        
        FOR mem_id in c_membrii LOOP
            
            v_membrii.EXTEND;
            v_membrii(v_membrii.LAST) := mem_id.membru_id;
            
        END LOOP;
        
        
        FOR i IN 1..v_membrii.COUNT LOOP
        
            SELECT nume
            INTO v_nume
            FROM membrii 
            WHERE membru_id = v_membrii(i);
        
            SELECT prenume
            INTO v_prenume
            FROM membrii 
            WHERE membru_id = v_membrii(i);
            
            
            DBMS_OUTPUT.PUT_LINE(v_nume || ' ' || v_prenume || ' cultiva: ');
            FOR planta in (SELECT  pl.nume
                            FROM plante pl
                            JOIN plante_parcele pp ON pp.planta_id = pl.planta_id
                            JOIN atribuiri_parcele ap ON pp.atribuire_parcela_id = ap.atribuire_id
                            WHERE ap.membru_id = v_membrii(i)) LOOP
                
                DBMS_OUTPUT.PUT_LINE(planta.nume);
                
            END LOOP;
            DBMS_OUTPUT.PUT_LINE(' ');
        END LOOP;
    
    
    END membrii_plante_ex_2; 
            
            
/

BEGIN
    membrii_plante_ex_2();
END;
/