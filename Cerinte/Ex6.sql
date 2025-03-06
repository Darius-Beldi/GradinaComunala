
CREATE OR REPLACE PROCEDURE gestionare_date(
    p_parcela_id IN NUMBER
) AS
    TYPE t_membri IS TABLE OF VARCHAR2(200);
    membri_table t_membri;

    -- Varray pentru plante
    TYPE t_plante IS VARRAY(100) OF VARCHAR2(50);
    plante_varray t_plante;

    TYPE t_cheltuieli IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    cheltuieli_table t_cheltuieli;

    v_nume VARCHAR2(50);
    v_email VARCHAR2(100);
    v_planta VARCHAR2(50);
    v_sarcina_id NUMBER;
    v_cheltuiala NUMBER;
BEGIN
    membri_table := t_membri();
    FOR rec IN (
        SELECT nume || ' ' || prenume AS nume_complet, email
        FROM MEMBRII
    ) LOOP
        membri_table.EXTEND;
        membri_table(membri_table.LAST) := rec.nume_complet || ' (' || rec.email || ')';
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Membrii activi:');
    FOR i IN 1..membri_table.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(membri_table(i));
    END LOOP;

    -- Populare Varray cu plante din parcela specificat
    plante_varray := t_plante();
    FOR rec IN (
        SELECT p.nume
        FROM PLANTE p
        JOIN PLANTE_PARCELE pp ON p.planta_id = pp.planta_id
        WHERE pp.atribuire_parcela_id = p_parcela_id
    ) LOOP
        plante_varray.EXTEND;
        plante_varray(plante_varray.LAST) := rec.nume;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Plante cultivate  n parcela specificata:');
    FOR i IN 1..plante_varray.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('- ' || plante_varray(i));
    END LOOP;

    FOR rec IN (
        SELECT sarcina_id, durata_estimata * 10 AS cheltuiala_estimativa
        FROM SARCINI_INTRETINERE
    ) LOOP
        cheltuieli_table(rec.sarcina_id) := rec.cheltuiala_estimativa;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Cheltuieli estimate pentru sarcini:');
    v_sarcina_id := cheltuieli_table.FIRST;
    WHILE v_sarcina_id IS NOT NULL LOOP
        DBMS_OUTPUT.PUT_LINE('Sarcina ID ' || v_sarcina_id || ': ' || cheltuieli_table(v_sarcina_id) || ' RON');
        v_sarcina_id := cheltuieli_table.NEXT(v_sarcina_id);
    END LOOP;
END;
/
BEGIN
    gestionare_date(7);
END;
