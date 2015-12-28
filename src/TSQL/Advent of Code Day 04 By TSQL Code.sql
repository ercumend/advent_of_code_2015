

DECLARE @idx int = 0
     ,  @key varchar(100) = 'yzbqklnj'


WHILE (1=1) BEGIN
    IF SUBSTRING(sys.fn_sqlvarbasetostr(HASHBYTES('MD5', @key + cast(@idx as varchar))),3,5) = '00000' BREAK
    SET @idx = @idx + 1

    IF @idx % 1000  = 0 PRINT cast(@idx as varchar)
        
END


SELECT @idx