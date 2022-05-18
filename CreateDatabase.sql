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