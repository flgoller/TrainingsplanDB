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
