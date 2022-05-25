Use Trainingsplan
Go

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




