SET NOCOUNT ON
DECLARE @input varchar(max) = N'Vixen can fly 19 km/s for 7 seconds, but then must rest for 124 seconds.
Rudolph can fly 3 km/s for 15 seconds, but then must rest for 28 seconds.
Donner can fly 19 km/s for 9 seconds, but then must rest for 164 seconds.
Blitzen can fly 19 km/s for 9 seconds, but then must rest for 158 seconds.
Comet can fly 13 km/s for 7 seconds, but then must rest for 82 seconds.
Cupid can fly 25 km/s for 6 seconds, but then must rest for 145 seconds.
Dasher can fly 14 km/s for 3 seconds, but then must rest for 38 seconds.
Dancer can fly 3 km/s for 16 seconds, but then must rest for 37 seconds.
Prancer can fly 25 km/s for 6 seconds, but then must rest for 143 seconds.
'




DECLARE @expression varchar(500)
DECLARE @RacerList TABLE(RacerName varchar(50), Speed int, FlyFor int, RestFor int , Cycle as FlyFor + RestFor)

DECLARE @RacerName varchar(50)
      , @Speed int
      , @FlyFor int
      , @RestFor int

WHILE CHARINDEX(CHAR(13),@input,0) > 0 BEGIN
    SET @expression = RTRIM(LTRIM(LEFT(@input,CHARINDEX(CHAR(13),@input,0))))

    SET @input = STUFF(@input,1,CHARINDEX(CHAR(13),@input,0),'')

    SET @expression = REPLACE(@expression,CHAR(10),'')
    SET @expression = REPLACE(@expression,CHAR(13),'')

    
    INSERT INTO @RacerList (RacerName,Speed,FlyFor,RestFor)
    SELECT LEFT(@expression, PATINDEX('% can fly %',@expression)-1)
         , SUBSTRING(@expression,PATINDEX('% can fly %',@expression)+9,PATINDEX('% km[/]s %',@expression) - PATINDEX('% can fly %',@expression) - 9 )
         , SUBSTRING(@expression,PATINDEX('% km[/]s for %',@expression)+10,PATINDEX('% seconds, but then must rest %',@expression) - PATINDEX('% km[/]s for %',@expression) - 10 )
         , SUBSTRING(@expression,PATINDEX('% rest for %',@expression)+10,PATINDEX('% seconds.%',@expression) - PATINDEX('% rest for %',@expression) - 10 )
    
END

DECLARE  @RaceLengt int  = 2503 

SELECT * 
, @RaceLengt / RL.Cycle as CycleCount
, @RaceLengt % RL.Cycle as TimeLeft
, CASE WHEN RL.FlyFor < @RaceLengt % RL.Cycle THEN RL.FlyFor ELSE @RaceLengt % RL.Cycle END FlyForLeft
, RL.FlyFor * RL.Speed * (@RaceLengt / RL.Cycle ) DistanceWithCyle
, CASE WHEN RL.FlyFor < @RaceLengt % RL.Cycle THEN RL.FlyFor ELSE @RaceLengt % RL.Cycle END * RL.Speed as DistanceWithLeft
, ( RL.FlyFor * RL.Speed * (@RaceLengt / RL.Cycle ) ) + ( CASE WHEN RL.FlyFor < @RaceLengt % RL.Cycle THEN RL.FlyFor ELSE @RaceLengt % RL.Cycle END * RL.Speed ) DistanceTotal
FROM @RacerList RL
ORDER BY DistanceTotal DESC