DROP PROCEDURE if exists sp_CreateTrainingplan;
go

CREATE PROCEDURE sp_CreateTrainingplan
 @bez varchar(50)
AS BEGIN
 INSERT INTO Trainingsplan VALUES(@bez, GETDATE());
 RETURN 1;
END
GO

-- EXEC sp_CreateTrainingplan 'Trainingsplan für Beine'