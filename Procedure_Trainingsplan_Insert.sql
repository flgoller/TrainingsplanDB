USE Trainingsplan
GO

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