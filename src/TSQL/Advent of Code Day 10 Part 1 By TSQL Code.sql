SET NOCOUNT ON
DECLARE @input varchar(max) = N'1113222113'
     , @Idx int = 1

DECLARE @OutputList TABLE ( stepId int identity(1,1) , inputItem varchar(max), outputItem varchar(max) )


DECLARE @char char(1)
      , @nextChar char(1)
      , @Count int
      , @output varchar(max) 


WHILE (@Idx <= 40 ) BEGIN 

    SELECT @char  =LEFT (@input,1)
        ,  @Count = 1
        ,  @output = ''
    SET @input = STUFF(@input,1,1,'')


    WHILE LEN(@input) > 0 BEGIN
        SET @nextChar = LEFT(@input,1)
        SET @input = STUFF(@input,1,1,'')

        IF @nextChar = @char BEGIN 
            SET @Count = @Count + 1
            CONTINUE
        END ELSE BEGIN
            SET @output = @output  + CAST(@Count as varchar) + @char
            SET @char = @nextChar
            SET @Count = 1
        END
    
    END
    SET @output = @output  + CAST(@Count as varchar) + @char

    PRINT CAST(@Idx as varchar) + '-' + @output

    INSERT INTO @OutputList (inputItem,outputItem)
    SELECT @input,@output
    
    SET @input = @output
    
    SET @Idx = @Idx + 1
END

SELECT *, LEN(OL.outputItem)
FROM @OutputList OL
ORDER BY OL.stepId