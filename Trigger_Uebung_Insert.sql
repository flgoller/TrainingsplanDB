DROP trigger if exists CheckUebung;
go

CREATE TRIGGER CheckUebung ON Uebung FOR INSERT
AS BEGIN
	
	if exists (SELECT Uebung.UebungID FROM Uebung WHERE Uebung.Bez = (SELECT inserted.Bez FROM inserted))
	begin
		raiserror('Diese �bung ist bereits vorhanden', 11, 10);
		rollback transaction;
	END
END