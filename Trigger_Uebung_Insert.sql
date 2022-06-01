USE Trainingsplan
GO

DROP trigger if exists CheckUebung;
go

CREATE TRIGGER CheckUebung ON Uebung INSTEAD OF INSERT
AS BEGIN
	DECLARE @AnzahlDoppelteUebungen INT = (SELECT COUNT(*) as Anz
	FROM (SELECT Uebung.Bez FROM Uebung INTERSECT SELECT inserted.bez From inserted) I);

	if (@AnzahlDoppelteUebungen > 0)
	begin
		DECLARE @DoppelteUebungen VARCHAR(max) = (SELECT STRING_AGG (Bez, ',') AS bezeichnungen FROM (SELECT Uebung.Bez FROM Uebung INTERSECT SELECT inserted.bez From inserted) I)
		raiserror('Folgende Übungen sind bereits vorhanden : %s', 11, 10, @DoppelteUebungen);
		rollback transaction;
	END
	else
		Insert INTO Uebung (Bez, fk_MuskelgruppeID) Select inserted.Bez, inserted.fk_MuskelgruppeID FROM inserted
END
GO