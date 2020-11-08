--zaposlenici i menager
SELECT r.ime || ' ' || r.prezime || ' radi za ' || l.prezime
FROM zaposlenik l INNER JOIN zaposlenik r
ON l.zaposlenik_id = r.zaposlenik_id_2;


--ispis potrosenih dana godisnjeg odmora 2020 godine, where 
SELECT z.ime, z.prezime, godo.kraj - godo.pocetak AS "Godisnji u 2020", z.zaposlenik_id
FROM zaposlenik z, godisnji_odmor godo
WHERE godo.zaposlenik_id = z.zaposlenik_id
AND godo.pocetak BETWEEN '01-JANUARY-2020' AND '31-DECEMBER-2020';

--ispis imena i prezimena gosta,broj sobe, broj lezaja, nacina placanja, poredaj po prezimenu pa imenu, inner join using
SELECT g.ime, g.prezime, broj_sobe, s.broj_lezaja, r.nacin_placanja
FROM rezervacija r INNER JOIN gost g USING(OIB)
INNER JOIN soba s USING(broj_sobe)
INNER JOIN racun r USING(broj_racuna)
ORDER BY g.prezime, g.ime;

--koliko ima pomocnih kuahara koji imaju parking mjesto, inner join on
SELECT COUNT(z.posao) AS "Broj pomocnih kuhara koji imaju parking mjesto"
FROM zaposlenik z INNER JOIN parking_mjesto pm ON z.parking_mjesto_id = pm.etaza_i_br_mjesta
WHERE z.parking_mjesto_id IS NOT NULL AND z.posao = 'Pomocni kuhar';


--unija lijevog i desnog vanjskog spoja, full outer join
SELECT broj_sobe, rezervacija_id
FROM soba s FULL OUTER JOIN rezervacija r USING(broj_sobe)
ORDER BY broj_sobe;

SELECT broj_sobe, rezervacija_id
FROM soba s RIGHT OUTER JOIN rezervacija r USING(broj_sobe)
UNION
SELECT broj_sobe, rezervacija_id
FROM soba s LEFT OUTER JOIN rezervacija r USING(broj_sobe)
ORDER BY broj_sobe;

--podupit, svi zaposlenici s vecom placom od prosjecne
SELECT ime, prezime
FROM zaposlenik
WHERE mjesecni_iznos_place > 
(
    SELECT AVG(mjesecni_iznos_place)
    FROM zaposlenik
);

SET SERVEROUTPUT ON;

DROP SEQUENCE niz;
CREATE SEQUENCE niz
    START WITH 40
    INCREMENT BY 1;
    

--procedura za unos godisnjih (zaposlenik 10)
CREATE OR REPLACE PROCEDURE p_godisnji
( v_pocetak IN DATE, v_kraj IN DATE, v_zaposlenik_id IN NUMBER ) AS
BEGIN
    INSERT INTO godisnji_odmor(godisnji_odmor_id, pocetak, kraj, zaposlenik_id)
    VALUES(niz.NEXTVAL, v_pocetak, v_kraj, v_zaposlenik_id);
    COMMIT;
    EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
END p_godisnji;
/ 

SELECT z.ime, z.prezime, godo.kraj - godo.pocetak AS "Godisnji u 2020", z.zaposlenik_id
FROM zaposlenik z, godisnji_odmor godo
WHERE godo.zaposlenik_id = z.zaposlenik_id
AND godo.pocetak > '01-JANUARY-2020';

SELECT * FROM godisnji_odmor ORDER BY godisnji_odmor_id;

CALL p_godisnji( '03-MAY-2020', '04-MAY-2020', 23 );

SELECT * FROM godisnji_odmor ORDER BY godisnji_odmor_id;


--procedura za racunaje iznosa racuna, update
CREATE OR REPLACE PROCEDURE p_iznos_racuna_update
(v_rez_id IN NUMBER) AS

c1 INTEGER;
c2 INTEGER;
br_rac INTEGER;

BEGIN
    SELECT DISTINCT(rez.datum_kraja - rez.datum_pocetka) * s.cijena INTO c1
    FROM rezervacija rez INNER JOIN soba s USING(broj_sobe) 
    WHERE rezervacija_id = v_rez_id;

    SELECT SUM( (TO_NUMBER(u.datum_kraj - u.pocetak_datum)* 24 + (u.vrijeme_kraj - u.pocetak_vrijeme)/100) * cu.cijena) INTO c2
    FROM rezervacija rez INNER JOIN usluga u USING(rezervacija_id) INNER JOIN cijena_usluge cu
    USING(cijena_usluge_id)
    WHERE rezervacija_id = v_rez_id;
    
    SELECT broj_racuna INTO br_rac
    FROM rezervacija rez INNER JOIN racun rac USING(broj_racuna)
    WHERE rezervacija_id = v_rez_id;

UPDATE racun SET iznos = c1 + c2 WHERE broj_racuna = br_rac;

COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;


END p_iznos_racuna_update;
/

SELECT * FROM racun;
CALL p_iznos_racuna_update(1);
CALL p_iznos_racuna_update(3);
UPDATE racun SET iznos = 0 WHERE broj_racuna = 1230001;


--select soba s odredenim brojem lezaja s procedurom

CREATE OR REPLACE PROCEDURE p_soba
(v_broj_lezaja IN NUMBER) AS
kursor SYS_REFCURSOR;
v_broj_sobe NUMBER;
v_cijena NUMBER; 
v_br NUMBER;
BEGIN

SELECT COUNT(broj_sobe) INTO v_br
FROM soba
WHERE broj_lezaja = v_broj_lezaja;


OPEN kursor FOR 
    SELECT broj_sobe, cijena FROM soba WHERE broj_lezaja = v_broj_lezaja;
    FOR COUNTER IN 1..v_br LOOP
        FETCH kursor INTO v_broj_sobe, v_cijena;
        DBMS_OUTPUT.PUT_LINE
        (
            'Broj sobe: ' || v_broj_sobe ||
            ', cijena: ' || v_cijena
        );
    END LOOP;

END p_soba;
/

CALL p_soba(3);

--trigger za update racuna
CREATE OR REPLACE TRIGGER t_minus_racun 
AFTER UPDATE OF iznos ON racun
FOR EACH ROW
WHEN (new.iznos < 0)
BEGIN
    raise_application_error(0, 'Iznos racuna je negativan');
END;
/

UPDATE racun
SET iznos = -10 WHERE broj_racuna = 1230001;

SELECT * FROM racun;

UPDATE racun
SET iznos = 100 WHERE broj_racuna = 1230001;

--triger na razini tablice
CREATE OR REPLACE TRIGGER t_auto_plan
AFTER UPDATE OF pocetni_broj_kilometara ON auto_plan
BEGIN
    DBMS_OUTPUT.PUT_LINE('Promjenjen broj kilometara' );
END;
/


UPDATE auto_plan
SET pocetni_broj_kilometara = 111111 WHERE broj_sasije = 'KMHJN81BP6U319344';


--index 
SELECT broj_sasije, marka, potrosnja 
FROM auto_plan 
WHERE marka = 'Opel' AND model = 'Astra';

DROP INDEX i_auto_plan;
CREATE INDEX i_auto_plan
ON auto_plan(marka, model);



--index 
SELECT broj_sobe, cijena, broj_lezaja 
FROM soba 
WHERE broj_lezaja = 3;

DROP INDEX i_sobe;
CREATE INDEX i_sobe
ON soba(broj_lezaja);



        
    
