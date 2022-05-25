USE Trainingsplan
GO

Drop FUNCTION IF EXISTS dbo.GetAllMuskelGruppenOfTrainingsplan;
GO
CREATE FUNCTION dbo.GetAllMuskelGruppenOfTrainingsplan (@trainingsPlanId INT) 
RETURNS VARCHAR(MAX)
AS
BEGIN
    declare @Result VARCHAR(max)
    declare @Enumerator table (id int)

    insert into @Enumerator
    SELECT DISTINCT Muskelgruppe.MuskelgruppeID
    from Muskelgruppe
    JOIN Uebung ON Uebung.fk_MuskelgruppeID = Muskelgruppe.MuskelgruppeID
    JOIN TrainingsplanEnthaeltUebung on TrainingsplanEnthaeltUebung.fk_UebungID = Uebung.UebungID
    WHERE fk_TrainingsplanID = @trainingsPlanId

    declare @id int
    while exists (select 1 from @Enumerator)
    begin
        select top 1
            @id = id
        from @Enumerator

        SET @Result = CONCAT(@Result, ', ', (Select Muskelgruppe.Bez From Muskelgruppe Where Muskelgruppe.MuskelgruppeID = @id))

        delete from @Enumerator where id = @id
    end

    RETURN right(@Result, len(@Result)-2);
END;
GO

SELECT dbo.GetAllMuskelGruppenOfTrainingsplan(1) AS 'Muskelgruppen'