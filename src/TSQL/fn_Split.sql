/****** Object:  UserDefinedFunction [dbo].[fn_Split]    Script Date: 16/01/06 10:57:39 AM ******/
DROP FUNCTION [dbo].[fn_Split]
GO

/****** Object:  UserDefinedFunction [dbo].[fn_Split]    Script Date: 16/01/06 10:57:39 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_Split](@String varchar(max),@Delimiter varchar(10) = ';')
RETURNS @Array TABLE(ID int IDENTITY(1,1),Item varchar(255))
AS BEGIN
  
  IF ISNULL(@String,'') = '' OR ISNULL(@Delimiter,'') = ''
    RETURN

  DECLARE @Position    int
         ,@OldPosition int
         ,@Item        varchar(255)
  SELECT  @Position    = 1
         ,@OldPosition = 1 
         ,@Item        = ''

  WHILE (1=1) BEGIN
    SELECT @OldPosition = @Position

    IF CHARINDEX(@Delimiter,@String,@Position) = 0 
      BREAK

    SELECT @Position = CHARINDEX(@Delimiter, @String, @Position) + 1

    SELECT @Item = SUBSTRING(@String, @OldPosition, @Position - @OldPosition - 1)
    IF DATALENGTH(ISNULL(@Item,'')) = 0 SELECT @Item = NULL
    INSERT INTO @Array SELECT REPLACE(REPLACE(LTRIM(RTRIM(@Item)),char(10),''),char(13),'')
  END

  SELECT @Item = SUBSTRING(@String, @Position, LEN(@String) - @Position + 1)
  IF DATALENGTH(ISNULL(@Item,'')) = 0 SELECT @Item = NULL
    INSERT INTO @Array SELECT REPLACE(REPLACE(LTRIM(RTRIM(@Item)),char(10),''),char(13),'')

  RETURN  
END
GO


