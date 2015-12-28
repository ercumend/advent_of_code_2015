SET NOCOUNT ON
DECLARE @input varchar(max) = N'Tristram to AlphaCentauri = 34
Tristram to Snowdin = 100
Tristram to Tambi = 63
Tristram to Faerun = 108
Tristram to Norrath = 111
Tristram to Straylight = 89
Tristram to Arbre = 132
AlphaCentauri to Snowdin = 4
AlphaCentauri to Tambi = 79
AlphaCentauri to Faerun = 44
AlphaCentauri to Norrath = 147
AlphaCentauri to Straylight = 133
AlphaCentauri to Arbre = 74
Snowdin to Tambi = 105
Snowdin to Faerun = 95
Snowdin to Norrath = 48
Snowdin to Straylight = 88
Snowdin to Arbre = 7
Tambi to Faerun = 68
Tambi to Norrath = 134
Tambi to Straylight = 107
Tambi to Arbre = 40
Faerun to Norrath = 11
Faerun to Straylight = 66
Faerun to Arbre = 144
Norrath to Straylight = 115
Norrath to Arbre = 135
Straylight to Arbre = 127
'

DECLARE @KeepValues varchar(200)
SET @KeepValues = ISNULL(@KeepValues,'a-z0-9 =')
SET @KeepValues = '%[^'+ @KeepValues + ']%'


DECLARE @expression varchar(500)
      , @Departure  varchar(50)
      , @Arrival    varchar(50)
      , @Distance   int

DECLARE @RouteList TABLE (Departure varchar(50) , Arrival varchar(50) , Distance int  )
DECLARE @LocationList TABLE (LocationId int identity(1,1), LocationName varchar(50) )
DECLARE @RoutePermutationList TABLE (rowId int identity(1,1), Ids varchar(100) , Distance int )

WHILE CHARINDEX(CHAR(13),@input,0) > 0 BEGIN
    SET @expression = RTRIM(LTRIM(LEFT(@input,CHARINDEX(CHAR(13),@input,0)-1)))
    SET @input = STUFF(@input,1,CHARINDEX(CHAR(13),@input,0),'')

    WHILE PatIndex(@KeepValues, @expression) > 0 SET @expression = Stuff(@expression, PatIndex(@KeepValues, @expression), 1, '')
    
    SET @distance = RIGHT(@expression,LEN(@expression) - PATINDEX('%[ ]=[ ]%',@expression) - 2)
    SET @expression = LEFT(@expression,PATINDEX('%[ ]=[ ]%',@expression))
    SET @Departure =  RTRIM(LTRIM(LEFT(@expression,PATINDEX('%[ ]to[ ]%',@expression))))
    SET @Arrival = RTRIM(LTRIM(RIGHT(@expression,LEN(@expression) - PATINDEX('%[ ]to[ ]%',@expression) - 2)))

    INSERT INTO @LocationList (LocationName) SELECT Location FROM ( SELECT @Departure Location UNION SELECT @Arrival Location) X LEFT JOIN @LocationList L ON L.LocationName = X.Location WHERE L.LocationName IS NULL


    INSERT INTO @RouteList (Departure,Arrival,Distance)
    SELECT @Departure,@Arrival,@distance
    UNION 
    SELECT @Arrival,@Departure,@distance
    
END


Declare @ElementsNumber int
Select  @ElementsNumber = COUNT(*)
From    @LocationList;

With Permutations(   Permutation,Ids, Depth )
AS
(
    SELECT  CAST(L.LocationName as varchar(max)),
            CAST(CAST(L.LocationId as varchar) + ';' as varchar(max)),
            Depth = 1
    FROM    @LocationList L
    UNION All
    SELECT  CAST(Permutation + ' ' + L.LocationName as varchar(max)),
            CAST(Ids + CAST(L.LocationId as varchar) + ';' as varchar(max)),
            Depth = Depth + 1
    FROM    Permutations P
    CROSS JOIN @LocationList L
    WHERE   Ids Not like '%' + CAST(L.LocationId as varchar) + ';%' 
       --AND  Depth < @ElementsNumber 
)
INSERT INTO @RoutePermutationList (Ids)
Select  LEFT(P.Ids,LEN(P.Ids)-1)
From    Permutations P
Where   Depth = @ElementsNumber


--SELECT * FROM @RouteList
--SELECT * FROM @LocationList
SELECT * FROM @RoutePermutationList 


DECLARE @Ids varchar(100) 
      , @RoutePermutaionRowId int
      , @RowsLeft int
WHILE EXISTS (SELECT * FROM @RoutePermutationList RPL WHERE RPL.Distance IS NULL) BEGIN 
    SELECT @Ids = RPL.Ids
         , @RoutePermutaionRowId = RPL.rowId
    FROM @RoutePermutationList RPL WHERE RPL.Distance IS NULL
    ORDER BY RPL.rowId OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY

    SELECT @RowsLeft = Count(*) FROM @RoutePermutationList RPL WHERE RPL.Distance IS NULL

    IF @RowsLeft % 100 = 0 PRINT CAST(@RowsLeft as varchar)


    SELECT @Distance = SUM(RL.Distance)
    FROM 
    (
        SELECT S.ID ,D.LocationName Departure
        FROM fn_Split(@Ids,';') S
            JOIN @LocationList D ON D.LocationId = S.Item
    ) D
    JOIN
    (
        SELECT S.ID ,D.LocationName Arrival
        FROM fn_Split(@Ids,';') S
            JOIN @LocationList D ON D.LocationId = S.Item
    ) A ON A.ID = D.ID + 1
    JOIN @RouteList RL ON RL.Departure = D.Departure AND RL.Arrival = A.Arrival    

    UPDATE RPL
    SET RPL.Distance = @Distance
    FROM @RoutePermutationList RPL WHERE RPL.rowId = @RoutePermutaionRowId

END


SELECT * FROM @RoutePermutationList RPL 
ORDER BY RPL.Distance
