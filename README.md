# TrainingsplanDB
DB for Project in M153

## ER-Diagramm
<img src="/Trainingsplan-erd.png" alt="Alt text" title="ER-Diagramm">

## Relationales Modell der DB
<img src="/Relationalesmodell.png" alt="Alt text" title="Relationales Modell">

Diagramm mit Beschreibung der Felder:
https://drawsql.app/trainingsplandb/diagrams/trainingsplan/embed


## Inhalt
### Trigger
Beim erstellen einer Übung wird zuerst geprüft, ob bereits eine Übung mit dieser Bezeichnung existiert.

### Stored Procedure
Erstellen eines Trainingplans, welches direkt das Heutige Datum als ErstellDatum abfüllt.

### Stored Function
Berechnung verwendete Muskelgruppen eines Trainingplans. (string Ausgabe mit Kommatrennung)

### Select SQL
Ausgabe von Traingsplan mit allen Übungen.

## SQL-Statements

### Erstellung der Datenbankstruktur
```sql
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

```
### Trigger
```sql
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

```

### Stored Procedure
```sql

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
```

### Beispieldaten
```sql
Use Trainingsplan
Go

DELETE FROM Muskelgruppe;
DELETE FROM Trainingsplan;
DELETE FROM TrainingsplanEnthaeltUebung;
DELETE FROM Uebung;
GO

INSERT INTO Muskelgruppe (Bez)
VALUES 
('Beine'), 
('Rücken'), 
('Bauch'), 
('Arme'), 
('Schultern'), 
('Brust')
GO

DECLARE @BeineID INT = (SELECT MuskelgruppeId From Muskelgruppe WHERE Muskelgruppe.Bez = 'Beine');
DECLARE @RückenID INT = (SELECT MuskelgruppeId From Muskelgruppe WHERE Muskelgruppe.Bez = 'Rücken');
DECLARE @BauchID INT = (SELECT MuskelgruppeId From Muskelgruppe WHERE Muskelgruppe.Bez = 'Bauch');
DECLARE @ArmeID INT = (SELECT MuskelgruppeId From Muskelgruppe WHERE Muskelgruppe.Bez = 'Arme');
DECLARE @SchulternID INT = (SELECT MuskelgruppeId From Muskelgruppe WHERE Muskelgruppe.Bez = 'Schultern');
DECLARE @BrustID INT = (SELECT MuskelgruppeId From Muskelgruppe WHERE Muskelgruppe.Bez = 'Brust');

INSERT INTO Uebung (Bez, fk_MuskelgruppeID)
VALUES
('Kniebeugen', @BeineID),
('Ausfallschritt', @BeineID),
('Beinheben', @BeineID),
('Kreuzheben', @BeineID),
('Wadenheben', @BeineID),

('Langhantel-Rudern', @RückenID),
('Kurzhantel-Rudern', @RückenID),
('Latzug', @RückenID),
('Klimmzug', @RückenID),
('Überzüge', @RückenID),

('Crunch', @BauchID),
('Plank', @BauchID),
('Side Plank', @BauchID),
('Russian Twist', @BauchID),
('Mountain Climber', @BauchID),

('Trizepsdrücken', @ArmeID),
('Dips', @ArmeID),
('Arnold Dips', @ArmeID),
('Enges Bankdrücken', @ArmeID),
('Curls', @ArmeID),

('Butterfly Reverse' ,@SchulternID),
('Schulterdrücken', @SchulternID),
('Seitenheben', @SchulternID),
('Frontheben', @SchulternID),
('Military Press', @SchulternID),

('Bankdrücken', @BrustID),
('Liegestütz', @BrustID),
('Fliegende', @BrustID),
('Schrägbankdrücken', @BrustID),
('Kabelzug-Fliegende', @BrustID)
GO

INSERT INTO Trainingsplan (Bez, ErstellDatum)
VALUES
('Ganzkörper', '2020-01-03'),
('Leg day', '2020-04-02'),
('Oberkörper', '2021-06-09')
GO

DECLARE @GanzKörperPlan INT = (SELECT TrainingsplandID From Trainingsplan WHERE Trainingsplan.Bez = 'Ganzkörper');
DECLARE @LegDayPlan INT = (SELECT TrainingsplandID From Trainingsplan WHERE Trainingsplan.Bez = 'Leg day');
DECLARE @OberkörperPlan INT = (SELECT TrainingsplandID From Trainingsplan WHERE Trainingsplan.Bez = 'Oberkörper');
INSERT INTO TrainingsplanEnthaeltUebung (fk_TrainingsplanID, fk_UebungID, Saetze, Wiederholungen, Gewicht, Optional)
VALUES
(@GanzKörperPlan, (Select UebungId From Uebung Where Uebung.Bez = 'Kniebeugen'), 3, 10, 120, 0),
(@GanzKörperPlan, (Select UebungId From Uebung Where Uebung.Bez = 'Kreuzheben'), 5, 6, 150, 0),
(@GanzKörperPlan, (Select UebungId From Uebung Where Uebung.Bez = 'Klimmzug'), 3, 10, 0, 0),
(@GanzKörperPlan, (Select UebungId From Uebung Where Uebung.Bez = 'Überzüge'), 3, 10, 70, 0),
(@GanzKörperPlan, (Select UebungId From Uebung Where Uebung.Bez = 'Crunch'), 2, 25, 0, 0),
(@GanzKörperPlan, (Select UebungId From Uebung Where Uebung.Bez = 'Dips'), 4, 12, 0, 0),
(@GanzKörperPlan, (Select UebungId From Uebung Where Uebung.Bez = 'Schulterdrücken'), 3, 10, 40, 0),
(@GanzKörperPlan, (Select UebungId From Uebung Where Uebung.Bez = 'Bankdrücken'), 3, 10, 10, 0),
(@GanzKörperPlan, (Select UebungId From Uebung Where Uebung.Bez = 'Liegestütz'), 3, 50, 0, 1),

(@LegDayPlan, (Select UebungId From Uebung Where Uebung.Bez = 'Kniebeugen'), 5, 8, 150, 0),
(@LegDayPlan, (Select UebungId From Uebung Where Uebung.Bez = 'Ausfallschritt'), 3, 10, 60, 0),
(@LegDayPlan, (Select UebungId From Uebung Where Uebung.Bez = 'Beinheben'), 3, 12, 70, 0),
(@LegDayPlan, (Select UebungId From Uebung Where Uebung.Bez = 'Kreuzheben'), 5, 8, 180, 0),
(@LegDayPlan, (Select UebungId From Uebung Where Uebung.Bez = 'Wadenheben'), 3, 12, 40, 0),

(@OberkörperPlan, (Select UebungId From Uebung Where Uebung.Bez = 'Latzug'), 3, 12, 80, 0),
(@OberkörperPlan, (Select UebungId From Uebung Where Uebung.Bez = 'Langhantel-Rudern'), 3, 10, 65, 0),
(@OberkörperPlan, (Select UebungId From Uebung Where Uebung.Bez = 'Trizepsdrücken'), 3, 10, 20, 0),
(@OberkörperPlan, (Select UebungId From Uebung Where Uebung.Bez = 'Curls'), 3, 10, 18, 0),
(@OberkörperPlan, (Select UebungId From Uebung Where Uebung.Bez = 'Seitenheben'), 3, 12, 40, 0),
(@OberkörperPlan, (Select UebungId From Uebung Where Uebung.Bez = 'Schulterdrücken'), 3, 12, 50, 0),
(@OberkörperPlan, (Select UebungId From Uebung Where Uebung.Bez = 'Bankdrücken'), 3, 12, 90, 0),
(@OberkörperPlan, (Select UebungId From Uebung Where Uebung.Bez = 'Fliegende'), 3, 12, 20, 1),
(@OberkörperPlan, (Select UebungId From Uebung Where Uebung.Bez = 'Kabelzug-Fliegende'), 3, 12, 20, 1)

```

### Abfragen
```sql
/* Alle Übungen des Ganzkörperplans */
SELECT 
Uebung.Bez as 'Übung', 
TrainingsplanEnthaeltUebung.Saetze AS 'Sätze', 
TrainingsplanEnthaeltUebung.Wiederholungen AS 'Wiederholungen',
TrainingsplanEnthaeltUebung.Gewicht AS 'Gewicht',
TrainingsplanEnthaeltUebung.OptiONal AS 'Optional',
Muskelgruppe.Bez AS 'Muskelgruppe'
FROM Trainingsplan
JOIN TrainingsplanEnthaeltUebung ON TrainingsplanEnthaeltUebung.fk_TrainingsplanID = Trainingsplan.TrainingsplandID
JOIN Uebung ON Uebung.UebungID = TrainingsplanEnthaeltUebung.fk_UebungID
JOIN Muskelgruppe ON Muskelgruppe.MuskelgruppeID = Uebung.fk_MuskelgruppeID
WHERE Trainingsplan.Bez = 'Ganzkörper'
GO

/* Übungen, welche keinem Plan zugewiesen sind anzeigen */

SELECT UebungID, Uebung.Bez as 'Übung' FROM Uebung
LEFT JOIN TrainingsplanEnthaeltUebung ON TrainingsplanEnthaeltUebung.fk_UebungID = Uebung.UebungID
WHERE TrainingsplanEnthaeltUebung.TrainingsplanEnthaeltUebungID IS NULL
GO

/* Eine Übung updaten */
SELECT * FROM Uebung WHERE Bez = 'Kniebeugen' 
GO
UPDATE Uebung SET fk_MuskelgruppeID = 2 WHERE Bez = 'Kniebeugen'
GO
SELECT * FROM Uebung WHERE Bez = 'Kniebeugen' 
GO

/* Eine Übung updaten wenn die neue Bezeichnung bereits existiert */
/* -> Sollte fehlschlagen, da Ausfallschritt bereits exisitert*/
UPDATE Uebung SET Bez = 'Ausfallschritt' WHERE Bez = 'Kniebeugen'
GO

/* Übersicht aller Plane*/
SELECT Trainingsplan.Bez as [Trainingsplan], Trainingsplan.ErstellDatum as [Erstellt am], dbo.GetAllMuskelGruppenOfTrainingsplan(Trainingsplan.TrainingsplandID) AS [Muskelgruppen] FROM Trainingsplan
GO

/* Ein Trainingsplan via Stored Procedure erstellen und danach ausgeben */
DECLARE @bez varchar(55) = 'Pull Day'
EXEC sp_CreateTrainingplan @bez
SELECT * FROM Trainingsplan WHERE Trainingsplan.Bez = @bez

```



