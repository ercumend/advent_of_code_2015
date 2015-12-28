SET NOCOUNT ON
DECLARE @input varchar(max) = N'Alice would gain 54 happiness units by sitting next to Bob.
Alice would lose 81 happiness units by sitting next to Carol.
Alice would lose 42 happiness units by sitting next to David.
Alice would gain 89 happiness units by sitting next to Eric.
Alice would lose 89 happiness units by sitting next to Frank.
Alice would gain 97 happiness units by sitting next to George.
Alice would lose 94 happiness units by sitting next to Mallory.
Bob would gain 3 happiness units by sitting next to Alice.
Bob would lose 70 happiness units by sitting next to Carol.
Bob would lose 31 happiness units by sitting next to David.
Bob would gain 72 happiness units by sitting next to Eric.
Bob would lose 25 happiness units by sitting next to Frank.
Bob would lose 95 happiness units by sitting next to George.
Bob would gain 11 happiness units by sitting next to Mallory.
Carol would lose 83 happiness units by sitting next to Alice.
Carol would gain 8 happiness units by sitting next to Bob.
Carol would gain 35 happiness units by sitting next to David.
Carol would gain 10 happiness units by sitting next to Eric.
Carol would gain 61 happiness units by sitting next to Frank.
Carol would gain 10 happiness units by sitting next to George.
Carol would gain 29 happiness units by sitting next to Mallory.
David would gain 67 happiness units by sitting next to Alice.
David would gain 25 happiness units by sitting next to Bob.
David would gain 48 happiness units by sitting next to Carol.
David would lose 65 happiness units by sitting next to Eric.
David would gain 8 happiness units by sitting next to Frank.
David would gain 84 happiness units by sitting next to George.
David would gain 9 happiness units by sitting next to Mallory.
Eric would lose 51 happiness units by sitting next to Alice.
Eric would lose 39 happiness units by sitting next to Bob.
Eric would gain 84 happiness units by sitting next to Carol.
Eric would lose 98 happiness units by sitting next to David.
Eric would lose 20 happiness units by sitting next to Frank.
Eric would lose 6 happiness units by sitting next to George.
Eric would gain 60 happiness units by sitting next to Mallory.
Frank would gain 51 happiness units by sitting next to Alice.
Frank would gain 79 happiness units by sitting next to Bob.
Frank would gain 88 happiness units by sitting next to Carol.
Frank would gain 33 happiness units by sitting next to David.
Frank would gain 43 happiness units by sitting next to Eric.
Frank would gain 77 happiness units by sitting next to George.
Frank would lose 3 happiness units by sitting next to Mallory.
George would lose 14 happiness units by sitting next to Alice.
George would lose 12 happiness units by sitting next to Bob.
George would lose 52 happiness units by sitting next to Carol.
George would gain 14 happiness units by sitting next to David.
George would lose 62 happiness units by sitting next to Eric.
George would lose 18 happiness units by sitting next to Frank.
George would lose 17 happiness units by sitting next to Mallory.
Mallory would lose 36 happiness units by sitting next to Alice.
Mallory would gain 76 happiness units by sitting next to Bob.
Mallory would lose 34 happiness units by sitting next to Carol.
Mallory would gain 37 happiness units by sitting next to David.
Mallory would gain 40 happiness units by sitting next to Eric.
Mallory would gain 18 happiness units by sitting next to Frank.
Mallory would gain 7 happiness units by sitting next to George.
Ercu would gain 0 happiness units by sitting next to Alice.
Ercu would gain 0 happiness units by sitting next to Bob.
Ercu would gain 0 happiness units by sitting next to Carol.
Ercu would gain 0 happiness units by sitting next to David.
Ercu would gain 0 happiness units by sitting next to Eric.
Ercu would gain 0 happiness units by sitting next to Frank.
Ercu would gain 0 happiness units by sitting next to George.
Ercu would gain 0 happiness units by sitting next to Mallory.
'

DECLARE @KeepValues varchar(200)
SET @KeepValues = ISNULL(@KeepValues,'a-z0-9 ')
SET @KeepValues = '%[^'+ @KeepValues + ']%'


DECLARE @expression varchar(500)
      , @Name varchar(50)
      , @NextToName varchar(50)
      , @HappinessGain int

DECLARE @PersonList TABLE (Id int identity(1,1), Name varchar(50) )
DECLARE @PersonHappiness TABLE (Id int identity(1,1), Name varchar(50) , NextToName varchar(50), HappinessGain int )
DECLARE @SeatingArrangementList TABLE (rowId int identity(1,1), Ids varchar(100) , TotalHappinessGain int )

WHILE CHARINDEX(CHAR(13),@input,0) > 0 BEGIN
    SET @expression = RTRIM(LTRIM(LEFT(@input,CHARINDEX(CHAR(13),@input,0))))

    SET @input = STUFF(@input,1,CHARINDEX(CHAR(13),@input,0),'')

    WHILE PatIndex(@KeepValues, @expression) > 0 SET @expression = Stuff(@expression, PatIndex(@KeepValues, @expression), 1, '')
    

    
    SELECT @Name = LEFT(@expression,PATINDEX('%' + g.GL + '%',@expression)-1)
         , @HappinessGain = CAST(SUBSTRING(@expression, PATINDEX('%[0-9]%',@expression),PATINDEX('% happiness%',@expression) - PATINDEX('%[0-9]%',@expression)  ) as int) * g.[Sign]
         , @NextToName = RIGHT(@expression, LEN(@expression)- PATINDEX('%sitting next to %',@expression) - 15)
    FROM (VALUES(' would gain',1),(' would lose',-1)) g(GL,[Sign]) WHERE PATINDEX('%' + g.GL + '%',@expression) > 0

    INSERT INTO @PersonHappiness (Name,NextToName,HappinessGain)
    SELECT @Name,@NextToName,@HappinessGain


    INSERT INTO @PersonList (Name) SELECT PersonName FROM ( SELECT @Name PersonName UNION SELECT @NextToName PersonName) X LEFT JOIN @PersonList L ON L.Name = X.PersonName WHERE L.Name IS NULL

    
END

DECLARE @ElementsNumber int
SELECT  @ElementsNumber = COUNT(*)
FROM    @PersonList;

With Permutations(   Permutation,Ids, Depth )
AS
(
    SELECT  CAST(L.Name as varchar(max)),
            CAST(CAST(L.Id as varchar) + ';' as varchar(max)),
            Depth = 1
    FROM    @PersonList L
    UNION All
    SELECT  CAST(Permutation + ' ' + L.Name as varchar(max)),
            CAST(Ids + CAST(L.Id as varchar) + ';' as varchar(max)),
            Depth = Depth + 1
    FROM    Permutations P
    CROSS JOIN @PersonList L
    WHERE   Ids Not like '%' + CAST(L.Id as varchar) + ';%' 
       --AND  Depth < @ElementsNumber 
)
INSERT INTO @SeatingArrangementList (Ids)
SELECT  LEFT(P.Ids,LEN(P.Ids)-1)
FROM    Permutations P
WHERE   Depth = @ElementsNumber


SELECT * FROM @PersonList
--SELECT * FROM @PersonHappiness
--SELECT * FROM @SeatingArrangementList



DECLARE @SeatingArrangement varchar(100) 
      , @SeatingArrangementRowId int
      , @RowsLeft int
      , @TotalHappinessGain int
WHILE EXISTS (SELECT * FROM @SeatingArrangementList SAL WHERE SAL.TotalHappinessGain IS NULL) BEGIN 

    SELECT @SeatingArrangement = SAL.Ids
         , @SeatingArrangementRowId = SAL.rowId
    FROM @SeatingArrangementList SAL WHERE SAL.TotalHappinessGain IS NULL
    ORDER BY SAL.rowId OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY

    SET @SeatingArrangement = @SeatingArrangement + ';'  + LEFT(@SeatingArrangement,CHARINDEX(';',@SeatingArrangement) - 1  )


    SELECT @RowsLeft = Count(*) FROM @SeatingArrangementList SAL WHERE SAL.TotalHappinessGain IS NULL

    IF @RowsLeft % 100 = 0 PRINT CAST(@RowsLeft as varchar)


    SET @TotalHappinessGain  = 0 
    SET @TotalHappinessGain = (
        SELECT SUM(PH.HappinessGain)
        FROM fn_Split(@SeatingArrangement,';') NameS
            JOIN @PersonList NamePL ON NamePL.Id = CAST(NameS.Item as int)
            JOIN fn_Split(@SeatingArrangement,';') NextToS ON NextToS.ID = NameS.ID + 1
            JOIN @PersonList NextToPL ON NextToPL.Id = CAST(NextToS.Item as int)
            JOIN @PersonHappiness PH ON PH.Name = NamePL.Name AND PH.NextToName = NextToPL.Name
    )

    SET @TotalHappinessGain = @TotalHappinessGain + (
        SELECT SUM(PH.HappinessGain)
        FROM fn_Split(@SeatingArrangement,';') NameS
            JOIN @PersonList NamePL ON NamePL.Id = CAST(NameS.Item as int)
            JOIN fn_Split(@SeatingArrangement,';') NextToS ON NextToS.ID = NameS.ID + 1
            JOIN @PersonList NextToPL ON NextToPL.Id = CAST(NextToS.Item as int)
            JOIN @PersonHappiness PH ON PH.Name = NextToPL.Name AND PH.NextToName = NamePL.Name
    )

    UPDATE SAL
    SET SAL.TotalHappinessGain= @TotalHappinessGain
    FROM @SeatingArrangementList SAL WHERE SAL.rowId = @SeatingArrangementRowId

    --IF @RowsLeft < 40000 BREAK
END


SELECT * FROM @SeatingArrangementList SAL
ORDER BY SAL.TotalHappinessGain
