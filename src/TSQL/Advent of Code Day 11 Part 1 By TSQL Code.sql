SET NOCOUNT ON
DECLARE @intput varchar(max) = 'hepxcrrq'
       ,@letters varchar(max) 
       ,@idx int = ASCII('a')
       ,@iterationCount int = 0

DECLARE @nextChar char(1)

DECLARE @ThreeincreasingLetter TABLE ( threeLetter char(3) )
DECLARE @PairLetter  TABLE ( PairLetter char(2) )


WHILE @idx <= ASCII('z') BEGIN
    SET @letters = ISNULL(@letters ,'')+ CHAR(@idx)
    INSERT INTO @PairLetter (PairLetter) 
    SELECT CHAR(@idx) + CHAR(@idx)
    SET @idx =  @idx + 1
END 


SET @idx = 1
WHILE @idx <= 24 BEGIN
    INSERT INTO @ThreeincreasingLetter (threeLetter)
    SELECT SUBSTRING(@letters,@idx,3)
    SET @idx =  @idx + 1
END 


WHILE(1=1) BEGIN

    SET @idx =  LEN(@intput)
    WHILE (@idx > 0) BEGIN
        SET @nextChar = CASE WHEN SUBSTRING(@intput,@idx,1) = 'z' THEN 'a'
                             ELSE SUBSTRING(@letters,CHARINDEX(SUBSTRING(@intput,@idx,1) ,@letters) + 1,1)
                        END 
        SET @intput = STUFF(@intput,@idx,1,@nextChar)
        IF @nextChar = 'a' SET @idx = @idx -1
        ELSE BREAK
    END 

    IF EXISTS(SELECT * FROM @ThreeincreasingLetter tl WHERE PATINDEX('%' + tl.threeLetter + '%',@intput) > 0) 
    AND NOT EXISTS(SELECT * FROM (VALUES ('i'),('o'),('l')) mnc(letter) WHERE PATINDEX('%' + mnc.letter + '%',@intput) > 0)
    AND (SELECT COUNT(*) FROM @PairLetter pl WHERE PATINDEX('%' + pl.PairLetter + '%',@intput) > 0) >= 2
    BEGIN
        SELECT  @intput
        BREAK
    END
    
    
    
    SET @iterationCount = @iterationCount  +  1
    IF  @iterationCount % 10000  = 0 PRINT @iterationCount
--    IF @iterationCount = 500 BREAK

END


