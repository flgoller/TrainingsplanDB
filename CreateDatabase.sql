USE Master;
GO
DROP DATABASE IF EXISTS Trainingsplan
GO
CREATE DATABASE Trainingsplan
GO
USE Trainingsplan
GO


CREATE TABLE Trainingsplan
(
    TrainingsplandID INT NOT NULL IDENTITY PRIMARY KEY,
    Bez VARCHAR(255) NOT NULL ,
    ErstellDatum DATETIME NOT NULL
);
CREATE TABLE Uebung
(
    UebungID INT NOT NULL IDENTITY PRIMARY KEY,
    Bez VARCHAR(255) NOT NULL ,
    fk_MuskelgruppeID INT NOT NULL
);
CREATE TABLE Muskelgruppe
(
    MuskelgruppeID INT NOT NULL IDENTITY PRIMARY KEY,
    Bez VARCHAR(255) NOT NULL
);
CREATE TABLE TrainingsplanEnthaeltUebung
(
    TrainingsplanEnthaeltUebungID INT NOT NULL IDENTITY PRIMARY KEY,
    Wiederholungen INT NOT NULL,
    Saetze INT NOT NULL,
    Gewicht DECIMAL(8, 2) NOT NULL,
    Optional BIT NOT NULL,
    fk_UebungID INT NOT NULL ,
    fk_TrainingsplanID INT NOT NULL
);
GO
ALTER TABLE
Uebung ADD CONSTRAINT uebung_fk_muskelgruppeid_foreign FOREIGN KEY(fk_MuskelgruppeID) REFERENCES Muskelgruppe(MuskelgruppeID);
ALTER TABLE
TrainingsplanEnthaeltUebung ADD CONSTRAINT trainingsplanenthaeltuebung_fk_uebungid_foreign FOREIGN KEY(fk_UebungID) REFERENCES Uebung(UebungID);
ALTER TABLE
TrainingsplanEnthaeltUebung ADD CONSTRAINT trainingsplanenthaeltuebung_fk_trainingsplanid_foreign FOREIGN KEY(fk_TrainingsplanID) REFERENCES Trainingsplan(TrainingsplandID);
GO


/* Trigger erstellen */
DROP trigger if exists CheckUebungOnInsert;
go

CREATE TRIGGER CheckUebungOnInsert ON Uebung INSTEAD OF INSERT
AS BEGIN
    DECLARE @AnzahlDoppelteUebungen INT = (SELECT COUNT(*) as Anz
    FROM (                        SELECT Uebung.Bez
            FROM Uebung
        INTERSECT
            SELECT inserted.bez
            From inserted) I);

    if (@AnzahlDoppelteUebungen > 0)
	begin
        DECLARE @DoppelteUebungen VARCHAR(max) = (SELECT STRING_AGG (Bez, ',') AS bezeichnungen
        FROM (                                SELECT Uebung.Bez
                FROM Uebung
            INTERSECT
                SELECT inserted.bez
                From inserted) I)
        raiserror('Folgende Übungen sind bereits vorhanden : %s', 11, 10, @DoppelteUebungen);
    END
	else
		Insert INTO Uebung
        (Bez, fk_MuskelgruppeID)
    Select inserted.Bez, inserted.fk_MuskelgruppeID
    FROM inserted
END
GO

DROP trigger if exists CheckUebungOnUpdate;
go

CREATE TRIGGER CheckUebungOnUpdate ON Uebung INSTEAD OF UPDATE
AS BEGIN
    DECLARE @AnzahlDoppelteUebungen INT = (SELECT COUNT(*) as Anz
    FROM (                        SELECT Uebung.Bez
            FROM Uebung
        INTERSECT
            SELECT inserted.bez
            From inserted) I);

    DECLARE @Bez VARCHAR(MAX), @fk_MuskelgruppeId INT, @UebungId INT
    SELECT @Bez = INSERTED.bez, @fk_MuskelgruppeId = INSERTED.fk_MuskelgruppeID, @UebungId = INSERTED.UebungId
    FROM INSERTED


    if (@AnzahlDoppelteUebungen > 0 AND UPDATE(Bez))
	begin
        DECLARE @DoppelteUebungen VARCHAR(max) = (SELECT STRING_AGG (Bez, ',') AS bezeichnungen
        FROM (                                SELECT Uebung.Bez
                FROM Uebung
            INTERSECT
                SELECT inserted.bez
                From inserted) I)
        raiserror('Folgende Übungen sind bereits vorhanden : %s', 11, 10, @DoppelteUebungen);
    END
	else
		UPDATE Uebung SET Uebung.bez = @bez, Uebung.fk_MuskelgruppeId = @fk_MuskelgruppeId WHERE UebungId = @UebungId;
END
GO


/* Funktion erstellen */
Drop FUNCTION IF EXISTS dbo.GetAllMuskelGruppenOfTrainingsplan;
GO
CREATE FUNCTION dbo.GetAllMuskelGruppenOfTrainingsplan (@trainingsPlanId INT) 
RETURNS VARCHAR(MAX)
AS
BEGIN
    declare @Result VARCHAR(max)
    declare @Enumerator TABLE (id INT)

    INSERT INTO @Enumerator
    SELECT DISTINCT Muskelgruppe.MuskelgruppeID
    FROM Muskelgruppe
        JOIN Uebung ON Uebung.fk_MuskelgruppeID = Muskelgruppe.MuskelgruppeID
        JOIN TrainingsplanEnthaeltUebung ON TrainingsplanEnthaeltUebung.fk_UebungID = Uebung.UebungID
    WHERE fk_TrainingsplanID = @trainingsPlanId

    DECLARE @id INT
    WHILE EXISTS (SELECT 1
    FROM @Enumerator)
    BEGIN
        SELECT TOP 1
            @id = id
        FROM @Enumerator

        SET @Result = CONCAT(
        @Result, 
        ', ',
        (SELECT Muskelgruppe.Bez FROM Muskelgruppe WHERE Muskelgruppe.MuskelgruppeID = @id),
        '(',
        (SELECT COUNT(Uebung.fk_MuskelgruppeID) FROM Uebung JOIN TrainingsplanEnthaeltUebung ON TrainingsplanEnthaeltUebung.fk_UebungID = Uebung.UebungID
        WHERE TrainingsplanEnthaeltUebung.fk_TrainingsplanID = @trainingsPlanId
        AND Uebung.fk_MuskelgruppeID = @id),
        ')')

        DELETE FROM @Enumerator WHERE id = @id
    END

    RETURN right(@Result, len(@Result)-2);
END;
GO


/* Prozedur Trainingsplan erstellen */
DROP PROCEDURE if exists sp_CreateTrainingplan;
go

CREATE PROCEDURE sp_CreateTrainingplan
    @bez varchar(50)
AS
BEGIN
    INSERT INTO Trainingsplan
        (Bez, ErstellDatum)
    VALUES(@bez, GETDATE());
    RETURN 1;
END
GO