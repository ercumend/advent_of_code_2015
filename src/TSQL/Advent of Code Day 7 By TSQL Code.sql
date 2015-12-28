SET NOCOUNT ON
DECLARE @input varchar(max) 
DECLARE @ExpressionList TABLE (
    id int identity(1,1)
,   expression varchar(200)
,   leftValue varchar(200)
,   hasLeftOperand bit
,   hasRightOperand bit
,   operator varchar(20)
,   leftOperand varchar(20)
,   rightOperand varchar(20)
,   identifier varchar(20)
,   identifierValue int

)    



SET @input = N'
bn RSHIFT 2 -> bo
lf RSHIFT 1 -> ly
fo RSHIFT 3 -> fq
cj OR cp -> cq
fo OR fz -> ga
t OR s -> u
lx -> a
NOT ax -> ay
he RSHIFT 2 -> hf
lf OR lq -> lr
lr AND lt -> lu
dy OR ej -> ek
1 AND cx -> cy
hb LSHIFT 1 -> hv
1 AND bh -> bi
ih AND ij -> ik
c LSHIFT 1 -> t
ea AND eb -> ed
km OR kn -> ko
NOT bw -> bx
ci OR ct -> cu
NOT p -> q
lw OR lv -> lx
NOT lo -> lp
fp OR fv -> fw
o AND q -> r
dh AND dj -> dk
ap LSHIFT 1 -> bj
bk LSHIFT 1 -> ce
NOT ii -> ij
gh OR gi -> gj
kk RSHIFT 1 -> ld
lc LSHIFT 1 -> lw
lb OR la -> lc
1 AND am -> an
gn AND gp -> gq
lf RSHIFT 3 -> lh
e OR f -> g
lg AND lm -> lo
ci RSHIFT 1 -> db
cf LSHIFT 1 -> cz
bn RSHIFT 1 -> cg
et AND fe -> fg
is OR it -> iu
kw AND ky -> kz
ck AND cl -> cn
bj OR bi -> bk
gj RSHIFT 1 -> hc
iu AND jf -> jh
NOT bs -> bt
kk OR kv -> kw
ks AND ku -> kv
hz OR ik -> il
b RSHIFT 1 -> v
iu RSHIFT 1 -> jn
fo RSHIFT 5 -> fr
be AND bg -> bh
ga AND gc -> gd
hf OR hl -> hm
ld OR le -> lf
as RSHIFT 5 -> av
fm OR fn -> fo
hm AND ho -> hp
lg OR lm -> ln
NOT kx -> ky
kk RSHIFT 3 -> km
ek AND em -> en
NOT ft -> fu
NOT jh -> ji
jn OR jo -> jp
gj AND gu -> gw
d AND j -> l
et RSHIFT 1 -> fm
jq OR jw -> jx
ep OR eo -> eq
lv LSHIFT 15 -> lz
NOT ey -> ez
jp RSHIFT 2 -> jq
eg AND ei -> ej
NOT dm -> dn
jp AND ka -> kc
as AND bd -> bf
fk OR fj -> fl
dw OR dx -> dy
lj AND ll -> lm
ec AND ee -> ef
fq AND fr -> ft
NOT kp -> kq
ki OR kj -> kk
cz OR cy -> da
as RSHIFT 3 -> au
an LSHIFT 15 -> ar
fj LSHIFT 15 -> fn
1 AND fi -> fj
he RSHIFT 1 -> hx
lf RSHIFT 2 -> lg
kf LSHIFT 15 -> kj
dz AND ef -> eh
ib OR ic -> id
lf RSHIFT 5 -> li
bp OR bq -> br
NOT gs -> gt
fo RSHIFT 1 -> gh
bz AND cb -> cc
ea OR eb -> ec
lf AND lq -> ls
NOT l -> m
hz RSHIFT 3 -> ib
NOT di -> dj
NOT lk -> ll
jp RSHIFT 3 -> jr
jp RSHIFT 5 -> js
NOT bf -> bg
s LSHIFT 15 -> w
eq LSHIFT 1 -> fk
jl OR jk -> jm
hz AND ik -> im
dz OR ef -> eg
1 AND gy -> gz
la LSHIFT 15 -> le
br AND bt -> bu
NOT cn -> co
v OR w -> x
d OR j -> k
1 AND gd -> ge
ia OR ig -> ih
NOT go -> gp
NOT ed -> ee
jq AND jw -> jy
et OR fe -> ff
aw AND ay -> az
ff AND fh -> fi
ir LSHIFT 1 -> jl
gg LSHIFT 1 -> ha
x RSHIFT 2 -> y
db OR dc -> dd
bl OR bm -> bn
ib AND ic -> ie
x RSHIFT 3 -> z
lh AND li -> lk
ce OR cd -> cf
NOT bb -> bc
hi AND hk -> hl
NOT gb -> gc
1 AND r -> s
fw AND fy -> fz
fb AND fd -> fe
1 AND en -> eo
z OR aa -> ab
bi LSHIFT 15 -> bm
hg OR hh -> hi
kh LSHIFT 1 -> lb
cg OR ch -> ci
1 AND kz -> la
gf OR ge -> gg
gj RSHIFT 2 -> gk
dd RSHIFT 2 -> de
NOT ls -> lt
lh OR li -> lj
jr OR js -> jt
au AND av -> ax
0 -> c
he AND hp -> hr
id AND if -> ig
et RSHIFT 5 -> ew
bp AND bq -> bs
e AND f -> h
ly OR lz -> ma
1 AND lu -> lv
NOT jd -> je
ha OR gz -> hb
dy RSHIFT 1 -> er
iu RSHIFT 2 -> iv
NOT hr -> hs
as RSHIFT 1 -> bl
kk RSHIFT 2 -> kl
b AND n -> p
ln AND lp -> lq
cj AND cp -> cr
dl AND dn -> do
ci RSHIFT 2 -> cj
as OR bd -> be
ge LSHIFT 15 -> gi
hz RSHIFT 5 -> ic
dv LSHIFT 1 -> ep
kl OR kr -> ks
gj OR gu -> gv
he RSHIFT 5 -> hh
NOT fg -> fh
hg AND hh -> hj
b OR n -> o
jk LSHIFT 15 -> jo
gz LSHIFT 15 -> hd
cy LSHIFT 15 -> dc
kk RSHIFT 5 -> kn
ci RSHIFT 3 -> ck
at OR az -> ba
iu RSHIFT 3 -> iw
ko AND kq -> kr
NOT eh -> ei
aq OR ar -> as
iy AND ja -> jb
dd RSHIFT 3 -> df
bn RSHIFT 3 -> bp
1 AND cc -> cd
at AND az -> bb
x OR ai -> aj
kk AND kv -> kx
ao OR an -> ap
dy RSHIFT 3 -> ea
x RSHIFT 1 -> aq
eu AND fa -> fc
kl AND kr -> kt
ia AND ig -> ii
df AND dg -> di
NOT fx -> fy
k AND m -> n
bn RSHIFT 5 -> bq
km AND kn -> kp
dt LSHIFT 15 -> dx
hz RSHIFT 2 -> ia
aj AND al -> am
cd LSHIFT 15 -> ch
hc OR hd -> he
he RSHIFT 3 -> hg
bn OR by -> bz
NOT kt -> ku
z AND aa -> ac
NOT ak -> al
cu AND cw -> cx
NOT ie -> if
dy RSHIFT 2 -> dz
ip LSHIFT 15 -> it
de OR dk -> dl
au OR av -> aw
jg AND ji -> jj
ci AND ct -> cv
dy RSHIFT 5 -> eb
hx OR hy -> hz
eu OR fa -> fb
gj RSHIFT 3 -> gl
fo AND fz -> gb
1 AND jj -> jk
jp OR ka -> kb
de AND dk -> dm
ex AND ez -> fa
df OR dg -> dh
iv OR jb -> jc
x RSHIFT 5 -> aa
NOT hj -> hk
NOT im -> in
fl LSHIFT 1 -> gf
hu LSHIFT 15 -> hy
iq OR ip -> ir
iu RSHIFT 5 -> ix
NOT fc -> fd
NOT el -> em
ck OR cl -> cm
et RSHIFT 3 -> ev
hw LSHIFT 1 -> iq
ci RSHIFT 5 -> cl
iv AND jb -> jd
dd RSHIFT 5 -> dg
as RSHIFT 2 -> at
NOT jy -> jz
af AND ah -> ai
1 AND ds -> dt
jx AND jz -> ka
da LSHIFT 1 -> du
fs AND fu -> fv
jp RSHIFT 1 -> ki
iw AND ix -> iz
iw OR ix -> iy
eo LSHIFT 15 -> es
ev AND ew -> ey
ba AND bc -> bd
fp AND fv -> fx
jc AND je -> jf
et RSHIFT 2 -> eu
kg OR kf -> kh
iu OR jf -> jg
er OR es -> et
fo RSHIFT 2 -> fp
NOT ca -> cb
bv AND bx -> by
u LSHIFT 1 -> ao
cm AND co -> cp
y OR ae -> af
bn AND by -> ca
1 AND ke -> kf
jt AND jv -> jw
fq OR fr -> fs
dy AND ej -> el
NOT kc -> kd
ev OR ew -> ex
dd OR do -> dp
NOT cv -> cw
gr AND gt -> gu
dd RSHIFT 1 -> dw
NOT gw -> gx
NOT iz -> ja
1 AND io -> ip
NOT ag -> ah
b RSHIFT 5 -> f
NOT cr -> cs
kb AND kd -> ke
jr AND js -> ju
cq AND cs -> ct
il AND in -> io
NOT ju -> jv
du OR dt -> dv
dd AND do -> dq
b RSHIFT 2 -> d
jm LSHIFT 1 -> kg
NOT dq -> dr
bo OR bu -> bv
gk OR gq -> gr
he OR hp -> hq
NOT h -> i
hf AND hl -> hn
gv AND gx -> gy
x AND ai -> ak
bo AND bu -> bw
hq AND hs -> ht
hz RSHIFT 1 -> is
gj RSHIFT 5 -> gm
g AND i -> j
gk AND gq -> gs
dp AND dr -> ds
b RSHIFT 3 -> e
gl AND gm -> go
gl OR gm -> gn
y AND ae -> ag
hv OR hu -> hw
1674 -> b
ab AND ad -> ae
NOT ac -> ad
1 AND ht -> hu
NOT hn -> ho
'

DECLARE @KeepValues varchar(200)
SET @KeepValues = ISNULL(@KeepValues,'a-z0-9 >')
SET @KeepValues = '%[^'+ @KeepValues + ']%'

DECLARE @expression varchar(256)
      , @identifier varchar(20)
      , @leftValue  varchar(256)
      , @operator  varchar(256)
      , @hasLeftOperand  bit
      , @hasRightOperand  bit
      , @LeftOperand varchar(20)
      , @RightOperand varchar(20)




DECLARE @message varchar(512)

WHILE CHARINDEX(CHAR(13),@input,0) > 0 BEGIN
    SET @expression = RTRIM(LTRIM(LEFT(@input,CHARINDEX(CHAR(13),@input,0)-1)))

    WHILE PatIndex(@KeepValues, @expression) > 0 SET @expression = Stuff(@expression, PatIndex(@KeepValues, @expression), 1, '')

    SET @identifier = CASE WHEN PATINDEX('%[ ]>[ ]%',@expression)  > 0 THEN RIGHT (@expression,LEN(@expression) - PATINDEX('%[ ]>[ ]%',@expression) - 2 ) ELSE NULL END
    SET @leftValue = CASE WHEN PATINDEX('%[ ]>[ ]%',@expression)  > 0 THEN LEFT (@expression,PATINDEX('%[ ]>[ ]%',@expression) - 1) ELSE NULL END

    SELECT  @operator = 'SET' , @hasLeftOperand = 0 ,@hasRightOperand = 0
    SELECT @operator = O.operator 
            , @hasLeftOperand = O.leftOperand
            , @hasRightOperand = O.rightOperand
    FROM  (VALUES('OR',1,1),('AND',1,1),('LSHIFT',1,1),('RSHIFT',1,1),('NOT',0,1)) O(operator,leftOperand,rightOperand) 
    WHERE PATINDEX('%' + O.operator + '[ ]%',@leftValue) > 0
    
    SELECT @LeftOperand = CASE WHEN @operator = 'SET' THEN @leftValue 
                               WHEN @hasLeftOperand = 1 THEN LEFT(@leftValue,PATINDEX('%[ ]' + @operator + '[ ]%',@leftValue))
                               ELSE NULL 
                          END

    SELECT @RightOperand = CASE WHEN @hasRightOperand = 1 THEN  RIGHT(@leftValue,len(@leftValue) - PATINDEX('%' + @operator + '[ ]%',@leftValue) - len(@operator) )
                               ELSE NULL 
                          END
    

    INSERT INTO @ExpressionList (expression,identifier,leftValue,operator,hasLeftOperand,hasRightOperand,leftOperand,rightOperand)
    SELECT  @expression
          , @identifier
          , @leftValue
          , @operator
          , @hasLeftOperand
          , @hasRightOperand
          , @LeftOperand
          , @RightOperand
    WHERE @identifier IS NOt NULL

    SET @input = STUFF(@input,1,CHARINDEX(CHAR(13),@input,0),'')

END 


WHILE EXISTS (
    SELECT I.*
    FROM @ExpressionList I
        LEFT JOIN @ExpressionList Iv ON I.operator = 'SET' AND I.leftOperand = Iv.identifier 
    WHERE (
          (I.operator = 'SET'  AND (ISNUMERIC(I.leftOperand) = 1  OR Iv.identifierValue IS NOT NULL ) )
       OR (ISNUMERIC(I.leftOperand) = 1 AND ISNUMERIC(I.rightOperand) = 1)
       OR (I.operator = 'NOT'  AND ISNUMERIC(I.rightOperand) = 1)
       )
     AND I.identifierValue IS NULL
) BEGIN 

    UPDATE I
    SET I.identifierValue = CAST(
                            CASE WHEN I.operator = 'SET' AND ISNUMERIC(I.leftOperand) = 1 THEN I.leftOperand
                                 WHEN I.operator = 'SET' AND Iv.identifierValue IS NOT NULL THEN Iv.identifierValue
                                 WHEN I.operator = 'LSHIFT' THEN I.leftOperand * POWER(2,I.rightOperand)
                                 WHEN I.operator = 'RSHIFT' THEN I.leftOperand / POWER(2,I.rightOperand)
                                 WHEN I.operator = 'AND'  THEN CAST(I.leftOperand as int) & CAST( I.rightOperand as int)
                                 WHEN I.operator = 'OR'  THEN CAST(I.leftOperand as int) | CAST( I.rightOperand as int)
                                 WHEN I.operator = 'NOT'  THEN CAST(~CAST(I.rightOperand - 32768 as smallint) + 32768 as int)
                                 ELSE NULL
                            END AS int)
    FROM @ExpressionList I
            LEFT JOIN @ExpressionList Iv ON I.operator = 'SET' AND I.leftOperand = Iv.identifier 
    WHERE (
          (I.operator = 'SET'  AND (ISNUMERIC(I.leftOperand) = 1  OR Iv.identifierValue IS NOT NULL ) )
       OR (ISNUMERIC(I.leftOperand) = 1 AND ISNUMERIC(I.rightOperand) = 1)
       OR (I.operator = 'NOT'  AND ISNUMERIC(I.rightOperand) = 1)
       )
     AND I.identifierValue IS NULL

    UPDATE I
    SET I.leftOperand = IV.identifierValue
    FROM @ExpressionList I
        JOIN @ExpressionList Iv ON IV.identifier = I.leftOperand AND IV.identifierValue IS NOT NULL
    WHERE I.hasLeftOperand = 1 


    UPDATE I
    SET I.rightOperand = IV.identifierValue
    FROM @ExpressionList I
        JOIN @ExpressionList Iv ON IV.identifier = I.rightOperand AND IV.identifierValue IS NOT NULL
    WHERE I.hasRightOperand = 1 


END 


    SELECT I.*
    FROM @ExpressionList I
    --ORDER BY I.identifier
    WHERE I.identifier IN( 'a','b')