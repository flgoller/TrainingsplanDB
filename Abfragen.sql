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

/* Übungen, welche keinem Plan zugewiesen sind anzeigen */

SELECT UebungID, Uebung.Bez as 'Übung' FROM Uebung
LEFT JOIN TrainingsplanEnthaeltUebung ON TrainingsplanEnthaeltUebung.fk_UebungID = Uebung.UebungID
WHERE TrainingsplanEnthaeltUebung.TrainingsplanEnthaeltUebungID IS NULL

