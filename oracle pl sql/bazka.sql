/*
BEGIN
  FOR cur_rec IN (SELECT object_name, object_type 
                  FROM   user_objects
                  WHERE  object_type IN ('TABLE', 'VIEW', 'PACKAGE', 'PROCEDURE', 'FUNCTION', 'SEQUENCE', 'TRIGGER', 'TYPE')) LOOP
    BEGIN
      IF cur_rec.object_type = 'TABLE' THEN
        IF instr(cur_rec.object_name, 'STORE') = 0 then
          EXECUTE IMMEDIATE 'DROP ' || cur_rec.object_type || ' "' || cur_rec.object_name || '" CASCADE CONSTRAINTS';
        END IF;
      ELSIF cur_rec.object_type = 'TYPE' THEN
        EXECUTE IMMEDIATE 'DROP ' || cur_rec.object_type || ' "' || cur_rec.object_name || '" FORCE';
      ELSE
        EXECUTE IMMEDIATE 'DROP ' || cur_rec.object_type || ' "' || cur_rec.object_name || '"';
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('FAILED: DROP ' || cur_rec.object_type || ' "' || cur_rec.object_name || '"');
    END;
  END LOOP;
END;
/
*/

////////////////////////
// Tworzenie obiektów //
////////////////////////

CREATE OR REPLACE TYPE ProducentType AS OBJECT (
    id_producenta NUMBER,
    nazwa NVARCHAR2(100),
    siedziba NVARCHAR2(100),
    kraj_pochodzenia NVARCHAR2(50),
    rok_zalozenia NUMBER(4)
);
/

CREATE OR REPLACE TYPE WydawcaType AS OBJECT (
    id_wydawcy NUMBER,
    nazwa NVARCHAR2(100),
    siedziba NVARCHAR2(100),
    kraj_pochodzenia NVARCHAR2(50),
    rok_zalozenia NUMBER(4)
);
/

CREATE OR REPLACE TYPE GraType AS OBJECT (
    id_gry NUMBER,
    nazwa NVARCHAR2(100),
    producent REF ProducentType,
    wydawca REF WydawcaType,
    data_wydania DATE,
    gatunek NVARCHAR2(50),
    cena_za_tydzien NUMBER(5,2),
    czas_przejscia NUMBER(5,2),
    platforma NVARCHAR2(50),
    rozmiar_na_dysku NUMBER(5,2),
    klasyfikacja_wiekowa NUMBER(2),
    w_ofercie CHAR(1)
);
/

CREATE OR REPLACE TYPE KlientType;
/

CREATE OR REPLACE TYPE WypozyczeniaType AS OBJECT (
    id_wypozyczenia NUMBER,
    klient REF KlientType,
    gra REF GraType,
    cena NUMBER(6,2),
    data_wypozyczenia DATE,
    data_zwrotu DATE,
    przedluzone CHAR(1),
    okres_przedluzenia NUMBER(2)
);
/

CREATE OR REPLACE TYPE WypozyczeniaRefList AS TABLE OF REF WypozyczeniaType;
/

CREATE OR REPLACE TYPE KlientType AS OBJECT (
    id_klienta NUMBER,
    imie NVARCHAR2(50),
    nazwisko NVARCHAR2(50),
    nickname NVARCHAR2(50),
    email NVARCHAR2(100),
    data_urodzenia DATE,
    rabat NUMBER(2),
    kraj NVARCHAR2(50),
    numer_telefonu NVARCHAR2(9),
    historia_wypozyczen WypozyczeniaRefList
);
/

CREATE OR REPLACE TYPE PostacType AS OBJECT (
    id_gry_postac NUMBER,
    id_postaci NUMBER,
    nazwa NVARCHAR2(30),
    poziom_odblokowania NUMBER
);
/

CREATE OR REPLACE TYPE ProfilGraczaType;
/

CREATE OR REPLACE TYPE GraczeVarray AS VARRAY(5) OF NVARCHAR2(50);
/

CREATE OR REPLACE TYPE PostacieVarray AS VARRAY(5) OF NVARCHAR2(30);
/

CREATE OR REPLACE TYPE MapaType AS OBJECT (
    id_gry_mapa NUMBER,
    id_mapy NUMBER,
    nazwa NVARCHAR2(30),
    dostepna_w_rankingowym CHAR(1),
    dostepna_w_nierankingowym CHAR(1)
);
/

CREATE OR REPLACE TYPE HistoriaRozgrywekType AS OBJECT (
    id_gry_rozgrywka NUMBER,
    id_rozgrywki NUMBER,
    gracze_home GraczeVarray,
    gracze_away GraczeVarray,
    postacie_home PostacieVarray,
    postacie_away PostacieVarray,
    wynik_home NUMBER,
    wynik_away NUMBER,
    mapa REF MapaType,
    liczba_rozegranych_rund NUMBER,
    typ CHAR
);
/

CREATE OR REPLACE TYPE HistoriaRozgrywekRefList AS TABLE OF REF HistoriaRozgrywekType;
/

CREATE OR REPLACE TYPE ProfilGraczaType AS OBJECT (
    id_gry_gracz NUMBER,
    id_klienta NUMBER,
    nickname NVARCHAR2(50),
    poziom NUMBER,
    MMR NUMBER,
    liczba_godzin NUMBER,
    historia_rozgrywek HistoriaRozgrywekRefList
);
/

CREATE OR REPLACE TYPE TierlistaPostaciType AS OBJECT (
    id_gry_postac_tierlist NUMBER,
    id_postaci NUMBER,
    nazwa NVARCHAR2(30),
    winrate NUMBER,
    pickrate NUMBER,
    liczba_gier NUMBER
);
/

//////////////////////
// Tabela obiektowa //
//////////////////////

CREATE TABLE Producent OF ProducentType (
    id_producenta PRIMARY KEY,
    CONSTRAINT producent_nazwa_unique UNIQUE (nazwa),
    CONSTRAINT producent_rok_zalozenia_check CHECK (rok_zalozenia > 1900)
);
/

ALTER TABLE PRODUCENT MODIFY (
    NAZWA NOT NULL,
    SIEDZIBA NOT NULL,
    KRAJ_POCHODZENIA NOT NULL,
    ROK_ZALOZENIA NOT NULL
);
/

CREATE TABLE Wydawca OF WydawcaType (
    id_wydawcy PRIMARY KEY,
    CONSTRAINT wydawca_nazwa_unique UNIQUE (nazwa),
    CONSTRAINT wydawca_rok_zalozenia_check CHECK (rok_zalozenia > 1900)
);
/

ALTER TABLE WYDAWCA MODIFY (
    NAZWA NOT NULL,
    SIEDZIBA NOT NULL,
    KRAJ_POCHODZENIA NOT NULL,
    ROK_ZALOZENIA NOT NULL
);
/

CREATE TABLE Gra OF GraType (
    id_gry PRIMARY KEY,
    SCOPE FOR (producent) IS Producent,
    SCOPE FOR (wydawca) IS Wydawca,
    CONSTRAINT gra_nazwa_unique UNIQUE (nazwa),
    CONSTRAINT klasyfikacja_wiekowa_check CHECK (klasyfikacja_wiekowa IN (3, 7, 12, 16, 18)),
    CONSTRAINT gatunek_check CHECK (gatunek IN ('RPG', 'Action', 'FPS', 'Racing', 'Sports', 'Horror', 'Fighting', 'MMORPG')),
    CONSTRAINT cena_za_tydzien_check CHECK (cena_za_tydzien > 0),
    CONSTRAINT czas_przejscia_check CHECK (czas_przejscia > 0),
    CONSTRAINT rozmiar_na_dysku_check CHECK (rozmiar_na_dysku > 0),
    CONSTRAINT w_ofercie_check CHECK (w_ofercie IN ('0', '1'))
);
/

ALTER TABLE GRA MODIFY (
    NAZWA NOT NULL, 
    PRODUCENT NOT NULL, 
    WYDAWCA NOT NULL, 
    DATA_WYDANIA NOT NULL, 
    GATUNEK NOT NULL, 
    CENA_ZA_TYDZIEN NOT NULL, 
    PLATFORMA NOT NULL, 
    KLASYFIKACJA_WIEKOWA NOT NULL
);
/

CREATE TABLE Klient OF KlientType (
    id_klienta PRIMARY KEY,
    CONSTRAINT klient_nickname_unique UNIQUE (nickname),
    CONSTRAINT klient_email_unique UNIQUE (email),
    CONSTRAINT klient_nr_tel_unique UNIQUE (numer_telefonu)
) NESTED TABLE historia_wypozyczen STORE AS historia_wypozyczen;
/

ALTER TABLE KLIENT MODIFY (
    IMIE NOT NULL, 
    NAZWISKO NOT NULL, 
    NICKNAME NOT NULL, 
    EMAIL NOT NULL, 
    DATA_URODZENIA NOT NULL
);
/

CREATE TABLE Wypozyczenia OF WypozyczeniaType (
    id_wypozyczenia PRIMARY KEY,
    SCOPE FOR (klient) IS Klient,
    SCOPE FOR (gra) IS Gra,
    CONSTRAINT data_wypozyczenia_check CHECK (data_wypozyczenia < data_zwrotu),
    CONSTRAINT cena_check CHECK (cena > 0),
    CONSTRAINT przedluzone_check CHECK (przedluzone IN ('0', '1'))
);
/

ALTER TABLE WYPOZYCZENIA MODIFY (
    KLIENT NOT NULL,
    GRA NOT NULL,
    CENA NOT NULL,
    DATA_WYPOZYCZENIA NOT NULL,
    DATA_ZWROTU NOT NULL,
    PRZEDLUZONE NOT NULL
);
/

BEGIN
   EXECUTE IMMEDIATE 'TRUNCATE TABLE "PROJEKT"."TYMCZASOWE_DANE_WYPOZYCZEN"';
   EXECUTE IMMEDIATE 'DROP TABLE "PROJEKT"."TYMCZASOWE_DANE_WYPOZYCZEN"';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE GLOBAL TEMPORARY TABLE tymczasowe_dane_wypozyczen (
    tytul VARCHAR2(100),
    gatunek VARCHAR2(50),
    cena NUMBER(10, 2),
    rok_wypozyczenia NUMBER(4),
    miesiac_wypozyczenia NUMBER(2),
    czas_wypozyczenia NUMBER(10)
) ON COMMIT PRESERVE ROWS;
/


CREATE TABLE Mapa OF MapaType (
    FOREIGN KEY (id_gry_mapa) REFERENCES Gra(id_gry),
    PRIMARY KEY (id_mapy),
    UNIQUE (nazwa),
    CONSTRAINT rankingowa_check CHECK (dostepna_w_rankingowym IN ('0', '1')),
    CONSTRAINT nierankingowa_check CHECK (dostepna_w_nierankingowym IN ('0', '1'))
);
/

ALTER TABLE MAPA MODIFY (
    nazwa NOT NULL, 
    dostepna_w_rankingowym NOT NULL, 
    dostepna_w_nierankingowym NOT NULL
);
/

CREATE TABLE Postac OF PostacType (
    FOREIGN KEY (id_gry_postac) REFERENCES Gra(id_gry),
    PRIMARY KEY (id_postaci),
    CONSTRAINT postac_nazwa_unique UNIQUE (nazwa),
    CONSTRAINT poziom_odblokowania_check CHECK (poziom_odblokowania >= 0 AND poziom_odblokowania <=30)
);

ALTER TABLE Postac MODIFY (
    nazwa NOT NULL,
    poziom_odblokowania NOT NULL
);
/

CREATE TABLE Profil_Gracza OF ProfilGraczaType (
    FOREIGN KEY (id_gry_gracz) REFERENCES Gra(id_gry),
    FOREIGN KEY (id_klienta) REFERENCES Klient(id_klienta),
    CONSTRAINT poziom_check CHECK (poziom >= 0),
    CONSTRAINT MMR_check CHECK (MMR >= 0)
) 
NESTED TABLE historia_rozgrywek STORE AS historia_rozgrywek_table;

ALTER TABLE Profil_Gracza MODIFY (
    id_klienta NOT NULL
);
/

CREATE TABLE Historia_Rozgrywek OF HistoriaRozgrywekType (
    FOREIGN KEY (id_gry_rozgrywka) REFERENCES Gra(id_gry),
    id_rozgrywki PRIMARY KEY,
    SCOPE FOR (mapa) IS Mapa,
    CONSTRAINT wynik_home_check CHECK (wynik_home >= 0),
    CONSTRAINT wynik_away_check CHECK (wynik_away >= 0),
    CONSTRAINT liczba_rozegranych_rund_check CHECK (liczba_rozegranych_rund >= 0),
    CONSTRAINT typ_check CHECK (typ IN ('r', 'n'))
);

ALTER TABLE Historia_Rozgrywek MODIFY (
    id_gry_rozgrywka NOT NULL,
    id_rozgrywki NOT NULL,
    gracze_home NOT NULL,
    gracze_away NOT NULL,
    postacie_home NOT NULL,
    postacie_away NOT NULL,
    wynik_home NOT NULL,
    wynik_away NOT NULL,
    mapa NOT NULL,
    liczba_rozegranych_rund NOT NULL,
    typ NOT NULL
);
/

CREATE TABLE Tierlista_Postaci OF TierlistaPostaciType (
    FOREIGN KEY (id_gry_postac_tierlist) REFERENCES Gra(id_gry),
    id_postaci PRIMARY KEY,
    CONSTRAINT winrate_check CHECK (winrate >= 0 AND winrate <= 100),
    CONSTRAINT pickrate_check CHECK (pickrate >= 0),
    CONSTRAINT liczba_gier_check CHECK (liczba_gier >= 0)
);
//CONSTRAINT pickrate_check CHECK (pickrate >= 0 AND pickrate <= 100),

ALTER TABLE Tierlista_Postaci MODIFY (
    id_gry_postac_tierlist NOT NULL,
    id_postaci NOT NULL
);
/

////////////////
// WYZWALACZE //
////////////////

CREATE OR REPLACE TRIGGER trg_check_klasyfikacja_wiekowa
BEFORE INSERT OR UPDATE ON Wypozyczenia
FOR EACH ROW
DECLARE
    klient_data_urodzenia DATE;
    gra_klasyfikacja_wiekowa NUMBER;
BEGIN
    SELECT k.data_urodzenia
    INTO klient_data_urodzenia
    FROM Klient k
    WHERE REF(k) = :NEW.klient;

    SELECT g.klasyfikacja_wiekowa
    INTO gra_klasyfikacja_wiekowa
    FROM Gra g
    WHERE REF(g) = :NEW.gra;

    IF klient_data_urodzenia + INTERVAL '1' YEAR * gra_klasyfikacja_wiekowa > SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20001, 'Klient nie spe³nia wymagañ wiekowych dla tej gry.');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_check_w_ofercie
BEFORE INSERT ON Wypozyczenia
FOR EACH ROW
DECLARE
    gra_w_ofercie CHAR(1);
BEGIN

    SELECT g.w_ofercie
    INTO gra_w_ofercie
    FROM Gra g
    WHERE REF(g) = :NEW.gra;

    IF gra_w_ofercie = '0' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Gra nie znajduje sie ju¿ w ofercie wypo¿yczeñ.');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_update_profilgracza_tierlista
BEFORE INSERT ON HISTORIA_ROZGRYWEK
FOR EACH ROW
DECLARE
    gracze_home_count NUMBER := :NEW.gracze_home.COUNT;
    gracze_away_count NUMBER := :NEW.gracze_away.COUNT;
    postacie_home_count NUMBER := :NEW.postacie_home.COUNT;
    postacie_away_count NUMBER := :NEW.postacie_away.COUNT;

    is_home_winner NUMBER;
    
    game NUMBER := :NEW.id_gry_rozgrywka;
BEGIN
    -- Ustalenie, która dru¿yna wygra³a
    IF :NEW.wynik_home > :NEW.wynik_away THEN
        is_home_winner := 1;
    ELSE
        is_home_winner := 0;
    END IF;

    -- Aktualizacja statystyk graczy dru¿yny home
    FOR i IN 1..gracze_home_count LOOP
        UPDATE Profil_Gracza
        SET liczba_godzin = liczba_godzin + (45 / 60),
            poziom = poziom + CASE WHEN is_home_winner = 1 THEN 0.25 ELSE 0.05 END,
            MMR = CASE 
                    WHEN MMR + CASE WHEN is_home_winner = 1 THEN 7 ELSE -10 END < 0 THEN 0
                    ELSE MMR + CASE WHEN is_home_winner = 1 THEN 7 ELSE -10 END
                  END
        WHERE nickname = :NEW.gracze_home(i) AND id_gry_gracz = game;
    END LOOP;

    -- Aktualizacja statystyk graczy dru¿yny away
    FOR i IN 1..gracze_away_count LOOP
        UPDATE Profil_Gracza
        SET liczba_godzin = liczba_godzin + (45 / 60),
            poziom = poziom + CASE WHEN is_home_winner = 0 THEN 0.25 ELSE 0.05 END,
            MMR = CASE 
                    WHEN MMR + CASE WHEN is_home_winner = 0 THEN 7 ELSE -10 END < 0 THEN 0
                    ELSE MMR + CASE WHEN is_home_winner = 0 THEN 7 ELSE -10 END
                  END
        WHERE nickname = :NEW.gracze_away(i) AND id_gry_gracz = game;
    END LOOP;

    -- Aktualizacja Tierlista_Postaci dla dru¿yny HOME
    FOR i IN 1..postacie_home_count LOOP
        UPDATE Tierlista_Postaci
        SET liczba_gier = liczba_gier + 1,
            winrate =   CASE
                            WHEN is_home_winner = 1 THEN 
                                ((winrate * liczba_gier + 100) / (liczba_gier + 1))
                            ELSE 
                                ((winrate * liczba_gier) / (liczba_gier + 1))
                        END,
            pickrate =  CASE 
                            WHEN (SELECT COUNT(*) FROM Historia_Rozgrywek) = 0 THEN 100
                            ELSE 
                                ((liczba_gier + 1) / ((SELECT COUNT(*) FROM Historia_Rozgrywek) + 1)) * 100
                        END
        WHERE nazwa = :NEW.postacie_home(i) AND id_gry_postac_tierlist = game;
    END LOOP;

    -- Analogiczna logika dla dru¿yny AWAY
    FOR i IN 1..postacie_away_count LOOP
        UPDATE Tierlista_Postaci
        SET liczba_gier = liczba_gier + 1,
            winrate =   CASE
                            WHEN is_home_winner = 0 THEN 
                                ((winrate * liczba_gier + 100) / (liczba_gier + 1))
                            ELSE 
                                ((winrate * liczba_gier) / (liczba_gier + 1))
                        END,
            pickrate =  CASE 
                            WHEN (SELECT COUNT(*) FROM Historia_Rozgrywek) = 0 THEN 100
                            ELSE 
                                ((liczba_gier + 1) / ((SELECT COUNT(*) FROM Historia_Rozgrywek) + 1)) * 100
                        END
        WHERE nazwa = :NEW.postacie_away(i) AND id_gry_postac_tierlist = game;
    END LOOP;
END;
/

CREATE OR REPLACE TRIGGER trg_dodaj_gracza_do_profilgracza
AFTER INSERT ON Wypozyczenia
FOR EACH ROW
DECLARE
    v_nickname NVARCHAR2(50);
    v_id_klienta NUMBER;
    v_id_gry NVARCHAR2(100);
    v_profil_exists NUMBER;
BEGIN
    SELECT g.id_gry 
    INTO v_id_gry 
    FROM Gra g 
    WHERE g.id_gry = DEREF(:NEW.gra).id_gry;

    IF v_id_gry IN (24, 1) THEN
        SELECT k.nickname, k.id_klienta 
        INTO v_nickname, v_id_klienta
        FROM Klient k
        WHERE k.id_klienta = DEREF(:NEW.klient).id_klienta;

        SELECT COUNT(*) 
        INTO v_profil_exists
        FROM Profil_Gracza 
        WHERE id_klienta = v_id_klienta AND id_gry_gracz = v_id_gry;

        IF v_profil_exists = 0 THEN
            INSERT INTO Profil_Gracza (id_gry_gracz, id_klienta, nickname, poziom, MMR, liczba_godzin)
            VALUES (v_id_gry, v_id_klienta, v_nickname, 1, 100, 0);
        END IF;
    END IF;
END;
/


/////////////
// PAKIETY //
/////////////

CREATE OR REPLACE PACKAGE Biblioteka_Gier AS
    PROCEDURE dodaj_nowa_gre(
        p_tytul IN VARCHAR2,
        p_producent IN VARCHAR2,
        p_wydawca IN VARCHAR2,
        p_data_wydania IN DATE,
        p_gatunek IN VARCHAR2,
        p_cena_za_tydzien IN NUMBER,
        p_czas_przejscia IN NUMBER DEFAULT NULL,
        p_platforma IN VARCHAR2,
        p_rozmiar_na_dysku IN NUMBER DEFAULT NULL,
        p_klasyfikacja_wiekowa IN NUMBER
    );
    
    PROCEDURE edytuj_gre(
        p_id_gry IN NUMBER,
        p_tytul IN NVARCHAR2,
        p_producent IN NVARCHAR2,
        p_wydawca IN NVARCHAR2,
        p_data_wydania IN DATE,
        p_gatunek IN NVARCHAR2,
        p_cena_za_tydzien IN NUMBER,
        p_czas_przejscia IN NUMBER DEFAULT NULL,
        p_platforma IN NVARCHAR2,
        p_rozmiar_na_dysku IN NUMBER DEFAULT NULL,
        p_klasyfikacja_wiekowa IN NUMBER
    );
    
    PROCEDURE zmien_stan_gry(
        p_id_gry IN NUMBER
    );
END Biblioteka_Gier;
/

CREATE OR REPLACE PACKAGE BODY Biblioteka_Gier AS
    PROCEDURE dodaj_nowa_gre(
        p_tytul IN VARCHAR2,
        p_producent IN VARCHAR2,
        p_wydawca IN VARCHAR2,
        p_data_wydania IN DATE,
        p_gatunek IN VARCHAR2,
        p_cena_za_tydzien IN NUMBER,
        p_czas_przejscia IN NUMBER DEFAULT NULL,
        p_platforma IN VARCHAR2,
        p_rozmiar_na_dysku IN NUMBER DEFAULT NULL,
        p_klasyfikacja_wiekowa IN NUMBER
    ) IS
        v_id_producent NUMBER;
        v_id_wydawca NUMBER;
        v_id_gry NUMBER;
    BEGIN
        IF UPPER(p_gatunek) NOT IN ('RPG', 'ACTION', 'FPS', 'SPORTS', 'HORROR', 'FIGHTING', 'MMORPG', 'RACING') THEN
            DBMS_OUTPUT.PUT_LINE('B³¹d: Podano nieprawid³owy gatunek gry.');
            RETURN;
        ELSIF p_klasyfikacja_wiekowa NOT IN (3, 7, 12, 16, 18) THEN
            DBMS_OUTPUT.PUT_LINE('B³¹d: Podano nieprawid³ow¹ klasyfikacjê wiekow¹.');
            RETURN;
        END IF;
    
        SELECT id_producenta
        INTO v_id_producent
        FROM Producent
        WHERE nazwa = p_producent;
        
        SELECT id_wydawcy
        INTO v_id_wydawca
        FROM Wydawca
        WHERE nazwa = p_wydawca;
    
        SELECT NVL(MAX(id_gry), 0) + 1
        INTO v_id_gry
        FROM Gra;
    
        INSERT INTO Gra (id_gry, nazwa, producent, wydawca, data_wydania, gatunek, cena_za_tydzien, czas_przejscia, platforma, rozmiar_na_dysku, klasyfikacja_wiekowa, w_ofercie) 
        VALUES (v_id_gry, p_tytul, (SELECT REF(p) FROM Producent p WHERE p.id_producenta = v_id_producent), (SELECT REF(w) FROM Wydawca w WHERE w.id_wydawcy = v_id_wydawca), p_data_wydania, p_gatunek, p_cena_za_tydzien, p_czas_przejscia, p_platforma, p_rozmiar_na_dysku, p_klasyfikacja_wiekowa, '1');
    
        DBMS_OUTPUT.PUT_LINE('Gra "' || p_tytul || '" zosta³a pomyœlnie dodana do bazy danych. ID gry: ' || v_id_gry);
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            IF v_id_producent IS NULL THEN
                DBMS_OUTPUT.PUT_LINE('B³¹d: Producent "' || p_producent || '" nie istnieje w bazie danych.');
            ELSIF v_id_wydawca IS NULL THEN
                DBMS_OUTPUT.PUT_LINE('B³¹d: Wydawca "' || p_wydawca || '" nie istnieje w bazie danych.');
            END IF;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Wyst¹pi³ b³¹d: ' || SQLERRM);
    END dodaj_nowa_gre;

    PROCEDURE edytuj_gre(
        p_id_gry IN NUMBER,
        p_tytul IN NVARCHAR2,
        p_producent IN NVARCHAR2,
        p_wydawca IN NVARCHAR2,
        p_data_wydania IN DATE,
        p_gatunek IN NVARCHAR2,
        p_cena_za_tydzien IN NUMBER,
        p_czas_przejscia IN NUMBER DEFAULT NULL,
        p_platforma IN NVARCHAR2,
        p_rozmiar_na_dysku IN NUMBER DEFAULT NULL,
        p_klasyfikacja_wiekowa IN NUMBER
    ) IS
        v_id_producent NUMBER := NULL;
        v_id_wydawca NUMBER := NULL;
        v_count NUMBER;
        v_czas_przejscia NUMBER;
        v_rozmiar_na_dysku NUMBER;
    BEGIN
        IF p_tytul IS NULL AND p_producent IS NULL AND p_wydawca IS NULL AND p_data_wydania IS NULL AND p_gatunek IS NULL AND p_cena_za_tydzien IS NULL AND p_czas_przejscia IS NULL AND p_platforma IS NULL AND p_rozmiar_na_dysku IS NULL AND p_klasyfikacja_wiekowa IS NULL THEN
            DBMS_OUTPUT.PUT_LINE('Brak wprowadzonych zmian.');
            RETURN;
        END IF;
    
        IF p_producent IS NOT NULL THEN
            SELECT id_producenta
            INTO v_id_producent
            FROM Producent
            WHERE UPPER(nazwa) = UPPER(p_producent);
        END IF;
        
        IF p_wydawca IS NOT NULL THEN
            SELECT id_wydawcy
            INTO v_id_wydawca
            FROM Wydawca
            WHERE UPPER(nazwa) = UPPER(p_wydawca);
        END IF;
        
        IF UPPER(p_gatunek) NOT IN ('RPG', 'ACTION', 'FPS', 'SPORTS', 'HORROR', 'FIGHTING', 'MMORPG', 'RACING') THEN
            DBMS_OUTPUT.PUT_LINE('B³¹d: Podano nieprawid³owy gatunek gry.');
            RETURN;
        ELSIF p_klasyfikacja_wiekowa NOT IN (3, 7, 12, 16, 18) THEN
            DBMS_OUTPUT.PUT_LINE('B³¹d: Podano nieprawid³ow¹ klasyfikacjê wiekow¹.');
            RETURN;
        END IF;
    
        IF p_czas_przejscia = -1 THEN
            v_czas_przejscia := NULL;
        ELSE
            v_czas_przejscia := p_czas_przejscia;
        END IF;
        
        IF p_rozmiar_na_dysku = -1 THEN
            v_rozmiar_na_dysku := NULL;
        ELSE
            v_rozmiar_na_dysku := p_rozmiar_na_dysku;
        END IF;
    
        SELECT COUNT(*)
        INTO v_count
        FROM Gra
        WHERE id_gry = p_id_gry;
        
        IF v_count = 0 THEN
            DBMS_OUTPUT.PUT_LINE('B³¹d: Gra o ID ' || p_id_gry || ' nie istnieje w bazie danych.');
            RETURN;
        END IF;
    
        UPDATE Gra
        SET
            nazwa = CASE WHEN p_tytul IS NOT NULL THEN p_tytul ELSE nazwa END,
            producent = CASE WHEN v_id_producent IS NOT NULL THEN (SELECT REF(p) FROM Producent p WHERE p.id_producenta = v_id_producent) ELSE producent END,
            wydawca = CASE WHEN v_id_wydawca IS NOT NULL THEN (SELECT REF(w) FROM Wydawca w WHERE w.id_wydawcy = v_id_wydawca) ELSE wydawca END,
            data_wydania = CASE WHEN p_data_wydania IS NOT NULL THEN p_data_wydania ELSE data_wydania END,
            gatunek = CASE WHEN p_gatunek IS NOT NULL THEN p_gatunek ELSE gatunek END,
            cena_za_tydzien = CASE WHEN p_cena_za_tydzien IS NOT NULL THEN p_cena_za_tydzien ELSE cena_za_tydzien END,
            czas_przejscia = CASE WHEN p_czas_przejscia IS NOT NULL THEN v_czas_przejscia ELSE czas_przejscia END,
            platforma = CASE WHEN p_platforma IS NOT NULL THEN p_platforma ELSE platforma END,
            rozmiar_na_dysku = CASE WHEN p_rozmiar_na_dysku IS NOT NULL THEN v_rozmiar_na_dysku ELSE rozmiar_na_dysku END,
            klasyfikacja_wiekowa = CASE WHEN p_klasyfikacja_wiekowa IS NOT NULL THEN p_klasyfikacja_wiekowa ELSE klasyfikacja_wiekowa END
        WHERE id_gry = p_id_gry;
        
        IF SQL%ROWCOUNT > 0 THEN
            DBMS_OUTPUT.PUT_LINE('Gra o ID ' || p_id_gry || ' zosta³a pomyœlnie zaktualizowana.');
        END IF;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            IF p_producent IS NOT NULL AND v_id_producent IS NULL THEN
                DBMS_OUTPUT.PUT_LINE('B³¹d: Producent "' || p_producent || '" nie istnieje w bazie danych.');
            ELSIF p_wydawca IS NOT NULL AND v_id_wydawca IS NULL THEN
                DBMS_OUTPUT.PUT_LINE('B³¹d: Wydawca "' || p_wydawca || '" nie istnieje w bazie danych.');
            END IF;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Wyst¹pi³ b³¹d: ' || SQLERRM);
    END edytuj_gre;

    PROCEDURE zmien_stan_gry(
        p_id_gry IN NUMBER
    ) IS
        v_stan CHAR(1);
    BEGIN
        SELECT w_ofercie
        INTO v_stan
        FROM Gra
        WHERE id_gry = p_id_gry;
    
        IF v_stan = '0' THEN
            UPDATE Gra
            SET w_ofercie = '1'
            WHERE id_gry = p_id_gry;
            DBMS_OUTPUT.PUT_LINE('Stan gry o ID ' || p_id_gry || ' zmieniono na "1".');
        ELSIF v_stan = '1' THEN
            UPDATE Gra
            SET w_ofercie = '0'
            WHERE id_gry = p_id_gry;
            DBMS_OUTPUT.PUT_LINE('Stan gry o ID ' || p_id_gry || ' zmieniono na "0".');
        ELSE
            DBMS_OUTPUT.PUT_LINE('B³¹d: Nieprawid³owa wartoœæ stanu gry dla ID ' || p_id_gry || '.');
            RETURN;
        END IF;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('B³¹d: Gra o ID ' || p_id_gry || ' nie istnieje w bazie danych.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Wyst¹pi³ b³¹d: ' || SQLERRM);
    END zmien_stan_gry;
END Biblioteka_Gier;
/

CREATE OR REPLACE PACKAGE Klienci AS
    PROCEDURE update_rabat_dla_klient(
        p_nickname_rabat_klienta IN VARCHAR2
    );
    PROCEDURE add_wypozyczenie(
        p_nazwa_gry IN VARCHAR2,
        p_nickname_klienta IN VARCHAR2,
        p_czas_tygodnie IN NUMBER
    );
    PROCEDURE edytuj_uzytkownika(
        p_nickname IN NVARCHAR2,
        p_imie IN NVARCHAR2 DEFAULT NULL,
        p_nazwisko IN NVARCHAR2 DEFAULT NULL,
        p_email IN NVARCHAR2 DEFAULT NULL,
        p_telefon IN NVARCHAR2 DEFAULT NULL,
        p_kraj IN NVARCHAR2 DEFAULT NULL,
        p_data_urodzenia IN DATE DEFAULT NULL
    );
    PROCEDURE pokaz_rabat_klienta(
        p_nickname IN VARCHAR2
    );
    PROCEDURE wyswietl_klientow_z_rabatem;
    PROCEDURE przedluz_wypozyczenie(
        p_nickname_klienta IN VARCHAR2,
        p_id_wypozyczenia IN NUMBER,
        p_dlugosc_przedluzenia IN NUMBER
    );
END Klienci;
/

CREATE OR REPLACE PACKAGE BODY Klienci AS
    PROCEDURE update_rabat_dla_klient(
        p_nickname_rabat_klienta IN VARCHAR2
    ) IS
        v_liczba_wypozyczen NUMBER := 0;
        v_nowy_rabat NUMBER;
        v_klient_id NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_liczba_wypozyczen
        FROM Wypozyczenia w
        WHERE w.klient = (SELECT REF(k) FROM Klient k WHERE k.nickname = p_nickname_rabat_klienta);
    
        IF v_liczba_wypozyczen >= 10 AND v_liczba_wypozyczen <= 50 AND v_liczba_wypozyczen mod 10 = 0 THEN
            v_nowy_rabat := FLOOR(v_liczba_wypozyczen / 10) * 10;
    
            SELECT k.id_klienta
            INTO v_klient_id
            FROM Klient k
            WHERE k.nickname = p_nickname_rabat_klienta;
    
            UPDATE Klient
            SET rabat = v_nowy_rabat
            WHERE id_klienta = v_klient_id;
    
            DBMS_OUTPUT.PUT_LINE('Nowy rabat wynosi: ' || v_nowy_rabat || '% dla klienta: ' || p_nickname_rabat_klienta || '. To ' || v_liczba_wypozyczen || ' wypo¿yczenie u¿ytkownika.');
        END IF;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('B³¹d: Klient o podanym nickname nie istnieje.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Wyst¹pi³ b³¹d: ' || SQLERRM);
    END update_rabat_dla_klient;

    PROCEDURE add_wypozyczenie(
        p_nazwa_gry IN VARCHAR2,
        p_nickname_klienta IN VARCHAR2,
        p_czas_tygodnie IN NUMBER
    ) IS
        v_gry_cena_tygodniowa NUMBER;
        v_id_wypozyczenia NUMBER;
        v_data_wypozyczenia DATE := SYSDATE;
        v_data_zwrotu DATE := NULL;
        v_rabat NUMBER;
        v_cena_wypozyczenia NUMBER;
    BEGIN
        SELECT cena_za_tydzien
        INTO v_gry_cena_tygodniowa
        FROM Gra g
        WHERE g.nazwa = p_nazwa_gry;
    
        SELECT rabat
        INTO v_rabat
        FROM Klient k
        WHERE k.nickname = p_nickname_klienta;
        
        IF p_czas_tygodnie < 4 THEN
            v_cena_wypozyczenia := (v_gry_cena_tygodniowa * p_czas_tygodnie) * (1 - NVL(v_rabat,0) / 100);
        ELSIF p_czas_tygodnie < 13 THEN
            v_cena_wypozyczenia := (v_gry_cena_tygodniowa * p_czas_tygodnie) * (1 - NVL(v_rabat,0) / 100) * (1 - (5 / 100));
        ELSIF p_czas_tygodnie < 52 THEN
            v_cena_wypozyczenia := (v_gry_cena_tygodniowa * p_czas_tygodnie) * (1 - NVL(v_rabat,0) / 100) * (1 - (15 / 100));
        ELSIF p_czas_tygodnie >= 52 THEN
            v_cena_wypozyczenia := (v_gry_cena_tygodniowa * p_czas_tygodnie) * (1 - NVL(v_rabat,0) / 100) * (1 - (30 / 100));
        END IF;
    
        SELECT NVL(MAX(id_wypozyczenia), 0) + 1
        INTO v_id_wypozyczenia
        FROM Wypozyczenia;
    
        INSERT INTO Wypozyczenia (
            id_wypozyczenia,
            klient,
            gra,
            cena,
            data_wypozyczenia,
            data_zwrotu,
            przedluzone,
            okres_przedluzenia
        )
        VALUES (
            v_id_wypozyczenia,
            (SELECT REF(k) FROM Klient k WHERE k.nickname = p_nickname_klienta),
            (SELECT REF(g) FROM Gra g WHERE g.nazwa = p_nazwa_gry),
            round(v_cena_wypozyczenia,2),
            v_data_wypozyczenia,
            v_data_wypozyczenia + p_czas_tygodnie * 7,
            '0',
            NULL
        );
    
        DBMS_OUTPUT.PUT_LINE('Wypo¿yczenie zosta³o dodane. ID Wypo¿yczenia: ' || v_id_wypozyczenia);
        DBMS_OUTPUT.PUT_LINE('Koszt wypo¿yczenia: ' || round(v_cena_wypozyczenia,2));
        BEGIN
            UPDATE_RABAT_DLA_KLIENT(p_nickname_klienta);
        END;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('B³¹d: Gra o podanej nazwie nie istnieje.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Wyst¹pi³ b³¹d: ' || SQLERRM);
    END add_wypozyczenie;

    PROCEDURE edytuj_uzytkownika (
        p_nickname IN NVARCHAR2,
        p_imie IN NVARCHAR2 DEFAULT NULL,
        p_nazwisko IN NVARCHAR2 DEFAULT NULL,
        p_email IN NVARCHAR2 DEFAULT NULL,
        p_telefon IN NVARCHAR2 DEFAULT NULL,
        p_kraj IN NVARCHAR2 DEFAULT NULL,
        p_data_urodzenia IN DATE DEFAULT NULL
    ) IS
        v_count NUMBER;
    BEGIN
        IF p_imie IS NULL AND p_nazwisko IS NULL AND p_email IS NULL AND p_telefon IS NULL AND p_kraj IS NULL AND p_data_urodzenia IS NULL THEN
            DBMS_OUTPUT.PUT_LINE('Brak wprowadzonych zmian.');
            RETURN;
        END IF;
    
        SELECT COUNT(*)
        INTO v_count
        FROM Klient
        WHERE nickname = p_nickname;
    
        IF v_count = 0 THEN
            DBMS_OUTPUT.PUT_LINE('B³¹d: U¿ytkownik o nicku "' || p_nickname || '" nie istnieje w bazie danych.');
            RETURN;
        END IF;
    
        UPDATE Klient
        SET
            imie = CASE WHEN p_imie IS NOT NULL THEN p_imie ELSE imie END,
            nazwisko = CASE WHEN p_nazwisko IS NOT NULL THEN p_nazwisko ELSE nazwisko END,
            email = CASE WHEN p_email IS NOT NULL THEN p_email ELSE email END,
            numer_telefonu = CASE WHEN p_telefon IS NOT NULL THEN p_telefon ELSE numer_telefonu END,
            kraj = CASE WHEN p_kraj IS NOT NULL THEN p_kraj ELSE kraj END,
            data_urodzenia = CASE WHEN p_data_urodzenia IS NOT NULL THEN p_data_urodzenia ELSE data_urodzenia END
        WHERE nickname = p_nickname;
    
        IF SQL%ROWCOUNT > 0 THEN
            DBMS_OUTPUT.PUT_LINE('Dane u¿ytkownika "' || p_nickname || '" zosta³y pomyœlnie zaktualizowane.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Brak zmian dla u¿ytkownika "' || p_nickname || '".');
        END IF;
    
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Wyst¹pi³ b³¹d: ' || SQLERRM);
    END edytuj_uzytkownika;

    PROCEDURE pokaz_rabat_klienta(
        p_nickname IN VARCHAR2
    ) IS
        v_rabat NUMBER;
    BEGIN
        SELECT rabat
        INTO v_rabat
        FROM Klient
        WHERE nickname = p_nickname;
    
        IF v_rabat IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE('Klient o nickname: ' || p_nickname || ' ma rabat w wysokoœci: ' || v_rabat || '%.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('B³¹d: Brak rabatu dla klienta o nickname ' || p_nickname || '.');
        END IF;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('B³¹d: Klient o nickname ' || p_nickname || ' nie istnieje w bazie danych.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Wyst¹pi³ b³¹d: ' || SQLERRM);
    END pokaz_rabat_klienta;

    PROCEDURE wyswietl_klientow_z_rabatem 
    IS
        CURSOR klienci_cursor IS
            SELECT id_klienta, nickname, rabat
            FROM Klient
            WHERE rabat IS NOT NULL;
    
        v_id_klienta Klient.id_klienta%TYPE;
        v_nickname Klient.nickname%TYPE;
        v_rabat Klient.rabat%TYPE;
        licznik INTEGER := 0;
    BEGIN
        OPEN klienci_cursor;
    
        LOOP
            FETCH klienci_cursor INTO v_id_klienta, v_nickname, v_rabat;
            EXIT WHEN klienci_cursor%NOTFOUND;
    
            licznik := licznik + 1;
            DBMS_OUTPUT.PUT_LINE('Klient o nr id: ' || v_id_klienta || 
                                 ' i nickname: ' || v_nickname || 
                                 ' posiada ' || v_rabat || '% rabatu.');
        END LOOP;
    
        CLOSE klienci_cursor;
    
        IF licznik = 0 THEN
            DBMS_OUTPUT.PUT_LINE('¯aden z klientów nie ma rabatu.');
        END IF;
    END wyswietl_klientow_z_rabatem;

    PROCEDURE przedluz_wypozyczenie(
        p_nickname_klienta IN VARCHAR2,
        p_id_wypozyczenia IN NUMBER,
        p_dlugosc_przedluzenia IN NUMBER
    ) IS
        v_id_klienta NUMBER;
        v_cena_tygodniowa NUMBER;
        v_cena_dotychczasowa NUMBER;
        v_rabat NUMBER;
        v_cena_przedluzenia NUMBER;
        v_data_zwrotu DATE;
        v_nowa_data_zwrotu DATE;
        v_nowa_cena NUMBER;
    BEGIN
        SELECT k.id_klienta
        INTO v_id_klienta
        FROM Klient k
        WHERE k.nickname = p_nickname_klienta;
    
        SELECT g.cena_za_tydzien, w.cena, w.data_zwrotu
        INTO v_cena_tygodniowa, v_cena_dotychczasowa, v_data_zwrotu
        FROM Wypozyczenia w
        JOIN Gra g ON g.id_gry = w.gra.id_gry
        WHERE w.id_wypozyczenia = p_id_wypozyczenia;
    
        IF v_data_zwrotu IS NOT NULL AND v_data_zwrotu < SYSDATE THEN
            DBMS_OUTPUT.PUT_LINE('Wypo¿yczenie zosta³o ju¿ zwrócone.');
            RETURN;
        END IF;
    
        SELECT k.rabat
        INTO v_rabat
        FROM Klient k
        WHERE k.id_klienta = v_id_klienta;
    
        v_cena_przedluzenia := v_cena_tygodniowa * (1 - NVL(v_rabat, 0) / 100) * p_dlugosc_przedluzenia;
        
        IF p_dlugosc_przedluzenia < 4 THEN
            v_cena_przedluzenia := v_cena_tygodniowa * (1 - NVL(v_rabat, 0) / 100) * p_dlugosc_przedluzenia;
        ELSIF p_dlugosc_przedluzenia < 13 THEN
            v_cena_przedluzenia := v_cena_tygodniowa * (1 - NVL(v_rabat, 0) / 100) * p_dlugosc_przedluzenia * (1 - (5 / 100));
        ELSIF p_dlugosc_przedluzenia < 52 THEN
            v_cena_przedluzenia := v_cena_tygodniowa * (1 - NVL(v_rabat, 0) / 100) * p_dlugosc_przedluzenia * (1 - (15 / 100));
        ELSIF p_dlugosc_przedluzenia >= 52 THEN
            v_cena_przedluzenia := v_cena_tygodniowa * (1 - NVL(v_rabat, 0) / 100) * p_dlugosc_przedluzenia * (1 - (30 / 100));
        END IF;
    
        v_nowa_data_zwrotu := v_data_zwrotu + (p_dlugosc_przedluzenia * 7);
    
        v_nowa_cena := v_cena_dotychczasowa + v_cena_przedluzenia;
    
        UPDATE Wypozyczenia
        SET data_zwrotu = v_nowa_data_zwrotu,
            cena = round(v_nowa_cena,2)
        WHERE id_wypozyczenia = p_id_wypozyczenia;
    
        DBMS_OUTPUT.PUT_LINE('Koszt przed³u¿enia: ' || round(v_cena_przedluzenia,2));
        DBMS_OUTPUT.PUT_LINE('Nowa data zwrotu: ' || TO_CHAR(v_nowa_data_zwrotu, 'DD-MM-YYYY'));
        DBMS_OUTPUT.PUT_LINE('Nowa cena wypo¿yczenia: ' || round(v_nowa_cena,2));
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('B³¹d: Nie znaleziono wypo¿yczenia o podanym ID lub klienta.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Wyst¹pi³ b³¹d: ' || SQLERRM);
    END przedluz_wypozyczenie;
END Klienci;
/

CREATE OR REPLACE PACKAGE Statystyki AS
    PROCEDURE odswiez_tymczasowe_dane;
    PROCEDURE najczesciej_wypozyczane_gry(
        rok_od IN NUMBER,
        miesiac_od IN NUMBER,
        rok_do IN NUMBER,
        miesiac_do IN NUMBER
    );
    PROCEDURE najczesciej_wypozyczane_gatunki(
        rok_od IN NUMBER,
        miesiac_od IN NUMBER,
        rok_do IN NUMBER,
        miesiac_do IN NUMBER
    );
    PROCEDURE sredni_czas_wypozyczenia(
        rok_od IN NUMBER,
        miesiac_od IN NUMBER,
        rok_do IN NUMBER,
        miesiac_do IN NUMBER
    );
    PROCEDURE srednie_ceny_gatunkow(
        rok_od IN NUMBER,
        miesiac_od IN NUMBER,
        rok_do IN NUMBER,
        miesiac_do IN NUMBER
    );
    PROCEDURE srednie_ceny_gier(
        rok_od IN NUMBER,
        miesiac_od IN NUMBER,
        rok_do IN NUMBER,
        miesiac_do IN NUMBER
    );
END Statystyki;
/

CREATE OR REPLACE PACKAGE BODY Statystyki AS
    PROCEDURE odswiez_tymczasowe_dane IS
    BEGIN
        DELETE FROM tymczasowe_dane_wypozyczen;

        INSERT INTO tymczasowe_dane_wypozyczen (tytul, gatunek, cena, rok_wypozyczenia, miesiac_wypozyczenia, czas_wypozyczenia)
        SELECT 
            w.gra.nazwa,
            w.gra.gatunek,
            w.cena,
            EXTRACT(YEAR FROM w.data_wypozyczenia) AS rok_wypozyczenia,
            EXTRACT(MONTH FROM w.data_wypozyczenia) AS miesiac_wypozyczenia,
            (w.data_zwrotu - w.data_wypozyczenia) / 7 AS czas_wypozyczenia
        FROM 
            Wypozyczenia w;
    
        DBMS_OUTPUT.PUT_LINE('Tabela tymczasowa zosta³a odœwie¿ona.');
    END odswiez_tymczasowe_dane;

    PROCEDURE najczesciej_wypozyczane_gry(
        rok_od IN NUMBER,
        miesiac_od IN NUMBER,
        rok_do IN NUMBER,
        miesiac_do IN NUMBER
    ) IS
    BEGIN
        odswiez_tymczasowe_dane();
        FOR rec IN (
            SELECT 
                t.tytul,
                COUNT(*) AS liczba_wypozyczen
            FROM 
                tymczasowe_dane_wypozyczen t
            WHERE 
                TO_DATE(t.rok_wypozyczenia || '-' || t.miesiac_wypozyczenia, 'YYYY-MM') 
                BETWEEN TO_DATE(rok_od || '-' || miesiac_od, 'YYYY-MM') 
                    AND TO_DATE(rok_do || '-' || miesiac_do, 'YYYY-MM')
            GROUP BY 
                t.tytul
            ORDER BY 
                liczba_wypozyczen DESC
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('Tytul: ' || rec.tytul || ', Liczba wypo¿yczeñ: ' || round(rec.liczba_wypozyczen,2));
        END LOOP;
    END najczesciej_wypozyczane_gry;

    PROCEDURE najczesciej_wypozyczane_gatunki(
        rok_od IN NUMBER,
        miesiac_od IN NUMBER,
        rok_do IN NUMBER,
        miesiac_do IN NUMBER
    ) IS
    BEGIN
        odswiez_tymczasowe_dane();
        FOR rec IN (
            SELECT 
                t.gatunek,
                COUNT(*) AS liczba_wypozyczen
            FROM 
                tymczasowe_dane_wypozyczen t
            WHERE 
                TO_DATE(t.rok_wypozyczenia || '-' || t.miesiac_wypozyczenia, 'YYYY-MM') 
                BETWEEN TO_DATE(rok_od || '-' || miesiac_od, 'YYYY-MM') 
                    AND TO_DATE(rok_do || '-' || miesiac_do, 'YYYY-MM')
            GROUP BY 
                t.gatunek
            ORDER BY 
                liczba_wypozyczen DESC
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('Gatunek: ' || rec.gatunek || ', Liczba wypo¿yczeñ: ' || round(rec.liczba_wypozyczen,2));
        END LOOP;
    END najczesciej_wypozyczane_gatunki;

    PROCEDURE sredni_czas_wypozyczenia(
        rok_od IN NUMBER,
        miesiac_od IN NUMBER,
        rok_do IN NUMBER,
        miesiac_do IN NUMBER
    ) IS
    BEGIN
        odswiez_tymczasowe_dane();
        FOR rec IN (
            SELECT 
                t.tytul,
                AVG(t.czas_wypozyczenia) AS sredni_czas
            FROM 
                tymczasowe_dane_wypozyczen t
            WHERE 
                TO_DATE(t.rok_wypozyczenia || '-' || t.miesiac_wypozyczenia, 'YYYY-MM') 
                BETWEEN TO_DATE(rok_od || '-' || miesiac_od, 'YYYY-MM') 
                    AND TO_DATE(rok_do || '-' || miesiac_do, 'YYYY-MM')
            GROUP BY 
                t.tytul
            ORDER BY 
                sredni_czas DESC
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('Tytul: ' || rec.tytul || ', Œredni czas: ' || round(rec.sredni_czas,2) || ' tygodnie');
        END LOOP;
    END sredni_czas_wypozyczenia;

    PROCEDURE srednie_ceny_gatunkow(
        rok_od IN NUMBER,
        miesiac_od IN NUMBER,
        rok_do IN NUMBER,
        miesiac_do IN NUMBER
    ) IS
    BEGIN
        odswiez_tymczasowe_dane();
        FOR rec IN (
            SELECT 
                t.gatunek,
                AVG(t.cena) AS srednia_cena
            FROM 
                tymczasowe_dane_wypozyczen t
            WHERE 
                TO_DATE(t.rok_wypozyczenia || '-' || t.miesiac_wypozyczenia, 'YYYY-MM') 
                BETWEEN TO_DATE(rok_od || '-' || miesiac_od, 'YYYY-MM') 
                    AND TO_DATE(rok_do || '-' || miesiac_do, 'YYYY-MM')
            GROUP BY 
                t.gatunek
            ORDER BY 
                srednia_cena DESC
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('Gatunek: ' || rec.gatunek || ', Œrednia cena: ' || round(rec.srednia_cena,2));
        END LOOP;
    END srednie_ceny_gatunkow;

    PROCEDURE srednie_ceny_gier(
        rok_od IN NUMBER,
        miesiac_od IN NUMBER,
        rok_do IN NUMBER,
        miesiac_do IN NUMBER
    ) IS
    BEGIN
        odswiez_tymczasowe_dane();
        FOR rec IN (
            SELECT 
                t.tytul,
                AVG(t.cena) AS srednia_cena
            FROM 
                tymczasowe_dane_wypozyczen t
            WHERE 
                TO_DATE(t.rok_wypozyczenia || '-' || t.miesiac_wypozyczenia, 'YYYY-MM') 
                BETWEEN TO_DATE(rok_od || '-' || miesiac_od, 'YYYY-MM') 
                    AND TO_DATE(rok_do || '-' || miesiac_do, 'YYYY-MM')
            GROUP BY 
                t.tytul
            ORDER BY 
                srednia_cena DESC
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('Tytul: ' || rec.tytul || ', Œrednia cena: ' || round(rec.srednia_cena,2));
        END LOOP;
    END srednie_ceny_gier;
END Statystyki;
/

CREATE OR REPLACE PACKAGE ROZGRYWKA_WIELOOSOBOWA AS
    PROCEDURE moj_profil(
        p_id_gry IN NUMBER,
        p_nickname IN NVARCHAR2,
        p_decision IN NVARCHAR2 DEFAULT 'DENY'
    );

    PROCEDURE dodaj_rozgrywke(
        p_id_gry IN NUMBER,
        p_gracze_home IN GraczeVarray,
        p_gracze_away IN GraczeVarray,
        p_postacie_home IN PostacieVarray,
        p_postacie_away IN PostacieVarray,
        p_wynik_home IN NUMBER,
        p_wynik_away IN NUMBER,
        p_liczba_rund IN NUMBER,
        p_id_mapy IN NUMBER,
        p_typ_rozgrywki IN CHAR
    );

    PROCEDURE wyszukaj_graczy_poziom_MMR(
        p_id_gry IN NUMBER,
        p_nickname IN NVARCHAR2,
        p_tolerancja IN NUMBER DEFAULT 150
    );
END ROZGRYWKA_WIELOOSOBOWA;
/

CREATE OR REPLACE PACKAGE BODY ROZGRYWKA_WIELOOSOBOWA AS
    PROCEDURE moj_profil(
        p_id_gry IN NUMBER,
        p_nickname IN NVARCHAR2,
        p_decision IN NVARCHAR2 DEFAULT 'DENY'
    ) IS
        v_id_klienta NUMBER;
        v_pozycja    NUMBER;
        v_mmr        NUMBER;
        v_liczba_godzin NUMBER;
        v_game_exists NUMBER;
    BEGIN
        BEGIN
            SELECT 1 INTO v_game_exists FROM Gra WHERE id_gry = p_id_gry;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20005, 'Podana gra nie istnieje.');
        END;
    
        SELECT id_klienta, FLOOR(poziom), MMR, liczba_godzin
        INTO v_id_klienta, v_pozycja, v_mmr, v_liczba_godzin
        FROM Profil_Gracza
        WHERE nickname = p_nickname and id_gry_gracz = p_id_gry;

        DBMS_OUTPUT.PUT_LINE('Profil gracza: ' || p_nickname);
        DBMS_OUTPUT.PUT_LINE('Poziom: ' || v_pozycja);
        DBMS_OUTPUT.PUT_LINE('MMR: ' || v_mmr);
        DBMS_OUTPUT.PUT_LINE('Liczba godzin: ' || v_liczba_godzin);

        IF UPPER(p_decision) = 'OK' THEN
            DBMS_OUTPUT.PUT_LINE('Historia ostatnich 10 gier:');

            FOR r IN (
                SELECT hr.id_rozgrywki,
                       hr.wynik_home || ' : ' || hr.wynik_away AS wynik,
                       (
                           SELECT LISTAGG(g.COLUMN_VALUE, ', ') WITHIN GROUP (ORDER BY ROWNUM)
                           FROM TABLE(hr.gracze_home) g
                       ) AS gracze_home,
                       (
                           SELECT LISTAGG(g.COLUMN_VALUE, ', ') WITHIN GROUP (ORDER BY ROWNUM)
                           FROM TABLE(hr.gracze_away) g
                       ) AS gracze_away,
                       (
                           SELECT LISTAGG(p.COLUMN_VALUE, ', ') WITHIN GROUP (ORDER BY ROWNUM)
                           FROM TABLE(hr.postacie_home) p
                       ) AS postacie_home,
                       (
                           SELECT LISTAGG(p.COLUMN_VALUE, ', ') WITHIN GROUP (ORDER BY ROWNUM)
                           FROM TABLE(hr.postacie_away) p
                       ) AS postacie_away,
                       hr.typ AS typ,
                       DEREF(hr.mapa).nazwa AS mapa
                FROM HISTORIA_ROZGRYWEK hr
                WHERE hr.id_gry_rozgrywka = p_id_gry AND (
                    EXISTS (
                        SELECT 1
                        FROM TABLE(hr.gracze_home) g
                        WHERE g.COLUMN_VALUE = p_nickname
                    )
                       OR EXISTS (
                        SELECT 1
                        FROM TABLE(hr.gracze_away) g
                        WHERE g.COLUMN_VALUE = p_nickname
                    )
                )
                ORDER BY hr.id_rozgrywki DESC
                FETCH FIRST 10 ROWS ONLY
            ) LOOP
                DBMS_OUTPUT.PUT_LINE('ID Rozgrywki: ' || r.id_rozgrywki);
                DBMS_OUTPUT.PUT_LINE('Wynik: ' || r.wynik);
                DBMS_OUTPUT.PUT_LINE('Gospodarze: ' || r.gracze_home);
                DBMS_OUTPUT.PUT_LINE('Goœcie: ' || r.gracze_away);
                DBMS_OUTPUT.PUT_LINE('Postacie Gospodarze: ' || r.postacie_home);
                DBMS_OUTPUT.PUT_LINE('Postacie Goœcie: ' || r.postacie_away);
                DBMS_OUTPUT.PUT_LINE('Typ gry: ' || r.typ);
                DBMS_OUTPUT.PUT_LINE('Mapa: ' || r.mapa);
                DBMS_OUTPUT.PUT_LINE('---');
            END LOOP;
        ELSE
            DBMS_OUTPUT.PUT_LINE('Historia gier nie zosta³a wyœwietlona.');
        END IF;
    END moj_profil;

    PROCEDURE dodaj_rozgrywke(
        p_id_gry IN NUMBER,
        p_gracze_home IN GraczeVarray,
        p_gracze_away IN GraczeVarray,
        p_postacie_home IN PostacieVarray,
        p_postacie_away IN PostacieVarray,
        p_wynik_home IN NUMBER,
        p_wynik_away IN NUMBER,
        p_liczba_rund IN NUMBER,
        p_id_mapy IN NUMBER,
        p_typ_rozgrywki IN CHAR
    ) IS
        v_new_id NUMBER;
        v_dostepnosc_mapy_rankingowy CHAR(1);
        v_dostepnosc_mapy_nierankingowy CHAR(1);
        v_poziom_gracza NUMBER;
        v_poziom_odblokowania NUMBER;
        v_map_exists NUMBER;
        v_game_exists NUMBER;
        v_map_ref REF MapaType;
        v_min_mmr NUMBER := NULL;
        v_max_mmr NUMBER := NULL;
        v_mmr NUMBER;
    BEGIN
        BEGIN
            SELECT 1 INTO v_game_exists FROM Gra WHERE id_gry = p_id_gry;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20005, 'Podana gra nie istnieje.');
        END;
        
        -- Walidacja liczby graczy w dru¿ynach
        IF p_gracze_home.COUNT <> 5 OR p_gracze_away.COUNT <> 5 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Ka¿da dru¿yna musi mieæ po piêciu graczy.');
        END IF;
    
        -- Walidacja liczby postaci w dru¿ynach
        IF p_postacie_home.COUNT <> 5 OR p_postacie_away.COUNT <> 5 THEN
            RAISE_APPLICATION_ERROR(-20002, 'Ka¿da dru¿yna musi mieæ po piêæ postaci.');
        END IF;
    
        -- Walidacja istnienia mapy
        BEGIN
            SELECT 1 INTO v_map_exists FROM Mapa WHERE id_mapy = p_id_mapy;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20005, 'Podana mapa nie istnieje.');
        END;
    
        -- Sprawdzenie dostêpnoœci mapy w trybie rankingowym i nierankingowym
        SELECT dostepna_w_rankingowym, dostepna_w_nierankingowym
        INTO v_dostepnosc_mapy_rankingowy, v_dostepnosc_mapy_nierankingowy
        FROM Mapa
        WHERE id_mapy = p_id_mapy;
    
        IF p_typ_rozgrywki = 'r' THEN
            IF v_dostepnosc_mapy_rankingowy = '0' THEN
                RAISE_APPLICATION_ERROR(-20006, 'Podana mapa nie jest dostêpna w trybie rankingowym.');
            END IF;
        ELSIF p_typ_rozgrywki = 'n' THEN
            IF v_dostepnosc_mapy_nierankingowy = '0' THEN
                RAISE_APPLICATION_ERROR(-20007, 'Podana mapa nie jest dostêpna w trybie nierankingowym.');
            END IF;
        ELSE
            RAISE_APPLICATION_ERROR(-20008, 'Nieznany typ gry: ' || p_typ_rozgrywki);
        END IF;
    
        -- Sprawdzenie MMR graczy w dru¿ynach
        FOR i IN 1..p_gracze_home.COUNT LOOP
            SELECT MMR INTO v_mmr FROM Profil_Gracza WHERE nickname = p_gracze_home(i) AND id_gry_gracz = p_id_gry;
            -- Aktualizacja minimalnego i maksymalnego MMR
            IF v_min_mmr IS NULL OR v_mmr < v_min_mmr THEN
                v_min_mmr := v_mmr;
            END IF;
            IF v_max_mmr IS NULL OR v_mmr > v_max_mmr THEN
                v_max_mmr := v_mmr;
            END IF;
        END LOOP;
    
        FOR i IN 1..p_gracze_away.COUNT LOOP
            SELECT MMR INTO v_mmr FROM Profil_Gracza WHERE nickname = p_gracze_away(i) AND id_gry_gracz = p_id_gry;
            -- Aktualizacja minimalnego i maksymalnego MMR
            IF v_min_mmr IS NULL OR v_mmr < v_min_mmr THEN
                v_min_mmr := v_mmr;
            END IF;
            IF v_max_mmr IS NULL OR v_mmr > v_max_mmr THEN
                v_max_mmr := v_mmr;
            END IF;
        END LOOP;
    
        -- Sprawdzenie, czy ró¿nica MMR nie przekracza 150
        IF v_max_mmr - v_min_mmr > 150 THEN
            RAISE_APPLICATION_ERROR(-20010, 'Ró¿nica MMR miêdzy graczami jest zbyt du¿a.');
        END IF;
    
        -- Sprawdzanie, czy gracz mo¿e graæ wybran¹ postaci¹
        FOR i IN 1..p_gracze_home.COUNT LOOP
            SELECT poziom INTO v_poziom_gracza FROM Profil_Gracza WHERE nickname = p_gracze_home(i) AND id_gry_gracz = p_id_gry;
            SELECT poziom_odblokowania INTO v_poziom_odblokowania FROM Postac WHERE nazwa = p_postacie_home(i);
            IF v_poziom_gracza < v_poziom_odblokowania THEN
                RAISE_APPLICATION_ERROR(-20009, 'Gracz ' || p_gracze_home(i) || ' nie ma wystarczaj¹cego poziomu do gry t¹ postaci¹: ' || p_postacie_home(i));
            END IF;
        END LOOP;
    
        FOR i IN 1..p_gracze_away.COUNT LOOP
            SELECT poziom INTO v_poziom_gracza FROM Profil_Gracza WHERE nickname = p_gracze_away(i) AND id_gry_gracz = p_id_gry;
            SELECT poziom_odblokowania INTO v_poziom_odblokowania FROM Postac WHERE nazwa = p_postacie_away(i);
            IF v_poziom_gracza < v_poziom_odblokowania THEN
                RAISE_APPLICATION_ERROR(-20009, 'Gracz ' || p_gracze_away(i) || ' nie ma wystarczaj¹cego poziomu do gry t¹ postaci¹: ' || p_postacie_away(i));
            END IF;
        END LOOP;
    
        -- Generowanie nowego ID dla rozgrywki
        SELECT NVL(MAX(id_rozgrywki), 0) + 1 INTO v_new_id FROM HISTORIA_ROZGRYWEK;
    
        -- Pobranie referencji do mapy
        SELECT REF(m) INTO v_map_ref FROM Mapa m WHERE m.id_mapy = p_id_mapy;
    
        -- Wstawienie nowej rozgrywki do tabeli
        INSERT INTO HISTORIA_ROZGRYWEK (
            id_gry_rozgrywka,
            id_rozgrywki,
            gracze_home,
            gracze_away,
            postacie_home,
            postacie_away,
            wynik_home,
            wynik_away,
            mapa,
            liczba_rozegranych_rund,
            typ
        ) VALUES (
            p_id_gry,
            v_new_id,
            p_gracze_home,
            p_gracze_away,
            p_postacie_home,
            p_postacie_away,
            p_wynik_home,
            p_wynik_away,
            v_map_ref,
            p_liczba_rund,
            p_typ_rozgrywki
        );
    
        -- Potwierdzenie dodania rozgrywki
        DBMS_OUTPUT.PUT_LINE('Rozgrywka zosta³a dodana z ID: ' || v_new_id || ', mapa ID: ' || p_id_mapy || ', typ: ' || p_typ_rozgrywki);
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20007, 'Wyst¹pi³ b³¹d podczas dodawania rozgrywki: ' || SQLERRM);
    END dodaj_rozgrywke;


    PROCEDURE wyszukaj_graczy_poziom_MMR(
        p_id_gry IN NUMBER,
        p_nickname IN NVARCHAR2,
        p_tolerancja IN NUMBER DEFAULT 150
    ) AS
        v_mmr NUMBER;
        CURSOR c_gracze IS
            SELECT nickname, MMR, poziom
            FROM Profil_Gracza
            WHERE ABS(MMR - v_mmr) <= p_tolerancja
              AND nickname != p_nickname
              AND id_gry_gracz = p_id_gry
            ORDER BY ABS(MMR - v_mmr), nickname;
        v_game_exists NUMBER;
    BEGIN
        BEGIN
            SELECT 1 INTO v_game_exists FROM Gra WHERE id_gry = p_id_gry;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20005, 'Podana gra nie istnieje.');
        END;
        
        SELECT MMR INTO v_mmr
        FROM Profil_Gracza
        WHERE nickname = p_nickname AND id_gry_gracz = p_id_gry;

        DBMS_OUTPUT.PUT_LINE('Lista graczy o zbli¿onym poziomie MMR do gracza ' || p_nickname || ':');
        FOR r_gracz IN c_gracze LOOP
            DBMS_OUTPUT.PUT_LINE('Gracz: ' || r_gracz.nickname || 
                                 ', MMR: ' || r_gracz.MMR || 
                                 ', Poziom: ' || r_gracz.poziom);
        END LOOP;
    END wyszukaj_graczy_poziom_MMR;
END ROZGRYWKA_WIELOOSOBOWA;
/


////////////
// WIDOKI //
////////////

CREATE OR REPLACE VIEW widok_dostepne_gry AS
SELECT
    g.nazwa AS tytul,
    g.producent.nazwa AS producent,
    g.wydawca.nazwa AS wydawca,
    TO_CHAR(g.data_wydania, 'DD-MM-YYYY') AS data_wydania,
    g.gatunek,
    g.czas_przejscia AS szacowanya_czas_przejscia,
    g.platforma,
    g.klasyfikacja_wiekowa AS pegi,
    round(g.cena_za_tydzien,2) AS cena,
    g.rozmiar_na_dysku AS miejsce_na_dysku
FROM
    Gra g
WHERE
    g.w_ofercie = '1'
/

CREATE OR REPLACE VIEW widok_lista_klientow AS
SELECT 
    id_klienta AS ID,
    imie AS Imie,
    nazwisko AS Nazwisko,
    email AS Email,
    nickname AS Nickname,
    data_urodzenia AS Urodzony,
    kraj AS Kraj,
    numer_telefonu AS Telefon
FROM Klient;
/

CREATE OR REPLACE VIEW widok_lista_gier AS
SELECT 
    g.id_gry AS ID,
    g.nazwa AS Tytul,
    g.gatunek AS Gatunek,
    p.nazwa AS Producent,
    w.nazwa AS Wydawca,
    g.data_wydania AS Data_Wydania,
    g.klasyfikacja_wiekowa AS PEGI,
    g.platforma AS Platforma,
    round(g.cena_za_tydzien,2) AS Cena,
    g.czas_przejscia AS Czas_Przejscia,
    g.rozmiar_na_dysku AS Rozmiar,
    g.w_ofercie AS Dostepny
FROM Gra g
LEFT JOIN Producent p ON g.producent = REF(p)
LEFT JOIN Wydawca w ON g.wydawca = REF(w);
/

CREATE OR REPLACE VIEW widok_lista_wypozyczen AS
SELECT 
    w.id_wypozyczenia AS ID,
    w.klient.nickname AS Klient,
    w.gra.id_gry AS ID_Gry,
    w.gra.nazwa AS Tytul,
    w.gra.gatunek AS Gatunek,
    w.cena AS Cena,
    round((w.cena / ((w.data_zwrotu - w.data_wypozyczenia) / 7)),2) AS Cena_na_tydzien,
    w.data_wypozyczenia AS Start_wypozyczenia,
    w.data_zwrotu AS Koniec_wypozyczenia,
    ((w.data_zwrotu - w.data_wypozyczenia) / 7) AS Czas_wypozyczenia,
    NVL((w.okres_przedluzenia / 7),0) AS Czas_przedluzenia
FROM Wypozyczenia w;
/

CREATE OR REPLACE VIEW widok_lista_producentow AS
SELECT 
    p.id_producenta AS ID,
    p.nazwa AS Nazwa,
    p.siedziba AS Siedziba,
    p.kraj_pochodzenia AS Kraj_pochodzenia,
    p.rok_zalozenia AS Rok_zalozenia,
    (EXTRACT(YEAR FROM SYSDATE) - rok_zalozenia) AS Lata_na_rynku,
    (SELECT COUNT(*) FROM Gra g WHERE g.producent.id_producenta = p.id_producenta) AS Ilosc_gier
FROM Producent p;

CREATE OR REPLACE VIEW widok_lista_wydawcow AS
SELECT 
    w.id_wydawcy AS ID,
    w.nazwa AS Nazwa,
    w.siedziba AS Siedziba,
    w.kraj_pochodzenia AS Kraj_pochodzenia,
    w.rok_zalozenia AS Rok_zalozenia,
    (EXTRACT(YEAR FROM SYSDATE) - rok_zalozenia) AS Lata_na_rynku,
    (SELECT COUNT(*) FROM Gra g WHERE g.wydawca.id_wydawcy = w.id_wydawcy) AS Ilosc_gier
FROM Wydawca w;

CREATE OR REPLACE VIEW widok_lista_dostepnych_gier AS
SELECT 
    g.nazwa AS Tytul,
    g.gatunek AS Gatunek,
    p.nazwa AS Producent,
    w.nazwa AS Wydawca,
    g.data_wydania AS Data_Wydania,
    g.klasyfikacja_wiekowa AS PEGI,
    g.platforma AS Platforma,
    round(g.cena_za_tydzien,2) AS Cena,
    g.czas_przejscia AS Czas_Przejscia,
    g.rozmiar_na_dysku AS Rozmiar
FROM Gra g
LEFT JOIN Producent p ON g.producent = REF(p)
LEFT JOIN Wydawca w ON g.wydawca = REF(w)
WHERE g.w_ofercie = '1';
/

CREATE OR REPLACE VIEW widok_lista_wypozyczen_klienta AS
SELECT 
    w.klient.nickname AS Klient,
    w.gra.nazwa AS Tytul,
    w.gra.gatunek AS Gatunek,
    round(w.cena,2) AS Cena,
    w.data_wypozyczenia AS Start_wypozyczenia,
    w.data_zwrotu AS Koniec_wypozyczenia,
    ((w.data_zwrotu - w.data_wypozyczenia) / 7) AS Czas_wypozyczenia,
    NVL((w.okres_przedluzenia / 7),0) AS Czas_przedluzenia
FROM Wypozyczenia w;
/

CREATE OR REPLACE VIEW widok_lista_gier_w_bibliotece_klienta AS
SELECT 
    w.klient.nickname AS Klient,
    w.gra.nazwa AS Tytul,
    w.gra.gatunek AS Gatunek,
    round(w.cena,2) AS Cena,
    w.data_zwrotu AS Koniec_wypozyczenia
FROM Wypozyczenia w
WHERE w.data_zwrotu >= SYSDATE;
/

CREATE OR REPLACE VIEW widok_leaderboard AS
SELECT 
    id_gry_gracz AS GRA,
    nickname AS NICKNAME,
    FLOOR(poziom) AS POZIOM,
    MMR,
    round(liczba_godzin,1) AS LICZBA_GODZIN
FROM 
    Profil_Gracza
ORDER BY 
    1 ASC, 4 DESC;
/

CREATE OR REPLACE VIEW widok_dostepni_gracze AS
SELECT 
    pg.id_gry_gracz AS GRA,
    pg.nickname AS nickname,
    FLOOR(pg.poziom) AS poziom,
    pg.MMR AS mmr,
    round(pg.liczba_godzin,1) AS liczba_godzin
FROM 
    Profil_Gracza pg
JOIN 
    Wypozyczenia w ON pg.id_klienta = w.klient.id_klienta
JOIN 
    Gra g ON w.gra.id_gry = g.id_gry
WHERE 
    g.id_gry in (24, 1)
    AND w.data_zwrotu > sysdate
GROUP BY
    pg.id_gry_gracz,
    pg.nickname,
    FLOOR(pg.poziom),
    pg.MMR,
    ROUND(pg.liczba_godzin, 1);
/

CREATE OR REPLACE VIEW widok_tierlist AS
SELECT 
    tp.nazwa AS NAZWA_POSTACI,
    round(tp.winrate,2) AS WINRATE,
    round(tp.pickrate,2) AS PICKRATE,
    tp.liczba_gier AS LICZBA_GIER
FROM 
    Tierlista_Postaci tp;
/

CREATE OR REPLACE VIEW widok_tierlista_map AS
SELECT 
    m.nazwa AS NAZWA,
    
    CASE 
        WHEN COUNT(CASE WHEN h.typ = 'r' AND h.wynik_home > h.wynik_away THEN 1 END) = 0 THEN 0
        ELSE 
            round(((COUNT(CASE WHEN h.typ = 'r' AND h.wynik_home > h.wynik_away THEN 1 END) * 100.0) /
            COUNT(CASE WHEN h.typ = 'r' THEN 1 END)),2)
    END AS WINRATE_ATK_RANKINGOWE,
    
    CASE 
        WHEN COUNT(CASE WHEN h.typ = 'r' AND h.wynik_away > h.wynik_home THEN 1 END) = 0 THEN 0
        ELSE 
            round(((COUNT(CASE WHEN h.typ = 'r' AND h.wynik_away > h.wynik_home THEN 1 END) * 100.0) /
            COUNT(CASE WHEN h.typ = 'r' THEN 1 END)),2)
    END AS WINRATE_OBR_RANKINGOWE,
    
    CASE 
        WHEN (SELECT COUNT(*) FROM Historia_Rozgrywek WHERE typ = 'r') = 0 THEN 0
        ELSE 
            round(((COUNT(CASE WHEN h.typ = 'r' THEN 1 END) * 100.0) /
            (SELECT COUNT(*) FROM Historia_Rozgrywek WHERE typ = 'r')),2)
    END AS PICKRATE_RANKINGOWE,
    
    CASE 
        WHEN (SELECT COUNT(*) FROM Historia_Rozgrywek WHERE typ = 'n') = 0 THEN 0
        ELSE 
            round(((COUNT(CASE WHEN h.typ = 'n' THEN 1 END) * 100.0) /
            (SELECT COUNT(*) FROM Historia_Rozgrywek WHERE typ = 'n')),2)
    END AS PICKRATE_NIERANKINGOWE
    
FROM 
    Historia_Rozgrywek h
    INNER JOIN Mapa m ON DEREF(h.mapa).id_mapy = m.id_mapy

GROUP BY 
    m.nazwa

ORDER BY 2 DESC, 3 DESC;
/

///////////////////////
// WSTAWIANIE DANYCH //
///////////////////////

BEGIN
    INSERT INTO Producent VALUES (ProducentType(1, 'CD Projekt', 'Warszawa', 'Polska', 1994));
    INSERT INTO Producent VALUES (ProducentType(2, 'Ubisoft', 'Montreal', 'Kanada', 1986));
    INSERT INTO Producent VALUES (ProducentType(3, 'Rockstar Games', 'Nowy Jork', 'USA', 1998));
    INSERT INTO Producent VALUES (ProducentType(4, 'Valve', 'Bellevue', 'USA', 1996));
    INSERT INTO Producent VALUES (ProducentType(5, 'Electronic Arts', 'Redwood City', 'USA', 1982));
    INSERT INTO Producent VALUES (ProducentType(6, 'Capcom', 'Osaka', 'Japonia', 1979));
    INSERT INTO Producent VALUES (ProducentType(7, 'Square Enix', 'Tokio', 'Japonia', 1986));
    INSERT INTO Producent VALUES (ProducentType(8, 'Bandai Namco', 'Tokio', 'Japonia', 2005));
    INSERT INTO Producent VALUES (ProducentType(9, 'Sony', 'Tokio', 'Japonia', 1946));
    INSERT INTO Producent VALUES (ProducentType(10, 'Activision', 'Santa Monica', 'USA', 1979));
    INSERT INTO Producent VALUES (ProducentType(11, 'Konami', 'Tokio', 'Japonia', 1969));
    INSERT INTO Producent VALUES (ProducentType(12, 'Blizzard Entertainment', 'Irvine', 'USA', 1991));
    INSERT INTO Producent VALUES (ProducentType(13, 'SEGA', 'Tokio', 'Japonia', 1940));
    INSERT INTO Producent VALUES (ProducentType(14, 'Bethesda', 'Rockville', 'USA', 1986));
    INSERT INTO Producent VALUES (ProducentType(15, 'Naughty Dog', 'Santa Monica', 'USA', 1984));
    INSERT INTO Producent VALUES (ProducentType(16, 'Larian Studios', 'Oudenaarde', 'Belgia', 1996));
    INSERT INTO Producent VALUES (ProducentType(17, 'Riot Games', 'Los Angeles', 'USA', 2006));
END;
/

BEGIN
    INSERT INTO Wydawca VALUES (WydawcaType(1, 'CD Projekt Red', 'Warszawa', 'Polska', 2002));
    INSERT INTO Wydawca VALUES (WydawcaType(2, 'Ubisoft Entertainment', 'Montreal', 'Kanada', 1986));
    INSERT INTO Wydawca VALUES (WydawcaType(3, 'Take-Two Interactive', 'Nowy Jork', 'USA', 1993));
    INSERT INTO Wydawca VALUES (WydawcaType(4, 'Valve Corporation', 'Bellevue', 'USA', 1996));
    INSERT INTO Wydawca VALUES (WydawcaType(5, 'EA Games', 'Redwood City', 'USA', 1982));
    INSERT INTO Wydawca VALUES (WydawcaType(6, 'Capcom Publishing', 'Osaka', 'Japonia', 1979));
    INSERT INTO Wydawca VALUES (WydawcaType(7, 'Square Enix Holdings', 'Tokio', 'Japonia', 1986));
    INSERT INTO Wydawca VALUES (WydawcaType(8, 'Bandai Namco Entertainment', 'Tokio', 'Japonia', 2005));
    INSERT INTO Wydawca VALUES (WydawcaType(9, 'Sony Interactive Entertainment', 'Tokio', 'Japonia', 1993));
    INSERT INTO Wydawca VALUES (WydawcaType(10, 'Activision Blizzard', 'Santa Monica', 'USA', 2008));
    INSERT INTO Wydawca VALUES (WydawcaType(11, 'Konami Digital Entertainment', 'Tokio', 'Japonia', 1969));
    INSERT INTO Wydawca VALUES (WydawcaType(12, 'Blizzard Publishing', 'Irvine', 'USA', 1991));
    INSERT INTO Wydawca VALUES (WydawcaType(13, 'SEGA Publishing', 'Tokio', 'Japonia', 1940));
    INSERT INTO Wydawca VALUES (WydawcaType(14, 'Bethesda Softworks', 'Rockville', 'USA', 1986));
    INSERT INTO Wydawca VALUES (WydawcaType(15, 'Sony Publishing', 'Santa Monica', 'USA', 1984));
    INSERT INTO Wydawca VALUES (WydawcaType(16, 'Larian Studios', 'Oudenaarde', 'Belgia', 1996));
    INSERT INTO Wydawca VALUES (WydawcaType(17, 'Riot Games', 'Los Angeles', 'USA', 2006));
END;
/

BEGIN
    BIBLIOTEKA_GIER.DODAJ_NOWA_GRE('WiedŸmin 3', 'CD Projekt', 'CD Projekt Red', to_date('2015-05-19','yyyy-MM-dd'), 'RPG', 14.99, 50, 'PC', 40, 18);
    BIBLIOTEKA_GIER.DODAJ_NOWA_GRE('World of Warcraft', 'Blizzard Entertainment', 'Blizzard Publishing', TO_DATE('2004-11-23', 'YYYY-MM-DD'), 'MMORPG', 9.99, NULL, 'PC', NULL, 12);
    BIBLIOTEKA_GIER.DODAJ_NOWA_GRE('Skyrim', 'Bethesda', 'Bethesda Softworks', TO_DATE('2011-11-11', 'YYYY-MM-DD'), 'RPG', 14.99, 100, 'PC', 50, 16);
    BIBLIOTEKA_GIER.DODAJ_NOWA_GRE('Uncharted 4', 'Naughty Dog', 'Sony Publishing', TO_DATE('2016-05-10', 'YYYY-MM-DD'), 'Action', 19.99, 20, 'PS4', 50, 16);
    BIBLIOTEKA_GIER.DODAJ_NOWA_GRE('WiedŸmin 2', 'CD Projekt', 'CD Projekt Red', TO_DATE('2007-10-26', 'YYYY-MM-DD'), 'RPG', 4.99, 25, 'PC', 20, 18);
    BIBLIOTEKA_GIER.DODAJ_NOWA_GRE('WiedŸmin 1', 'CD Projekt', 'CD Projekt Red', TO_DATE('2015-05-19', 'YYYY-MM-DD'), 'RPG', 3.99, NULL, 'PC', NULL, 18);
    BIBLIOTEKA_GIER.DODAJ_NOWA_GRE('Cyberpunk 2077', 'CD Projekt', 'CD Projekt Red', TO_DATE('2020-12-10', 'YYYY-MM-DD'), 'RPG', 24.99, 25, 'PS5', 80, 18);
    BIBLIOTEKA_GIER.DODAJ_NOWA_GRE('God of War 3', 'Sony', 'Sony Interactive Entertainment', TO_DATE('2010-03-16', 'YYYY-MM-DD'), 'Action', 7.99, 10, 'PS3', NULL, 18);
    BIBLIOTEKA_GIER.DODAJ_NOWA_GRE('Watch Dogs 2', 'Ubisoft', 'Ubisoft Entertainment', TO_DATE('2016-11-15', 'YYYY-MM-DD'), 'Action', 5.99, 20, 'PS4', 40, 18);
    BIBLIOTEKA_GIER.DODAJ_NOWA_GRE('The Crew 2', 'Ubisoft', 'Ubisoft Entertainment', TO_DATE('2018-06-29', 'YYYY-MM-DD'), 'Racing', 9.99, 20, 'PS4', NULL, 12);
    BIBLIOTEKA_GIER.DODAJ_NOWA_GRE('Fifa 22', 'Electronic Arts', 'EA Games', TO_DATE('2021-10-01', 'YYYY-MM-DD'), 'Sports', 15.99, 97, 'PS5', 60, 3);
    BIBLIOTEKA_GIER.DODAJ_NOWA_GRE('Half Life: Alyx', 'Valve', 'Valve Corporation', TO_DATE('2020-03-20', 'YYYY-MM-DD'), 'Action', 29.99, 12, 'PS4', NULL, 16);
    BIBLIOTEKA_GIER.DODAJ_NOWA_GRE('Need For Speed: Hot Pursuit', 'Electronic Arts', 'EA Games', TO_DATE('2010-11-16', 'YYYY-MM-DD'), 'Racing', 5.99, 15, 'PS3', NULL, 7);
    BIBLIOTEKA_GIER.DODAJ_NOWA_GRE('Left 4 Dead 2', 'Valve', 'Valve Corporation', TO_DATE('2009-11-17', 'YYYY-MM-DD'), 'FPS', 5.99, 10, 'PC', NULL, 18);
    BIBLIOTEKA_GIER.DODAJ_NOWA_GRE('Battlefield 4', 'Electronic Arts', 'EA Games', TO_DATE('2013-10-31', 'YYYY-MM-DD'), 'FPS', 19.99, 5, 'PC', 30, 18);
    BIBLIOTEKA_GIER.DODAJ_NOWA_GRE('The Last of Us Part II', 'Sony', 'Sony Interactive Entertainment', TO_DATE('2020-06-19', 'YYYY-MM-DD'), 'Action', 19.99, 25, 'PS4', 60, 18);
    BIBLIOTEKA_GIER.DODAJ_NOWA_GRE('Tekken 7', 'Bandai Namco', 'Bandai Namco Entertainment', to_date('2015-05-19','yyyy-MM-dd'), 'RPG', 14.99, 50, 'PC', 40, 18);
    BIBLIOTEKA_GIER.DODAJ_NOWA_GRE('Final Fantasy XV', 'Square Enix', 'Square Enix Holdings', TO_DATE('2017-06-02', 'YYYY-MM-DD'), 'Fighting', 4.99, 30, 'PC', 40, 12);
    BIBLIOTEKA_GIER.DODAJ_NOWA_GRE('Resident Evil 4', 'Capcom', 'Capcom Publishing', to_date('2015-05-19','yyyy-MM-dd'), 'RPG', 14.99, 50, 'PC', 40, 18);
    BIBLIOTEKA_GIER.DODAJ_NOWA_GRE('FIFA 21', 'Electronic Arts', 'EA Games', TO_DATE('2005-01-11', 'YYYY-MM-DD'), 'Horror', 9.99, 20, 'PC', 15, 18);
    BIBLIOTEKA_GIER.DODAJ_NOWA_GRE('Half-Life 2', 'Valve', 'Valve Corporation', to_date('2015-05-19','yyyy-MM-dd'), 'RPG', 14.99, 50, 'PC', 40, 18);
    BIBLIOTEKA_GIER.DODAJ_NOWA_GRE('GTA V', 'Rockstar Games', 'Take-Two Interactive', TO_DATE('2004-11-16', 'YYYY-MM-DD'), 'FPS', 3.99, 15, 'PC', 20, 16);
    BIBLIOTEKA_GIER.DODAJ_NOWA_GRE('Assassin’s Creed', 'Ubisoft', 'Ubisoft Entertainment', TO_DATE('2007-11-13', 'YYYY-MM-DD'), 'Action', 2.99, 30, 'PS3', 20, 16);
    BIBLIOTEKA_GIER.DODAJ_NOWA_GRE('Valorant', 'Riot Games', 'Riot Games', TO_DATE('2020-06-2', 'YYYY-MM-DD'), 'FPS', 4.99, NULL, 'PC', NULL, 16);
END;
/

BEGIN
    INSERT INTO Klient VALUES (KlientType(1, 'Jan', 'Kowalski', 'janko123', 'jan.kowalski@example.com', TO_DATE('1990-05-15', 'YYYY-MM-DD'), NULL, 'Polska', '123456789', WypozyczeniaRefList()));
    INSERT INTO Klient VALUES (KlientType(2, 'Anna', 'Nowak', 'annnowak', 'anna.nowak@example.com', TO_DATE('1985-08-22', 'YYYY-MM-DD'), NULL, 'Polska', '987654321', WypozyczeniaRefList()));
    INSERT INTO Klient VALUES (KlientType(3, 'Piotr', 'Zieliñski', 'piotrekz', 'piotr.zielinski@example.com', TO_DATE('1995-03-10', 'YYYY-MM-DD'), NULL, 'Polska', NULL, WypozyczeniaRefList()));
    INSERT INTO Klient VALUES (KlientType(4, 'Krzysztof', 'Mazur', 'kris_maz', 'kris@example.com', TO_DATE('1992-04-17', 'YYYY-MM-DD'), NULL, 'Polska', '888111222', WypozyczeniaRefList()));
    INSERT INTO Klient VALUES (KlientType(5, 'Marta', 'Lewandowska', 'martal', 'marta.lewa@example.com', TO_DATE('1988-11-30', 'YYYY-MM-DD'), NULL, 'Polska', '889222333', WypozyczeniaRefList()));
    INSERT INTO Klient VALUES (KlientType(6, 'Andrzej', 'Kowal', 'andrzejk', 'andrzej@example.com', TO_DATE('1981-07-25', 'YYYY-MM-DD'), NULL, 'Polska', NULL, WypozyczeniaRefList()));
    INSERT INTO Klient VALUES (KlientType(7, 'Justyna', 'Kwiatkowska', 'justkwiat', 'justyna@example.com', TO_DATE('1999-01-15', 'YYYY-MM-DD'), NULL, 'Polska', '881123456', WypozyczeniaRefList()));
    INSERT INTO Klient VALUES (KlientType(8, '£ukasz', 'Jankowski', 'lukaszz', 'lukasz.jankowski@example.com', TO_DATE('1993-09-10', 'YYYY-MM-DD'), NULL, 'Polska', '123987654', WypozyczeniaRefList()));
    INSERT INTO Klient VALUES (KlientType(9, 'Micha³', 'Szymañski', 'michals', 'michal.szymanski@example.com', TO_DATE('1994-02-19', 'YYYY-MM-DD'), NULL, 'Polska', '765432109', WypozyczeniaRefList()));
    INSERT INTO Klient VALUES (KlientType(10, 'Karolina', 'Wójcik', 'karolaw', 'karolina.wojcik@example.com', TO_DATE('1989-11-05', 'YYYY-MM-DD'), NULL, 'Polska', '431234567', WypozyczeniaRefList()));
    INSERT INTO Klient VALUES (KlientType(11, 'Jakub', 'Kamiñski', 'jakubk', 'jakub.kaminski@example.com', TO_DATE('1996-03-22', 'YYYY-MM-DD'), NULL, 'Polska', '550001234', WypozyczeniaRefList()));
    INSERT INTO Klient VALUES (KlientType(12, 'Dorota', 'Zawisza', 'dorotaz', 'dorota.zawisza@example.com', TO_DATE('1992-06-13', 'YYYY-MM-DD'), NULL, 'Polska', '332211445', WypozyczeniaRefList()));
    INSERT INTO Klient VALUES (KlientType(13, 'Kamil', 'Kaczmarek', 'kamill', 'kamil.kaczmarek@example.com', TO_DATE('1987-04-07', 'YYYY-MM-DD'), NULL, 'Polska', '990088776', WypozyczeniaRefList()));
    INSERT INTO Klient VALUES (KlientType(14, 'Zofia', 'Piotrowska', 'zofiap', 'zofia.piotrowska@example.com', TO_DATE('1991-12-25', 'YYYY-MM-DD'), NULL, 'Polska', '455667788', WypozyczeniaRefList()));
    INSERT INTO Klient VALUES (KlientType(15, 'Tomasz', 'Nowicki', 'tomeknow', 'tomasz.nowicki@example.com', TO_DATE('1984-05-01', 'YYYY-MM-DD'), NULL, 'Polska', '667788990', WypozyczeniaRefList()));
    INSERT INTO Klient VALUES (KlientType(16, 'Ewa', 'Kaczmarczyk', 'ewakacz', 'ewa.kaczmarczyk@example.com', TO_DATE('1998-02-03', 'YYYY-MM-DD'), NULL, 'Polska', '321654987', WypozyczeniaRefList()));
    INSERT INTO Klient VALUES (KlientType(17, 'Adam', 'Kwiecieñ', 'adamkw', 'adam.kwiecien@example.com', TO_DATE('1990-08-16', 'YYYY-MM-DD'), NULL, 'Polska', '453213569', WypozyczeniaRefList()));
    INSERT INTO Klient VALUES (KlientType(18, 'Oliwia', 'Wojciechowska', 'oliwiaw', 'oliwia.wojciechowska@example.com', TO_DATE('1997-11-09', 'YYYY-MM-DD'), NULL, 'Polska', '215478369', WypozyczeniaRefList()));
    INSERT INTO Klient VALUES (KlientType(19, 'Szymon', 'Sikora', 'szymons', 'szymon.sikora@example.com', TO_DATE('1983-12-30', 'YYYY-MM-DD'), NULL, 'Polska', '567890123', WypozyczeniaRefList()));
    INSERT INTO Klient VALUES (KlientType(20, 'Magdalena', 'Baran', 'magdab', 'magdalena.baran@example.com', TO_DATE('1995-07-19', 'YYYY-MM-DD'), NULL, 'Polska', '762543890', WypozyczeniaRefList()));
    INSERT INTO Klient VALUES (KlientType(21, 'Bartosz', 'Chmielowski', 'bartoszc', 'bartosz.chmielowski@example.com', TO_DATE('1986-01-25', 'YYYY-MM-DD'), NULL, 'Polska', '103246589', WypozyczeniaRefList()));
    INSERT INTO Klient VALUES (KlientType(22, 'Paulina', 'Nowakowska', 'paulinan', 'paulina.nowakowska@example.com', TO_DATE('1999-04-11', 'YYYY-MM-DD'), NULL, 'Polska', '543210987', WypozyczeniaRefList()));
    INSERT INTO Klient VALUES (KlientType(23, 'Sebastian', 'Bia³ek', 'sebastianb', 'sebastian.bialek@example.com', TO_DATE('1994-01-30', 'YYYY-MM-DD'), NULL, 'Polska', '981234567', WypozyczeniaRefList()));
    INSERT INTO Klient VALUES (KlientType(24, 'Alicja', 'Skrzypczyk', 'alicjas', 'alicja.skrzypczyk@example.com', TO_DATE('1990-10-10', 'YYYY-MM-DD'), NULL, 'Polska', '661122334', WypozyczeniaRefList()));
    INSERT INTO Klient VALUES (KlientType(25, 'Marek', 'Górski', 'marekg', 'marek.gorski@example.com', TO_DATE('1982-09-18', 'YYYY-MM-DD'), NULL, 'Polska', '226754889', WypozyczeniaRefList()));
    INSERT INTO Klient VALUES (KlientType(26, 'Barbara', 'Pawlak', 'barbarap', 'barbara.pawlak@example.com', TO_DATE('1993-02-04', 'YYYY-MM-DD'), NULL, 'Polska', '399876543', WypozyczeniaRefList()));
    INSERT INTO Klient VALUES (KlientType(27, 'Dominik', 'Jakubowski', 'dominikj', 'dominik.jakubowski@example.com', TO_DATE('1989-12-15', 'YYYY-MM-DD'), NULL, 'Polska', '234567890', WypozyczeniaRefList()));
    INSERT INTO Klient VALUES (KlientType(28, 'Iwona', 'Borkowska', 'iwonab', 'iwona.borkowska@example.com', TO_DATE('1992-07-03', 'YYYY-MM-DD'), NULL, 'Polska', '775444321', WypozyczeniaRefList()));
    INSERT INTO Klient VALUES (KlientType(29, 'Wojciech', 'Kowalczyk', 'wojciechk', 'wojciech.kowalczyk@example.com', TO_DATE('1988-06-24', 'YYYY-MM-DD'), NULL, 'Polska', '115578234', WypozyczeniaRefList()));
    INSERT INTO Klient VALUES (KlientType(30, 'Sofia', 'Szewczyk', 'sofia', 'sofia.szewczyk@example.com', TO_DATE('1997-10-22', 'YYYY-MM-DD'), NULL, 'Polska', '667788123', WypozyczeniaRefList()));
END;
/

DECLARE
    klient REF KlientType;
    gra REF GraType;
BEGIN
    KLIENCI.ADD_WYPOZYCZENIE('WiedŸmin 3', 'janko123', 1); 
    KLIENCI.ADD_WYPOZYCZENIE('GTA V', 'annnowak', 2); 
    KLIENCI.ADD_WYPOZYCZENIE('FIFA 21', 'piotrekz', 1);

    SELECT REF(k) INTO klient FROM Klient k WHERE nickname = 'kris_maz';
    SELECT REF(g) INTO gra FROM Gra g WHERE nazwa = 'Resident Evil 4';
    INSERT INTO Wypozyczenia VALUES (WypozyczeniaType(4, klient, gra, 9.99, SYSDATE - 3, SYSDATE + 4, '0', NULL));
    
    SELECT REF(k) INTO klient FROM Klient k WHERE nickname = 'martal';
    SELECT REF(g) INTO gra FROM Gra g WHERE nazwa = 'Skyrim';
    INSERT INTO Wypozyczenia VALUES (WypozyczeniaType(5, klient, gra, 29.98, SYSDATE - 134, SYSDATE -120, '1', 7));
    
    SELECT REF(k) INTO klient FROM Klient k WHERE nickname = 'martal';
    SELECT REF(g) INTO gra FROM Gra g WHERE nazwa = 'Watch Dogs 2';
    INSERT INTO Wypozyczenia VALUES (WypozyczeniaType(6, klient, gra, 5.99, SYSDATE - 120, SYSDATE - 113, '0', NULL));
    
    SELECT REF(k) INTO klient FROM Klient k WHERE nickname = 'martal';
    SELECT REF(g) INTO gra FROM Gra g WHERE nazwa = 'Need For Speed: Hot Pursuit';
    INSERT INTO Wypozyczenia VALUES (WypozyczeniaType(7, klient, gra, 5.99, SYSDATE - 113, SYSDATE - 106, '0', NULL));
    
    SELECT REF(k) INTO klient FROM Klient k WHERE nickname = 'martal';
    SELECT REF(g) INTO gra FROM Gra g WHERE nazwa = 'Cyberpunk 2077';
    INSERT INTO Wypozyczenia VALUES (WypozyczeniaType(8, klient, gra, 24.99, SYSDATE - 106, SYSDATE - 99, '0', NULL));
    
    SELECT REF(k) INTO klient FROM Klient k WHERE nickname = 'martal';
    SELECT REF(g) INTO gra FROM Gra g WHERE nazwa = 'God of War 3';
    INSERT INTO Wypozyczenia VALUES (WypozyczeniaType(9, klient, gra, 7.99, SYSDATE - 99, SYSDATE - 92, '0', NULL));
    
    SELECT REF(k) INTO klient FROM Klient k WHERE nickname = 'martal';
    SELECT REF(g) INTO gra FROM Gra g WHERE nazwa = 'Battlefield 4';
    INSERT INTO Wypozyczenia VALUES (WypozyczeniaType(10, klient, gra, 19.99, SYSDATE - 92, SYSDATE - 85, '0', NULL));
    
    SELECT REF(k) INTO klient FROM Klient k WHERE nickname = 'martal';
    SELECT REF(g) INTO gra FROM Gra g WHERE nazwa = 'Half Life: Alyx';
    INSERT INTO Wypozyczenia VALUES (WypozyczeniaType(11, klient, gra, 29.99, SYSDATE - 85, SYSDATE - 78, '0', NULL));
    
    SELECT REF(k) INTO klient FROM Klient k WHERE nickname = 'martal';
    SELECT REF(g) INTO gra FROM Gra g WHERE nazwa = 'Fifa 22';
    INSERT INTO Wypozyczenia VALUES (WypozyczeniaType(12, klient, gra, 15.99, SYSDATE - 78, SYSDATE - 71, '0', NULL));
    
    SELECT REF(k) INTO klient FROM Klient k WHERE nickname = 'martal';
    SELECT REF(g) INTO gra FROM Gra g WHERE nazwa = 'Tekken 7';
    INSERT INTO Wypozyczenia VALUES (WypozyczeniaType(13, klient, gra, 4.99, SYSDATE - 71, SYSDATE - 64, '0', NULL));
    
    KLIENCI.ADD_WYPOZYCZENIE('GTA V', 'martal', 2);
    KLIENCI.ADD_WYPOZYCZENIE('WiedŸmin 3', 'martal', 1);
    KLIENCI.ADD_WYPOZYCZENIE('WiedŸmin 3', 'dorotaz', 3);
    KLIENCI.ADD_WYPOZYCZENIE('Cyberpunk 2077', 'ewakacz', 2);
    KLIENCI.ADD_WYPOZYCZENIE('The Last of Us Part II', 'paulinan', 1);
    KLIENCI.ADD_WYPOZYCZENIE('Skyrim', 'dominikj', 4);
    KLIENCI.ADD_WYPOZYCZENIE('World of Warcraft', 'zofiap', 3);
    KLIENCI.ADD_WYPOZYCZENIE('Assassin’s Creed', 'bartoszc', 2);
    KLIENCI.ADD_WYPOZYCZENIE('Uncharted 4', 'andrzejk', 1);
    KLIENCI.ADD_WYPOZYCZENIE('Fifa 22', 'annnowak', 1);
    KLIENCI.ADD_WYPOZYCZENIE('Need For Speed: Hot Pursuit', 'sofia', 2);
    KLIENCI.ADD_WYPOZYCZENIE('Half-Life 2', 'alicjas', 4);
    KLIENCI.ADD_WYPOZYCZENIE('Battlefield 4', 'oliwiaw', 3);
    KLIENCI.ADD_WYPOZYCZENIE('God of War 3', 'kamill', 2);
    KLIENCI.ADD_WYPOZYCZENIE('Watch Dogs 2', 'lukaszz', 2);
    KLIENCI.ADD_WYPOZYCZENIE('The Crew 2', 'szymons', 2);
    KLIENCI.ADD_WYPOZYCZENIE('FIFA 21', 'paulinan', 4);
    KLIENCI.ADD_WYPOZYCZENIE('Final Fantasy XV', 'michals', 4);
    KLIENCI.ADD_WYPOZYCZENIE('Tekken 7', 'piotrekz', 1);
    KLIENCI.ADD_WYPOZYCZENIE('Left 4 Dead 2', 'zofiap', 2);
    KLIENCI.ADD_WYPOZYCZENIE('WiedŸmin 2', 'barbarap', 1);
    KLIENCI.ADD_WYPOZYCZENIE('Resident Evil 4', 'szymons', 1);
    KLIENCI.ADD_WYPOZYCZENIE('Skyrim', 'zofiap', 2);
    KLIENCI.ADD_WYPOZYCZENIE('GTA V', 'paulinan', 3);
    KLIENCI.ADD_WYPOZYCZENIE('World of Warcraft', 'justkwiat', 3);
    KLIENCI.ADD_WYPOZYCZENIE('Fifa 22', 'kris_maz', 2);
    KLIENCI.ADD_WYPOZYCZENIE('Uncharted 4', 'justkwiat', 1);
    KLIENCI.ADD_WYPOZYCZENIE('Cyberpunk 2077', 'janko123', 1);
    KLIENCI.ADD_WYPOZYCZENIE('WiedŸmin 3', 'janko123', 4);
    KLIENCI.ADD_WYPOZYCZENIE('Watch Dogs 2', 'kamill', 4);
    KLIENCI.ADD_WYPOZYCZENIE('Need For Speed: Hot Pursuit', 'bartoszc', 1);
    KLIENCI.ADD_WYPOZYCZENIE('Half-Life 2', 'dominikj', 2);
    KLIENCI.ADD_WYPOZYCZENIE('FIFA 21', 'wojciechk', 2);
    KLIENCI.ADD_WYPOZYCZENIE('Battlefield 4', 'sofia', 3);
    KLIENCI.ADD_WYPOZYCZENIE('Tekken 7', 'dorotaz', 3);
    KLIENCI.ADD_WYPOZYCZENIE('The Crew 2', 'piotrekz', 2);
    KLIENCI.ADD_WYPOZYCZENIE('Final Fantasy XV', 'sofia', 2);
    KLIENCI.ADD_WYPOZYCZENIE('Left 4 Dead 2', 'piotrekz', 2);
    KLIENCI.ADD_WYPOZYCZENIE('Resident Evil 4', 'sofia', 4);
    KLIENCI.ADD_WYPOZYCZENIE('GTA V', 'jakubk', 4);
    KLIENCI.ADD_WYPOZYCZENIE('Skyrim', 'zofiap', 1);
    KLIENCI.ADD_WYPOZYCZENIE('The Last of Us Part II', 'sebastianb', 1);
    KLIENCI.ADD_WYPOZYCZENIE('WiedŸmin 2', 'sebastianb', 1);
    KLIENCI.ADD_WYPOZYCZENIE('WiedŸmin 1', 'dominikj', 1);
    KLIENCI.ADD_WYPOZYCZENIE('Cyberpunk 2077', 'tomeknow', 1);
    KLIENCI.ADD_WYPOZYCZENIE('Assassin’s Creed', 'lukaszz', 2);
    KLIENCI.ADD_WYPOZYCZENIE('Fifa 22', 'marekg', 2);
    KLIENCI.ADD_WYPOZYCZENIE('Battlefield 4', 'sofia', 1);
    KLIENCI.ADD_WYPOZYCZENIE('Final Fantasy XV', 'karolaw', 2);
    KLIENCI.ADD_WYPOZYCZENIE('Watch Dogs 2', 'andrzejk', 3);
    KLIENCI.ADD_WYPOZYCZENIE('Tekken 7', 'annnowak', 3);
    KLIENCI.ADD_WYPOZYCZENIE('The Crew 2', 'karolaw', 3);
    KLIENCI.ADD_WYPOZYCZENIE('Half-Life 2', 'tomeknow', 2);
    KLIENCI.ADD_WYPOZYCZENIE('Need For Speed: Hot Pursuit', 'paulinan', 2);
    KLIENCI.ADD_WYPOZYCZENIE('WiedŸmin 3', 'iwonab', 1);
    KLIENCI.ADD_WYPOZYCZENIE('Resident Evil 4', 'annnowak', 1);
    KLIENCI.ADD_WYPOZYCZENIE('GTA V', 'magdab', 1);
    KLIENCI.ADD_WYPOZYCZENIE('World of Warcraft', 'lukaszz', 2);
    KLIENCI.ADD_WYPOZYCZENIE('Final Fantasy XV', 'dominikj', 2);
    KLIENCI.ADD_WYPOZYCZENIE('The Last of Us Part II', 'karolaw', 3);
    KLIENCI.ADD_WYPOZYCZENIE('FIFA 21', 'sofia', 3);
    KLIENCI.ADD_WYPOZYCZENIE('WiedŸmin 1', 'oliwiaw', 4);
    
    KLIENCI.ADD_WYPOZYCZENIE('Valorant', 'janko123', 1);
    KLIENCI.ADD_WYPOZYCZENIE('Valorant', 'annnowak', 2);
    KLIENCI.ADD_WYPOZYCZENIE('Valorant', 'piotrekz', 3);
    KLIENCI.ADD_WYPOZYCZENIE('Valorant', 'kris_maz', 4);
    KLIENCI.ADD_WYPOZYCZENIE('Valorant', 'martal', 5);
    KLIENCI.ADD_WYPOZYCZENIE('Valorant', 'andrzejk', 6);
    KLIENCI.ADD_WYPOZYCZENIE('Valorant', 'justkwiat', 7);
    KLIENCI.ADD_WYPOZYCZENIE('Valorant', 'lukaszz', 8);
    KLIENCI.ADD_WYPOZYCZENIE('Valorant', 'michals', 9);
    KLIENCI.ADD_WYPOZYCZENIE('Valorant', 'sofia', 10);
    KLIENCI.ADD_WYPOZYCZENIE('Valorant', 'wojciechk', 11);
    KLIENCI.ADD_WYPOZYCZENIE('Valorant', 'iwonab', 12);
    KLIENCI.ADD_WYPOZYCZENIE('Valorant', 'dominikj', 13);
    KLIENCI.ADD_WYPOZYCZENIE('Valorant', 'barbarap', 14);
    KLIENCI.ADD_WYPOZYCZENIE('Valorant', 'marekg', 15);
    KLIENCI.ADD_WYPOZYCZENIE('Valorant', 'alicjas', 16);
    KLIENCI.ADD_WYPOZYCZENIE('Valorant', 'sebastianb', 17);
    KLIENCI.ADD_WYPOZYCZENIE('Valorant', 'paulinan', 18);
    KLIENCI.ADD_WYPOZYCZENIE('Valorant', 'bartoszc', 19);
    KLIENCI.ADD_WYPOZYCZENIE('Valorant', 'magdab', 20);
END;
/

BEGIN
    INSERT INTO Mapa VALUES (24, 1, 'Ascent', '1', '1');
    INSERT INTO Mapa VALUES (24, 2, 'Bind', '1', '1');
    INSERT INTO Mapa VALUES (24, 3, 'Haven', '0', '1');
    INSERT INTO Mapa VALUES (24, 4, 'Split', '1', '1');
    INSERT INTO Mapa VALUES (24, 5, 'Icebox', '0', '1');
    INSERT INTO Mapa VALUES (24, 6, 'Breeze', '1', '1');
    INSERT INTO Mapa VALUES (24, 7, 'Fracture', '0', '1');
    INSERT INTO Mapa VALUES (24, 8, 'Pearl', '1', '1');
    INSERT INTO Mapa VALUES (24, 9, 'Lotus', '1', '1');
END;
/

BEGIN
    INSERT INTO Postac VALUES (24, 1, 'Brimstone', 1);
    INSERT INTO Postac VALUES (24, 2, 'Phoenix', 1);
    INSERT INTO Postac VALUES (24, 3, 'Sage', 1);
    INSERT INTO Postac VALUES (24, 4, 'Sova', 1);
    INSERT INTO Postac VALUES (24, 5, 'Viper', 1);
    INSERT INTO Postac VALUES (24, 6, 'Cypher', 1);
    INSERT INTO Postac VALUES (24, 7, 'Reyna', 1);
    INSERT INTO Postac VALUES (24, 8, 'Killjoy', 10);
    INSERT INTO Postac VALUES (24, 9, 'Breach', 1);
    INSERT INTO Postac VALUES (24, 10, 'Omen', 1);
    INSERT INTO Postac VALUES (24, 11, 'Jett', 1);
    INSERT INTO Postac VALUES (24, 12, 'Raze', 1);
    INSERT INTO Postac VALUES (24, 13, 'Skye', 10);
    INSERT INTO Postac VALUES (24, 14, 'Yoru', 15);
    INSERT INTO Postac VALUES (24, 15, 'Astra', 20);
    INSERT INTO Postac VALUES (24, 16, 'KAY/O', 10);
    INSERT INTO Postac VALUES (24, 17, 'Chamber', 20);
    INSERT INTO Postac VALUES (24, 18, 'Neon', 15);
    INSERT INTO Postac VALUES (24, 19, 'Fade', 15);
    INSERT INTO Postac VALUES (24, 20, 'Harbor', 20);
END;
/

BEGIN
    INSERT INTO Tierlista_Postaci VALUES (24, 1, 'Brimstone', 0, 0, 0);
    INSERT INTO Tierlista_Postaci VALUES (24, 2, 'Phoenix', 0, 0, 0);
    INSERT INTO Tierlista_Postaci VALUES (24, 3, 'Sage', 0, 0, 0);
    INSERT INTO Tierlista_Postaci VALUES (24, 4, 'Sova', 0, 0, 0);
    INSERT INTO Tierlista_Postaci VALUES (24, 5, 'Viper', 0, 0, 0);
    INSERT INTO Tierlista_Postaci VALUES (24, 6, 'Cypher', 0, 0, 0);
    INSERT INTO Tierlista_Postaci VALUES (24, 7, 'Reyna', 0, 0, 0);
    INSERT INTO Tierlista_Postaci VALUES (24, 8, 'Killjoy', 0, 0, 0);
    INSERT INTO Tierlista_Postaci VALUES (24, 9, 'Breach', 0, 0, 0);
    INSERT INTO Tierlista_Postaci VALUES (24, 10, 'Omen', 0, 0, 0);
    INSERT INTO Tierlista_Postaci VALUES (24, 11, 'Jett', 0, 0, 0);
    INSERT INTO Tierlista_Postaci VALUES (24, 12, 'Raze', 0, 0, 0);
    INSERT INTO Tierlista_Postaci VALUES (24, 13, 'Skye', 0, 0, 0);
    INSERT INTO Tierlista_Postaci VALUES (24, 14, 'Yoru', 0, 0, 0);
    INSERT INTO Tierlista_Postaci VALUES (24, 15, 'Astra', 0, 0, 0);
    INSERT INTO Tierlista_Postaci VALUES (24, 16, 'KAY/O', 0, 0, 0);
    INSERT INTO Tierlista_Postaci VALUES (24, 17, 'Chamber', 0, 0, 0);
    INSERT INTO Tierlista_Postaci VALUES (24, 18, 'Neon', 0, 0, 0);
    INSERT INTO Tierlista_Postaci VALUES (24, 19, 'Fade', 0, 0, 0);
    INSERT INTO Tierlista_Postaci VALUES (24, 20, 'Harbor', 0, 0,0);
END;
/

BEGIN
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('janko123','sofia','wojciechk','iwonab','dominikj'), GraczeVarray('barbarap','marekg','alicjas','sebastianb','paulinan'), PostacieVarray('Brimstone','Phoenix','Sage','Sova','Viper'), PostacieVarray('Cypher','Reyna','Breach','Omen','Jett'), 13, 2, 15, 1, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('annnowak','janko123','sofia','wojciechk','iwonab'), GraczeVarray('dominikj','barbarap','marekg','alicjas','sebastianb'), PostacieVarray('Jett','Brimstone','Phoenix','Sage','Sova'), PostacieVarray('Viper','Cypher','Reyna','Breach','Omen'), 11, 13, 24, 2, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('piotrekz','annnowak','janko123','sofia','wojciechk'), GraczeVarray('iwonab','dominikj','barbarap','marekg','alicjas'), PostacieVarray('Omen','Jett','Brimstone','Phoenix','Sage'), PostacieVarray('Sova','Viper','Cypher','Reyna','Breach'), 11, 13, 24, 3, 'n');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('kris_maz','piotrekz','annnowak','janko123','sofia'), GraczeVarray('wojciechk','iwonab','dominikj','barbarap','marekg'), PostacieVarray('Breach','Omen','Jett','Brimstone','Phoenix'), PostacieVarray('Sage','Sova','Viper','Cypher','Reyna'), 10, 13, 23, 4, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('martal','kris_maz','piotrekz','annnowak','janko123'), GraczeVarray('sofia','wojciechk','iwonab','dominikj','barbarap'), PostacieVarray('Reyna','Breach','Omen','Jett','Brimstone'), PostacieVarray('Phoenix','Sage','Sova','Viper','Cypher'), 9, 13, 22, 5, 'n');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('andrzejk','martal','kris_maz','piotrekz','annnowak'), GraczeVarray('janko123','sofia','wojciechk','iwonab','dominikj'), PostacieVarray('Cypher','Reyna','Breach','Omen','Jett'), PostacieVarray('Brimstone','Phoenix','Sage','Sova','Viper'), 8, 13, 21, 6, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('justkwiat','andrzejk','martal','kris_maz','piotrekz'), GraczeVarray('annnowak','janko123','sofia','wojciechk','iwonab'), PostacieVarray('Viper','Cypher','Reyna','Breach','Omen'), PostacieVarray('Jett','Brimstone','Phoenix','Sage','Sova'), 7, 13, 20, 7, 'n');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('lukaszz','justkwiat','andrzejk','martal','kris_maz'), GraczeVarray('piotrekz','annnowak','janko123','sofia','wojciechk'), PostacieVarray('Sova','Viper','Cypher','Reyna','Breach'), PostacieVarray('Omen','Jett','Brimstone','Phoenix','Sage'), 6, 13, 19, 8, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('michals','lukaszz','justkwiat','andrzejk','martal'), GraczeVarray('kris_maz','piotrekz','annnowak','janko123','sofia'), PostacieVarray('Sage','Sova','Viper','Cypher','Reyna'), PostacieVarray('Breach','Omen','Jett','Brimstone','Phoenix'), 4, 13, 17, 1, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('sofia','michals','lukaszz','justkwiat','andrzejk'), GraczeVarray('martal','kris_maz','piotrekz','annnowak','janko123'), PostacieVarray('Phoenix','Sage','Sova','Viper','Cypher'), PostacieVarray('Reyna','Breach','Omen','Jett','Brimstone'), 3, 13, 16, 2, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('michals','lukaszz','justkwiat','andrzejk','martal'), GraczeVarray('kris_maz','piotrekz','annnowak','janko123','sofia'), PostacieVarray('Sage','Sova','Viper','Cypher','Reyna'), PostacieVarray('Breach','Omen','Jett','Brimstone','Phoenix'), 2, 13, 15, 3, 'n');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('lukaszz','justkwiat','andrzejk','martal','kris_maz'), GraczeVarray('piotrekz','annnowak','janko123','sofia','wojciechk'), PostacieVarray('Sova','Viper','Cypher','Reyna','Breach'), PostacieVarray('Omen','Jett','Brimstone','Phoenix','Sage'), 1, 13, 14, 4, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('justkwiat','andrzejk','martal','kris_maz','piotrekz'), GraczeVarray('annnowak','janko123','sofia','wojciechk','iwonab'), PostacieVarray('Viper','Cypher','Reyna','Breach','Omen'), PostacieVarray('Jett','Brimstone','Phoenix','Sage','Sova'), 0, 13, 13, 5, 'n');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('andrzejk','martal','kris_maz','piotrekz','annnowak'), GraczeVarray('janko123','sofia','wojciechk','iwonab','dominikj'), PostacieVarray('Cypher','Reyna','Breach','Omen','Jett'), PostacieVarray('Brimstone','Phoenix','Sage','Sova','Viper'), 1, 13, 14, 6, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('martal','kris_maz','piotrekz','annnowak','janko123'), GraczeVarray('sofia','wojciechk','iwonab','dominikj','barbarap'), PostacieVarray('Raze','Jett','Omen','Breach','Reyna'), PostacieVarray('Brimstone','Phoenix','Sage','Sova','Viper'), 2, 13, 15, 7, 'n');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('kris_maz','piotrekz','annnowak','janko123','sofia'), GraczeVarray('wojciechk','iwonab','dominikj','barbarap','marekg'), PostacieVarray('Reyna','Raze','Jett','Omen','Breach'), PostacieVarray('Sage','Brimstone','Phoenix','Sova','Viper'), 3, 13, 16, 8, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('piotrekz','annnowak','janko123','sofia','wojciechk'), GraczeVarray('iwonab','dominikj','barbarap','marekg','alicjas'), PostacieVarray('Reyna','Breach','Raze','Jett','Omen'), PostacieVarray('Phoenix','Brimstone','Sage','Sova','Viper'), 4, 13, 17, 9, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('annnowak','janko123','sofia','wojciechk','iwonab'), GraczeVarray('dominikj','barbarap','marekg','alicjas','sebastianb'), PostacieVarray('Jett','Brimstone','Phoenix','Sage','Sova'), PostacieVarray('Viper','Cypher','Reyna','Breach','Omen'), 5, 13, 18, 1, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('janko123','sofia','wojciechk','iwonab','dominikj'), GraczeVarray('barbarap','marekg','alicjas','sebastianb','paulinan'), PostacieVarray('Breach','Omen','Jett','Brimstone','Phoenix'), PostacieVarray('Sage','Sova','Viper','Cypher','Reyna'), 6, 13, 19, 1, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('sofia','wojciechk','iwonab','dominikj','barbarap'), GraczeVarray('marekg','alicjas','sebastianb','paulinan','bartoszc'), PostacieVarray('Jett','Brimstone','Phoenix','Sage','Sova'), PostacieVarray('Viper','Cypher','Reyna','Breach','Omen'), 7, 13, 20, 1, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('wojciechk','iwonab','dominikj','barbarap','marekg'), GraczeVarray('alicjas','sebastianb','paulinan','bartoszc','magdab'), PostacieVarray('Breach','Omen','Jett','Brimstone','Phoenix'), PostacieVarray('Sage','Sova','Viper','Cypher','Reyna'), 8, 13, 21, 2, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('iwonab','dominikj','barbarap','marekg','alicjas'), GraczeVarray('sebastianb','paulinan','bartoszc','magdab','janko123'), PostacieVarray('Reyna','Breach','Omen','Jett','Brimstone'), PostacieVarray('Phoenix','Sage','Sova','Viper','Cypher'), 9, 13, 22, 2, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('dominikj','barbarap','marekg','alicjas','sebastianb'), GraczeVarray('paulinan','bartoszc','magdab','janko123','annnowak'), PostacieVarray('Sage','Sova','Viper','Cypher','Reyna'), PostacieVarray('Breach','Omen','Jett','Brimstone','Phoenix'), 10, 13, 23, 2, 'n');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('barbarap','marekg','alicjas','sebastianb','paulinan'), GraczeVarray('bartoszc','magdab','janko123','annnowak','piotrekz'), PostacieVarray('Jett','Brimstone','Phoenix','Sage','Sova'), PostacieVarray('Viper','Cypher','Reyna','Breach','Omen'), 11, 13, 24, 2, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('marekg','alicjas','sebastianb','paulinan','bartoszc'), GraczeVarray('magdab','janko123','annnowak','piotrekz','kris_maz'), PostacieVarray('Reyna','Breach','Omen','Jett','Brimstone'), PostacieVarray('Phoenix','Sage','Sova','Viper','Cypher'), 11, 13, 24, 2, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('alicjas','sebastianb','paulinan','bartoszc','magdab'), GraczeVarray('janko123','annnowak','piotrekz','kris_maz','martal'), PostacieVarray('Sova','Viper','Cypher','Reyna','Breach'), PostacieVarray('Omen','Jett','Brimstone','Phoenix','Sage'), 13, 0, 13, 4, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('janko123','magdab','bartoszc','paulinan','sebastianb'), GraczeVarray('alicjas','marekg','barbarap','wojciechk','sofia'), PostacieVarray('Jett','Brimstone','Phoenix','Sage','Sova'), PostacieVarray('Viper','Cypher','Reyna','Breach','Omen'), 14, 16, 30, 3, 'n');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('dominikj','janko123','magdab','bartoszc','paulinan'), GraczeVarray('sebastianb','alicjas','marekg','barbarap','wojciechk'), PostacieVarray('Brimstone','Phoenix','Sage','Sova','Viper'), PostacieVarray('Cypher','Reyna','Breach','Omen','Jett'), 15, 19, 34, 3, 'n');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('iwonab','dominikj','janko123','magdab','bartoszc'), GraczeVarray('paulinan','sebastianb','alicjas','marekg','barbarap'), PostacieVarray('Breach','Omen','Jett','Brimstone','Phoenix'), PostacieVarray('Sage','Sova','Viper','Cypher','Reyna'), 16, 20, 36, 3, 'n');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('iwonab','dominikj','barbarap','janko123','magdab'), GraczeVarray('bartoszc','paulinan','sebastianb','alicjas','marekg'), PostacieVarray('Reyna','Breach','Omen','Jett','Brimstone'), PostacieVarray('Phoenix','Sage','Sova','Viper','Cypher'), 17, 21, 38, 4, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('iwonab','dominikj','barbarap','marekg','janko123'), GraczeVarray('magdab','bartoszc','paulinan','sebastianb','alicjas'), PostacieVarray('Jett','Brimstone','Phoenix','Sage','Sova'), PostacieVarray('Viper','Cypher','Reyna','Breach','Omen'), 18, 22, 40, 4, 'n');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('iwonab','dominikj','barbarap','marekg','alicjas'), GraczeVarray('janko123','magdab','bartoszc','paulinan','sebastianb'), PostacieVarray('Sova','Viper','Cypher','Reyna','Breach'), PostacieVarray('Omen','Jett','Brimstone','Phoenix','Sage'), 17, 21, 38, 4, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('sofia','iwonab','dominikj','barbarap','marekg'), GraczeVarray('alicjas','janko123','magdab','bartoszc','paulinan'), PostacieVarray('Sova','Viper','Cypher','Reyna','Breach'), PostacieVarray('Omen','Jett','Brimstone','Phoenix','Sage'), 16, 20, 36, 4, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('michals','sofia','iwonab','dominikj','barbarap'), GraczeVarray('marekg','alicjas','janko123','magdab','bartoszc'), PostacieVarray('Breach','Omen','Jett','Brimstone','Phoenix'), PostacieVarray('Sage','Sova','Viper','Cypher','Reyna'), 15, 19, 34, 4, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('michals','sofia','iwonab','dominikj','barbarap'), GraczeVarray('justkwiat','marekg','alicjas','janko123','magdab'), PostacieVarray('Jett','Brimstone','Phoenix','Sage','Sova'), PostacieVarray('Viper','Cypher','Reyna','Breach','Omen'), 14, 16, 30, 4, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('michals','lukaszz','sofia','iwonab','dominikj'), GraczeVarray('justkwiat','barbarap','marekg','alicjas','janko123'), PostacieVarray('Cypher','Reyna','Breach','Omen','Jett'), PostacieVarray('Brimstone','Phoenix','Sage','Sova','Viper'), 13, 3, 16, 5, 'n');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('michals','lukaszz','sofia','iwonab','dominikj'), GraczeVarray('barbarap','marekg','alicjas','janko123','magdab'), PostacieVarray('Reyna','Breach','Omen','Jett','Brimstone'), PostacieVarray('Phoenix','Sage','Sova','Viper','Cypher'), 13, 3, 16, 5, 'n');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('michals','sofia','iwonab','dominikj','barbarap'), GraczeVarray('marekg','alicjas','janko123','magdab','bartoszc'), PostacieVarray('Brimstone','Phoenix','Sage','Sova','Viper'), PostacieVarray('Cypher','Reyna','Breach','Omen','Jett'), 13, 4, 17, 5, 'n');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('sofia','iwonab','dominikj','barbarap','marekg'), GraczeVarray('alicjas','janko123','magdab','bartoszc','paulinan'), PostacieVarray('Sova','Viper','Cypher','Reyna','Breach'), PostacieVarray('Omen','Jett','Brimstone','Phoenix','Sage'), 13, 5, 18, 5, 'n');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('sofia','dominikj','barbarap','marekg','alicjas'), GraczeVarray('janko123','magdab','bartoszc','paulinan','sebastianb'), PostacieVarray('Breach','Omen','Jett','Brimstone','Phoenix'), PostacieVarray('Sage','Sova','Viper','Cypher','Reyna'), 13, 5, 18, 5, 'n');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('kris_maz','piotrekz','annnowak','janko123','wojciechk'), GraczeVarray('iwonab','dominikj','barbarap','marekg','alicjas'), PostacieVarray('Cypher','Reyna','Breach','Omen','Jett'), PostacieVarray('Brimstone','Phoenix','Sage','Sova','Viper'), 13, 11, 24, 6, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('martal','kris_maz','piotrekz','annnowak','janko123'), GraczeVarray('wojciechk','iwonab','dominikj','barbarap','marekg'), PostacieVarray('Cypher','Reyna','Breach','Omen','Jett'), PostacieVarray('Brimstone','Phoenix','Sage','Sova','Viper'), 1, 13, 14, 6, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('andrzejk','martal','kris_maz','piotrekz','annnowak'), GraczeVarray('janko123','wojciechk','iwonab','dominikj','barbarap'), PostacieVarray('Breach','Omen','Jett','Brimstone','Phoenix'), PostacieVarray('Sage','Sova','Viper','Cypher','Reyna'), 11, 13, 24, 6, 'n');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('justkwiat','andrzejk','martal','kris_maz','piotrekz'), GraczeVarray('annnowak','janko123','wojciechk','iwonab','dominikj'), PostacieVarray('Jett','Brimstone','Phoenix','Sage','Sova'), PostacieVarray('Viper','Cypher','Reyna','Breach','Omen'), 10, 13, 23, 6, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('lukaszz','justkwiat','andrzejk','martal','kris_maz'), GraczeVarray('piotrekz','annnowak','janko123','wojciechk','iwonab'), PostacieVarray('Breach','Omen','Jett','Brimstone','Phoenix'), PostacieVarray('Sage','Sova','Viper','Cypher','Reyna'), 10, 13, 23, 6, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('sofia','michals','lukaszz','justkwiat','andrzejk'), GraczeVarray('martal','kris_maz','piotrekz','annnowak','janko123'), PostacieVarray('Jett','Brimstone','Phoenix','Sage','Sova'), PostacieVarray('Viper','Cypher','Reyna','Breach','Omen'), 10, 13, 23, 6, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('martal','kris_maz','piotrekz','annnowak','janko123'), GraczeVarray('wojciechk','iwonab','dominikj','barbarap','marekg'), PostacieVarray('Brimstone','Phoenix','Sage','Sova','Viper'), PostacieVarray('Cypher','Reyna','Breach','Omen','Jett'), 9, 13, 22, 6, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('piotrekz','annnowak','janko123','wojciechk','iwonab'), GraczeVarray('dominikj','barbarap','marekg','alicjas','sebastianb'), PostacieVarray('Breach','Omen','Jett','Brimstone','Phoenix'), PostacieVarray('Sage','Sova','Viper','Cypher','Reyna'), 9, 13, 22, 6, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('annnowak','janko123','wojciechk','iwonab','dominikj'), GraczeVarray('barbarap','marekg','alicjas','sebastianb','paulinan'), PostacieVarray('Jett','Brimstone','Phoenix','Sage','Sova'), PostacieVarray('Viper','Cypher','Reyna','Breach','Omen'), 9, 13, 22, 6, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('janko123','wojciechk','iwonab','dominikj','barbarap'), GraczeVarray('marekg','alicjas','sebastianb','paulinan','bartoszc'), PostacieVarray('Brimstone','Phoenix','Sage','Sova','Viper'), PostacieVarray('Cypher','Reyna','Breach','Omen','Jett'), 9, 13, 22, 6, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('justkwiat','lukaszz','michals','sofia','wojciechk'), GraczeVarray('iwonab','dominikj','barbarap','marekg','alicjas'), PostacieVarray('Reyna','Breach','Omen','Jett','Brimstone'), PostacieVarray('Phoenix','Sage','Sova','Viper','Cypher'), 9, 13, 22, 7, 'n');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('sebastianb','justkwiat','lukaszz','michals','sofia'), GraczeVarray('wojciechk','iwonab','dominikj','barbarap','marekg'), PostacieVarray('Jett','Brimstone','Phoenix','Sage','Sova'), PostacieVarray('Viper','Cypher','Reyna','Breach','Omen'), 9, 13, 22, 7, 'n');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('paulinan','sebastianb','justkwiat','lukaszz','michals'), GraczeVarray('sofia','wojciechk','iwonab','dominikj','barbarap'), PostacieVarray('Breach','Omen','Jett','Brimstone','Phoenix'), PostacieVarray('Sage','Sova','Viper','Cypher','Reyna'), 9, 13, 22, 7, 'n');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('bartoszc','paulinan','sebastianb','justkwiat','lukaszz'), GraczeVarray('michals','sofia','wojciechk','iwonab','dominikj'), PostacieVarray('Sova','Viper','Cypher','Reyna','Breach'), PostacieVarray('Omen','Jett','Brimstone','Phoenix','Sage'), 8, 13, 21, 8, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('magdab','bartoszc','paulinan','sebastianb','justkwiat'), GraczeVarray('lukaszz','michals','sofia','wojciechk','iwonab'), PostacieVarray('Reyna','Breach','Omen','Jett','Brimstone'), PostacieVarray('Phoenix','Sage','Sova','Viper','Cypher'), 8, 13, 21, 8, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('kris_maz', 'magdab', 'paulinan', 'piotrekz', 'justkwiat'), GraczeVarray('lukaszz', 'marekg', 'sofia', 'alicjas', 'iwonab'), PostacieVarray('Jett','Brimstone','Phoenix','Sage','Sova'), PostacieVarray('Viper','Cypher','Reyna','Breach','Omen'), 1, 13, 14, 9, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('janko123', 'piotrekz', 'alicjas', 'sofia', 'kris_maz'), GraczeVarray('justkwiat', 'lukaszz', 'annnowak', 'bartoszc', 'iwonab'), PostacieVarray('Viper','Cypher','Reyna','Breach','Omen'), PostacieVarray('Jett','Brimstone','Phoenix','Sage','Sova'), 1, 13, 14, 9, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('barbarap', 'sebastianb', 'paulinan', 'annnowak', 'magdab'), GraczeVarray('janko123', 'piotrekz', 'sofia', 'andrzejk', 'justkwiat'), PostacieVarray('Jett','Brimstone','Phoenix','Sage','Sova'), PostacieVarray('Viper','Cypher','Reyna','Breach','Omen'), 0, 13, 13, 9, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('sofia', 'andrzejk', 'justkwiat', 'kris_maz', 'martal'), GraczeVarray('barbarap', 'janko123', 'dominikj', 'piotrekz', 'magdab'), PostacieVarray('Sova','Viper','Cypher','Reyna','Breach'), PostacieVarray('Omen','Jett','Brimstone','Phoenix','Sage'), 4, 13, 17, 9, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('barbarap', 'alicjas', 'paulinan', 'bartoszc', 'magdab'), GraczeVarray('janko123', 'piotrekz', 'sebastianb', 'andrzejk', 'justkwiat'), PostacieVarray('Brimstone','Phoenix','Sage','Sova','Viper'), PostacieVarray('Cypher','Reyna','Breach','Omen','Jett'), 6, 13, 19, 8, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('janko123', 'piotrekz', 'michals', 'annnowak', 'kris_maz'), GraczeVarray('lukaszz', 'andrzejk', 'sofia', 'bartoszc', 'iwonab'), PostacieVarray('Cypher','Reyna','Breach','Omen','Jett'), PostacieVarray('Brimstone','Phoenix','Sage','Sova','Viper'), 8, 13, 21, 8, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('barbarap', 'sebastianb', 'alicjas', 'andrzejk', 'magdab'), GraczeVarray('janko123', 'piotrekz', 'marekg', 'annnowak', 'justkwiat'), PostacieVarray('Reyna','Breach','Raze','Jett','Omen'), PostacieVarray('Phoenix','Brimstone','Sage','Sova','Viper'), 7, 13, 20, 9, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('lukaszz', 'bartoszc', 'sofia', 'justkwiat', 'iwonab'), GraczeVarray('barbarap', 'wojciechk', 'paulinan', 'andrzejk', 'magdab'), PostacieVarray('Brimstone','Phoenix','Sage','Sova','Viper'), PostacieVarray('Cypher','Reyna','Breach','Omen','Jett'), 8, 13, 21, 9, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('barbarap', 'sofia', 'dominikj', 'iwonab', 'wojciechk'), GraczeVarray('janko123', 'piotrekz', 'annnowak', 'paulinan', 'justkwiat'), PostacieVarray('Sova','Viper','Cypher','Reyna','Breach'), PostacieVarray('Omen','Jett','Brimstone','Phoenix','Sage'), 10, 13, 23, 9, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('annnowak', 'janko123', 'magdab', 'paulinan', 'kris_maz'), GraczeVarray('barbarap', 'lukaszz', 'iwonab', 'bartoszc', 'alicjas'), PostacieVarray('Sova','Viper','Cypher','Reyna','Breach'), PostacieVarray('Omen','Jett','Brimstone','Phoenix','Sage'), 11, 13, 24, 9, 'r');
END;
/
  
///////////////////////
// Scenariusz u¿ycia //
///////////////////////
// Dodanie gry (Baldur’s Gate III)

DECLARE
  P_TYTUL VARCHAR2(200);
  P_PRODUCENT VARCHAR2(200);
  P_WYDAWCA VARCHAR2(200);
  P_DATA_WYDANIA DATE;
  P_GATUNEK VARCHAR2(200);
  P_CENA_ZA_TYDZIEN NUMBER;
  P_CZAS_PRZEJSCIA NUMBER;
  P_PLATFORMA VARCHAR2(200);
  P_ROZMIAR_NA_DYSKU NUMBER;
  P_KLASYFIKACJA_WIEKOWA NUMBER;
BEGIN
  P_TYTUL := 'Baldur’s Gate III';
  P_PRODUCENT := 'Larian Studios';
  P_WYDAWCA := 'Larian Studios';
  P_DATA_WYDANIA := to_date('2023-08-03','yyyy-MM-dd');
  P_GATUNEK := 'RPG';
  P_CENA_ZA_TYDZIEN := 24.99;
  P_CZAS_PRZEJSCIA := 70;
  P_PLATFORMA := 'PC';
  P_ROZMIAR_NA_DYSKU := 80;
  P_KLASYFIKACJA_WIEKOWA := 18;

  BIBLIOTEKA_GIER.DODAJ_NOWA_GRE(
    P_TYTUL => P_TYTUL,
    P_PRODUCENT => P_PRODUCENT,
    P_WYDAWCA => P_WYDAWCA,
    P_DATA_WYDANIA => P_DATA_WYDANIA,
    P_GATUNEK => P_GATUNEK,
    P_CENA_ZA_TYDZIEN => P_CENA_ZA_TYDZIEN,
    P_CZAS_PRZEJSCIA => P_CZAS_PRZEJSCIA,
    P_PLATFORMA => P_PLATFORMA,
    P_ROZMIAR_NA_DYSKU => P_ROZMIAR_NA_DYSKU,
    P_KLASYFIKACJA_WIEKOWA => P_KLASYFIKACJA_WIEKOWA
  );
END;
/
// Przegl¹d dostêpnych gier w bibliotece gier
SELECT * FROM WIDOK_LISTA_DOSTEPNYCH_GIER;
/
// Dodanie klienta
INSERT INTO Klient VALUES (KlientType(31, 'Adam', 'Œmiechowski', 'Œmiechu', 'adam.œmiechowski@example.com', TO_DATE('2004-05-15', 'YYYY-MM-DD'), NULL, 'Polska', '019283778', WypozyczeniaRefList()));
/
// Przegl¹d wypo¿yczeñ klienta
SELECT * FROM WIDOK_LISTA_GIER_W_BIBLIOTECE_KLIENTA WHERE Klient = 'Œmiechu';
/
// Dodanie wypo¿yczenia wczeœniej dodanej gry i 5 innych (WiedŸmin 3, Battlefield 4, Need for Speed Hot Pursuit, WiedŸmin 2, Fifa 22)
BEGIN
    KLIENCI.ADD_WYPOZYCZENIE('Baldur’s Gate III', 'Œmiechu', 3);
    KLIENCI.ADD_WYPOZYCZENIE('WiedŸmin 3', 'Œmiechu', 2);
    KLIENCI.ADD_WYPOZYCZENIE('Battlefield 4', 'Œmiechu', 5);
    KLIENCI.ADD_WYPOZYCZENIE('Need For Speed: Hot Pursuit', 'Œmiechu', 1);
    KLIENCI.ADD_WYPOZYCZENIE('WiedŸmin 2', 'Œmiechu', 1);
    KLIENCI.ADD_WYPOZYCZENIE('Fifa 22', 'Œmiechu', 3);
END;
/
// Przed³u¿enie wypo¿yczenia nr 3 wczeœniej utworzonego klienta
BEGIN
    KLIENCI.PRZEDLUZ_WYPOZYCZENIE('Œmiechu', 78, 3);
END;
/
// Ponowny przegl¹d wypo¿yczeñ klienta
SELECT * FROM WIDOK_LISTA_GIER_W_BIBLIOTECE_KLIENTA WHERE Klient = 'Œmiechu';
/
// Dodanie kolejnych 11 wypo¿yczeñ do wczeœniej utworzonego klienta
BEGIN
    KLIENCI.ADD_WYPOZYCZENIE('Half-Life 2', 'Œmiechu', 2);
    KLIENCI.ADD_WYPOZYCZENIE('FIFA 21', 'Œmiechu', 2);
    KLIENCI.ADD_WYPOZYCZENIE('Tekken 7', 'Œmiechu', 3);
    KLIENCI.ADD_WYPOZYCZENIE('The Crew 2', 'Œmiechu', 2);
    KLIENCI.ADD_WYPOZYCZENIE('Final Fantasy XV', 'Œmiechu', 2);
    KLIENCI.ADD_WYPOZYCZENIE('Left 4 Dead 2', 'Œmiechu', 2);
    KLIENCI.ADD_WYPOZYCZENIE('Resident Evil 4', 'Œmiechu', 4);
    KLIENCI.ADD_WYPOZYCZENIE('GTA V', 'Œmiechu', 4);
    KLIENCI.ADD_WYPOZYCZENIE('Skyrim', 'Œmiechu', 1);
    KLIENCI.ADD_WYPOZYCZENIE('The Last of Us Part II', 'Œmiechu', 1);
    KLIENCI.ADD_WYPOZYCZENIE('WiedŸmin 1', 'Œmiechu', 1);
END;
/
// Prezentacja zni¿ek dla tego klienta (procedura)
BEGIN
    KLIENCI.POKAZ_RABAT_KLIENTA('Œmiechu');
END;
/
// Przegl¹d rabatów dla wszystkich klientów
BEGIN
    KLIENCI.WYSWIETL_KLIENTOW_Z_RABATEM();
END;
/
// Dodanie kolejnego klienta
INSERT INTO Klient VALUES (KlientType(32, 'Jakub', 'Smutas', 'smutjak_', 'jakub.smutas@example.com', TO_DATE('2001-07-25', 'YYYY-MM-DD'), NULL, 'Polska', '453453778', WypozyczeniaRefList()));
/
// Poprawka imienia i daty urodzenia klienta
BEGIN
    KLIENCI.EDYTUJ_UZYTKOWNIKA('smutjak_', 'Kuba', NULL, NULL, '112212212', 'UK', NULL);
END;
/
// Prze³¹czenie stanu wczeœniej dodanej gry i kilku innych wypo¿yczonych przez poprzedniego klienta
BEGIN
    BIBLIOTEKA_GIER.ZMIEN_STAN_GRY(12);
    BIBLIOTEKA_GIER.ZMIEN_STAN_GRY(3);
    BIBLIOTEKA_GIER.ZMIEN_STAN_GRY(22);
END;
/
// Przegl¹d dostêpnych gier w wypo¿yczalni
SELECT * FROM WIDOK_LISTA_DOSTEPNYCH_GIER;
/
SELECT * FROM WIDOK_LISTA_GIER;
// Wypo¿yczenie 3 gier przez nowego u¿ytkownika
BEGIN
    KLIENCI.ADD_WYPOZYCZENIE('Half-Life 2', 'smutjak_', 1);
    KLIENCI.ADD_WYPOZYCZENIE('FIFA 21', 'smutjak_', 1);
    KLIENCI.ADD_WYPOZYCZENIE('Tekken 7', 'smutjak_', 4);
END;
/
// Przegl¹d historii wypo¿yczeñ wszystkich klientów
SELECT * FROM WIDOK_LISTA_WYPOZYCZEN;
/
// Przegl¹d statystyk danych gatunków gier
BEGIN
    STATYSTYKI.NAJCZESCIEJ_WYPOZYCZANE_GATUNKI(2025,1,2025,12);
END;
/
// Przegl¹d statystyk danej gry
BEGIN
    STATYSTYKI.NAJCZESCIEJ_WYPOZYCZANE_GRY(2025,1,2025,12);
END;
/
// Przegl¹d œredniej ceny wypo¿yczeñ
BEGIN
    STATYSTYKI.SREDNIE_CENY_GATUNKOW(2025,1,2025,12);
END;
/
// Edycja ceny gry, która osi¹gnê³a wysok¹ popularnoœæ na wy¿sz¹ od œredniej gatunku
DECLARE
  P_ID_GRY NUMBER;
  P_TYTUL VARCHAR2(200);
  P_PRODUCENT VARCHAR2(200);
  P_WYDAWCA VARCHAR2(200);
  P_DATA_WYDANIA DATE;
  P_GATUNEK VARCHAR2(200);
  P_CENA_ZA_TYDZIEN NUMBER;
  P_CZAS_PRZEJSCIA NUMBER;
  P_PLATFORMA VARCHAR2(200);
  P_ROZMIAR_NA_DYSKU NUMBER;
  P_KLASYFIKACJA_WIEKOWA NUMBER;
BEGIN
  P_ID_GRY := 1;
  P_TYTUL := NULL;
  P_PRODUCENT := NULL;
  P_WYDAWCA := NULL;
  P_DATA_WYDANIA := NULL;
  P_GATUNEK := NULL;
  P_CENA_ZA_TYDZIEN := 30.99;
  P_CZAS_PRZEJSCIA := NULL;
  P_PLATFORMA := NULL;
  P_ROZMIAR_NA_DYSKU := NULL;
  P_KLASYFIKACJA_WIEKOWA := NULL;

  BIBLIOTEKA_GIER.EDYTUJ_GRE(
    P_ID_GRY => 1,
    P_TYTUL => NULL,
    P_PRODUCENT => NULL,
    P_WYDAWCA => NULL,
    P_DATA_WYDANIA => NULL,
    P_GATUNEK => NULL,
    P_CENA_ZA_TYDZIEN => 30.99,
    P_CZAS_PRZEJSCIA => NULL,
    P_PLATFORMA => NULL,
    P_ROZMIAR_NA_DYSKU => NULL,
    P_KLASYFIKACJA_WIEKOWA => NULL
  );
END;
/
// Przegl¹d dostêpnych gier w bibliotece (pokazanie ceny)
SELECT * FROM WIDOK_LISTA_DOSTEPNYCH_GIER;
/
// Przegl¹danie dostêpnych graczy.
SELECT * FROM WIDOK_DOSTEPNI_GRACZE ORDER BY 1 ASC, 4 DESC;
/
// Dodanie nowej rozgrywki
BEGIN
    ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('martal', 'piotrekz', 'alicjas', 'sofia', 'kris_maz'), GraczeVarray('wojciechk', 'lukaszz', 'annnowak', 'bartoszc', 'iwonab'), PostacieVarray('Brimstone', 'Sova', 'Brimstone', 'Reyna', 'Breach'), PostacieVarray('Reyna', 'Omen', 'Jett', 'Raze', 'Breach'), 1, 13, 14, 9, 'r');
END;
/
// Przegl¹d profilu gracza wraz z wyœwietleniem dodatkowej historii
BEGIN
    ROZGRYWKA_WIELOOSOBOWA.MOJ_PROFIL(24, 'martal', 'DENY');
END;
/
// Przegl¹d podobnych graczy do siebie
BEGIN
    ROZGRYWKA_WIELOOSOBOWA.WYSZUKAJ_GRACZY_POZIOM_MMR(24, 'martal');
END;
/
// Przegl¹d tablicy najlepszych
SELECT * FROM WIDOK_LEADERBOARD;
/
// Przegl¹d historii rozgrywek dla najlepszych 3 graczy
BEGIN
    ROZGRYWKA_WIELOOSOBOWA.MOJ_PROFIL(24, 'wojciechk', 'OK');
    ROZGRYWKA_WIELOOSOBOWA.MOJ_PROFIL(24, 'marekg', 'OK');
    ROZGRYWKA_WIELOOSOBOWA.MOJ_PROFIL(24, 'iwonab', 'OK');
END;
/
// Przegl¹d tierlisty i rozegranie gry najlepsz¹ postaci¹ w grze wed³ug tierlisty
SELECT * FROM WIDOK_TIERLIST ORDER BY WINRATE DESC;
/
// Sprawdzenie na jakiej mapie s¹ wyrównane szanse dla atakuj¹cych i broni¹cych
SELECT * FROM WIDOK_TIERLISTA_MAP;
/
// Symulacja wygranych (6 gier)
BEGIN
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('barbarap', 'piotrekz', 'sebastianb', 'andrzejk', 'justkwiat'), GraczeVarray('martal', 'alicjas', 'paulinan', 'bartoszc', 'magdab'), PostacieVarray('Reyna', 'Sova', 'Omen', 'Jett', 'Raze'), PostacieVarray('Viper', 'Phoenix', 'Sage', 'Brimstone', 'Cypher'), 6, 13, 19, 8, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('lukaszz', 'janko123', 'piotrekz', 'alicjas', 'magdab'), GraczeVarray('martal', 'michals', 'sofia', 'kris_maz', 'dominikj'), PostacieVarray('Brimstone', 'Jett', 'Breach', 'Cypher', 'Omen'), PostacieVarray('Viper', 'Phoenix', 'Sage', 'Reyna', 'Sova'), 7, 13, 20, 8, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('lukaszz', 'andrzejk', 'sofia', 'bartoszc', 'iwonab'), GraczeVarray('martal', 'piotrekz', 'michals', 'annnowak', 'kris_maz'), PostacieVarray('Omen', 'Sova', 'Cypher', 'Raze', 'Breach'), PostacieVarray('Viper', 'Phoenix', 'Sage', 'Brimstone', 'Reyna'), 8, 13, 21, 8, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('barbarap', 'piotrekz', 'marekg', 'annnowak', 'justkwiat'), GraczeVarray('martal', 'sebastianb', 'alicjas', 'andrzejk', 'magdab'), PostacieVarray('Cypher', 'Breach', 'Omen', 'Jett', 'Raze'), PostacieVarray('Viper', 'Phoenix', 'Sage', 'Brimstone', 'Sova'), 7, 13, 20, 8, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('barbarap', 'kris_maz', 'paulinan', 'andrzejk', 'magdab'), GraczeVarray('martal', 'bartoszc', 'sofia', 'justkwiat', 'iwonab'), PostacieVarray('Sage', 'Cypher', 'Breach', 'Omen', 'Raze'), PostacieVarray('Viper', 'Phoenix', 'Reyna', 'Brimstone', 'Jett'), 8, 13, 21, 8, 'r');
  ROZGRYWKA_WIELOOSOBOWA.DODAJ_ROZGRYWKE(24, GraczeVarray('lukaszz', 'magdab', 'dominikj', 'sofia', 'iwonab'), GraczeVarray('martal', 'paulinan', 'marekg', 'andrzejk', 'kris_maz'), PostacieVarray('Cypher', 'Sage', 'Brimstone', 'Omen', 'Jett'), PostacieVarray('Viper', 'Phoenix', 'Sova', 'Breach', 'Raze'), 9, 13, 22, 8, 'r');
END;
/

//Ponowny przegl¹d profilu (poprawa statystyk) i ponowne zerkniêcie na tablicê wyników i wyszukanie siebie na liœcie
BEGIN
    ROZGRYWKA_WIELOOSOBOWA.MOJ_PROFIL(24, 'martal', 'DENY');
END;
/
// Ponowny przegl¹d podobnych graczy do siebie
BEGIN
    ROZGRYWKA_WIELOOSOBOWA.WYSZUKAJ_GRACZY_POZIOM_MMR(24, 'martal');
END;
/

SELECT * FROM WIDOK_LEADERBOARD;
/