DROP TABLE parking_mjesto CASCADE CONSTRAINTS;
DROP TABLE zaposlenik CASCADE CONSTRAINTS;
DROP TABLE auto_plan CASCADE CONSTRAINTS;
DROP TABLE datum CASCADE CONSTRAINTS;
DROP TABLE godisnji_odmor CASCADE CONSTRAINTS;
DROP TABLE soba CASCADE CONSTRAINTS;
DROP TABLE cijena_usluge CASCADE CONSTRAINTS;
DROP TABLE racun CASCADE CONSTRAINTS;
DROP TABLE gost CASCADE CONSTRAINTS;
DROP TABLE rezervacija CASCADE CONSTRAINTS;
DROP TABLE usluga CASCADE CONSTRAINTS;

CREATE TABLE parking_mjesto
(
    etaza_i_br_mjesta VARCHAR(5) CONSTRAINT parking_mjesto_pk PRIMARY KEY
);

CREATE TABLE zaposlenik  
(
    zaposlenik_id INTEGER CONSTRAINT zaposlenik_pk PRIMARY KEY,
    posao VARCHAR(30) NOT NULL,
    ime VARCHAR(30) NOT NULL,
    prezime VARCHAR(30) NOT NULL,
    broj_tel INTEGER NOT NULL,
    email VARCHAR(50) NOT NULL,
    adresa VARCHAR(100) NOT NULL,
    mjesecni_iznos_place FLOAT NOT NULL,
    IBAN VARCHAR(34) NOT NULL,
    budzet FLOAT,
    parking_mjesto_id VARCHAR(5) CONSTRAINT zaposlenik_parking_mjesto_fk REFERENCES
        parking_mjesto(etaza_i_br_mjesta),

    zaposlenik_id_2 INTEGER CONSTRAINT zaposlenik_zaposlenik_fk REFERENCES 
        zaposlenik(zaposlenik_id)
);


CREATE TABLE auto_plan
(
    broj_sasije VARCHAR(17) CONSTRAINT broj_sasije_pk PRIMARY KEY,
    marka VARCHAR(15) NOT NULL,
    model VARCHAR(15) NOT NULL,
    godina_proizvodnje INTEGER NOT NULL,
    potrosnja FLOAT NOT NULL,
    pocetni_broj_kilometara INTEGER NOT NULL
);

CREATE TABLE datum
(
    datum_id INTEGER CONSTRAINT datupm_pk PRIMARY KEY,
    datum_pocetka_iznajmljivanja DATE NOT NULL,
    datum_kraja_iznajmljivanja DATE NOT NULL,
    zaposlenik_id INTEGER NOT NULL CONSTRAINT datum_zaposlenik_fk REFERENCES
        zaposlenik(zaposlenik_id),
    auto_plan_id VARCHAR(17) NOT NULL CONSTRAINT datum_auto_plan_fk REFERENCES
        auto_plan(broj_sasije)
);

CREATE TABLE godisnji_odmor
(
    godisnji_odmor_id INTEGER CONSTRAINT godisnji_odmor_pk PRIMARY KEY,
    pocetak DATE NOT NULL,
    kraj DATE NOT NULL,
    zaposlenik_id INTEGER NOT NULL CONSTRAINT godisnji_odmor_zaposlenik_fk REFERENCES
        zaposlenik(zaposlenik_id)
);


CREATE TABLE soba
(
    broj_sobe INTEGER CONSTRAINT broj_sobe_pk PRIMARY KEY,
    cijena FLOAT NOT NULL,
    broj_lezaja INTEGER NOT NULL
);

CREATE TABLE cijena_usluge 
(
    cijena_usluge_id INTEGER CONSTRAINT cijena_usluge_pk PRIMARY KEY,
    naziv VARCHAR(50) NOT NULL,
    cijena FLOAT NOT NULL
);

CREATE TABLE racun
(
    broj_racuna INTEGER CONSTRAINT broj_racuna_pk PRIMARY KEY,
    iznos FLOAT NOT NULL,
    nacin_placanja VARCHAR(20) NOT NULL,
    vrijeme_izdavanja DATE NOT NULL,
    broj_kartice INTEGER
);

CREATE TABLE gost
(
    OIB INTEGER CONSTRAINT gost_pk PRIMARY KEY,
    ime VARCHAR(20) NOT NULL,
    prezime VARCHAR(30) NOT NULL,
    broj_tel INTEGER NOT NULL,
    email VARCHAR(50) NOT NULL,
    adresa VARCHAR(100) NOT NULL
);

CREATE TABLE rezervacija 
(
    rezervacija_id INTEGER CONSTRAINT rezervacija_pk PRIMARY KEY,
    datum_rezervacije DATE NOT NULL,
    datum_pocetka DATE NOT NULL,
    datum_kraja DATE NOT NULL,
    broj_racuna INTEGER NOT NULL CONSTRAINT rezervacija_broj_racuna_fk REFERENCES
        racun(broj_racuna),
    OIB INTEGER NOT NULL CONSTRAINT rezervacija_OIB_fk REFERENCES
        gost(OIB),
    parking_mjesto_id VARCHAR(5) CONSTRAINT rezervacija_parking_mjesto_fk REFERENCES
        parking_mjesto(etaza_i_br_mjesta),
    broj_sobe INTEGER CONSTRAINT rezervacija_broj_sobe_fk REFERENCES
        soba(broj_sobe)
);


CREATE TABLE usluga 
(
    usluga_id INTEGER,
    pocetak_datum DATE NOT NULL,
    pocetak_vrijeme INTEGER NOT NULL,
    datum_kraj DATE NOT NULL,
    vrijeme_kraj INTEGER NOT NULL,
    rezervacija_id INTEGER NOT NULL CONSTRAINT usluga_rezervacija_fk REFERENCES
        rezervacija(rezervacija_id),
    cijena_usluge_id INTEGER NOT NULL CONSTRAINT usluga_cijena_usluge_fk REFERENCES
        cijena_usluge(cijena_usluge_id),
    
    PRIMARY KEY(usluga_id, rezervacija_id, cijena_usluge_id)
);