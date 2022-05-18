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
('Leg day', '2020-04-20'),
('Oberkörper', '2021-06-09')
GO

DECLARE @GanzKörperPlan INT = (SELECT TrainingsplandID From Trainingsplan WHERE Trainingsplan.Bez = 'Ganzkörper');
DECLARE @LegDayPlan INT = (SELECT TrainingsplandID From Trainingsplan WHERE Trainingsplan.Bez = 'Leg day');
DECLARE @OberkörperPlan INT = (SELECT TrainingsplandID From Trainingsplan WHERE Trainingsplan.Bez = 'Oberkörper');
INSERT INTO TrainingsplanEnthaeltUebung (fk_TrainingsplanID, fk_UebungID, Saetze, Wiederholungen, Gewicht, Optional)
VALUES
(@GanzKörperPlan, (Select UebungId From Uebung Where Uebung.Bez = 'Bankdrücken'), 3, 10, 100, 0)



