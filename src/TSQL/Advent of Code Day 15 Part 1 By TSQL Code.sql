SET NOCOUNT ON
DECLARE @input varchar(max) = N'Frosting: capacity 4, durability -2, flavor 0, texture 0, calories 5
Candy: capacity 0, durability 5, flavor -1, texture 0, calories 8
Butterscotch: capacity -1, durability 0, flavor 5, texture 0, calories 6
Sugar: capacity 0, durability 0, flavor -2, texture 2, calories 1
'
DECLARE @expression varchar(200)
DECLARE @IngredientList TABLE (Id int identity(1,1), Name varchar(50) , capacity int, durability int, flavor int, texture int,  calories int)
DECLARE @RecipeList TABLE (Id int identity(1,1) , Recipe varchar(200), Score bigint, Calories bigint)


WHILE PATINDEX('%' + CHAR(10) + '%',@input) > 0 BEGIN
    SET @expression = LEFT(@input,PATINDEX('%' + CHAR(10) + '%',@input)-2)
    SET @input = STUFF(@input,1,PATINDEX('%' + CHAR(10) + '%',@input),'')
    PRINT '[' + @expression + ']'
    INSERT INTO @IngredientList (Name,capacity,durability,flavor,texture,calories)
    SELECT LEFT(@expression,PATINDEX('%:%',@expression)-1)
          ,SUBSTRING(@expression,PATINDEX('%capacity%',@expression)+LEN('capacity'),PATINDEX('%, durability%',@expression)-PATINDEX('%capacity%',@expression)-LEN('capacity')) 
          ,SUBSTRING(@expression,PATINDEX('%durability%',@expression)+LEN('durability'),PATINDEX('%, flavor%',@expression)-PATINDEX('%durability%',@expression)-LEN('durability')) 
          ,SUBSTRING(@expression,PATINDEX('%flavor%',@expression)+LEN('flavor'),PATINDEX('%, texture%',@expression)-PATINDEX('%flavor%',@expression)-LEN('flavor')) 
          ,SUBSTRING(@expression,PATINDEX('%texture%',@expression)+LEN('texture'),PATINDEX('%, calories%',@expression)-PATINDEX('%texture%',@expression)-LEN('texture')) 
          ,SUBSTRING(@expression,PATINDEX('%calories%',@expression)+LEN('calories'),LEN(@expression) - PATINDEX('%calories%',@expression)+LEN('calories')) 
END 

SELECT * FROM @IngredientList

DECLARE @ElementList TABLE (Id int identity(1,1) , Name varchar(50) )

DECLARE @Idx int = 0

WHILE @Idx < 100 BEGIN 
    SET @Idx = @Idx + 1
    INSERT INTO @ElementList (Name)
    SELECT CAST(@Idx as varchar)
END





--SELECT * FROM @ElementList;

;WITH CTE  (Ids,Name,Depth,Total) AS 
(
    SELECT CAST(E.Id as varchar)
          ,CAST(E.Name  as varchar)
          ,0 
          ,E.Id 
    FROM @ElementList E
    UNION ALL
    SELECT  CAST(CAST(E.Id as varchar) + ';' + CE.Ids  as varchar)
         , CAST(E.Name + ';' + CE.Name as varchar)
         , CE.Depth + 1
         , E.Id + CE.Total
    FROM CTE CE
    CROSS JOIN @ElementList E
    WHERE CE.Depth + 1 < 4
)
INSERT INTO @RecipeList(Recipe)
SELECT c.Ids 
FROM CTE c
WHERE c.Depth = 3
 AND c.Total = 100



 DECLARE @RecipeSet varchar(100) 
       , @RecipeId int
       , @Score    bigint
       , @Calories bigint
       , @RecordLeft bigint 

 WHILE EXISTS( SELECT * FROM @RecipeList RL WHERE RL.Score IS NULL ) BEGIN
    SELECT @RecipeSet = RL.Recipe
      ,    @RecipeId = RL.Id 
    FROM @RecipeList RL
    WHERE RL.Score IS NULL 
    ORDER BY RL.Id OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY 

    SET @RecordLeft = ( SELECT COUNT(*) FROM @RecipeList RL WHERE RL.Score IS NULL) 
    IF @RecordLeft % 100 = 0  PRINT CAST(@RecordLeft  as varchar)

    SELECT @Score =  CASE WHEN SUM(CAST(S.Item as bigint) * I.capacity) < 0 THEN 0 ELSE SUM(CAST(S.Item as bigint) * I.capacity) END  
         * CASE WHEN SUM(CAST(S.Item as bigint) * I.durability) < 0 THEN 0 ELSE SUM(CAST(S.Item as bigint) * I.durability) END  
         * CASE WHEN SUM(CAST(S.Item as bigint) * I.flavor) < 0 THEN 0 ELSE SUM(CAST(S.Item as bigint) * I.flavor) END  
         * CASE WHEN SUM(CAST(S.Item as bigint) * I.texture) < 0 THEN 0 ELSE SUM(CAST(S.Item as bigint) * I.texture) END  
         , @Calories = CASE WHEN SUM(CAST(S.Item as bigint) * I.calories) < 0 THEN 0 ELSE SUM(CAST(S.Item as bigint) * I.calories) END  
     FROM fn_Split(@RecipeSet,';') S
     INNER JOIN @IngredientList I ON S.ID = I.Id

    UPDATE RL
    SET RL.Score = @Score
      , RL.Calories = @Calories
    FROM @RecipeList RL
    WHERE RL.Id = @RecipeId

 END

 

SELECT * FROM @RecipeList RL
ORDER BY RL.Score DESC


SELECT * FROM @RecipeList RL
WHERE RL.Calories = 500
ORDER BY RL.Score DESC