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
    Bez INT NOT NULL
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
DROP trigger if exists CheckUebung;
go

CREATE TRIGGER CheckUebung ON Uebung FOR INSERT, UPDATE
AS BEGIN

	if ((SELECT Count(Uebung.UebungID) FROM Uebung WHERE Uebung.Bez = (SELECT inserted.Bez FROM inserted)) > 1)
	begin
		raiserror('Diese Übung ist bereits vorhanden', 11, 10);
		rollback transaction;
	END
END

```

### Stored Procedure
```sql
DROP PROCEDURE if exists sp_CreateTrainingplan;
go

CREATE PROCEDURE sp_CreateTrainingplan
 @bez varchar(50)
AS BEGIN
 INSERT INTO Trainingsplan VALUES(@bez, GETDATE());
 RETURN 1;
END
GO

-- EXEC sp_CreateTrainingplan 'Trainingsplan f�r Beine'

```

