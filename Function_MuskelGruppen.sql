USE Trainingsplan
GO

Drop FUNCTION IF EXISTS dbo.GetAllMuskelGruppenOfTrainingsplan;
GO
CREATE FUNCTION dbo.GetAllMuskelGruppenOfTrainingsplan (@trainingsPlanId INT) 
RETURNS VARCHAR(MAX)
AS
BEGIN
    declare @Result VARCHAR(max)
    declare @Enumerator TABLE (id INT)

    INSERT INTO @Enumerator
    SELECT DISTINCT Muskelgruppe.MuskelgruppeID
    FROM Muskelgruppe
        JOIN Uebung ON Uebung.fk_MuskelgruppeID = Muskelgruppe.MuskelgruppeID
        JOIN TrainingsplanEnthaeltUebung ON TrainingsplanEnthaeltUebung.fk_UebungID = Uebung.UebungID
    WHERE fk_TrainingsplanID = @trainingsPlanId

    DECLARE @id INT
    WHILE EXISTS (SELECT 1 FROM @Enumerator)
    BEGIN
        SELECT TOP 1
            @id = id
        FROM @Enumerator

        SET @Result = CONCAT(@Result, ', ', (SELECT Muskelgruppe.Bez
        FROM Muskelgruppe
        WHERE Muskelgruppe.MuskelgruppeID = @id))

        DELETE FROM @Enumerator WHERE id = @id
    END

    RETURN right(@Result, len(@Result)-2);
END;
GO

SELECT dbo.GetAllMuskelGruppenOfTrainingsplan(1) AS 'Muskelgruppen'