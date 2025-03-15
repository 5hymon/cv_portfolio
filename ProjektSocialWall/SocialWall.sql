CREATE DATABASE SocialWall;
GO

USE SocialWall;
GO

----------------------------
----- TWORZENIE TABEL ------
----------------------------

-- Tworzenie tabeli Lokalizacja 
CREATE TABLE Lokalizacja (
    lokalizacja_id INT PRIMARY KEY IDENTITY(1,1), -- PK Lokalizacja: Indeks klasterowany umo�liwiaj�cy szybkie wyszukiwanie lokalizacji po identyfikatorze.
    kraj NVARCHAR(50) NOT NULL,
    miejscowosc NVARCHAR(100) NOT NULL,
    ulica NVARCHAR(100) NOT NULL,
    nr_domu NVARCHAR(10) NOT NULL,
    nr_mieszkania NVARCHAR(10) DEFAULT NULL,
    informacje_dodatkowe NVARCHAR(MAX) DEFAULT NULL,
    modified_date DATE DEFAULT NULL,
	rowguid UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL
);

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Tabela zawieraj�ca informacje o miejscach zamieszkania u�ytkownik�w.', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Table', @level1name = N'Lokalizacja';
GO

-- Tworzenie tabeli Uzytkownicy
CREATE TABLE Uzytkownicy (
    uzytkownik_id INT PRIMARY KEY IDENTITY(1,1), -- PK Uzytkownicy: Indeks klasterowany umo�liwiaj�cy szybkie wyszukiwanie u�ytkownik�w po identyfikatorze.
    imie NVARCHAR(50) NOT NULL,
    nazwisko NVARCHAR(50) NOT NULL,
    data_urodzenia DATE NOT NULL,
    data_dolaczenia DATE NOT NULL DEFAULT GETDATE(),
    miejscowosc NVARCHAR(50),
    kraj NVARCHAR(50),
    plec NVARCHAR(9),
    pseudonim NVARCHAR(20) UNIQUE NOT NULL, -- IX_Uzytkownicy_pseudonim: Indeks nieklasterowany wymuszaj�cy unikalno�� pseudonim�w u�ytkownik�w.
    lokalizacja_marketplace INT DEFAULT NULL,
    modified_date DATE DEFAULT NULL,
	rowguid UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL,
    FOREIGN KEY (lokalizacja_marketplace) REFERENCES Lokalizacja(lokalizacja_id) ON DELETE SET NULL, -- IX_Uzytkownicy_lokalizacja
    CHECK (DATEDIFF(YEAR, data_urodzenia, data_dolaczenia) >= 13)
);

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Tabela zawieraj�ca informacje o u�ytkownikach systemu.', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Table', @level1name = N'Uzytkownicy';

CREATE NONCLUSTERED INDEX IX_Uzytkownicy_Lokalizacja 
ON Uzytkownicy(lokalizacja_marketplace);
GO

-- Tworzenie tabeli Obserwacje
CREATE TABLE Obserwacje (
    obserwujacy_id INT NOT NULL,
    obserwowany_id INT NOT NULL,
	rowguid UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL PRIMARY KEY, -- PK Obserwacje: Indeks klasterowany zapewniaj�cy unikalno�� dla kolumny rowguid w tabeli obserwacji.
    FOREIGN KEY (obserwujacy_id) REFERENCES Uzytkownicy(uzytkownik_id) ON DELETE CASCADE -- IX_Obserwacje_Obserwujacy
);

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Tabela zawieraj�ca informacje o obserwacjach mi�dzy u�ytkownikami.', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Table', @level1name = N'Obserwacje';

CREATE NONCLUSTERED INDEX IX_Obserwacje_Obserwujacy 
ON Obserwacje(obserwujacy_id);
GO

-- Tworzenie tabeli Grupy
CREATE TABLE Grupy (
    grupa_id INT PRIMARY KEY IDENTITY(1,1), -- PK Grupy: Indeks klasterowany umo�liwiaj�cy szybkie wyszukiwanie grup po identyfikatorze.
    nazwa NVARCHAR(100) NOT NULL,
    modified_date DATE DEFAULT NULL,
	rowguid UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL
);

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Tabela zawieraj�ca grupy u�ytkownik�w w systemie.', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Table', @level1name = N'Grupy';
GO

-- Tworzenie tabeli Czlonkowie_Grupy
CREATE TABLE Czlonkowie_Grupy (
    grupa_id INT NOT NULL,
    uzytkownik_id INT NOT NULL,
	rowguid UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL PRIMARY KEY, -- PK Czlonkowie_Grupy: Indeks klasterowany zapewniaj�cy unikalno�� dla kolumny rowguid w tabeli czlonk�w grupy.
    FOREIGN KEY (grupa_id) REFERENCES Grupy(grupa_id), -- IX_Czlonkowie_Grupy_grupa
    FOREIGN KEY (uzytkownik_id) REFERENCES Uzytkownicy(uzytkownik_id) ON DELETE CASCADE
);

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Tabela zawieraj�ca cz�onk�w poszczeg�lnych grup.', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Table', @level1name = N'Czlonkowie_Grupy';

CREATE NONCLUSTERED INDEX IX_CzlonkowieGrupy_Grupa 
ON Czlonkowie_Grupy(grupa_id);

CREATE NONCLUSTERED INDEX IX_CzlonkowieGrupy_Uzytkownik 
ON Czlonkowie_Grupy(uzytkownik_id);
GO

-- Tworzenie tabeli Posty
CREATE TABLE Posty (
    post_id INT PRIMARY KEY IDENTITY(1,1), -- PK Posty: Indeks klasterowany umo�liwiaj�cy szybkie wyszukiwanie post�w po identyfikatorze.
    autor_id INT NOT NULL,
    tytul NVARCHAR(200) NOT NULL,
    opis NVARCHAR(MAX) DEFAULT NULL,
    rodzaj NVARCHAR(50) NOT NULL,
    grupa_id INT DEFAULT NULL,
    modified_date DATE DEFAULT NULL,
	rowguid UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL,
    FOREIGN KEY (autor_id) REFERENCES Uzytkownicy(uzytkownik_id),
    FOREIGN KEY (grupa_id) REFERENCES Grupy(grupa_id),
    CHECK (rodzaj IN ('Tekst', 'Obraz', 'Film'))
);

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Tabela zawieraj�ca posty u�ytkownik�w.', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Table', @level1name = N'Posty';

CREATE NONCLUSTERED INDEX IX_Posty_Autor 
ON Posty(autor_id);

CREATE NONCLUSTERED INDEX IX_Posty_Grupa 
ON Posty(grupa_id);
GO

-- Tworzenie tabeli Komentarze_Posty
CREATE TABLE Komentarze_Posty (
    komentarz_id INT PRIMARY KEY IDENTITY(1,1), -- PK Komentarze_Posty: Indeks klasterowany umo�liwiaj�cy szybkie wyszukiwanie komentarzy po identyfikatorze.
    post_id INT NOT NULL,
    uzytkownik_id INT NOT NULL,
    tresc NVARCHAR(MAX) NOT NULL,
    modified_date DATE DEFAULT NULL,
	rowguid UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL,
    FOREIGN KEY (post_id) REFERENCES Posty(post_id) ON DELETE CASCADE,
    FOREIGN KEY (uzytkownik_id) REFERENCES Uzytkownicy(uzytkownik_id)
);

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Tabela zawieraj�ca komentarze do poszczeg�lnych post�w.', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Table', @level1name = N'Komentarze_Posty';

CREATE NONCLUSTERED INDEX IX_KomentarzePosty_Post 
ON Komentarze_Posty(post_id);

CREATE NONCLUSTERED INDEX IX_KomentarzePosty_Uzytkownik 
ON Komentarze_Posty(uzytkownik_id);
GO

-- Tworzenie tabeli Wydarzenia
CREATE TABLE Wydarzenia (
    wydarzenie_id INT PRIMARY KEY IDENTITY(1,1), -- PK Wydarzenia: Indeks klasterowany umo�liwiaj�cy szybkie wyszukiwanie wydarze� po identyfikatorze.
    autor_id INT NOT NULL,
    tytul NVARCHAR(200) NOT NULL,
    opis NVARCHAR(MAX) NOT NULL,
    miejsce NVARCHAR(200) NOT NULL,
    data_rozpoczecia DATE NOT NULL,
    data_zakonczenia DATE NOT NULL,
    modified_date DATE DEFAULT NULL,
	rowguid UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL,
    FOREIGN KEY (autor_id) REFERENCES Uzytkownicy(uzytkownik_id),
    CHECK (data_rozpoczecia <= data_zakonczenia)
);

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Tabela zawieraj�ca wydarzenia organizowane przez u�ytkownik�w.', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Table', @level1name = N'Wydarzenia';

CREATE NONCLUSTERED INDEX IX_Wydarzenia_Autor 
ON Wydarzenia(autor_id);
GO

-- Tworzenie tabeli Zainteresowani_Wydarzenia
CREATE TABLE Zainteresowani_Wydarzenia (
    wydarzenie_id INT NOT NULL,
    uzytkownik_id INT NOT NULL,
	rowguid UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL PRIMARY KEY, -- PK Zainteresowani_Wydarzenia: Indeks klasterowany zapewniaj�cy unikalno�� dla kolumny rowguid w tabeli zainteresowanych wydarzeniem.
    FOREIGN KEY (wydarzenie_id) REFERENCES Wydarzenia(wydarzenie_id),
    FOREIGN KEY (uzytkownik_id) REFERENCES Uzytkownicy(uzytkownik_id)
);

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Tabela zawieraj�ca zainteresowanych wydarzeniami u�ytkownik�w.', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Table', @level1name = N'Zainteresowani_Wydarzenia';

CREATE NONCLUSTERED INDEX IX_ZainteresowaniWydarzenia_Wydarzenie 
ON Zainteresowani_Wydarzenia(wydarzenie_id);

CREATE NONCLUSTERED INDEX IX_ZainteresowaniWydarzenia_Uzytkownik 
ON Zainteresowani_Wydarzenia(uzytkownik_id);
GO

-- Tworzenie tabeli Kanal_Nadawczy
CREATE TABLE Kanal_Nadawczy (
    kanal_id INT PRIMARY KEY IDENTITY(1,1), -- PK Kanal_Nadawczy: Indeks klasterowany umo�liwiaj�cy szybkie wyszukiwanie kana��w nadawczysz po identyfikatorze.
    nazwa NVARCHAR(MAX) NOT NULL,
    nadawca_id INT NOT NULL,
    modified_date DATE DEFAULT NULL,
	rowguid UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL,
    FOREIGN KEY (nadawca_id) REFERENCES Uzytkownicy(uzytkownik_id)
);

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Tabela zawieraj�ca kana�y nadawcze utworzone przez u�ytkownik�w.', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Table', @level1name = N'Kanal_Nadawczy';

CREATE NONCLUSTERED INDEX IX_KanalNadawczy_Nadawca 
ON Kanal_Nadawczy(nadawca_id);
GO

-- Tworzenie tabeli Czlonkowie_Kanal_Nadawczy
CREATE TABLE Czlonkowie_Kanal_Nadawczy (
    kanal_id INT NOT NULL,
    uzytkownik_id INT NOT NULL,
	rowguid UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL PRIMARY KEY, -- PK Czlonkowie_Kanal_Nadawczy: Indeks klasterowany zapewniaj�cy unikalno�� dla kolumny rowguid w tabeli cz�onk�w kana�u nadawczego.
    FOREIGN KEY (kanal_id) REFERENCES Kanal_Nadawczy(kanal_id),
    FOREIGN KEY (uzytkownik_id) REFERENCES Uzytkownicy(uzytkownik_id)
);

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Tabela zawieraj�ca cz�onk�w poszczeg�lnych kana��w nadawczych.', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Table', @level1name = N'Czlonkowie_Kanal_Nadawczy';

CREATE NONCLUSTERED INDEX IX_CzlonkowieKanalNadawczy_KanalNadawczy 
ON Czlonkowie_Kanal_Nadawczy(kanal_id);

CREATE NONCLUSTERED INDEX IX_CzlonkowieKanalNadawczy_Uzytkownik 
ON Czlonkowie_Kanal_Nadawczy(uzytkownik_id);
GO

-- Tworzenie tabeli Wiadomosci_Kanal_Nadawczy
CREATE TABLE Wiadomosci_Kanal_Nadawczy (
    kanal_id INT NOT NULL,
    wiadomosc_id INT NOT NULL IDENTITY(1,1),
    tresc NVARCHAR(MAX) NOT NULL,
	rowguid UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL PRIMARY KEY, -- PK Wiadomosci_Kanal_Nadawczy: Indeks klasterowany zapewniaj�cy unikalno�� dla kolumny rowguid w tabeli wiadaomo�ci kana�u nadawczego.
    FOREIGN KEY (kanal_id) REFERENCES Kanal_Nadawczy(kanal_id)
);

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Tabela zawieraj�ca wiadomo�ci poszczeg�lnych kana��w nadawczych.', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Table', @level1name = N'Wiadomosci_Kanal_Nadawczy';

CREATE NONCLUSTERED INDEX IX_WiadomosciKanalNadawczy_KanalNadawczy 
ON Wiadomosci_Kanal_Nadawczy(kanal_id);
GO

-- Tworzenie tabeli Marketplace
CREATE TABLE Marketplace (
    ogloszenie_id INT PRIMARY KEY IDENTITY(1,1), -- PK Marketplace: Indeks klasterowany umo�liwiaj�cy szybkie przeszukiwanie marketplace po identyfikatorze.
    ogloszeniodawca_id INT NOT NULL,
    tytul NVARCHAR(200) NOT NULL,
    opis NVARCHAR(MAX) DEFAULT NULL,
    kategoria NVARCHAR(50) NOT NULL,
    cena MONEY NOT NULL,
    cena_do_negocjacji BIT NOT NULL,
    mozliwosc_przesylki BIT NOT NULL,
    aktywne BIT DEFAULT 1 NOT NULL,
    modified_date DATE DEFAULT NULL,
	rowguid UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL,
    FOREIGN KEY (ogloszeniodawca_id) REFERENCES Uzytkownicy(uzytkownik_id),
    CHECK (kategoria IN ('Motoryzacja', 'Nieruchomo�ci', 'Dom i ogr�d', 'Elektronika', 'Moda', 'Zwierz�ta', 'Dla dzieci', 'Sport', 'Rozrywka', 'Zdrowie i uroda'))
);

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Tabela zawieraj�ca og�oszenia sprzeda�y u�ytkownik�w w systemie.', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Table', @level1name = N'Marketplace';

CREATE NONCLUSTERED INDEX IX_Marketplace_Ogloszeniodawca 
ON Marketplace(ogloszeniodawca_id);
GO

-- Tworzenie tabeli Zakupy
CREATE TABLE Zakupy (
    zakup_id INT PRIMARY KEY IDENTITY(1,1), -- PK Zakupy: Indeks klasterowany umo�liwiaj�cy szybkie wyszukiwanie zakup�w po identyfikatorze.
    sprzedajacy_id INT NOT NULL,
    kupujacy_id INT NOT NULL,
    kwota_zakupu MONEY NOT NULL,
    dane_wysylkowe INT,
    ogloszenie_id INT NOT NULL,
	rowguid UNIQUEIDENTIFIER DEFAULT NEWID() NOT NULL,
    FOREIGN KEY (sprzedajacy_id) REFERENCES Uzytkownicy(uzytkownik_id),
    FOREIGN KEY (kupujacy_id) REFERENCES Uzytkownicy(uzytkownik_id),
    FOREIGN KEY (dane_wysylkowe) REFERENCES Lokalizacja(lokalizacja_id) ON DELETE SET NULL,
    FOREIGN KEY (ogloszenie_id) REFERENCES Marketplace(ogloszenie_id),
);

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Tabela zawieraj�ca zakupy poszczeg�lnych u�ytkownik�w.', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Table', @level1name = N'Zakupy';

CREATE NONCLUSTERED INDEX IX_Zakupy_Sprzedajacy 
ON Zakupy(sprzedajacy_id);

CREATE NONCLUSTERED INDEX IX_Zakupy_Kupujacy 
ON Zakupy(kupujacy_id);

CREATE NONCLUSTERED INDEX IX_Zakupy_DaneWysylkowe 
ON Zakupy(dane_wysylkowe);

CREATE NONCLUSTERED INDEX IX_Zakupy_Ogloszenie 
ON Zakupy(ogloszenie_id);
GO

--------------------------------
----- TWORZENIE TRIGGER�W ------
--------------------------------

-- Trigger usuwaj�cy kaskadowo rekordy powi�zane z u�ytkownikiem i samego u�ytkownika po wywo�aniu delete na danym u�ytkowniku.
CREATE OR ALTER TRIGGER trg_DeleteUsr
ON Uzytkownicy
INSTEAD OF DELETE
AS
BEGIN
    DELETE FROM Zakupy
    WHERE kupujacy_id IN (SELECT uzytkownik_id FROM deleted);

	DELETE FROM Zakupy
    WHERE sprzedajacy_id IN (SELECT uzytkownik_id FROM deleted);

	DELETE FROM Marketplace
    WHERE ogloszeniodawca_id IN (SELECT uzytkownik_id FROM deleted);

	DELETE FROM Czlonkowie_Kanal_Nadawczy
    WHERE uzytkownik_id IN (SELECT uzytkownik_id FROM deleted);

	DELETE FROM Kanal_Nadawczy
    WHERE nadawca_id IN (SELECT uzytkownik_id FROM deleted);

	DELETE FROM Zainteresowani_Wydarzenia
    WHERE uzytkownik_id IN (SELECT uzytkownik_id FROM deleted);

	DELETE FROM Wydarzenia
    WHERE autor_id IN (SELECT uzytkownik_id FROM deleted);

	DELETE FROM Komentarze_Posty
    WHERE uzytkownik_id IN (SELECT uzytkownik_id FROM deleted);

	DELETE FROM Posty
    WHERE autor_id IN (SELECT uzytkownik_id FROM deleted);

	DELETE FROM Czlonkowie_Grupy
    WHERE uzytkownik_id IN (SELECT uzytkownik_id FROM deleted);

	DELETE FROM Obserwacje
	WHERE obserwowany_id IN (SELECT uzytkownik_id from deleted);

	DELETE FROM Obserwacje
	WHERE obserwujacy_id IN (SELECT uzytkownik_id from deleted);

	DELETE FROM Uzytkownicy
	WHERE uzytkownik_id IN (SELECT uzytkownik_id from deleted);
END;
GO

-- Trigger usuwaj�cy kaskadowo rekordy powi�zane z postem i sam post po wywo�aniu delete na danym poscie.
CREATE OR ALTER TRIGGER trg_DeletePst
ON Posty
INSTEAD OF DELETE
AS
BEGIN
    DELETE FROM Komentarze_Posty
    WHERE post_id IN (SELECT post_id FROM deleted);

	DELETE FROM Posty
	WHERE post_id IN (SELECT post_id from deleted);
END;
GO

-- Trigger usuwaj�cy kaskadowo rekordy powi�zane z wydarzeniem i same wydarzenie po wywo�aniu delete na danym wydarzeniu.
CREATE OR ALTER TRIGGER trg_DeleteWyd
ON Wydarzenia
INSTEAD OF DELETE
AS
BEGIN
    DELETE FROM Zainteresowani_Wydarzenia
    WHERE wydarzenie_id IN (SELECT wydarzenie_id FROM deleted);

	DELETE FROM Wydarzenia
    WHERE wydarzenie_id IN (SELECT wydarzenie_id FROM deleted);
END;
GO

-- Trigger usuwaj�cy kaskadowo rekordy powi�zane z kana�em nadawczym i sam kana� nadawczy po wywo�aniu delete na danym kanale nadawczym.
CREATE OR ALTER TRIGGER trg_DeleteKan
ON Kanal_Nadawczy
INSTEAD OF DELETE
AS
BEGIN
    DELETE FROM Czlonkowie_Kanal_Nadawczy
    WHERE kanal_id IN (SELECT kanal_id FROM deleted);

	DELETE FROM Wiadomosci_Kanal_Nadawczy
    WHERE kanal_id IN (SELECT kanal_id FROM deleted);

	DELETE FROM Kanal_Nadawczy
    WHERE kanal_id IN (SELECT kanal_id FROM deleted);
END;
GO

-- Trigger usuwaj�cy kaskadowo rekordy powi�zane z zakupami i sam zakup po wywo�aniu delete na danym zakupie.
CREATE OR ALTER TRIGGER trg_DeleteSpr
ON Marketplace
INSTEAD OF DELETE
AS
BEGIN
    DELETE FROM Zakupy
    WHERE ogloszenie_id IN (SELECT ogloszenie_id FROM deleted);

	DELETE FROM Marketplace
    WHERE ogloszenie_id IN (SELECT ogloszenie_id FROM deleted);
END;
GO

-- Trigger usuwaj�cy kaskadowo rekordy powi�zane z grup� i sam� grup� po wywo�aniu delete na danej grupie.
CREATE OR ALTER TRIGGER trg_DeleteGrp
ON Grupy
INSTEAD OF DELETE
AS
BEGIN
    DELETE FROM Posty
    WHERE grupa_id IN (SELECT grupa_id FROM deleted);

	DELETE FROM Czlonkowie_Grupy
    WHERE grupa_id IN (SELECT grupa_id FROM deleted);

	DELETE FROM Grupy
    WHERE grupa_id IN (SELECT grupa_id FROM deleted);
END;
GO

-- Trigger dzia�aj�cy przy modyfikacji rekordu w tabeli Lokalizacja zmieniaj�cy pole modified_date na aktualn� dat�.
CREATE OR ALTER TRIGGER trg_update_Lokalizacja_modified_date
ON Lokalizacja
AFTER UPDATE
AS
BEGIN
    UPDATE Lokalizacja
    SET modified_date = GETDATE()
    WHERE lokalizacja_id IN (SELECT DISTINCT lokalizacja_id FROM inserted);
END;
GO

-- Trigger dzia�aj�cy przy modyfikacji rekordu w tabeli Uzytkownicy zmieniaj�cy pole modified_date na aktualn� dat�.
CREATE OR ALTER TRIGGER trg_update_Uzytkownicy_modified_date
ON Uzytkownicy
AFTER UPDATE
AS
BEGIN
    UPDATE Uzytkownicy
    SET modified_date = GETDATE()
    WHERE uzytkownik_id IN (SELECT DISTINCT uzytkownik_id FROM inserted);
END;
GO

-- Trigger dzia�aj�cy przy modyfikacji rekordu w tabeli Posty zmieniaj�cy pole modified_date na aktualn� dat�.
CREATE OR ALTER TRIGGER trg_update_Posty_modified_date
ON Posty
AFTER UPDATE
AS
BEGIN
    UPDATE Posty
    SET modified_date = GETDATE()
    WHERE post_id IN (SELECT DISTINCT post_id FROM inserted);
END;
GO

-- Trigger dzia�aj�cy przy modyfikacji rekordu w tabeli Wydarzenia zmieniaj�cy pole modified_date na aktualn� dat�.
CREATE OR ALTER TRIGGER trg_update_Wydarzenia_modified_date
ON Wydarzenia
AFTER UPDATE
AS
BEGIN
    UPDATE Wydarzenia
    SET modified_date = GETDATE()
    WHERE wydarzenie_id IN (SELECT DISTINCT wydarzenie_id FROM inserted);
END;
GO

-- Trigger dzia�aj�cy przy modyfikacji rekordu w tabeli Komentarze_Posty zmieniaj�cy pole modified_date na aktualn� dat�.
CREATE OR ALTER TRIGGER trg_update_Komentarze_Posty_modified_date
ON Komentarze_Posty
AFTER UPDATE
AS
BEGIN
    UPDATE Komentarze_Posty
    SET modified_date = GETDATE()
    WHERE komentarz_id IN (SELECT DISTINCT komentarz_id FROM inserted);
END;
GO

-- Trigger dzia�aj�cy przy modyfikacji rekordu w tabeli Kanal_Nadawczy zmieniaj�cy pole modified_date na aktualn� dat�.
CREATE OR ALTER TRIGGER trg_update_Kanal_Nadawczy_modified_date
ON Kanal_Nadawczy
AFTER UPDATE
AS
BEGIN
    UPDATE Kanal_Nadawczy
    SET modified_date = GETDATE()
    WHERE kanal_id IN (SELECT DISTINCT kanal_id FROM inserted);
END;
GO

-- Trigger dzia�aj�cy przy modyfikacji rekordu w tabeli Marketplace zmieniaj�cy pole modified_date na aktualn� dat�.
CREATE OR ALTER TRIGGER trg_update_Marketplace_modified_date
ON Marketplace
AFTER UPDATE
AS
BEGIN
    UPDATE Marketplace
    SET modified_date = GETDATE()
    WHERE ogloszenie_id IN (SELECT DISTINCT ogloszenie_id FROM inserted);
END;
GO

-- Trigger dzia�aj�cy przy modyfikacji rekordu w tabeli Grupy zmieniaj�cy pole modified_date na aktualn� dat�.
CREATE OR ALTER TRIGGER trg_update_Grupy_modified_date
ON Grupy
AFTER UPDATE
AS
BEGIN
    UPDATE Grupy
    SET modified_date = GETDATE()
    WHERE grupa_id IN (SELECT DISTINCT grupa_id FROM inserted);
END;
GO

-------------------------------------------
----- WSTAWIANIE PRZYK�ADOWYCH DANYCH -----
-------------------------------------------

-- Dane do tabeli Lokalizacja
INSERT INTO Lokalizacja (kraj, miejscowosc, ulica, nr_domu, nr_mieszkania, informacje_dodatkowe) VALUES
('Polska', 'Warszawa', 'Marsza�kowska', '10', '15', 'Blisko centrum'),
('Polska', 'Krak�w', 'Floria�ska', '5', NULL, NULL),
('Polska', 'Gda�sk', 'D�uga', '12', '3A', 'Z widokiem na Mot�aw�'),
('Polska', 'Pozna�', 'P�wiejska', '3', NULL, 'Przy Starym Browarze'),
('Polska', 'Wroc�aw', '�widnicka', '8', '2B', NULL),
('Polska', '��d�', 'Piotrkowska', '14', NULL, 'Naprzeciwko kina'),
('Polska', 'Sopot', 'Monte Cassino', '22', '1', 'Blisko mola'),
('Polska', 'Lublin', 'Krakowskie Przedmie�cie', '7', '4', 'Naprzeciwko ratusza'),
('Polska', 'Katowice', 'Mariacka', '9', NULL, 'W pobli�u ko�cio�a Mariackiego'),
('Polska', 'Zakopane', 'Krup�wki', '20', '6', 'Z widokiem na Giewont');
GO

-- Dane do tabeli Uzytkownicy
INSERT INTO Uzytkownicy (imie, nazwisko, data_urodzenia, miejscowosc, kraj, plec, pseudonim, lokalizacja_marketplace) VALUES
('Anna', 'Kowalska', '1990-03-15', 'Warszawa', 'Polska', 'Kobieta', 'AniaK', 1),
('Jan', 'Nowak', '1985-07-22', 'Krak�w', 'Polska', 'M�czyzna', 'Janek', 2),
('Katarzyna', 'Wi�niewska', '1992-11-03', 'Gda�sk', 'Polska', 'Kobieta', 'KasiaW', 3),
('Micha�', 'Lewandowski', '1988-05-14', 'Pozna�', 'Polska', 'M�czyzna', 'MichalL', 4),
('Magdalena', 'Zieli�ska', '1994-01-09', 'Wroc�aw', 'Polska', 'Kobieta', 'MagdaZ', 5),
('Pawe�', 'Kami�ski', '1991-06-17', '��d�', 'Polska', 'M�czyzna', 'PawelK', 6),
('Agnieszka', 'D�browska', '1993-09-25', 'Sopot', 'Polska', 'Kobieta', 'AgaD', 7),
('Piotr', 'W�jcik', '1987-02-13', 'Lublin', 'Polska', 'M�czyzna', 'Piotrek', 8),
('Monika', 'Szyma�ska', '1995-08-19', 'Katowice', 'Polska', 'Kobieta', 'Monia', 9),
('Tomasz', 'Koz�owski', '1990-04-27', 'Zakopane', 'Polska', 'M�czyzna', 'TomekK', 10);
GO

-- Dane do tabeli Obserwacje
INSERT INTO Obserwacje (obserwujacy_id, obserwowany_id) VALUES
(1, 2), (1, 3), (2, 1), (2, 4), (3, 1),
(3, 5), (4, 2), (5, 6), (6, 7), (7, 8);
GO

-- Dane do tabeli Grupy
INSERT INTO Grupy (nazwa) VALUES
('Mi�o�nicy ksi��ek'),
('Fotografowie krajobraz�w'),
('Fani film�w science-fiction'),
('Biegacze z ca�ej Polski'),
('Mi�o�nicy g�r'),
('Grupa wsparcia IT'),
('Kreatywni kucharze'),
('Mi�o�nicy zwierz�t'),
('Entuzja�ci fitnessu'),
('Klub podr�nik�w');
GO

-- Dane do tabeli Czlonkowie_Grupy
INSERT INTO Czlonkowie_Grupy (grupa_id, uzytkownik_id) VALUES
(1, 1), (1, 2), (1, 3),
(2, 4), (2, 5), (2, 6),
(3, 7), (3, 8), (3, 9),
(4, 10), (4, 1), (4, 5);
GO

-- Dane do tabeli Posty
INSERT INTO Posty (autor_id, tytul, opis, rodzaj, grupa_id) VALUES
(1, 'Najlepsze ksi��ki 2023 roku', 'Jakie ksi��ki polecacie na zimowe wieczory?', 'Tekst', 1),
(2, 'Zdj�cie z Tatr', 'Wczoraj wsch�d s�o�ca w Tatrach by� niesamowity!', 'Obraz', 5),
(3, 'Nowy przepis na ciasto', 'Spr�bujcie tego przepisu na sernik!', 'Tekst', 7),
(4, 'Pomoc z SQL', 'Mam problem z triggerem, kto� pomo�e?', 'Tekst', 6),
(5, 'Ulubione filmy sci-fi', 'Dyskusja o najlepszych filmach science-fiction', 'Film', 3),
(6, 'Przebieg�em maraton!', 'Pierwszy raz uko�czy�em maraton, jestem bardzo dumny!', 'Tekst', 4),
(7, 'Zwierz�ta w naszym �yciu', 'Zdj�cie mojego psa - wprowadza tyle rado�ci!', 'Obraz', 8),
(8, 'Trening na nogi', 'Sprawd�cie m�j plan treningowy na nogi', 'Tekst', 9),
(9, 'Zdj�cie z podr�y', 'Odwiedzi�em Pary�, pi�kne miasto!', 'Obraz', 10),
(10, 'Pomys�y na wakacje', 'Jakie s� wasze plany na wakacje?', 'Tekst', 10);
GO

-- Dane do tabeli Komentarze_Posty
INSERT INTO Komentarze_Posty (post_id, uzytkownik_id, tresc) VALUES
(1, 2, 'Bardzo ciekawe pytanie!'),
(1, 3, 'Polecam ksi��k� "Cie� wiatru".'),
(2, 4, 'Pi�kne zdj�cie! Jakiego aparatu u�ywasz?'),
(3, 5, 'Uwielbiam serniki, podziel si� przepisem!'),
(4, 6, 'Mam podobny problem, mo�e razem znajdziemy rozwi�zanie.'),
(5, 7, 'Kto� widzia� now� cz�� "Diuny"?'),
(6, 8, 'Gratulacje! Maraton to ogromne osi�gni�cie.'),
(7, 9, 'Tw�j pies jest przeuroczy!'),
(8, 10, 'Dobry plan treningowy, dzi�ki!'),
(9, 1, 'Pary� to jedno z moich ulubionych miejsc.');
GO

-- Dane do tabeli Marketplace
INSERT INTO Marketplace (ogloszeniodawca_id, tytul, opis, kategoria, cena, cena_do_negocjacji, mozliwosc_przesylki) VALUES
(1, 'Sprzedam rower g�rski', 'Rower w bardzo dobrym stanie, u�ywany kilka razy.', 'Sport', 1200, 1, 1),
(2, 'Mieszkanie na wynajem', 'Dwupokojowe mieszkanie w centrum Krakowa.', 'Nieruchomo�ci', 2500, 0, 0),
(3, 'Laptop gamingowy', 'Mocny laptop idealny do gier.', 'Elektronika', 4500, 1, 1),
(4, 'Kanapa do salonu', 'Wygodna kanapa, lekko u�ywana.', 'Dom i ogr�d', 800, 1, 0),
(5, 'Sukienka wieczorowa', 'Elegancka sukienka na r�ne okazje.', 'Moda', 200, 0, 1),
(6, 'Telewizor OLED', 'Nowoczesny telewizor z du�ym ekranem.', 'Elektronika', 3500, 1, 1),
(7, 'Samoch�d osobowy', 'Auto w dobrym stanie, do negocjacji.', 'Motoryzacja', 20000, 1, 0),
(8, 'Klatka dla chomika', 'Ma�o u�ywana klatka z wyposa�eniem.', 'Zwierz�ta', 150, 0, 1),
(9, 'Zestaw narciarski', 'Narty, buty i kijki - wszystko w dobrym stanie.', 'Sport', 1000, 1, 0),
(10, 'Fotel biurowy', 'Ergonomiczny fotel idealny do pracy przy komputerze.', 'Dom i ogr�d', 600, 1, 1);
GO

-- Dane do tabeli Zakupy
INSERT INTO Zakupy (sprzedajacy_id, kupujacy_id, kwota_zakupu, dane_wysylkowe, ogloszenie_id) VALUES
(1, 2, 1200.00, 2, 1),
(2, 3, 2500.00, 3, 2),
(3, 4, 4500.00, 4, 3),
(4, 5, 800.00, 5, 4),
(5, 6, 200.00, 6, 5),
(6, 7, 3500.00, 7, 6),
(7, 8, 20000.00, 8, 7),
(8, 9, 150.00, 9, 8),
(9, 10, 1000.00, 10, 9),
(10, 1, 600.00, 1, 10);
GO

-- Dane do tabeli Kanal_Nadawczy
INSERT INTO Kanal_Nadawczy (nazwa, nadawca_id) VALUES
('Wsp�lna pasja do ksi��ek', 1),
('Grupa wspinaczkowa', 2),
('Klub fotograficzny', 3),
('Zesp� IT', 4),
('Warsztaty kulinarne', 5),
('Spotkania sportowe', 6),
('Fani film�w sci-fi', 7),
('Mi�o�nicy zwierz�t', 8),
('Grupa podr�nicza', 9),
('Planowanie wycieczek', 10);
GO

-- Dane do tabeli Czlonkowie_Kanal_Nadawczy
INSERT INTO Czlonkowie_Kanal_Nadawczy (kanal_id, uzytkownik_id) VALUES
(1, 1), (1, 2), (1, 3), (2, 2), (2, 4),
(3, 3), (3, 5), (4, 4), (4, 6), (5, 5),
(6, 6), (6, 7), (7, 7), (7, 8), (8, 8),
(9, 9), (9, 10), (10, 1), (10, 2), (10, 3);
GO

-- Dane do tabeli Wiadomosci_Kanal_Nadawczy
INSERT INTO Wiadomosci_Kanal_Nadawczy (kanal_id, tresc) VALUES
(1, 'Witamy wszystkich nowych cz�onk�w kana�u!'),
(1, 'Nie zapomnijcie o dzisiejszym spotkaniu grupowym.'),
(2, 'Kto wybiera si� na wycieczk� w g�ry w ten weekend?'),
(2, 'Dzisiaj o 18:00 omawiamy sprz�t wspinaczkowy.'),
(3, 'Kiedy mo�emy zrobi� kolejne zdj�cia grupowe?'),
(3, 'Szukam ch�tnego do wsp�pracy przy projekcie fotograficznym.'),
(4, 'Pami�tajcie, aby przes�a� swoje raporty przed 15:00.'),
(4, 'Mamy nowe zadania do realizacji w zespole IT.'),
(5, 'Prosz�, sprawd�cie dost�pne terminy na warsztaty.'),
(5, 'Zapraszamy do udzia�u w jutrzejszym webinarze.');
GO

-- Dane do tabeli Wydarzenia
INSERT INTO Wydarzenia (autor_id, tytul, opis, miejsce, data_rozpoczecia, data_zakonczenia) VALUES
(1, 'Spotkanie mi�o�nik�w ksi��ek', 'Dyskusja o nowo�ciach wydawniczych.', 'Warszawa, Biblioteka Publiczna', '2024-01-15', '2024-01-15'),
(2, 'Wspinaczka w Tatrach', 'Organizujemy grupow� wspinaczk�.', 'Zakopane, Tatry', '2024-03-10', '2024-03-12'),
(3, 'Warsztaty kulinarne', 'Gotujemy potrawy z r�nych zak�tk�w �wiata.', 'Krak�w, Centrum Kulinarne', '2024-02-20', '2024-02-20'),
(4, 'Maraton biegowy', 'Bieg przez miasto dla amator�w i zawodowc�w.', 'Pozna�, Plac Wolno�ci', '2024-04-01', '2024-04-01'),
(5, 'Prelekcja o filmach sci-fi', 'Spotkanie z re�yserami i fanami gatunku.', 'Wroc�aw, Kino Nowe Horyzonty', '2024-01-25', '2024-01-25'),
(6, 'Warsztaty IT', 'Szkolenie z najnowszych technologii.', '��d�, Centrum Konferencyjne', '2024-03-05', '2024-03-06'),
(7, 'Fotospacer w parku', 'Grupowe robienie zdj�� w plenerze.', 'Gda�sk, Park Oliwski', '2024-02-10', '2024-02-10'),
(8, 'Targi fitness', 'Prezentacja sprz�tu i suplement�w diety.', 'Katowice, Spodek', '2024-05-15', '2024-05-16'),
(9, 'Spotkanie mi�o�nik�w zwierz�t', 'Dzie� adopcji i wystawa zwierz�t.', 'Sopot, Hala Widowiskowa', '2024-02-25', '2024-02-25'),
(10, 'Wyjazd podr�niczy', 'Zwiedzanie najpi�kniejszych miejsc w Polsce.', 'Zakopane, Krup�wki', '2024-06-01', '2024-06-05');
GO

-- Dane do tabeli Zainteresowani_Wydarzenia
INSERT INTO Zainteresowani_Wydarzenia (wydarzenie_id, uzytkownik_id) VALUES
(1, 1), (1, 3), (2, 4), (2, 5), (3, 2),
(4, 6), (5, 7), (6, 8), (7, 9), (8, 10);
GO

----------------------------------------------------
----- WSTAWIANIE PRZYK�ADOWYCH B��DNYCH DANYCH -----
----------------------------------------------------
/*
INSERT INTO Lokalizacja (kraj, miejscowosc, ulica, nr_domu, nr_mieszkania, informacje_dodatkowe) VALUES
(NULL, 'Warszawa', 'Marsza�kowska', '10', '15', 'Brak kraju') -- NULL w polu kraj
GO

INSERT INTO Uzytkownicy (imie, nazwisko, data_urodzenia, miejscowosc, kraj, plec, pseudonim, lokalizacja_marketplace) VALUES
('Kamil', 'Kowalski', '2025-01-01', 'Warszawa', 'Polska', 'M�czyzna', 'KamilK', 1); -- Data urodzenia w przysz�o�ci
GO

INSERT INTO Uzytkownicy (imie, nazwisko, data_urodzenia, miejscowosc, kraj, plec, pseudonim, lokalizacja_marketplace) VALUES
('Tomasz', 'Wi�niewski', '1990-13-03', 'Gda�sk', 'Polska', 'M�czyzna', 'TomekW', 3); -- Nieistniej�ca data
GO

INSERT INTO Posty (autor_id, tytul, opis, rodzaj, grupa_id) VALUES
(1, 'Najlepsze ksi��ki 1998', 'Jakie ksi��ki znacie i polecacie?', 'Kontent', 1); -- Nieistenij�cy rodzaj postu
GO

INSERT INTO Wydarzenia (autor_id, tytul, opis, miejsce, data_rozpoczecia, data_zakonczenia) VALUES
(1, 'Spotkanie mi�o�nik�w ksi��ek', 'Dyskusja o nowo�ciach wydawniczych.', 'Warszawa, Biblioteka Publiczna', '2025-01-15', '2024-01-15'); -- Rozpocz�cie wydarzenia po zako�czeniu
GO

INSERT INTO Marketplace (ogloszeniodawca_id, tytul, opis, kategoria, cena, cena_do_negocjacji, mozliwosc_przesylki) VALUES
(1, 'Sprzedam rower g�rski', 'Rower w bardzo dobrym stanie, u�ywany kilka razy.', 'Komputery', 1200, 1, 1); -- Nieistniej�ca kategoria
GO
*/

--------------------------------------------
----- AKTUALIZACJA PRZYK�ADOWYCH TABEL -----
--------------------------------------------

-- Aktualizacja tabeli Uzytkownicy
UPDATE Uzytkownicy
SET nazwisko = 'Kowalski-Nowak'
WHERE uzytkownik_id = 1;
GO

SELECT * FROM Uzytkownicy
WHERE uzytkownik_id = 1;
GO

-- Aktualizacja tabeli Posty
UPDATE Posty
SET tytul = 'Najlepsze ksi��ki minionych lat'
WHERE post_id = 1;
GO

SELECT * FROM Posty
WHERE post_id = 1;
GO

-- Aktualizacja tabeli Marketplace
UPDATE Marketplace
SET cena = cena * 1.1
WHERE ogloszenie_id = 1;
GO

SELECT * FROM Marketplace
WHERE ogloszenie_id = 1;
GO

--------------------------
--- TWORZENIE PROCEDUR ---
--------------------------

-- Procedura dodaj�ca u�ytkownika
CREATE OR ALTER PROCEDURE AddUser
    @pImie NVARCHAR(50),
    @pNazwisko NVARCHAR(50),
    @pUrodziny DATE,
    @pMiejscowosc NVARCHAR(50) = NULL,
    @pKraj NVARCHAR(50) = NULL,
    @pPlec NVARCHAR(9) = NULL,
    @pPseudonim NVARCHAR(9),
    @pLokacja BIT,
    @lKraj NVARCHAR(50) = NULL,
    @lMiejscowosc NVARCHAR(100) = NULL,
    @lUlica NVARCHAR(100) = NULL,
    @lNrDom NVARCHAR(10) = NULL,
    @lNrMieszkanie NVARCHAR(10) = NULL,
    @lInfo NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @LocID INT;

        IF @pLokacja = 1
        BEGIN
            INSERT INTO Lokalizacja (kraj, miejscowosc, ulica, nr_domu, nr_mieszkania, informacje_dodatkowe)
            VALUES (@lKraj, @lMiejscowosc, @lUlica, @lNrDom, @lNrMieszkanie, @lInfo);

            SET @LocID = SCOPE_IDENTITY();
        END
        ELSE
        BEGIN
            SET @LocID = NULL;
        END

        INSERT INTO Uzytkownicy (imie, nazwisko, data_urodzenia, miejscowosc, kraj, plec, pseudonim, lokalizacja_marketplace)
        VALUES (@pImie, @pNazwisko, @pUrodziny, @pMiejscowosc, @pKraj, @pPlec, @pPseudonim, @LocID);

        PRINT 'Operacja zako�czy�a si� sukcesem: U�ytkownik zosta� dodany.';
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        PRINT 'Operacja nie powiod�a si�: ' + @ErrorMessage;

        THROW @ErrorSeverity, @ErrorMessage, @ErrorState;
    END CATCH
END
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Procedura dodaj�ca u�ytkownika', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Procedure', @level1name = N'AddUser';

-- Przyk�adowe wywo�ania:
-- Poprawne
EXEC AddUser 
    @pImie = 'Szymon',
    @pNazwisko = 'G�siewicz',
    @pUrodziny = '1991-02-12',
    @pPseudonim = '5hymon',
    @pLokacja = 0;
GO

-- Poprawne
EXEC AddUser 
    @pImie = 'Jan',
    @pNazwisko = 'Kowalski',
    @pUrodziny = '1985-06-15',
    @pMiejscowosc = 'Warszawa',
    @pKraj = 'Polska',
    @pPlec = 'M�czyzna',
    @pPseudonim = 'Janek85',
    @pLokacja = 1,
    @lKraj = 'Polska',
    @lMiejscowosc = 'Warszawa',
    @lUlica = 'Krakowska',
    @lNrDom = '15',
    @lNrMieszkanie = '10',
    @lInfo = 'Blisko centrum';
GO

-- Poprawne
EXEC AddUser 
    @pImie = 'Kamil',
    @pNazwisko = 'Kowaleski',
    @pUrodziny = '1992-06-28',
    @pMiejscowosc = '��d�',
    @pKraj = 'Polska',
    @pPlec = 'M�czyzna',
    @pPseudonim = '�limak',
    @pLokacja = 0;
GO

-- Niepoprawne
/*EXEC AddUser 
    @pImie = 'Konrad',
	@pNazwisko = NULL,
    @pUrodziny = '1972-09-20',
    @pMiejscowosc = 'Bydgoszcz',
    @pPlec = 'M�czyzna',
    @pPseudonim = 'Kondi',
    @pLokacja = 1;
GO*/

SELECT * FROM Uzytkownicy
SELECT * FROM Lokalizacja
GO

-- Procedura edytuj�ca dane u�ytkownika
CREATE OR ALTER PROCEDURE UpdateUser
    @UserID INT,
    @pImie NVARCHAR(50) = NULL,
    @pNazwisko NVARCHAR(50) = NULL,
    @pUrodziny NVARCHAR(50) = NULL,
    @pMiejscowosc NVARCHAR(50) = NULL,
    @pKraj NVARCHAR(50) = NULL,
    @pPlec NVARCHAR(9) = NULL,
    @pPseudonim NVARCHAR(20) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF @pImie IS NULL AND @pNazwisko IS NULL AND @pUrodziny IS NULL AND 
           @pMiejscowosc IS NULL AND @pKraj IS NULL AND @pPlec IS NULL AND @pPseudonim IS NULL
        BEGIN
            RAISERROR ('Nie dokonano zmian: brak parametr�w do zmiany.', 16, 1);
            RETURN;
        END

        UPDATE Uzytkownicy
        SET 
            imie = CASE WHEN @pImie = 'null' THEN NULL 
                        WHEN @pImie IS NOT NULL THEN @pImie 
                        ELSE imie END,
            nazwisko = CASE WHEN @pNazwisko = 'null' THEN NULL 
                            WHEN @pNazwisko IS NOT NULL THEN @pNazwisko 
                            ELSE nazwisko END,
            data_urodzenia = CASE WHEN @pUrodziny = 'null' THEN NULL 
                                  WHEN @pUrodziny IS NOT NULL THEN CAST(@pUrodziny AS DATE) 
                                  ELSE data_urodzenia END,
            miejscowosc = CASE WHEN @pMiejscowosc = 'null' THEN NULL 
                               WHEN @pMiejscowosc IS NOT NULL THEN @pMiejscowosc 
                               ELSE miejscowosc END,
            kraj = CASE WHEN @pKraj = 'null' THEN NULL 
                        WHEN @pKraj IS NOT NULL THEN @pKraj 
                        ELSE kraj END,
            plec = CASE WHEN @pPlec = 'null' THEN NULL 
                        WHEN @pPlec IS NOT NULL THEN @pPlec 
                        ELSE plec END,
            pseudonim = CASE WHEN @pPseudonim = 'null' THEN NULL 
                             WHEN @pPseudonim IS NOT NULL THEN @pPseudonim 
                             ELSE pseudonim END
        WHERE uzytkownik_id = @UserID;

        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR ('Nie znaleziono u�ytkownika o podanym ID.', 16, 1);
        END
        ELSE
        BEGIN
            PRINT 'Dane u�ytkownika zosta�y zaktualizowane pomy�lnie.';
        END
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        PRINT 'Wyst�pi� b��d podczas aktualizacji danych u�ytkownika: ' + @ErrorMessage;

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Procedura edytuj�ca dane u�ytkownika', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Procedure', @level1name = N'UpdateUser';

-- Przyk�adowe wywo�ania:
-- Poprawne
EXEC UpdateUser 
    @UserID = 12,
    @pPseudonim = 'NowyPseudonim';
GO

-- Poprawne
EXEC UpdateUser 
    @UserID = 12,
    @pMiejscowosc = 'null';
GO

-- Niepoprawne
/*EXEC UpdateUser 
    @UserID = 12;
GO

-- Niepoprawne
EXEC UpdateUser 
    @UserID = 999,
    @pImie = 'Jan';
GO

-- Niepoprawne
EXEC UpdateUser 
    @UserID = 12,
    @pImie = 'null';
GO*/

SELECT * FROM Uzytkownicy
GO

-- Procedura usuwaj�ca u�ytkownika
CREATE OR ALTER PROCEDURE DeleteUser
    @UserID INT
AS
BEGIN
	SET NOCOUNT ON;

    BEGIN TRY
		DELETE FROM Uzytkownicy
		WHERE uzytkownik_id = @UserID;

		IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR ('Nie znaleziono u�ytkownika o podanym ID.', 16, 1);
        END
        ELSE
        BEGIN
            PRINT 'Dane u�ytkownika zosta�y pomy�lnie usuni�te.';
        END
	END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        PRINT 'Wyst�pi� b��d podczas usuwania u�ytkownika: ' + @ErrorMessage;

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Procedura usuwaj�ca u�ytkownika', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Procedure', @level1name = N'DeleteUser';

-- Przyk�adowe wywo�ania:
-- Poprawne
EXEC DeleteUser
    @UserID = 13;
GO

-- Niepoprawne
/*EXEC DeleteUser
    @UserID = 99;
GO*/

SELECT * FROM Uzytkownicy
GO

-- Procedura dodaj�ca oferte sprzeda�y na Marketplace
CREATE OR ALTER PROCEDURE AddOffer
    @pOgloszeniodawca INT,
	@pTytul NVARCHAR(200),
	@pOpis NVARCHAR(MAX) = NULL,
	@pKategoria NVARCHAR(50),
	@pCena MONEY,
	@pNegocjacja BIT,
	@pPrzesylka BIT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        INSERT INTO Marketplace (ogloszeniodawca_id, tytul, opis, kategoria, cena, cena_do_negocjacji, mozliwosc_przesylki, aktywne)
        VALUES (@pOgloszeniodawca, @pTytul, @pOpis, @pKategoria, @pCena, @pNegocjacja, @pPrzesylka, 1);

        PRINT 'Operacja zako�czy�a si� sukcesem: Og�oszenie zosta�o dodane.';
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        PRINT 'Operacja nie powiod�a si�: ' + @ErrorMessage;

        THROW @ErrorSeverity, @ErrorMessage, @ErrorState;
    END CATCH
END
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Procedura dodaj�ca oferte sprzeda�y na Marketplace', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Procedure', @level1name = N'AddOffer';

-- Przyk�adowe wywo�ania:
-- Poprawne
EXEC AddOffer
	@pOgloszeniodawca = 12,
	@pTytul = 'Rowerek dla dziecka',
	@pOpis = NULL,
	@pKategoria = 'Dla dzieci',
	@pCena = 300,
	@pNegocjacja = 0,
	@pPrzesylka = 1
GO

-- Niepoprawne
/*EXEC AddOffer
	@pOgloszeniodawca = 99,
	@pTytul = 'Rowerek dla dziecka',
	@pOpis = NULL,
	@pKategoria = 'Dla dzieci',
	@pCena = 300,
	@pNegocjacja = 0,
	@pPrzesylka = 1
GO*/

SELECT * FROM Marketplace
GO

-- Procedura edytuj�ca og�oszenie na Marketplace
CREATE OR ALTER PROCEDURE ModifyOffer
    @pOgloszenie INT,
	@pTytul NVARCHAR(200) = NULL,
	@pOpis NVARCHAR(MAX) = NULL,
	@pKategoria NVARCHAR(50) = NULL,
	@pCena NVARCHAR(50) = NULL,
	@pNegocjacja NVARCHAR(4) = NULL,
	@pPrzesylka NVARCHAR(4) = NULL,
	@pAktywne NVARCHAR(4) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF @pTytul IS NULL AND @pOpis IS NULL AND @pKategoria IS NULL AND 
           @pCena IS NULL AND @pNegocjacja IS NULL AND @pPrzesylka IS NULL AND @pAktywne IS NULL
        BEGIN
            RAISERROR ('Nie dokonano zmian: brak parametr�w do zmiany.', 16, 1);
            RETURN;
        END

        UPDATE Marketplace
        SET 
            tytul = CASE WHEN @pTytul = 'null' THEN NULL 
                        WHEN @pTytul IS NOT NULL THEN @pTytul 
                        ELSE tytul END,
            opis = CASE WHEN @pOpis = 'null' THEN NULL 
                        WHEN @pOpis IS NOT NULL THEN @pOpis 
                        ELSE opis END,
            kategoria = CASE WHEN @pKategoria = 'null' THEN NULL 
                        WHEN @pKategoria IS NOT NULL THEN @pKategoria 
                        ELSE kategoria END,
            cena = CASE WHEN @pCena = 'null' THEN NULL 
                        WHEN @pCena IS NOT NULL THEN CAST(@pCena AS MONEY)
                        ELSE cena END,
            cena_do_negocjacji = CASE WHEN @pNegocjacja = 'null' THEN NULL 
                        WHEN @pNegocjacja IS NOT NULL AND @pNegocjacja = '1' THEN 1
						WHEN @pNegocjacja IS NOT NULL AND @pNegocjacja = '0' THEN 0
                        ELSE cena_do_negocjacji END,
            mozliwosc_przesylki = CASE WHEN @pPrzesylka = 'null' THEN NULL 
                        WHEN @pPrzesylka IS NOT NULL AND @pPrzesylka = '1' THEN 1
						WHEN @pPrzesylka IS NOT NULL AND @pPrzesylka = '0' THEN 0
                        ELSE mozliwosc_przesylki END,
            aktywne = CASE WHEN @pAktywne = 'null' THEN NULL 
                        WHEN @pAktywne IS NOT NULL AND @pAktywne = '1' THEN 1
						WHEN @pAktywne IS NOT NULL AND @pNegocjacja = '0' THEN 0
                        ELSE aktywne END
        WHERE ogloszenie_id = @pOgloszenie;

        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR ('Nie znaleziono og�oszenia o podanym ID.', 16, 1);
        END
        ELSE
        BEGIN
            PRINT 'Dane og�oszenia zosta�y zaktualizowane pomy�lnie.';
        END
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        PRINT 'Wyst�pi� b��d podczas aktualizacji danych og�oszenia: ' + @ErrorMessage;

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Procedura edytuj�ca og�oszenie na Marketplace', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Procedure', @level1name = N'ModifyOffer';

-- Przyk�adowe wywo�ania:
-- Poprawne
EXEC ModifyOffer
	@pOgloszenie = 11,
	@pOpis = 'Rowerek ma�y i fajny i zadbany',
	@pCena = 1190
GO

-- Niepoprawne
/*EXEC ModifyOffer
	@pOgloszenie = 11
GO

-- Niepoprawne
EXEC ModifyOffer
	@pOgloszenie = 11,
	@pCena = 'null'
GO*/

SELECT * FROM Marketplace
GO

-- Procedura sprzedaj�ca og�oszenie z Marketplace i dodaj�ca do tabeli Zakupy
CREATE OR ALTER PROCEDURE TradeOffer
    @pOgloszenie INT,
    @pKupujacy INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (
            SELECT 1 
            FROM Marketplace 
            WHERE ogloszenie_id = @pOgloszenie AND aktywne = 1
        )
        BEGIN
            RAISERROR ('Og�oszenie nie istnieje lub jest ju� nieaktywne.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        DECLARE @Sprzedawca INT;
        DECLARE @Cena MONEY;
        DECLARE @DaneWysylkowe INT;

        SELECT 
            @Sprzedawca = ogloszeniodawca_id,
            @Cena = cena
        FROM Marketplace
        WHERE ogloszenie_id = @pOgloszenie;

		SELECT 
            @DaneWysylkowe = lokalizacja_marketplace
        FROM Uzytkownicy
        WHERE uzytkownik_id = @pKupujacy;

        INSERT INTO Zakupy (sprzedajacy_id, kupujacy_id, kwota_zakupu, dane_wysylkowe, ogloszenie_id)
        VALUES (@Sprzedawca, @pKupujacy, @Cena, @DaneWysylkowe, @pOgloszenie);

        UPDATE Marketplace
        SET aktywne = 0
        WHERE ogloszenie_id = @pOgloszenie;

        COMMIT TRANSACTION;

        PRINT 'Og�oszenie zosta�o pomy�lnie sprzedane.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        PRINT 'Wyst�pi� b��d podczas sprzeda�y og�oszenia: ' + @ErrorMessage;

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Procedura sprzedaj�ca og�oszenie z Marketplace i dodaj�ca do tabeli Zakupy', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Procedure', @level1name = N'TradeOffer';

-- Przyk�adowe wywo�ania:
-- Poprawne
EXEC TradeOffer
	@pOgloszenie = 11,
	@pKupujacy = 12
GO

-- Poprawne
EXEC TradeOffer
	@pOgloszenie = 10,
	@pKupujacy = 12
GO

-- Niepoprawne
/*EXEC TradeOffer
	@pOgloszenie = 11,
	@pKupujacy = 12
GO

-- Niepoprawne
EXEC TradeOffer
	@pOgloszenie = 99,
	@pKupujacy = 12
GO

-- Niepoprawne
EXEC TradeOffer
	@pOgloszenie = 10,
	@pKupujacy = 99
GO*/

SELECT * FROM Marketplace
GO
SELECT * FROM Zakupy
GO
SELECT * FROM Uzytkownicy
GO

-- Procedura usuwaj�ca dane og�oszenie z Marketplace
CREATE OR ALTER PROCEDURE DeleteOffer
    @OfferID INT
AS
BEGIN
	SET NOCOUNT ON;

    BEGIN TRY
		DELETE FROM Marketplace
		WHERE ogloszenie_id = @OfferID;

		IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR ('Nie znaleziono og�oszenia o podanym ID.', 16, 1);
        END
        ELSE
        BEGIN
            PRINT 'Dane og�oszenie zosta�o pomy�lnie usuni�te.';
        END
	END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        PRINT 'Wyst�pi� b��d podczas usuwania og�oszenia: ' + @ErrorMessage;

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Procedura usuwaj�ca dane og�oszenie z Marketplace', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Procedure', @level1name = N'DeleteOffer';

-- Przyk�adowe wywo�ania:
-- Poprawne
EXEC DeleteOffer
	@OfferID = 11
GO

/*EXEC DeleteOffer
	@OfferID = 99
GO*/

SELECT * FROM Marketplace
GO
SELECT * FROM Zakupy
GO

-- Procedura edytuj�ca lokalizacje
CREATE OR ALTER PROCEDURE EditLocation
    @LocationID INT,
    @pKraj NVARCHAR(50) = NULL,
    @pMiejscowo�� NVARCHAR(100) = NULL,
    @pUlica NVARCHAR(100) = NULL,
    @pNrDomu NVARCHAR(10) = NULL,
    @pNrMieszkania NVARCHAR(10) = NULL,
    @pInfo NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF @pKraj IS NULL AND @pMiejscowo�� IS NULL AND 
           @pUlica IS NULL AND @pNrDomu IS NULL AND @pNrMieszkania IS NULL AND @pInfo IS NULL
        BEGIN
            RAISERROR ('Nie dokonano zmian: brak parametr�w do zmiany.', 16, 1);
            RETURN;
        END

        UPDATE Lokalizacja
        SET 
            kraj = CASE WHEN @pKraj = 'null' THEN NULL 
                        WHEN @pKraj IS NOT NULL THEN @pKraj 
                        ELSE kraj END,
            miejscowosc = CASE WHEN @pMiejscowo�� = 'null' THEN NULL 
                            WHEN @pMiejscowo�� IS NOT NULL THEN @pMiejscowo�� 
                            ELSE miejscowosc END,
            ulica = CASE WHEN @pUlica = 'null' THEN NULL 
                                  WHEN @pUlica IS NOT NULL THEN @pUlica
                                  ELSE ulica END,
            nr_domu = CASE WHEN @pNrDomu = 'null' THEN NULL 
                               WHEN @pNrDomu IS NOT NULL THEN @pNrDomu 
                               ELSE nr_domu END,
            nr_mieszkania = CASE WHEN @pNrMieszkania = 'null' THEN NULL 
                        WHEN @pNrMieszkania IS NOT NULL THEN @pNrMieszkania 
                        ELSE nr_mieszkania END,
            informacje_dodatkowe = CASE WHEN @pInfo = 'null' THEN NULL 
                        WHEN @pInfo IS NOT NULL THEN @pInfo 
                        ELSE informacje_dodatkowe END
        WHERE lokalizacja_id = @LocationID;

        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR ('Lokalizacja u�ytkownika nie istnieje.', 16, 1);
        END
        ELSE
        BEGIN
            PRINT 'Dane lokalizacji zosta�y zaktualizowane pomy�lnie.';
        END
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        PRINT 'Wyst�pi� b��d podczas aktualizacji lokalizacji: ' + @ErrorMessage;

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Procedura edytuj�ca lokalizacje', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Procedure', @level1name = N'EditLocation';

-- Przyk�adowe wywo�ania:
-- Niepoprawne
/*EXEC EditLocation
	@LocationID = 11
GO

-- Niepoprawne
EXEC EditLocation
	@LocationID = 99,
	@pInfo = 'Daleko Centrum'
GO*/

-- Poprawne
EXEC EditLocation
	@LocationID = 11,
	@pInfo = 'Daleko Centrum'
GO

SELECT * FROM Lokalizacja
GO

-- Procedura dodaj�ca lokalizacje do u�ytkownika
CREATE OR ALTER PROCEDURE AddLocation
	@pUserID INT,
    @pKraj NVARCHAR(50) = NULL,
    @pMiejscowo�� NVARCHAR(100) = NULL,
    @pUlica NVARCHAR(100) = NULL,
    @pNrDomu NVARCHAR(10) = NULL,
    @pNrMieszkania NVARCHAR(10) = NULL,
    @pInfo NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
		IF (SELECT 1 FROM Uzytkownicy WHERE uzytkownik_id = @pUserID) IS NULL
		BEGIN
            RAISERROR ('Uzytkownik o podanym ID nie istnieje.', 16, 1);
			RETURN;
        END
		DECLARE @LocID INT;

        INSERT INTO Lokalizacja(kraj, miejscowosc, ulica, nr_domu, nr_mieszkania, informacje_dodatkowe)
        VALUES (@pKraj, @pMiejscowo��, @pUlica, @pNrDomu, @pNrMieszkania, @pInfo);

		SET @LocID = SCOPE_IDENTITY();

		UPDATE Uzytkownicy
		SET lokalizacja_marketplace = @LocID
		WHERE uzytkownik_id = @pUserID;

        PRINT 'Operacja zako�czy�a si� sukcesem: Lokalizacja zosta�a dodana.';
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        PRINT 'Operacja nie powiod�a si�: ' + @ErrorMessage;

        THROW @ErrorSeverity, @ErrorMessage, @ErrorState;
    END CATCH
END
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Procedura dodaj�ca lokalizacje do u�ytkownika', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Procedure', @level1name = N'AddLocation';

-- Przyk�adowe wywo�ania:
-- Poprawne
EXEC AddLocation
	@pUserID = 11,
	@pKraj = 'Argentyna',
    @pMiejscowo�� = 'Buenos Aires',
    @pUlica = 'Buenos Noches',
    @pNrDomu = '76'
GO

-- Niepoprawne
/*EXEC AddLocation
	@pUserID = 99,
	@pKraj = 'Argentyna',
    @pMiejscowo�� = 'Buenos Aires',
    @pUlica = 'Buenos Noches',
    @pNrDomu = '76'
GO

-- Niepoprawne
EXEC AddLocation
	@pUserID = 12,
	@pKraj = 'Argentyna',
    @pMiejscowo�� = 'Buenos Aires'
GO*/

SELECT * FROM Uzytkownicy
GO
SELECT * FROM Lokalizacja
GO

-- Procedura tworz�ca kana� nadawczy
CREATE OR ALTER PROCEDURE CreateChannel
    @UserID INT,
    @ChannelName NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF EXISTS (SELECT 1 FROM Kanal_Nadawczy WHERE nazwa = @ChannelName)
        BEGIN
            RAISERROR ('Kana� o podanej nazwie ju� istnieje.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        INSERT INTO Kanal_Nadawczy (nazwa, nadawca_id)
        VALUES (@ChannelName, @UserID);

        INSERT INTO Czlonkowie_Kanal_Nadawczy (kanal_id, uzytkownik_id)
        SELECT kanal_id, @UserID FROM Kanal_Nadawczy WHERE nazwa = @ChannelName;

        COMMIT TRANSACTION;

        PRINT 'Kana� zosta� pomy�lnie utworzony.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        PRINT 'Wyst�pi� b��d podczas tworzenia kana�u: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Procedura tworz�ca kana� nadawczy', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Procedure', @level1name = N'CreateChannel';

-- Przyk�adowe wywo�ania:
-- Poprawne
EXEC CreateChannel 
	@UserID = 11, 
	@ChannelName = 'TechNews';
GO
-- Niepoprawne
/*EXEC CreateChannel 
	@UserID = 1, 
	@ChannelName = 'TechNews';
GO

-- Niepoprawne
EXEC CreateChannel 
	@UserID = 99, 
	@ChannelName = 'MotoCrew';
GO*/

SELECT * FROM Kanal_Nadawczy
GO

-- Procedura edytuj�ca kana� nadawczy
CREATE OR ALTER PROCEDURE EditChannel
    @UserID INT,
    @OldChannelName NVARCHAR(MAX),
    @NewChannelName NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

		IF NOT EXISTS (SELECT 1 FROM Kanal_Nadawczy WHERE nazwa = @OldChannelName)
        BEGIN
            RAISERROR ('Brak kana�u o takiej nazwie.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM Kanal_Nadawczy WHERE nazwa = @OldChannelName AND nadawca_id = @UserID)
        BEGIN
            RAISERROR ('Brak uprawnie� do edycji tego kana�u.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        UPDATE Kanal_Nadawczy
        SET nazwa = @NewChannelName
        WHERE nazwa = @OldChannelName;

        COMMIT TRANSACTION;

        PRINT 'Nazwa kana�u zosta�a zmieniona.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        PRINT 'Wyst�pi� b��d podczas edycji kana�u: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Procedura edytuj�ca kana� nadawczy', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Procedure', @level1name = N'EditChannel';

-- Przyk�adowe wywo�ania:
-- Poprawne
EXEC EditChannel @UserID = 11, @OldChannelName = 'TechNews', @NewChannelName = 'TechUpdates';
GO

-- Niepoprawne
/*EXEC EditChannel @UserID = 2, @OldChannelName = 'TechUpdates', @NewChannelName = 'GlobalNews';
GO

-- Niepoprawne
EXEC EditChannel @UserID = 99, @OldChannelName = 'TechUpdates', @NewChannelName = 'GlobalNews';
GO

-- Niepoprawne
EXEC EditChannel @UserID = 1, @OldChannelName = 'MotoCrew', @NewChannelName = 'GlobalNews';
GO*/

SELECT * FROM Kanal_Nadawczy
GO

-- Procedura do��czaj�ca u�ytkownika do kana�u nadawczego
CREATE OR ALTER PROCEDURE JoinChannel
    @UserID INT,
    @ChannelName NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @ChannelID INT;
        SELECT @ChannelID = kanal_id FROM Kanal_Nadawczy WHERE nazwa = @ChannelName;

        IF @ChannelID IS NULL
        BEGIN
            RAISERROR ('Kana� o podanej nazwie nie istnieje.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        IF EXISTS (SELECT 1 FROM Czlonkowie_Kanal_Nadawczy WHERE kanal_id = @ChannelID AND uzytkownik_id = @UserID)
        BEGIN
            RAISERROR ('Ju� jeste� na tym kanale.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        INSERT INTO Czlonkowie_Kanal_Nadawczy (kanal_id, uzytkownik_id)
        VALUES (@ChannelID, @UserID);

        COMMIT TRANSACTION;

        PRINT 'Pomy�lnie do��czono do kana�u.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        PRINT 'Wyst�pi� b��d podczas do��czania do kana�u: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Procedura do��czaj�ca u�ytkownika do kana�u nadawczego', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Procedure', @level1name = N'JoinChannel';

-- Przyk�adowe wywo�ania:
-- Poprawne
EXEC JoinChannel @UserID = 2, @ChannelName = 'TechUpdates';
GO

-- Niepoprawne
/*EXEC JoinChannel @UserID = 2, @ChannelName = 'TechUpdates';
GO

-- Niepoprawne
EXEC JoinChannel @UserID = 2, @ChannelName = 'MotoCrew';
GO*/

SELECT * FROM Czlonkowie_Kanal_Nadawczy
GO

-- Procedura usuwaj�ca u�ytkownika z kana�u nadawczego
CREATE OR ALTER PROCEDURE LeaveChannel
    @UserID INT,
    @ChannelName NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @ChannelID INT;
        SELECT @ChannelID = kanal_id FROM Kanal_Nadawczy WHERE nazwa = @ChannelName;

        IF @ChannelID IS NULL
        BEGIN
            RAISERROR ('Kana� o podanej nazwie nie istnieje.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        IF EXISTS (SELECT 1 FROM Kanal_Nadawczy WHERE kanal_id = @ChannelID AND nadawca_id = @UserID)
        BEGIN
            RAISERROR ('Nie mo�esz opu�ci� kana�u, kt�rego jeste� w�a�cicielem.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

		IF NOT EXISTS (SELECT 1 FROM Czlonkowie_Kanal_Nadawczy WHERE kanal_id = @ChannelID AND uzytkownik_id = @UserID)
        BEGIN
            RAISERROR ('Nie mo�esz opu�ci� kana�u, kt�rego nie jeste� cz�onkiem.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        DELETE FROM Czlonkowie_Kanal_Nadawczy
        WHERE kanal_id = @ChannelID AND uzytkownik_id = @UserID;

        COMMIT TRANSACTION;

        PRINT 'Pomy�lnie opu�ci�e� kana�.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        PRINT 'Wyst�pi� b��d podczas opuszczania kana�u: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Procedura usuwaj�ca u�ytkownika z kana�u nadawczego', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Procedure', @level1name = N'LeaveChannel';

-- Przyk�adowe wywo�ania:
-- Poprawne
EXEC LeaveChannel @UserID = 2, @ChannelName = 'TechUpdates';
GO

-- Niepoprawne
/*EXEC LeaveChannel @UserID = 11, @ChannelName = 'TechUpdates';
GO

-- Niepoprawne
EXEC LeaveChannel @UserID = 2, @ChannelName = 'MotoCrew';
GO

-- Niepoprawne
EXEC LeaveChannel @UserID = 99, @ChannelName = 'TechUpdates';
GO*/

SELECT * FROM Czlonkowie_Kanal_Nadawczy
GO

-- Procedura do wysy�ania wiadomo�ci na kanale nadawczym
CREATE OR ALTER PROCEDURE SendMessage
    @UserID INT,
    @ChannelName NVARCHAR(MAX),
    @Message NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

		IF NOT EXISTS (SELECT 1 FROM Kanal_Nadawczy WHERE nazwa = @ChannelName)
        BEGIN
            RAISERROR ('Nie ma kana�u o podanej nazwie.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM Kanal_Nadawczy WHERE nazwa = @ChannelName AND nadawca_id = @UserID)
        BEGIN
            RAISERROR ('Tylko w�a�ciciel mo�e wysy�a� wiadomo�ci na kanale nadawczym.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        DECLARE @ChannelID INT;
        SELECT @ChannelID = kanal_id FROM Kanal_Nadawczy WHERE nazwa = @ChannelName;

        INSERT INTO Wiadomosci_Kanal_Nadawczy (kanal_id, tresc)
        VALUES (@ChannelID, @Message);

        COMMIT TRANSACTION;

        PRINT 'Wiadomo�� zosta�a wys�ana.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        PRINT 'Wyst�pi� b��d podczas wysy�ania wiadomo�ci: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Procedura do wysy�ania wiadomo�ci na kanale nadawczym', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Procedure', @level1name = N'SendMessage';

-- Przyk�adowe wywo�ania:
-- Poprawne
EXEC SendMessage @UserID = 11, @ChannelName = 'TechUpdates', @Message = 'Witamy w TechNews!';
GO

-- Niepoprawne
/*EXEC SendMessage @UserID = 2, @ChannelName = 'TechUpdates', @Message = 'Fajny kana�!';
GO

-- Niepoprawne
EXEC SendMessage @UserID = 2, @ChannelName = 'MotoCrew', @Message = 'Fajny kana�!';
GO*/

SELECT * FROM Wiadomosci_Kanal_Nadawczy
GO

-- Procedura do wy�wietlania wiadomo�ci na danym kanale nadawczym
CREATE OR ALTER PROCEDURE ReadMessages
    @UserID INT,
    @ChannelName NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @ChannelID INT;
        SELECT @ChannelID = kanal_id FROM Kanal_Nadawczy WHERE nazwa = @ChannelName;

        IF @ChannelID IS NULL
        BEGIN
            RAISERROR ('Kana� o podanej nazwie nie istnieje.', 16, 1);
            RETURN;
        END

		IF @UserID = -999 GOTO administrator;
        IF NOT EXISTS (
            SELECT 1 FROM Czlonkowie_Kanal_Nadawczy WHERE kanal_id = @ChannelID AND uzytkownik_id = @UserID
        )
        BEGIN
            RAISERROR ('Brak uprawnie� do wy�wietlania wiadomo�ci.', 16, 1);
            RETURN;
        END

		administrator:
        SELECT tresc
        FROM Wiadomosci_Kanal_Nadawczy
        WHERE kanal_id = @ChannelID
        ORDER BY wiadomosc_id;
    END TRY
    BEGIN CATCH
        PRINT 'Wyst�pi� b��d podczas odczytywania wiadomo�ci: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Procedura do wy�wietlania wiadomo�ci na danym kanale nadawczym', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Procedure', @level1name = N'ReadMessages';

-- Przyk�adowe wywo�ania:
-- Poprawne
EXEC ReadMessages @UserID = 11, @ChannelName = 'TechUpdates';
GO

-- Niepoprawne
/*EXEC ReadMessages @UserID = 3, @ChannelName = 'TechUpdates';
GO

-- Niepoprawne
EXEC ReadMessages @UserID = 2, @ChannelName = 'MotoCrew';
GO*/

SELECT * FROM Czlonkowie_Kanal_Nadawczy
GO

-- Procedura do usuwania kan�u nadawczego
CREATE OR ALTER PROCEDURE DeleteChannel
    @UserID INT,
    @ChannelName NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;
		IF @UserID = -999 GOTO administartor;

		IF (SELECT 1 FROM Kanal_Nadawczy WHERE nazwa = @ChannelName) IS NULL
        BEGIN
            RAISERROR ('Kana� o podanej nazwie nie istnieje.', 16, 1);
            RETURN;
        END

        DECLARE @ChannelID INT;
        SELECT @ChannelID = kanal_id FROM Kanal_Nadawczy WHERE nazwa = @ChannelName AND nadawca_id = @UserID;

        IF @ChannelID IS NULL
        BEGIN
            RAISERROR ('Brak uprawnie� do usuni�cia tego kana�u.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

		administartor:
        DELETE FROM Kanal_Nadawczy WHERE kanal_id = @ChannelID;

        COMMIT TRANSACTION;

        PRINT 'Kana� zosta� pomy�lnie usuni�ty.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        PRINT 'Wyst�pi� b��d podczas usuwania kana�u: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Procedura do usuwania kan�u nadawczego', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Procedure', @level1name = N'DeleteChannel';

-- Przyk�adowe wywo�ania:
-- Niepoprawne
/*EXEC DeleteChannel @UserID = 2, @ChannelName = 'TechUpdates';
GO

-- Niepoprawne
EXEC DeleteChannel @UserID = 2, @ChannelName = 'MotoCrew';
GO*/

-- Poprawne
EXEC DeleteChannel @UserID = 11, @ChannelName = 'TechUpdates';
GO

SELECT * FROM Kanal_Nadawczy
GO
SELECT * FROM Wiadomosci_Kanal_Nadawczy
GO
SELECT * FROM Czlonkowie_Kanal_Nadawczy
GO

-- Procedura do dodawania wydarzenia
CREATE OR ALTER PROCEDURE CreateEvent
    @UserID INT,
    @EventName NVARCHAR(200),
    @Description NVARCHAR(MAX),
    @Place NVARCHAR(200),
    @StartDate DATETIME,
    @EndDate DATETIME
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        INSERT INTO Wydarzenia (autor_id, tytul, opis, miejsce, data_rozpoczecia, data_zakonczenia)
        VALUES (@UserID, @EventName, @Description, @Place, @StartDate, @EndDate);

        DECLARE @EventID INT = SCOPE_IDENTITY();

        INSERT INTO Zainteresowani_Wydarzenia(wydarzenie_id, uzytkownik_id)
        VALUES (@EventID, @UserID);

        PRINT 'Wydarzenie zosta�o utworzone pomy�lnie.';
    END TRY
    BEGIN CATCH
        PRINT 'Wyst�pi� b��d podczas tworzenia wydarzenia: ' + ERROR_MESSAGE();
        THROW;
    END CATCH
END;
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Procedura do dodawania wydarzenia', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Procedure', @level1name = N'CreateEvent';

-- Przyk�adowe wywo�ania:
-- Poprawne
EXEC CreateEvent 
    @UserID = 11, 
    @EventName = 'Konferencja IT', 
    @Description = 'Spotkanie dla pasjonat�w IT', 
    @Place = 'Warszawa', 
    @StartDate = '2026-01-15', 
    @EndDate = '2026-01-15';
GO

-- Niepoprawne
/*EXEC CreateEvent 
    @UserID = 2, 
    @EventName = 'Wycieczka g�rska', 
    @Description = 'Wyprawa w Tatry', 
    @Place = 'Zakopane', 
    @StartDate = '2024-06-15', 
    @EndDate = '2024-06-14';
GO*/

SELECT * FROM Wydarzenia
GO
SELECT * FROM Zainteresowani_Wydarzenia
GO

-- Procedura do do��czania do wydarzenia
CREATE OR ALTER PROCEDURE JoinEvent
    @UserID INT,
    @EventName NVARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @EventID INT, @EndDate DATETIME, @OwnerID INT;

        SELECT 
            @EventID = wydarzenie_id, 
            @EndDate = data_zakonczenia,
            @OwnerID = autor_id
        FROM Wydarzenia
        WHERE tytul = @EventName;

        IF @EventID IS NULL
        BEGIN
            PRINT 'Wydarzenie o podanej nazwie nie istnieje.';
            RETURN;
        END

        IF @EndDate < GETDATE()
        BEGIN
            PRINT 'Nie mo�na do��czy� do wydarzenia, kt�re ju� si� zako�czy�o.';
            RETURN;
        END

        IF EXISTS (SELECT 1 FROM Zainteresowani_Wydarzenia WHERE wydarzenie_id = @EventID AND uzytkownik_id = @UserID)
        BEGIN
            PRINT 'Jeste� ju� zainteresowany tym wydarzeniem.';
            RETURN;
        END

        INSERT INTO Zainteresowani_Wydarzenia(wydarzenie_id, uzytkownik_id)
        VALUES (@EventID, @UserID);

        PRINT 'Do��czy�e� do wydarzenia.';
    END TRY
    BEGIN CATCH
        PRINT 'Wyst�pi� b��d podczas do��czania do wydarzenia: ' + ERROR_MESSAGE();
        THROW;
    END CATCH
END;
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Procedura do do��czania do wydarzenia', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Procedure', @level1name = N'JoinEvent';

-- Przyk�adowe wywo�ania:
-- Poprawne
EXEC JoinEvent 
    @UserID = 2, 
    @EventName = 'Konferencja IT';
GO

-- Niepoprawne
/*EXEC JoinEvent 
    @UserID = 2, 
    @EventName = 'Konferencja IT';
GO

-- Niepoprawne
EXEC JoinEvent 
    @UserID = 4, 
    @EventName = 'Spotkanie literackie';
GO*/

SELECT * FROM Wydarzenia
GO
SELECT * FROM Zainteresowani_Wydarzenia
GO

-- Procedura usuwaj�ca wydarzenie
CREATE OR ALTER PROCEDURE DeleteEvent
    @UserID INT,
    @EventName NVARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
		IF @UserID = -999 GOTO administartor;
        DECLARE @EventID INT;

        SELECT @EventID = wydarzenie_id
        FROM Wydarzenia
        WHERE tytul = @EventName AND autor_id = @UserID;

        IF @EventID IS NULL
        BEGIN
            PRINT 'Nie masz uprawnie� do usuni�cia tego wydarzenia.';
            RETURN;
        END

		administartor:
        DELETE FROM Wydarzenia
        WHERE wydarzenie_id = @EventID;

        PRINT 'Wydarzenie zosta�o usuni�te.';
    END TRY
    BEGIN CATCH
        PRINT 'Wyst�pi� b��d podczas usuwania wydarzenia: ' + ERROR_MESSAGE();
        THROW;
    END CATCH
END;
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Procedura usuwaj�ca wydarzenie', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Procedure', @level1name = N'DeleteEvent';

-- Przyk�adowe wywo�ania:
-- Niepoprawne
/*EXEC DeleteEvent 
    @UserID = 1, 
    @EventName = 'Konferencja IT';
GO*/

-- Poprawne
EXEC DeleteEvent 
    @UserID = 11, 
    @EventName = 'Konferencja IT';
GO

SELECT * FROM Wydarzenia
GO
SELECT * FROM Zainteresowani_Wydarzenia
GO

-- Procedura edytuj�ca wydarzenie
CREATE OR ALTER PROCEDURE EditEvent
    @UserID INT,
    @EventName NVARCHAR(200),
    @NewName NVARCHAR(200) = NULL,
    @NewDescription NVARCHAR(MAX) = NULL,
    @NewPlace NVARCHAR(200) = NULL,
    @NewStartDate DATETIME = NULL,
    @NewEndDate DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @EventID INT;

        SELECT @EventID = wydarzenie_id
        FROM Wydarzenia
        WHERE tytul = @EventName AND autor_id = @UserID;

        IF @EventID IS NULL
        BEGIN
            PRINT 'Nie masz uprawnie� do edycji tego wydarzenia.';
            RETURN;
        END

        UPDATE Wydarzenia
        SET 
            tytul = ISNULL(@NewName, tytul),
            opis = ISNULL(@NewDescription, opis),
            miejsce = ISNULL(@NewPlace, miejsce),
            data_rozpoczecia = ISNULL(@NewStartDate, data_rozpoczecia),
            data_zakonczenia = ISNULL(@NewEndDate, data_zakonczenia)
        WHERE wydarzenie_id = @EventID;

        PRINT 'Wydarzenie zosta�o zaktualizowane.';
    END TRY
    BEGIN CATCH
        PRINT 'Wyst�pi� b��d podczas edycji wydarzenia: ' + ERROR_MESSAGE();
        THROW;
    END CATCH
END;
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Procedura edytuj�ca wydarzenie', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Procedure', @level1name = N'EditEvent';

-- Przyk�adowe wywo�ania:
-- Poprawne
EXEC EditEvent 
    @UserID = 1, 
    @EventName = 'Spotkanie mi�o�nik�w ksi��ek', 
    @NewName = 'Spotkanie mi�o�nik�w ksi��eczek', 
    @NewDescription = 'Rozszerzone spotkanie pasjonat�w ksi��ek', 
    @NewPlace = 'Gda�sk', 
    @NewStartDate = '2026-01-20', 
    @NewEndDate = '2026-01-20';
GO

-- Poprawne
EXEC EditEvent 
    @UserID = 1, 
    @EventName = 'Spotkanie mi�o�nik�w ksi��eczek', 
    @NewDescription = 'Spotkanie pasjonat�w ksi��ek'
GO

-- Niepoprawne
/*EXEC EditEvent 
    @UserID = 3, 
    @EventName = 'Spotkanie mi�o�nik�w ksi��eczek', 
    @NewPlace = 'Krak�w';
GO*/

SELECT * FROM Wydarzenia
GO
SELECT * FROM Zainteresowani_Wydarzenia
GO

-- Procedura do przestania bycia zainteresowanym wydarzeniem
CREATE OR ALTER PROCEDURE LeaveEvent
    @UserID INT,
    @EventName NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @EventID INT, @OwnerID INT;

        SELECT 
            @EventID = wydarzenie_id, 
            @OwnerID = autor_id
        FROM Wydarzenia
        WHERE tytul = @EventName;

        IF @EventID IS NULL
        BEGIN
            PRINT 'Wydarzenie o podanej nazwie nie istnieje.';
            RETURN;
        END

        IF @OwnerID = @UserID
        BEGIN
            PRINT 'Nie mo�esz opu�ci� wydarzenia, kt�rego jeste� za�o�ycielem.';
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM Zainteresowani_Wydarzenia WHERE wydarzenie_id = @EventID AND uzytkownik_id = @UserID)
        BEGIN
            PRINT 'Nie jeste� zainteresowany tym wydarzeniem.';
            RETURN;
        END

        DELETE FROM Zainteresowani_Wydarzenia
        WHERE wydarzenie_id = @EventID AND uzytkownik_id = @UserID;

        PRINT 'Przesta�e� by� zainteresowany wydarzeniem.';
    END TRY
    BEGIN CATCH
        PRINT 'Wyst�pi� b��d podczas opuszczania wydarzenia: ' + ERROR_MESSAGE();
        THROW;
    END CATCH
END;
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Procedura do przestania bycia zainteresowanym wydarzeniem', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Procedure', @level1name = N'LeaveEvent';

-- Przyk�adowe wywo�ania:
-- Poprawne
EXEC LeaveEvent 
    @UserID = 3, 
    @EventName = 'Spotkanie mi�o�nik�w ksi��eczek';
GO

-- Niepoprawne
/*EXEC LeaveEvent 
    @UserID = 1, 
    @EventName = 'Spotkanie mi�o�nik�w ksi��eczek';
GO

-- Niepoprawne
EXEC LeaveEvent 
    @UserID = 4, 
    @EventName = 'Spotkanie mi�o�nik�w ksi��eczek';
GO

-- Niepoprawne
EXEC LeaveEvent 
@UserID = 4, 
@EventName = 'Konferencja IT';
GO*/

SELECT * FROM Wydarzenia
GO
SELECT * FROM Zainteresowani_Wydarzenia
GO

-- Procedura dodaj�ca obserwacj�
CREATE OR ALTER PROCEDURE AddObservation
    @ObserverID INT,
    @ObservedID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Uzytkownicy WHERE uzytkownik_id = @ObservedID)
        BEGIN
			PRINT 'Obserwowany u�ytkownik nie istnieje.';
            RETURN;
        END

        IF EXISTS (SELECT 1 FROM Obserwacje WHERE obserwujacy_id = @ObserverID AND obserwowany_id = @ObservedID)
        BEGIN
			PRINT 'Ju� obserwujesz tego u�ytkownika.';
            RETURN;
        END

        INSERT INTO Obserwacje (obserwujacy_id, obserwowany_id) VALUES (@ObserverID, @ObservedID);

        PRINT 'Dodano obserwacj�.';
    END TRY
    BEGIN CATCH
        PRINT 'Wyst�pi� b��d podczas tworzenia obserwacji: ' + ERROR_MESSAGE();
        THROW;
    END CATCH
END;
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Procedura dodaj�ca obserwacj�', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Procedure', @level1name = N'AddObservation';

-- Przyk�adowe wywo�ania:
-- Poprawne
EXEC AddObservation 
	@ObserverID = 1, 
	@ObservedID = 4;
GO

-- Niepoprawne
/*EXEC AddObservation 
	@ObserverID = 1, 
	@ObservedID = 2;
GO

-- Niepoprawne
EXEC AddObservation 
	@ObserverID = 1, 
	@ObservedID = 99;
GO*/

SELECT * FROM Uzytkownicy
GO
SELECT * FROM Obserwacje
GO

-- Procedura usuwaj�ca obserwacj�
CREATE OR ALTER PROCEDURE RemoveObservation
    @ObserverID INT,
    @ObservedID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Obserwacje WHERE obserwujacy_id = @ObserverID AND obserwowany_id = @ObservedID)
        BEGIN
			PRINT 'Nie obserwujesz tego u�ytkownika.';
            RETURN;
        END

        DELETE FROM Obserwacje WHERE obserwujacy_id = @ObserverID AND obserwowany_id = @ObservedID;

        PRINT 'Usuni�to obserwacj�.';
    END TRY
    BEGIN CATCH
        PRINT 'Wyst�pi� b��d podczas usuwania obserwacji: ' + ERROR_MESSAGE();
        THROW;
    END CATCH
END;
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Procedura usuwaj�ca obserwacj�', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Procedure', @level1name = N'RemoveObservation';

-- Przyk�adowe wywo�ania:
-- Poprawne
EXEC RemoveObservation 
	@ObserverID = 1, 
	@ObservedID = 2;
GO

-- Niepoprawne
/*EXEC RemoveObservation 
	@ObserverID = 1, 
	@ObservedID = 5;
GO*/

SELECT * FROM Uzytkownicy
GO
SELECT * FROM Obserwacje
GO

-- Procedura tworz�ca grup�
CREATE OR ALTER PROCEDURE CreateGroup
    @UserID INT,
    @GroupName NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        INSERT INTO Grupy (nazwa) VALUES (@GroupName);
        INSERT INTO Czlonkowie_Grupy (grupa_id, uzytkownik_id) VALUES (SCOPE_IDENTITY(), @UserID);

        PRINT 'Grupa zosta�a utworzona.';
    END TRY
    BEGIN CATCH
        PRINT 'Wyst�pi� b��d podczas tworzenia grupy: ' + ERROR_MESSAGE();
        THROW;
    END CATCH
END;
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Procedura tworz�ca grup�', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Procedure', @level1name = N'CreateGroup';

-- Przyk�adowe wywo�ania:
-- Poprawne
EXEC CreateGroup 
	@UserID = 11, 
	@GroupName = 'Programi�ci';
GO

SELECT * FROM Grupy
GO

-- Procedura edytuj�ca grup�
CREATE OR ALTER PROCEDURE EditGroup
    @UserID INT,
    @OldGroupName NVARCHAR(100),
    @NewGroupName NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF NOT EXISTS (
            SELECT 1 
            FROM Czlonkowie_Grupy 
            WHERE grupa_id = (SELECT grupa_id FROM Grupy WHERE nazwa = @OldGroupName)
              AND uzytkownik_id = @UserID
        )
        BEGIN
            RAISERROR ('U�ytkownik nie jest cz�onkiem grupy i nie mo�e jej edytowa�.', 16, 1);
            RETURN;
        END

        IF EXISTS (SELECT 1 FROM Grupy WHERE nazwa = @NewGroupName)
        BEGIN
            RAISERROR ('Grupa o podanej nowej nazwie ju� istnieje.', 16, 1);
            RETURN;
        END

        UPDATE Grupy
        SET nazwa = @NewGroupName
        WHERE nazwa = @OldGroupName;
        PRINT 'Nazwa grupy zosta�a zmieniona.';
    END TRY
    BEGIN CATCH
        PRINT 'Wyst�pi� b��d podczas edycji grupy: ' + ERROR_MESSAGE();
        THROW;
    END CATCH
END;
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Procedura edytuj�ca grup�', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Procedure', @level1name = N'EditGroup';

-- Przyk�adowe wywo�ania:
-- Poprawne
EXEC EditGroup 
	@UserID = 11, 
	@OldGroupName = 'Programi�ci', 
	@NewGroupName = 'Deweloperzy';
GO

-- Niepoprawne
/*EXEC EditGroup 
	@UserID = 11, 
	@OldGroupName = 'Deweloperzy', 
	@NewGroupName = NULL;
GO

-- Niepoprawne
EXEC EditGroup 
	@UserID = 99, 
	@OldGroupName = 'Deweloperzy', 
	@NewGroupName = 'Programi�ci';
GO

-- Niepoprawne
EXEC EditGroup 
	@UserID = 10, 
	@OldGroupName = 'Biegacze z ca�ej Polski', 
	@NewGroupName = 'Deweloperzy';
GO*/

SELECT * FROM Grupy
GO

-- Procedura usuwaj�ca grup�
CREATE OR ALTER PROCEDURE DeleteGroup
    @UserID INT,
    @GroupName NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
		IF @UserID = -999 GOTO administartor;

		IF NOT EXISTS (
            SELECT 1 
            FROM Czlonkowie_Grupy 
            WHERE grupa_id = (SELECT grupa_id FROM Grupy WHERE nazwa = @GroupName)
              AND uzytkownik_id = @UserID
        )
        BEGIN
            RAISERROR ('U�ytkownik nie jest cz�onkiem grupy i nie mo�e jej usun��.', 16, 1);
            RETURN;
        END

		administartor:
		IF @UserID = -999 BEGIN
			DELETE FROM Grupy WHERE nazwa = @GroupName;
			PRINT 'Grupa zosta�a usuni�ta.';
			RETURN;
		END

        DELETE FROM Grupy WHERE nazwa = @GroupName AND EXISTS (
            SELECT 1 FROM Czlonkowie_Grupy cg
            JOIN Grupy g ON cg.grupa_id = g.grupa_id
            WHERE cg.uzytkownik_id = @UserID AND g.nazwa = @GroupName
        );

        PRINT 'Grupa zosta�a usuni�ta.';
    END TRY
    BEGIN CATCH
        PRINT 'Wyst�pi� b��d podczas usuwania grupy: ' + ERROR_MESSAGE();
        THROW;
    END CATCH
END;
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Procedura usuwaj�ca grup�', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Procedure', @level1name = N'DeleteGroup';

-- Przyk�adowe wywo�ania:
-- Poprawne
EXEC DeleteGroup
	@UserID = 11, 
	@GroupName = 'Deweloperzy';
GO

-- Niepoprawne
/*EXEC DeleteGroup 
	@UserID = 99, 
	@GroupName = 'Deweloperzy';
GO*/

SELECT * FROM Uzytkownicy
GO
SELECT * FROM Grupy
GO
SELECT * FROM Czlonkowie_Grupy
GO

-- Procedura do do��czania do grupy
CREATE OR ALTER PROCEDURE JoinGroup
    @UserID INT,
    @GroupName NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF EXISTS (SELECT 1 FROM Czlonkowie_Grupy cg
                   JOIN Grupy g ON cg.grupa_id = g.grupa_id
                   WHERE cg.uzytkownik_id = @UserID AND g.nazwa = @GroupName)
        BEGIN
            PRINT 'Jeste� ju� cz�onkiem tej grupy.';
			RETURN;
        END

        INSERT INTO Czlonkowie_Grupy (grupa_id, uzytkownik_id)
        SELECT grupa_id, @UserID FROM Grupy WHERE nazwa = @GroupName;

        PRINT 'Do��czono do grupy.';
    END TRY
    BEGIN CATCH
        PRINT 'Wyst�pi� b��d podczas do��czania do grupy: ' + ERROR_MESSAGE();
        THROW;
    END CATCH
END;
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Procedura do do��czania do grupy', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Procedure', @level1name = N'JoinGroup';

-- Przyk�adowe wywo�ania:
-- Poprawne
EXEC JoinGroup 
	@UserID = 4, 
	@GroupName = 'Mi�o�nicy ksi��ek';
GO

-- Niepoprawne
/*EXEC JoinGroup 
	@UserID = 2, 
	@GroupName = 'Mi�o�nicy ksi��ek';
GO*/

SELECT * FROM Uzytkownicy
GO
SELECT * FROM Grupy
GO
SELECT * FROM Czlonkowie_Grupy
GO

-- Procedura do opuszczenia grupy
CREATE OR ALTER PROCEDURE LeaveGroup
    @UserID INT,
    @GroupName NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
		IF NOT EXISTS (
            SELECT 1 
            FROM Czlonkowie_Grupy 
            WHERE grupa_id = (SELECT grupa_id FROM Grupy WHERE nazwa = @GroupName)
              AND uzytkownik_id = @UserID
        )
        BEGIN
            RAISERROR ('Nie jeste� ju� cz�onkiem tej grupy.', 16, 1);
            RETURN;
        END

        DELETE FROM Czlonkowie_Grupy
        WHERE uzytkownik_id = @UserID AND grupa_id = (
            SELECT grupa_id FROM Grupy WHERE nazwa = @GroupName
        );

        PRINT 'Opuszczono grup�.';
    END TRY
    BEGIN CATCH
        PRINT 'Wyst�pi� b��d podczas opuszczania grupy: ' + ERROR_MESSAGE();
        THROW;
    END CATCH
END;
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Procedura do opuszczenia grupy', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Procedure', @level1name = N'LeaveGroup';

-- Przyk�adowe wywo�ania:
-- Poprawne
EXEC LeaveGroup 
	@UserID = 4, 
	@GroupName = 'Mi�o�nicy ksi��ek';
GO

-- Niepoprawne
/*EXEC LeaveGroup 
	@UserID = 5, 
	@GroupName = 'Mi�o�nicy ksi��ek';
GO*/

SELECT * FROM Czlonkowie_Grupy
GO

-- Procedura do tworzenia postu
CREATE OR ALTER PROCEDURE CreatePost
    @UserID INT,
    @Title NVARCHAR(200),
    @Description NVARCHAR(MAX),
    @PostType NVARCHAR(50),
    @GroupName NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF @PostType NOT IN ('tekst', 'film', 'obraz')
        BEGIN
            RAISERROR ('Niepoprawny typ postu. Dozwolone warto�ci to: tekst, film, obraz.', 16, 1);
            RETURN;
        END

        IF @GroupName IS NOT NULL AND NOT EXISTS (
            SELECT 1 
            FROM Grupy 
            WHERE nazwa = @GroupName AND EXISTS (
                SELECT 1 
                FROM Czlonkowie_Grupy 
                WHERE uzytkownik_id = @UserID AND grupa_id = Grupy.grupa_id
            )
        )
        BEGIN
            RAISERROR ('Grupa o podanej nazwie nie istnieje lub u�ytkownik nie jest jej cz�onkiem.', 16, 1);
            RETURN;
        END

        INSERT INTO Posty (autor_id, tytul, opis, rodzaj, grupa_id)
        SELECT 
            @UserID, 
            @Title, 
            CASE WHEN @Description = 'null' THEN NULL ELSE @Description END, 
            @PostType, 
            (SELECT grupa_id FROM Grupy WHERE nazwa = @GroupName)
        WHERE @GroupName IS NULL OR EXISTS (
            SELECT 1 
            FROM Czlonkowie_Grupy 
            WHERE uzytkownik_id = @UserID 
              AND grupa_id = (SELECT grupa_id FROM Grupy WHERE nazwa = @GroupName)
        );

        PRINT 'Post zosta� utworzony.';
    END TRY
    BEGIN CATCH
        PRINT 'Wyst�pi� b��d podczas dodawania postu: ' + ERROR_MESSAGE();
        THROW;
    END CATCH
END;
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Procedura do tworzenia postu', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Procedure', @level1name = N'CreatePost';

-- Przyk�adowe wywo�ania:
-- Poprawne
EXEC CreatePost 
	@UserID = 11, 
	@Title = 'Nowo�ci w MSSQL', 
	@Description = 'SQL Server 2024 wyszed�!', 
	@PostType = 'Tekst'
GO

-- Niepoprawne
/*EXEC CreatePost 
	@UserID = 1, 
	@Title = 'Zaawansowane algorytmy', 
	@Description = 'Eksploracja zaawansowanych algorytm�w sortuj�cych', 
	@PostType = 'Film', 
	@GroupName = 'Programmers';
GO

-- Niepoprawne
EXEC CreatePost 
	@UserID = 1, 
	@Title = 'Zaawansowane algorytmy', 
	@Description = 'Eksploracja zaawansowanych algorytm�w sortuj�cych', 
	@PostType = 'Education', 
	@GroupName = 'Programmers';
GO*/

SELECT * FROM Posty
GO
SELECT * FROM Komentarze_Posty
GO

-- Procedura do edycji postu
CREATE OR ALTER PROCEDURE EditPost
    @UserID INT,
    @PostTitle NVARCHAR(200),
    @NewTitle NVARCHAR(200) = NULL,
    @NewDescription NVARCHAR(MAX) = NULL,
    @NewPostType NVARCHAR(50) = NULL,
    @NewGroupName NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Posty WHERE tytul = @PostTitle AND autor_id = @UserID)
        BEGIN
            PRINT 'Nie jeste� autorem tego postu.';
			RETURN;
        END

        UPDATE Posty
        SET 
            tytul = ISNULL(@NewTitle, tytul),
            opis = CASE WHEN @NewDescription IS NULL THEN opis WHEN @NewDescription = 'null' THEN NULL ELSE @NewDescription END,
            rodzaj = ISNULL(@NewPostType, rodzaj),
            grupa_id = CASE 
                         WHEN @NewGroupName IS NOT NULL 
                         THEN (SELECT grupa_id FROM Grupy WHERE nazwa = @NewGroupName AND EXISTS (
                                SELECT 1 FROM Czlonkowie_Grupy 
                                WHERE uzytkownik_id = @UserID AND grupa_id = Grupy.grupa_id))
						 WHEN @NewGroupName = 'null' THEN NULL
                         ELSE grupa_id 
                      END
        WHERE tytul = @PostTitle AND autor_id = @UserID;

        PRINT 'Post zosta� zaktualizowany.';
    END TRY
    BEGIN CATCH
        PRINT 'Wyst�pi� b��d podczas edycji postu: ' + ERROR_MESSAGE();
        THROW;
    END CATCH
END;
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Procedura do edycji postu', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Procedure', @level1name = N'EditPost';

-- Przyk�adowe wywo�ania:
-- Poprawne
EXEC EditPost 
	@UserID = 11, 
	@PostTitle = 'Nowo�ci w MSSQL', 
	@NewTitle = 'Aktualizacja MSSQL'
GO

-- Poprawne
EXEC EditPost 
	@UserID = 11, 
	@PostTitle = 'Aktualizacja MSSQL', 
	@NewGroupName = 'Grupa wsparcia IT';
GO

-- Niepoprawne
/*EXEC EditPost 
	@UserID = 2, 
	@PostTitle = 'Aktualizacja MSSQL', 
	@NewTitle = 'Nowa aktualizacja MSSQL';
GO*/

SELECT * FROM Posty
GO
SELECT * FROM Komentarze_Posty
GO

-- Procedura do usuwania postu
CREATE OR ALTER PROCEDURE DeletePost
    @UserID INT,
    @PostTitle NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
		IF @UserID = -999 GOTO administartor;

        IF NOT EXISTS (SELECT 1 FROM Posty WHERE tytul = @PostTitle AND autor_id = @UserID)
        BEGIN
            PRINT 'Nie jeste� autorem tego postu.';
			RETURN;
        END

		administartor:
        DELETE FROM Posty WHERE tytul = @PostTitle;

        PRINT 'Post zosta� usuni�ty.';
    END TRY
    BEGIN CATCH
        PRINT 'Wyst�pi� b��d podczas usuwania postu: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Procedura do usuwania postu', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Procedure', @level1name = N'DeletePost';

-- Przyk�adowe wywo�ania:
-- Niepoprawne
/*EXEC DeletePost 
	@UserID = 1,
	@PostTitle = 'Aktualizacja MSSQL';
GO*/

-- Poprawne
EXEC DeletePost 
	@UserID = 11, 
	@PostTitle = 'Aktualizacja MSSQL';
GO

SELECT * FROM Posty
GO
SELECT * FROM Komentarze_Posty
GO

-- Procedura do dodawania komentarza do postu
CREATE OR ALTER PROCEDURE AddCommentToPost
    @UserID INT,
    @PostTitle NVARCHAR(200),
    @CommentText NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Posty WHERE tytul = @PostTitle)
        BEGIN
            PRINT 'Post o podanym tytule nie istnieje.';
			RETURN;
        END

        INSERT INTO Komentarze_Posty (post_id, uzytkownik_id, tresc)
        SELECT post_id, @UserID, @CommentText FROM Posty WHERE tytul = @PostTitle;

        PRINT 'Komentarz zosta� dodany.';
    END TRY
    BEGIN CATCH
        PRINT 'Wyst�pi� b��d podczas dodawania komentarza: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Procedura do dodawania komentarza do postu', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Procedure', @level1name = N'AddCommentToPost';

-- Przyk�adowe wywo�ania:
-- Poprawne
EXEC AddCommentToPost 
	@UserID = 2, 
	@PostTitle = 'Najlepsze ksi��ki minionych lat', 
	@CommentText = 'Metro 2033 jest MEGA!';
GO

-- Niepoprawne
/*EXEC AddCommentToPost 
	@UserID = 2, 
	@PostTitle = 'Nieistniej�cy post', 
	@CommentText = 'Fajny post!';
GO*/

SELECT * FROM Posty
GO
SELECT * FROM Komentarze_Posty
GO

-- Procedura do edycji komentarza
CREATE OR ALTER PROCEDURE EditComment
    @UserID INT,
    @CommentID INT,
    @NewCommentText NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM Komentarze_Posty WHERE komentarz_id = @CommentID AND uzytkownik_id = @UserID)
        BEGIN
            PRINT 'Nie jeste� autorem tego komentarza.';
			RETURN;
        END

        UPDATE Komentarze_Posty
        SET tresc = @NewCommentText
        WHERE komentarz_id = @CommentID AND uzytkownik_id = @UserID;

        PRINT 'Komentarz zosta� zaktualizowany.';
    END TRY
    BEGIN CATCH
        PRINT 'Wyst�pi� b��d podczas edycji komentarza: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Procedura do edycji komentarza', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Procedure', @level1name = N'EditComment';

-- Przyk�adowe wywo�ania:
-- Poprawne
EXEC EditComment 
	@UserID = 2, 
	@CommentID = 11, 
	@NewCommentText = 'Metro 2033, 2034 i 2035 jest MEGA!';
GO

-- Niepoprawne
EXEC EditComment 
	@UserID = 3, 
	@CommentID = 11, 
	@NewCommentText = 'Aktualizacja komentarza';
GO

SELECT * FROM Posty
GO
SELECT * FROM Komentarze_Posty
GO

-- Procedura do usuwania komentarza
CREATE OR ALTER PROCEDURE DeleteComment
    @UserID INT,
    @CommentID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
		IF @UserID = -999 GOTO administartor;
		
        IF NOT EXISTS (
            SELECT 1 FROM Komentarze_Posty kp
            JOIN Posty p ON kp.post_id = p.post_id
            WHERE (kp.uzytkownik_id = @UserID OR p.autor_id = @UserID) AND kp.komentarz_id = @CommentID
        )
        BEGIN
            PRINT 'Nie masz uprawnie� do usuni�cia tego komentarza.';
			RETURN;
        END

		administartor:
        DELETE FROM Komentarze_Posty WHERE komentarz_id = @CommentID;

        PRINT 'Komentarz zosta� usuni�ty.';
    END TRY
    BEGIN CATCH
         PRINT 'Wyst�pi� b��d podczas usuwania komentarza: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Procedura do usuwania komentarza', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Procedure', @level1name = N'DeleteComment';

-- Przyk�adowe wywo�ania:
-- Poprawne
EXEC DeleteComment 
	@UserID = 1, 
	@CommentID = 11;
GO

-- Poprawne
EXEC DeleteComment 
	@UserID = 1, 
	@CommentID = 10;
GO

-- Niepoprawne
/*EXEC DeleteComment 
	@UserID = 3, 
	@CommentID = 3;
GO*/

SELECT * FROM Posty
GO
SELECT * FROM Komentarze_Posty
GO

-------------------------
--- TWORZENIE FUNKCJI ---
-------------------------

-- Funkcja do wyszukiwania pobliskich og�osze� na marketplace
CREATE OR ALTER FUNCTION dbo.WyszukajOgloszeniaDlaUzytkownika(
    @uzytkownik_id INT
)
RETURNS @wyniki TABLE (
    ogloszenie_id INT,
    tytul NVARCHAR(200),
    opis NVARCHAR(MAX),
    kategoria NVARCHAR(50),
    cena MONEY,
    pseudonim NVARCHAR(20),
    miejscowosc NVARCHAR(100),
    kraj NVARCHAR(50)
)
AS
BEGIN
    DECLARE @lokalizacja_marketplace INT;
    DECLARE @miejscowosc NVARCHAR(100);
    DECLARE @kraj NVARCHAR(50);

    SELECT 
        @lokalizacja_marketplace = lokalizacja_marketplace,
        @miejscowosc = miejscowosc,
        @kraj = kraj
    FROM Uzytkownicy
    WHERE uzytkownik_id = @uzytkownik_id;

    IF @lokalizacja_marketplace IS NULL
    BEGIN
		IF @miejscowosc IS NULL OR @kraj IS NULL
		BEGIN
			RETURN;
		END
    END
	ELSE
	BEGIN
		SELECT
			@miejscowosc =  miejscowosc,
			@kraj = kraj
		FROM Lokalizacja
		WHERE lokalizacja_id = @lokalizacja_marketplace;
	END

    INSERT INTO @wyniki
    SELECT 
        m.ogloszenie_id,
        m.tytul,
        m.opis,
        m.kategoria,
        m.cena,
        u.pseudonim,
        l.miejscowosc,
        l.kraj
    FROM Marketplace m
    INNER JOIN Uzytkownicy u ON m.ogloszeniodawca_id = u.uzytkownik_id
    LEFT JOIN Lokalizacja l ON u.lokalizacja_marketplace = l.lokalizacja_id
    WHERE l.miejscowosc = @miejscowosc AND l.kraj = @kraj;

    RETURN;
END
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Funkcja do wyszukiwania pobliskich og�osze� na marketplace zwracaj�ca list� og�osze� dla u�ytkownika w zale�no�ci od jego lokalizacji.', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'Function', @level1name = N'WyszukajOgloszeniaDlaUzytkownika';

-- Dodanie potrzebnych rekord�w do wyszukiwania:
exec AddUser
	@pImie = 'Robert',
    @pNazwisko = 'Lewandowski',
    @pUrodziny = '1988-08-21',
    @pMiejscowosc = 'Warszawa',
    @pKraj = 'Polska',
    @pPseudonim = 'RL9',
    @pLokacja = 1,
    @lKraj = 'Polska',
    @lMiejscowosc = 'Warszawa',
    @lUlica = 'Pozna�ska',
    @lNrDom = '9'
GO

exec AddUser
	@pImie = 'Ola',
    @pNazwisko = 'Szyma�ska',
    @pUrodziny = '1998-02-13',
    @pMiejscowosc = 'Warszawa',
    @pKraj = 'Polska',
    @pPseudonim = 'Olusia',
    @pLokacja = 1,
    @lKraj = 'Polska',
    @lMiejscowosc = 'Warszawa',
    @lUlica = 'Berli�ska',
    @lNrDom = '39'
GO

EXEC AddOffer
	@pOgloszeniodawca = 1,
	@pTytul = 'Pi�ka z podpisem Roberta Lewandowskiego',
	@pKategoria = 'Sport',
	@pCena = 30000,
	@pNegocjacja = 0,
	@pPrzesylka = 0
GO

EXEC AddOffer
	@pOgloszeniodawca = 12,
	@pTytul = 'Pi�ka do gry w basenie',
	@pKategoria = 'Sport',
	@pCena = 50,
	@pNegocjacja = 1,
	@pPrzesylka = 1
GO

-- Prezentacja wyszukania pobliskich ofert
SELECT * FROM dbo.WyszukajOgloszeniaDlaUzytkownika(14);
GO

SELECT * FROM Uzytkownicy
GO
SELECT * FROM Lokalizacja
GO
SELECT * FROM Marketplace
GO

--------------------------------------------
--- TWORZENIE WIDOK�W DLA ADMINISTRATORA ---
--------------------------------------------

-- Informacje o profilach u�ytkownik�w
CREATE OR ALTER VIEW vIstniejacyUzytkownicy AS
SELECT 
    u.uzytkownik_id,
    u.imie,
    u.nazwisko,
    u.data_urodzenia,
    u.miejscowosc,
    u.kraj,
    u.plec,
    u.pseudonim,
    l.kraj AS marketplace_kraj,
    l.miejscowosc AS marketplace_miejscowosc,
    l.ulica AS marketplace_ulica,
    l.nr_domu AS marketplace_nr_domu,
    l.nr_mieszkania AS marketplace_nr_mieszkania,
    l.informacje_dodatkowe AS marketplace_informacje_dodatkowe
FROM Uzytkownicy u
LEFT JOIN Lokalizacja l ON u.lokalizacja_marketplace = l.lokalizacja_id;
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Informacje o profilach u�ytkownik�w.', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'View', @level1name = N'vIstniejacyUzytkownicy';

SELECT * FROM vIstniejacyUzytkownicy
GO

-- Informacje o obserwacjach u�ytkownik�w
CREATE OR ALTER VIEW vIstniejaceObserwacje AS
SELECT 
    o.obserwujacy_id AS obserwujacy,
    ou.pseudonim AS obserwujacy_pseudonim,
    ou.imie AS obserwujacy_imie,
    ou.nazwisko AS obserwujacy_nazwisko,
    o.obserwowany_id AS obserwowany,
    uw.pseudonim AS obserwowany_pseudonim,
    uw.imie AS obserwowany_imie,
    uw.nazwisko AS obserwowany_nazwisko
FROM Obserwacje o
INNER JOIN Uzytkownicy uw ON o.obserwowany_id = uw.uzytkownik_id
INNER JOIN Uzytkownicy ou ON o.obserwujacy_id = ou.uzytkownik_id;
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Informacje o obserwacjach u�ytkownik�w.', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'View', @level1name = N'vIstniejaceObserwacje';

SELECT * FROM vIstniejaceObserwacje
GO

-- Informacje o kana�ach nadawczych i cz�onkach
CREATE OR ALTER VIEW vIstniejaceKanalyNadawcze AS
SELECT 
    kn.kanal_id,
    kn.nazwa AS nazwa_kanalu,
    kn.nadawca_id,
    n.uzytkownik_id AS czlonek_id,
    u.pseudonim AS czlonek_pseudonim,
    u.imie AS czlonek_imie,
    u.nazwisko AS czlonek_nazwisko
FROM Kanal_Nadawczy kn
LEFT JOIN Czlonkowie_Kanal_Nadawczy n ON kn.kanal_id = n.kanal_id
LEFT JOIN Uzytkownicy u ON n.uzytkownik_id = u.uzytkownik_id;
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Informacje o kana�ach nadawczych i cz�onkach.', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'View', @level1name = N'vIstniejaceKanalyNadawcze';

SELECT * FROM vIstniejaceKanalyNadawcze
GO

-- Informacje o wydarzeniach i zainteresowanych
CREATE OR ALTER VIEW vIstniejaceWydarzenia AS
SELECT 
    w.wydarzenie_id,
    w.tytul AS tytul_wydarzenia,
    w.opis AS opis_wydarzenia,
    w.miejsce AS miejsce_wydarzenia,
    w.data_rozpoczecia,
    w.data_zakonczenia,
    w.autor_id,
    u_autor.pseudonim AS autor_pseudonim,
    u_autor.imie AS autor_imie,
    u_autor.nazwisko AS autor_nazwisko,
    z.uzytkownik_id AS zainteresowany_id,
    u_zain.pseudonim AS zainteresowany_pseudonim,
    u_zain.imie AS zainteresowany_imie,
    u_zain.nazwisko AS zainteresowany_nazwisko
FROM Wydarzenia w
LEFT JOIN Uzytkownicy u_autor ON w.autor_id = u_autor.uzytkownik_id
LEFT JOIN Zainteresowani_Wydarzenia z ON w.wydarzenie_id = z.wydarzenie_id
LEFT JOIN Uzytkownicy u_zain ON z.uzytkownik_id = u_zain.uzytkownik_id;
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Informacje o wydarzeniach i zainteresowanych.', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'View', @level1name = N'vIstniejaceWydarzenia';

SELECT * FROM vIstniejaceWydarzenia
GO

-- Informacje o wszytskich postach
CREATE OR ALTER VIEW vIstniejacePosty AS
SELECT 
    p.post_id,
    p.tytul AS tytul_postu,
    p.opis AS opis_postu,
    p.rodzaj AS rodzaj_postu,
    p.modified_date AS data_modyfikacji_postu,
    p.grupa_id,
    g.nazwa AS nazwa_grupy,
    p.autor_id,
    u.pseudonim AS autor_pseudonim,
    u.imie AS autor_imie,
    u.nazwisko AS autor_nazwisko
FROM Posty p
LEFT JOIN Grupy g ON p.grupa_id = g.grupa_id
LEFT JOIN Uzytkownicy u ON p.autor_id = u.uzytkownik_id;
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Informacje o wszytskich postach.', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'View', @level1name = N'vIstniejacePosty';

SELECT * FROM vIstniejacePosty
GO

-- Informacje o komentarzach pod postami
CREATE OR ALTER VIEW vIstniejaceKomentarzePodPostami AS
SELECT 
    k.komentarz_id,
    k.tresc AS tresc_komentarza,
    k.modified_date AS data_modyfikacji_komentarza,
    k.post_id,
    p.tytul AS tytul_postu,
    p.opis AS opis_postu,
    p.rodzaj AS rodzaj_postu,
    p.autor_id,
    u.pseudonim AS autor_pseudonim,
    u.imie AS autor_imie,
    u.nazwisko AS autor_nazwisko,
    k.uzytkownik_id,
    u2.pseudonim AS komentujacy_pseudonim,
    u2.imie AS komentujacy_imie,
    u2.nazwisko AS komentujacy_nazwisko
FROM Komentarze_Posty k
INNER JOIN Posty p ON k.post_id = p.post_id
INNER JOIN Uzytkownicy u ON p.autor_id = u.uzytkownik_id
INNER JOIN Uzytkownicy u2 ON k.uzytkownik_id = u2.uzytkownik_id;
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Informacje o komentarzach pod postami.', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'View', @level1name = N'vIstniejaceKomentarzePodPostami';

SELECT * FROM vIstniejaceKomentarzePodPostami where uzytkownik_id = 2
GO

-- Informacje o grupach i ich cz�onkach
CREATE OR ALTER VIEW vIstniejaceGrupy AS
SELECT 
    g.grupa_id,
    g.nazwa AS nazwa_grupy,
    g.modified_date AS data_modyfikacji_grupy,
    c.uzytkownik_id,
    u.pseudonim AS czlonek_pseudonim,
    u.imie AS czlonek_imie,
    u.nazwisko AS czlonek_nazwisko
FROM Grupy g
INNER JOIN Czlonkowie_Kanal_Nadawczy c ON g.grupa_id = c.kanal_id
INNER JOIN Uzytkownicy u ON c.uzytkownik_id = u.uzytkownik_id
GO

EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'Informacje o grupach i ich cz�onkach.', @level0type = N'Schema', @level0name = N'dbo', @level1type = N'View', @level1name = N'vIstniejaceGrupy';

SELECT * FROM vIstniejaceGrupy
GO

---------------------------------
--- TWORZENIE R�L BAZY DANYCH ---
---------------------------------

CREATE ROLE [administrator]
GO
GRANT CONTROL ON DATABASE::[SocialWall] TO [administrator];
GO

CREATE ROLE [moderator]
GO
GRANT EXECUTE ON [dbo].[ReadMessages] TO [moderator]
GO
GRANT SELECT ON [dbo].[vIstniejaceKomentarzePodPostami] TO [moderator]
GO
GRANT EXECUTE ON [dbo].[DeletePost] TO [moderator]
GO
GRANT EXECUTE ON [dbo].[DeleteEvent] TO [moderator]
GO
GRANT SELECT ON [dbo].[vIstniejacePosty] TO [moderator]
GO
GRANT EXECUTE ON [dbo].[DeleteOffer] TO [moderator]
GO
GRANT SELECT ON [dbo].[vIstniejaceGrupy] TO [moderator]
GO
GRANT EXECUTE ON [dbo].[DeleteChannel] TO [moderator]
GO
GRANT EXECUTE ON [dbo].[DeleteGroup] TO [moderator]
GO
GRANT SELECT ON [dbo].[vIstniejacyUzytkownicy] TO [moderator]
GO
GRANT SELECT ON [dbo].[vIstniejaceKanalyNadawcze] TO [moderator]
GO
GRANT EXECUTE ON [dbo].[DeleteComment] TO [moderator]
GO
GRANT SELECT ON [dbo].[vIstniejaceWydarzenia] TO [moderator]
GO
GRANT EXECUTE ON [dbo].[DeleteUser] TO [moderator]
GO

CREATE ROLE [uzytkownik]
GO
GRANT EXECUTE ON [dbo].[EditChannel] TO [uzytkownik]
GO
GRANT EXECUTE ON [dbo].[DeleteGroup] TO [uzytkownik]
GO
GRANT EXECUTE ON [dbo].[CreatePost] TO [uzytkownik]
GO
GRANT EXECUTE ON [dbo].[LeaveChannel] TO [uzytkownik]
GO
GRANT EXECUTE ON [dbo].[CreateGroup] TO [uzytkownik]
GO
GRANT EXECUTE ON [dbo].[DeleteEvent] TO [uzytkownik]
GO
GRANT EXECUTE ON [dbo].[DeleteChannel] TO [uzytkownik]
GO
GRANT EXECUTE ON [dbo].[AddLocation] TO [uzytkownik]
GO
GRANT EXECUTE ON [dbo].[ReadMessages] TO [uzytkownik]
GO
GRANT EXECUTE ON [dbo].[EditGroup] TO [uzytkownik]
GO
GRANT EXECUTE ON [dbo].[JoinGroup] TO [uzytkownik]
GO
GRANT EXECUTE ON [dbo].[SendMessage] TO [uzytkownik]
GO
GRANT EXECUTE ON [dbo].[AddCommentToPost] TO [uzytkownik]
GO
GRANT EXECUTE ON [dbo].[CreateEvent] TO [uzytkownik]
GO
GRANT EXECUTE ON [dbo].[LeaveGroup] TO [uzytkownik]
GO
GRANT EXECUTE ON [dbo].[DeleteOffer] TO [uzytkownik]
GO
GRANT EXECUTE ON [dbo].[EditEvent] TO [uzytkownik]
GO
GRANT EXECUTE ON [dbo].[EditLocation] TO [uzytkownik]
GO
GRANT EXECUTE ON [dbo].[AddUser] TO [uzytkownik]
GO
GRANT EXECUTE ON [dbo].[EditPost] TO [uzytkownik]
GO
GRANT EXECUTE ON [dbo].[JoinEvent] TO [uzytkownik]
GO
GRANT EXECUTE ON [dbo].[AddOffer] TO [uzytkownik]
GO
GRANT EXECUTE ON [dbo].[EditComment] TO [uzytkownik]
GO
GRANT EXECUTE ON [dbo].[JoinChannel] TO [uzytkownik]
GO
GRANT EXECUTE ON [dbo].[LeaveEvent] TO [uzytkownik]
GO
GRANT EXECUTE ON [dbo].[AddObservation] TO [uzytkownik]
GO
GRANT EXECUTE ON [dbo].[DeletePost] TO [uzytkownik]
GO
GRANT EXECUTE ON [dbo].[CreateChannel] TO [uzytkownik]
GO
GRANT EXECUTE ON [dbo].[ModifyOffer] TO [uzytkownik]
GO
GRANT EXECUTE ON [dbo].[RemoveObservation] TO [uzytkownik]
GO
GRANT EXECUTE ON [dbo].[DeleteComment] TO [uzytkownik]
GO
GRANT EXECUTE ON [dbo].[TradeOffer] TO [uzytkownik]
GO
GRANT EXECUTE ON [dbo].[UpdateUser] TO [uzytkownik]
GO
GRANT SELECT ON [dbo].[vIstniejaceGrupy] TO [uzytkownik]
GO
GRANT SELECT ON [dbo].[vIstniejaceKanalyNadawcze] TO [uzytkownik]
GO
GRANT SELECT ON [dbo].[vIstniejacyUzytkownicy] TO [uzytkownik]
GO
GRANT SELECT ON [dbo].[vIstniejaceObserwacje] TO [uzytkownik]
GO
GRANT SELECT ON [dbo].[vIstniejaceWydarzenia] TO [uzytkownik]
GO
GRANT SELECT ON [dbo].[vIstniejaceKomentarzePodPostami] TO [uzytkownik]
GO
GRANT SELECT ON [dbo].[vIstniejacePosty] TO [uzytkownik]
GO
GRANT SELECT ON [dbo].[WyszukajOgloszeniaDlaUzytkownika] TO [uzytkownik]
GO

-----------------------------------
--- TWORZENIE LOGIN�W INSTANCJI ---
-----------------------------------

USE [master]
GO

CREATE LOGIN [padmin] WITH PASSWORD=N'Qwerty1@3', DEFAULT_DATABASE=[SocialWall], DEFAULT_LANGUAGE=[polski], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

CREATE LOGIN [pmod] WITH PASSWORD=N'Qazxsw1@3', DEFAULT_DATABASE=[SocialWall], DEFAULT_LANGUAGE=[polski], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

CREATE LOGIN [puser] WITH PASSWORD=N'Wsxzaq1@3', DEFAULT_DATABASE=[SocialWall], DEFAULT_LANGUAGE=[polski], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

------------------------------------------
--- TWORZENIE U�YTKOWNIK�W BAZY DANYCH ---
------------------------------------------

USE [SocialWall]
GO

CREATE USER [Pan_admin] FOR LOGIN [padmin]
GO
ALTER ROLE [administrator] ADD MEMBER [Pan_admin]
GO

CREATE USER [Pan_moderator] FOR LOGIN [pmod]
GO
ALTER ROLE [moderator] ADD MEMBER [Pan_moderator]
GO

CREATE USER [Pan_uzytkownik] FOR LOGIN [puser]
GO
ALTER ROLE [uzytkownik] ADD MEMBER [Pan_uzytkownik]
GO