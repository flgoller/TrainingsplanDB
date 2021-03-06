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
SELECT * FROM Uebung WHERE Bez = 'Kniebeugen'
GO
UPDATE Uebung SET Bez = 'Ausfallschritt' WHERE Bez = 'Kniebeugen'
GO
SELECT * FROM Uebung WHERE Bez = 'Kniebeugen'
GO

/* Übersicht aller Plane*/
SELECT Trainingsplan.Bez as [Trainingsplan], Trainingsplan.ErstellDatum as [Erstellt am], dbo.GetAllMuskelGruppenOfTrainingsplan(Trainingsplan.TrainingsplandID) AS [Muskelgruppen] FROM Trainingsplan
GO

/* Ein Trainingsplan via Stored Procedure erstellen und danach ausgeben */
DECLARE @bez varchar(55) = 'Pull Day'
EXEC sp_CreateTrainingplan @bez
SELECT * FROM Trainingsplan WHERE Trainingsplan.Bez = @bez