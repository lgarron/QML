-----------------------------------------------------------------------------
Happy Parser For QML, version 0.1

> {
> import Data.Char
> import Text.Read
> import Data.Complex
> import QTyCirc
> import QAux
> import QVec
> import QOrth
> import QSyn
> import QComp
  import QDen
> import QSuper
> import QCirc
> }

> %name calc
> %tokentype { Token }

> %monad { P } { thenP } { returnP }
> %lexer { lexer } { TokenEOF }

> %token 
>	let		{ TokenLet }
>	in		{ TokenIn }
>       if              { TokenIf }
>       ifo             { TokenIfo }
>       then            { TokenThen }
>       else            { TokenElse}
>       qtrue           { TokenTrue}
>       qfalse          { TokenFalse}
>	double		{ TokenDouble $$ }
>	var		{ TokenVar $$ }
>       fName           { TokenFunc $$ }
>	'='		{ TokenEq }
>	'+'		{ TokenPlus }
>	'*'		{ TokenTimes }
>	'('		{ TokenOB }
>	')'		{ TokenCB }
>       ','             { TokenCom }
>       '['             { TokenOSB }
>       ']'             { TokenCSB }
>       exp             { TokenExpo }
>       sqrt            { TokenSqrt }
>       pi              { TokenPi }
>       hF              { TokenHFaq }
>       '/'             { TokenDiv }
>       '-'             { TokenMinus }
>       ':'             { TokenColon }
>       ';'             { TokenSColon }
>       '|'             { TokenBar }
>       qb              { TokenQB }

> %right in
> %left '+' '-'
> %left '*' '/'
> %left NEG

> %%

> CTerms  :: { Snoc (Name,Con,PTerm,Ty) }
> CTerms  : CTerm             { SNil :< $1 } 
>         | CTerms ';' CTerm  { $1 :< $3 }

> CTerm  :: { (Name,Con,PTerm,Ty) }    
>        :  fName context '|' '-' PTerm ':' ':' type { ($1,$2,$5,$8) }

> PTerm  :: { PTerm }
>        : qfalse snames         { PAtom (PSup 1 0) $2 }
>        | qtrue  snames         { PAtom (PSup 0 1) $2 }
>        | qfalse                { PAtom (PSup 1 0) SNil }
>        | qtrue                 { PAtom (PSup 0 1) SNil }
>        | '-' qfalse snames     { PAtom (PSup (-1) 0) $3 }
>        | '-' qtrue  snames     { PAtom (PSup 0 (-1)) $3 }
>        | '-' qfalse            { PAtom (PSup (-1) 0) SNil }
>        | '-' qtrue             { PAtom (PSup 0 (-1)) SNil }
>        | '(' PTerm ')'         { ( $2 ) }
>        | Exp                   { $1 }

> Exp    :: { PTerm } 
>        : let '(' var ',' var ')' '=' PTerm in PTerm  { PLetP $3 $5 $8 $10 }
>        | let var '=' PTerm in PTerm                  { PLet $2 $4 $6 }
>        | if PTerm then PTerm else PTerm              { PIf $2 $4 $6 }
>        | '(' ')'                                     { PUnit }
>        | '(' PTerm ',' PTerm ')'                     { PPair $2 $4 }
>        | var    snames                               { PAtom (PVar $1) $2 }
>        | var                                         { PAtom (PVar $1) SNil }
>        | CNum '*' qtrue  snames '+' CNum '*' qfalse snames { PAtom (PSup $6 $1) (noDups ($4++<$9)) }
>        | CNum '*' qfalse snames '+' CNum '*' qtrue  snames { PAtom (PSup $1 $6) (noDups ($4++<$9)) }
>        | CNum '*' qtrue  '+' CNum '*' qfalse         { PAtom (PSup $5 $1) SNil }
>        | CNum '*' qfalse '+' CNum '*' qtrue          { PAtom (PSup $1 $5) SNil }
>        | CNum '*' Exp '+' CNum '*' Exp               { PTSup $1 $3 $5 $7 }
>        | ifo PTerm then PTerm else PTerm             { PIfo $2 $4 $6 }
>        | fName '(' PTerms ')'                        { PFApp $1 $3 }


> CNum  :: { Compl } 
>       : CNum '+' CNum               { $1 + $3 }
>       | CNum '-' CNum               { $1 - $3 }
>       | CNum '*' CNum               { $1 * $3 }
>       | CNum '/' CNum               { $1 / $3 }
>       | pi                          { pi }
>       | double                      { $1 :+ 0 }
>       | double ':' '+' double       { $1 :+ $4 }
>       | exp '(' CNum ')'            { exp  $3 } 
>       | sqrt '(' CNum ')'           { sqrt $3 }
>       | hF                          { 1 / sqrt 2 }
>       | '-' CNum  %prec NEG         { - ( $2 ) }
>       | '(' CNum ')'                { ( $2 ) }

> PTerms  : {- empty -}       { SNil }
>         | PTerm             { SNil :< $1 }
>         | PTerms ',' PTerm  { $1 :< $3 } 

> snames   : '[' names ']'  { $2 }

> names    : {- empty -}  { SNil }
>          | names var    { $1 :< $2 }

> context  : {- empty -}                   { SNil }
>          | context '(' var ',' type ')'  { $1 :< ($3,$5) }

> type :: { Ty }
>      : type '*' type  { $1 :<*> $3 }
>      | '(' type ')'   { $2 }
>      | qb             { Q2 }

> {

-----------------------------------------------------------------------------
The Error monad serves three purposes: 

	* it passes the input string around
	* it passes the current line number around
	* it deals with success/failure.

> type P a = String -> Int -> Error a

> thenP :: P a -> (a -> P b) -> P b
> m `thenP` k = \s l -> 
>	case m s l of
>		Error s -> Error s
>		OK a -> k a s l

> returnP :: a -> P a
> returnP a = \s l -> OK a

-----------------------------------------------------------------------------

The structure of parsed terms:

> data PTerm =  PAtom  Atm (Snoc Name)
>            |  PPair  PTerm PTerm
>            |  PLet   Name PTerm PTerm
>            |  PLetP  Name Name PTerm PTerm
>            |  PIf    PTerm  PTerm  PTerm
>            |  PIfo   PTerm  PTerm  PTerm
>            |  PTSup  Compl  PTerm  Compl  PTerm
>            |  PFApp  Name (Snoc PTerm)
>            |  PUnit
>             deriving (Eq,Show)

> data Atm  =  PVar  Name  
>           |  PSup  Compl Compl
>            deriving (Eq,Show)


The datastructure for the tokens...


> data Token
>	= TokenLet
>	| TokenIn
>       | TokenIf
>       | TokenIfo
>       | TokenThen
>       | TokenElse
>       | TokenTrue
>       | TokenFalse
>       | TokenDouble Double
>	| TokenVar Name
>       | TokenFunc Name
>	| TokenEq
>	| TokenPlus
>	| TokenTimes
>	| TokenCom
>	| TokenOSB
>	| TokenCSB
>	| TokenOB
>	| TokenCB
>	| TokenEOF
>       | TokenMinus
>       | TokenDiv
>       | TokenColon
>       | TokenSColon
>       | TokenPi
>       | TokenHFaq
>       | TokenSqrt
>       | TokenExpo
>       | TokenBar
>       | TokenQB

.. and a simple lexer that returns this datastructure.

> lexer :: (Token -> P a) -> P a
> lexer cont s = case s of
> 	[] -> cont TokenEOF []
>  	('\n':cs) -> \line -> lexer cont cs (line+1)
> 	(c:cs) 
>               | isSpace c -> lexer cont cs
>               | isAlpha c -> lexVar (c:cs)
>               | isNum c -> lexNum (c:cs)
> 	('-':'-':cs) -> \line -> lexer cont (dropWhile (/='\n') cs) (line+1)
> 	('=':cs) -> cont TokenEq cs
> 	('+':cs) -> cont TokenPlus cs
> 	('-':cs) -> cont TokenMinus cs
> 	('*':cs) -> cont TokenTimes cs
> 	('/':cs) -> cont TokenDiv cs
> 	(',':cs) -> cont TokenCom cs
> 	(':':cs) -> cont TokenColon cs
> 	(';':cs) -> cont TokenSColon cs
> 	('(':cs) -> cont TokenOB cs
> 	(')':cs) -> cont TokenCB cs
> 	('[':cs) -> cont TokenOSB cs
> 	(']':cs) -> cont TokenCSB cs
> 	('|':cs) -> cont TokenBar cs
>  where
>     lexNum cs = cont (TokenDouble (read num :: Double)) rest
>         where (num,rest) = span isNum cs
>     lexVar cs =
>         case span isAlpha cs of
>              ("let",rest)    -> cont TokenLet rest
>              ("in",rest)     -> cont TokenIn rest
>              ("if",rest)     -> cont TokenIf rest
>              ("ifo",rest)    -> cont TokenIfo rest
>              ("then",rest)   -> cont TokenThen rest
>              ("else",rest)   -> cont TokenElse rest
>              ("qtrue",rest)  -> cont TokenTrue rest
>              ("qfalse",rest) -> cont TokenFalse rest
>              ("exp",rest)    -> cont TokenExpo rest
>              ("pi",rest)     -> cont TokenPi rest
>              ("hF",rest)     -> cont TokenHFaq rest
>              ("sqrt",rest)   -> cont TokenSqrt rest
>              ("qb",rest)     -> cont TokenQB rest
>              (var,rest)      -> cont (lexAux var) rest
>     isNum  :: Char -> Bool
>     isNum  c = isDigit c || (c == '.') -- Needs improvement

> lexAux (c:cs) | isUpper c  = TokenFunc (c:cs)
>               | otherwise  = TokenVar (c:cs)

> runCalc :: String -> Snoc (Name,Con,PTerm,Ty)
> runCalc s = case calc s 1 of
>		OK e     -> e
>		Error s  -> error s

> runParser :: FilePath -> IO ()
> runParser x = (readFile x) >>= print.runCalc

> runPQTerm :: FilePath -> IO ()
> runPQTerm x = (readFile x) >>= print.pQTerm

> pQTerm    :: String -> Error Prog
> pQTerm s  =  do  funcs <- calc s 1
>                  return (Env ((unError.parseF (Env SNil)) (sreverse funcs)))

> parseF  :: Env (TCon,Ty) -> Snoc (Name,Con,PTerm,Ty) -> Error (Snoc (Name,FDef))
> parseF fs SNil                  =  OK SNil
> parseF fs (xs:< (f,gam,t,sig))  =  
>       do  pt           <- pTerm fs gam t
>           (gam',sig')  <- typeTm fs gam pt
>           eguard (size gam == size gam') (show f ++ ": context mismatch "++ show (gam,gam'))
>           eguard (size sig == size sig') (show f ++ ": Inferred type mismatch " ++ show (sig,sig'))
>           let fs' = Env ((unEnv fs) :< (f,(con2tcon gam,sig)))
>           pts          <- parseF fs' xs  
>           return (pts :< (f,FDef (FSig gam sig) pt))

> runTC :: FilePath -> Name -> IO()
> runTC fp n =  (readFile fp) >>= print.(pTCirc n)

> pTCirc :: Name -> String -> Error TCirc
> pTCirc n s = do  p <- pQTerm s
>                  c <- getTCirc n p 
>                  return c

> runC :: FilePath -> Name -> IO()
> runC fp n =  (readFile fp) >>= print.(pCirc n)

> pCirc :: Name -> String -> Error Circ
> pCirc n s = do  p <- pQTerm s
>                 c <- getCirc n p 
>                 return c

> runM :: FilePath -> Name -> IO()
> runM fp n =  (readFile fp) >>= print.(pComp n)

> pComp :: Name -> String -> Error Mat
> pComp n s = do  p <- pQTerm s
>                 c <- compP n p 
>                 return c

> runI :: FilePath -> Name -> IO()
> runI fp n =  (readFile fp) >>= print.(pIsom n)

> pIsom :: Name -> String -> Error (Int,Isom)
> pIsom n s = do  p     <- pQTerm s
>                 (g,c) <- isomP n p
>                 return (g,c)

> runCon :: FilePath -> Name -> IO()
> runCon fp n =  (readFile fp) >>= print.(pCon n)

> pCon :: Name -> String -> Error (Snoc Name)
> pCon n s = do  p   <- pQTerm s
>                uc  <- getuCon n p
>                return uc

> runS :: FilePath -> Name -> IO()
> runS fp n =  (readFile fp) >>= print.(pSuper n)

> pSuper      :: Name -> String -> Error Super
> pSuper n s  = do  p <- pQTerm s
>                   s <- superP n p         
>                   return s

> runStrict     :: FilePath -> IO()
> runStrict fp  =  (readFile fp) >>= print.(pStrict)


> pStrict    :: String -> Error (Env Bool)
> pStrict s  = do p <- pQTerm s
>                 return (strictTms (getTms p))
 
-----------------------------------------------------------------------------
The following functions should be defined for all parsers.

This is the overall type of the parser.

> type Parse = P (Snoc (Name,Con,PTerm,Ty))
> calc :: Parse

The next function is called when a parse error is detected.  It has
the same type as the top-level parse function.

> happyError :: P a
> happyError = \s i -> error (
>	"Parse error in line " ++ show (i::Int) ++ "\n")

-----------------------------------------------------------------------------

Put any tests or extra code here ...


Function to translate from P(arsed)Terms to QML Terms
by adding the orthogonality judgement

> pTerm :: Env (TCon,Ty) -> Con -> PTerm -> Error Tm
> pTerm fs g (PPair t u)      = do  pt <- pTerm fs g t
>                                   pu <- pTerm fs g u
>                                   return (Pair pt pu)
> pTerm fs g (PLet x t u)     = do  pt <- pTerm fs g t
>                                   pu <- pTerm fs g u
>                                   return (Let x pt pu)
> pTerm fs g (PLetP x y t u)  = do  pt <- pTerm fs g t
>                                   pu <- pTerm fs g u
>                                   return (LetP x y pt pu)
> pTerm fs g (PIf c t u)      = do  pt <- pTerm fs g t
>                                   pu <- pTerm fs g u
>                                   pc <- pTerm fs g c
>                                   return (If pc pt pu)
> pTerm fs g (PTSup l t k u)  = do  pt  <- pTerm fs g t
>                                   pu  <- pTerm fs g u
>                                   otu <- isOrth fs g pt pu
>                                   return (Ifo (Atom (Sup l k) SNil) pt pu otu)
> pTerm fs g (PIfo c t u)     = do  pt  <- pTerm fs g t
>                                   pu  <- pTerm fs g u
>                                   pc  <- pTerm fs g c
>                                   otu <- isOrth fs g pt pu
>                                   return (Ifo pc pt pu otu)
> pTerm fs g (PFApp fn pts)        = OK (FApp fn (smap (unError.pTerm fs g) pts))
> pTerm _  _ (PAtom (PSup a b) xs) = OK (Atom (Sup a b) xs)
> pTerm _  _ (PAtom (PVar x) xs)   = OK (Atom (Var x) xs)
> pTerm _  _ (PUnit)               = OK Unit

> }
