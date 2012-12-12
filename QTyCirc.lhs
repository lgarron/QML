\documentclass[times, 10pt,twocolumn]{article} 
%\documentstyle[times,art10,twocolumn,latex8]{article}

%\documentclass{mscs}
\documentclass{article}

%COMMENT OUT - JUST FOR PRINTING
\usepackage{a4wide}
\usepackage{color} %For comments

%include lhs2TeX.sty
%include lhs2TeX.fmt

\input{Qcircuit}
\input{prooftree}
\input{defs}

%QML Rule definitions:
% \input{ruledefs}


%include lhsrules.fmt

\newcommand{\txa}[1]{\textcolor{red}  {\textbf{Thorsten:} #1 }}
\newcommand{\jjg}[1]{\textcolor{blue} {\textbf{Jon:}      #1 }}
\newcommand{\asg}[1]{\textcolor{green}{\textbf{Alex:}     #1 }}

\title{QCirc.lhs: Haskell code for quantum circuits}
\author{Jonathan Grattage}
\date{}

\begin{document}

\maketitle

This file includes the Haskell code for typed quantum circuits 
(|FQC| morphisms), introduced in chapter 5. 
The Glasgow extensions are required.

\begin{code}
{-# OPTIONS_GHC -fglasgow-exts #-}
\end{code}

\begin{code}
module QTyCirc where

import Control.Monad
import Data.List

import QSyn
import QVec
import QCirc
import QAux
import QShow()
\end{code}

\subsection{Type Definitions}
\begin{code}
data Ty  =  Q1 | Q2 | Ty :<*> Ty
            deriving (Eq,Show)

instance Size Ty where
    size  Q1                = 0
    size  Q2                = 1
    size  (sigma :<*> tau)  = (size sigma) + (size tau)

instance Size (Maybe Ty) where
    size Nothing   = 0
    size (Just x)  = size x
\end{code}

\subsection{Types of terms}
Outputs pair of term input context and term output size.
The use of noDups ensures a variable that is copied
by $delta_C$ is onlt included once.
\begin{code}
typeTm :: Env (TCon,Ty) -> Con -> Tm -> Error (Con,Ty)
typeTm _ gam  (Atom (Var x) SNil)  = 
     do  sig <- slookup x gam
         return (SNil :< (x,sig), sig) 

typeTm _ gam  (Atom (Var x) dom)   =
     do  eguard  (not (selem x dom)) 
                 ("Weakening: "++ x ++" is in domain")
         sig   <- slookup x gam
         gam'  <- popCon gam (dom:<x)
         return (gam',sig)

typeTm _ _    (Atom (Sup _ _) SNil) =
     return (SNil,Q2)

typeTm _ gam  (Atom (Sup _ _) dom) =
     do  cdom <- popCon gam dom
         return (cdom,Q2)

typeTm fs gam  (Pair t u) =
     do  (conT,tyT) <- typeTm fs gam t
         (conU,tyU) <- typeTm fs gam u
         let uCon = uniqueCon conT conU
         return (uCon,tyT :<*> tyU)

typeTm fs gam  (Let x t u) =
     do  (conT,tyT)  <- typeTm fs gam t
         let gam'    = gam :< (x,tyT)
         (conU,tyU)  <- typeTm fs gam' u
         let con     = uniqueCon conT (sfilter (/=(x,tyT)) conU)
         return (con,tyU)

typeTm fs gam (LetP x y t u) =
     do  (conT,tyT)  <- typeTm fs gam t
         (sig,tau)   <- splitTy tyT
         let gam'    = gam:<(x,sig):<(y,tau)
         (conU,tyU)  <- typeTm fs gam' u
         let conU'   = sfilter (/=(x,sig)) (sfilter (/=(y,tau)) conU)
         return (uniqueCon conT conU',tyU)

typeTm fs gam (If b t u) =
     do  (conT,tyT)  <- typeTm fs gam t
         (conU,tyU)  <- typeTm fs gam u
         (conB,tyB)  <- typeTm fs gam b
         eguard (size tyB == 1)           "If: Conditional type error"
         eguard (size conT == size conU)  "If: context mismatch in branches"
         eguard (size tyT == size tyU)    "If: type mismatch in branches"
         let con = uniqueCon conB (uniqueCon conT conU)
         return (con,tyU)

typeTm fs gam (Ifo b t u _) =
     do  (conT,tyT)  <- typeTm fs gam t
         (conU,tyU)  <- typeTm fs gam u
         (conB,tyB)  <- typeTm fs gam b
         eguard (size tyB == 1)          "Ifo: Conditional type error"
         eguard (size conT == size conU) "Ifo: context mismatch in branches"
         eguard (size tyT == size tyU)   "Ifo: type mismatch in branches"
         let con = uniqueCon conB (uniqueCon conT conU)
         return (con,tyU)

typeTm fs gam (FApp n tms) = 
     do  (i,o) <- elookup n fs
         let sTms = smap (typeTm fs gam) tms
             sOut = ssum (smap (size.snd.unError) sTms)
             sIn  = sreverse (sconcat (smap (fst.unError) sTms))
         eguard  (size i == sOut)
                 ("Type mismatch in function "++ n ++"'s arguments")
         return (sIn,o)

typeTm _ _ Unit = return (SNil,Q1)
\end{code}

\subsection{Typed Contexts}
\begin{code}
class (Eq a, Show a, Size a) => VTy a where
  unitT  :: a
  enum   :: a -> [[Bool]]
  enum   a = base (size a)
class VTy a => VTenTy a where
  (<**>) :: a -> a -> a
  zeroT  :: a

type TCon = Snoc Ty

instance Size TCon where
    size (SNil)  = 0
    size (xs:<x) = size x + size xs

instance VTy TCon where
    unitT     = eC

instance VTenTy TCon where
    x <**> y  = (x ++< y)
    zeroT     = eC

eC,qC :: TCon
eC = SNil
qC = eC :< Q2
\end{code}

\subsection{Named Typed Contexts}
\begin{code}
type Con = Snoc (String,Ty) 

instance Size Con where
    size (SNil)  = 0
    size (xs:<(_,x)) = size x + size xs

instance VTy Con where
    unitT     = SNil

instance VTenTy Con where
    xs <**> SNil     = xs
    xs <**> (ys:<y)  = if selem y xs then xs <**> ys else (xs <**> ys) :< y
    zeroT            = SNil

splitCon :: Int -> TCon -> (TCon,TCon)
splitCon h tc = (sdrop h tc, stake h tc)

con2tcon              :: Con -> TCon
con2tcon SNil         = SNil
con2tcon (xs:<(_,s))  = (con2tcon xs) :< s

tcon2ty           :: TCon -> Ty
tcon2ty  SNil     = Q1
tcon2ty  (cs:<c)  = sfoldr (:<*>) c cs

con2ty  :: Con -> Ty
con2ty  = (tcon2ty.con2tcon) 

mkTy :: Int -> Ty
mkTy  0     = Q1
mkTy  1     = Q2
mkTy  (n+1) = (mkTy n) :<*> Q2

-- Names into types
populate  :: Con -> Snoc Name -> Error TCon
populate  _    SNil       = return SNil
populate  gam  (xs:<x)    = do  sig    <- slookup x gam
			        ptail  <- populate gam xs
				return (ptail:<sig)

-- Names into Contexts
popCon :: Con -> Snoc Name -> Error Con
popCon _    SNil     = return SNil
popCon gam  (xs:<x)  = do  sig    <- slookup x gam
                           ptail  <- popCon gam xs
                           return (ptail:<(x,sig))

-- Check if all names are given in context
checkCon :: Con -> Snoc Name -> Bool
checkCon gam ns  = (qsort lns) == (qsort.(sremove vs).names) gam
    where  lns  = sremove vs (noDups ns)
	   vs   = getVoid gam
           getVoid SNil          = SNil
           getVoid (xs:<(n,Q1))  = (getVoid xs):<n
           getVoid (xs:<_)       = getVoid xs

-- Gives the names used in a context
names  :: Con -> Snoc Name
names  = smap fst

conEq :: Con -> Con -> Bool
conEq xs ys | slength xs /= slength ys = False
            | otherwise = conEq' xs ys
      where conEq' SNil    _  = True
            conEq' (xs:<x) ys | selem x ys = conEq' xs ys
                              | otherwise  = False

-- Split a type in two (Used by LetP, typeTm)
splitTy :: Ty -> Error (Ty,Ty)
splitTy  (x:<*>y)  = OK (x,y)
splitTy  _         = Error "Tensor/Pair expected"
\end{code}

\subsection{Typed Circuits Datatype}
\begin{code}
data TCirc = TCirc {inT::TCon, outT::Ty, hpS,gbS::Int, circ::Circ}
            deriving (Show,Eq)
\end{code}

\subsubsection{Useful Circuits}
\begin{code}
eTy  ::  Ty
eTy  =   Q1

eTC    ::  TCirc
eTC    =   TCirc SNil eTy 0 0 (Wire [])

idTC   ::  TCon -> Circ
idTC   =   idC.size
\end{code}

\subsection{Typed Circuit Arity Function}
\begin{code}
arityTC ::  TCirc  ->  Error Int
arityTC     tc     =   (arity.circ) tc
\end{code}


\subsection{$\delta$ Functions}
\begin{code}
deltaTy :: Ty -> TCirc
deltaTy Q1            = TCirc  (eC:<Q1)  (Q1:<*>Q1)  1 0 (Wire [])
deltaTy Q2            = TCirc  (eC:<Q2)  (Q2:<*>Q2)  1 0 cnotC
deltaTy i@(s :<*> t)  = TCirc  (eC:<i)   (i:<*>i)    
                                (size i)  0 (Seq  (Seq  (Wire ps) 
                                                        (Par  ((circ.deltaTy) s) 
                                                              ((circ.deltaTy) t))) 
                                                  (Wire ps))
        where  ps  = permFromTy (eC:<s:<t:<s:<t) [0,2,1,3]
\end{code}
%format dcs = "\delta_{\sigma}"
%format dct = "\delta_{\tau}"
\[
\Qcircuit@@C=1.5em @@R=1.5em @@!R{
 \lstick{|sig|}           & \qw & \qw & \qw& \multigate{1}{|dcs|}& \qw & \qw& \rstick{|sig|}\qw\\
 \lstick{|tau|}           & \qw & \qxT&    & \ghost{|dcs|}       & \qxT&    & \rstick{|tau|}\qw\\
                          & \eqw& \qxB&    & \multigate{1}{|dct|}& \qxB&    & \rstick{|sig|}\qw\\
                          & \eqw& \qw & \qw& \ghost{|dct|}       & \qw & \qw& \rstick{|tau|}\qw}
\]

\begin{code}
deltaTCon            :: TCon -> TCirc
deltaTCon SNil        = eTC
deltaTCon (SNil:<t)   = deltaTy t
deltaTCon tc@(ts:<t)  = TCirc  tc oTc (size tc) 0
			       (Seq  (Seq  (Wire ps) 
                                           (Par ((circ.deltaTCon) ts) ((circ.deltaTy) t))) 
                                     (Wire ps))
                       where  oTc   = (tcon2ty tc):<*>(tcon2ty tc)
			      ps    = permFromTy (tc<**>tc) shuf
			      shuf  = [0..st-1]++[st+1..st*2]++[st,(st*2)+1]
			      st    = slength ts
\end{code}

\begin{code}
-- Takes Input Context and usedCon, and permutes input to match usedCon
sortCon  :: Con -> Snoc Name -> Error Circ
sortCon gam ucon = do  ps <- sortCon' ws (ucon)
                       return (Wire ps)
   where  ws = (conWires.sreverse) (stripCon gam ucon)
          sortCon' _  SNil     = OK []
          sortCon' xs (uc:<n)  = do ps'  <- slookup n xs 
                                    ps'' <- sortCon' xs uc
                                    return (ps'' ++ ps')

conWires :: Con -> Snoc (Name,[Int])
conWires xs = conWires' 0 ( xs)
     where  conWires' _  SNil         = SNil
            conWires' o  (xs:<(n,x))  = (conWires' l xs) :< (n, [o..l-1])   
                  where l = o + size x

stripCon :: Con -> Snoc Name -> Con
stripCon SNil         _  = SNil
stripCon (xs:<(n,ty)) ns | selem n ns  = stripCon xs ns :< (n,ty)
                         | otherwise   = stripCon xs ns

stripfromCon :: Con -> Snoc Name -> Con
stripfromCon  SNil         _  = SNil
stripfromCon  (xs:<(n,ty)) ns | selem n ns  = stripfromCon xs ns
                              | otherwise   = stripfromCon xs ns :< (n,ty)


rmFromCon :: Con -> Name -> Con
rmFromCon SNil         _  = SNil
rmFromCon (xs:<(n,ty)) n' | n == n'   = xs
                          | otherwise = rmFromCon xs n' :< (n,ty)

deltaCon             :: Con -> Con -> Con -> Error TCirc
deltaCon con gam del = do  let TCirc a b h g circ = deltaCon' gam del
                           --sortG   <- sortCon con uG
                           --sortD   <- sortCon con uD
                           sortGD  <- sortCon con (uniqueCon uG uD)
                           --return (TCirc a b h g (Seq sortGD (Seq circ (Par sortG sortD))))
                           return (TCirc a b h g (Seq sortGD circ))
   where uG = smap fst gam
         uD = smap fst del

-- If an a appears in xs and ys, remove it from ys and concat
-- Used to calculate "used context" when |deltaCon| is used
uniqueCon :: (Eq a) => Snoc a -> Snoc a -> Snoc a
uniqueCon xs ys = xs ++< (uniqueCon' xs ys)

uniqueCon' :: (Eq a) => Snoc a ->   Snoc a   ->  Snoc a
uniqueCon'  _   SNil     =   SNil
uniqueCon'  xs  (ys:<y)  |   selem y xs  = uniqueCon' xs ys
                         |   otherwise   = (uniqueCon' xs ys):<y

deltaCon'              :: Con -> Con -> TCirc
deltaCon'  SNil  SNil  = eTC
deltaCon'  SNil  ys    = TCirc (con2tcon ys) (con2ty ys) 0 0 (idC (size ys))
deltaCon'  ys    SNil  = TCirc (con2tcon ys) (con2ty ys) 0 0 (idC (size ys))
deltaCon'  xs (ys:<(y,s)) =
    case splitAtN (y,s) xs of
                   Nothing         ->  TCirc (a:<s) (b:<*>s) h 0 (Seq  (Wire ps)
                                                                     (Par  sub 
                                                                           (idTC (eC:<s))))
                         where  TCirc a b h _ sub = deltaCon' xs ys
				iTy      = (a:<s)<**>mkHeap h
				sa       = slength a
				ps       = permFromTy iTy ([0..sa-1]++[sa+1..sa+h]++[sa])
                   Just (xsl,xsr)  ->  TCirc (a:<s) oTy (h+size s) 0 (Seq  (Seq  (Wire ps)
						                                 (Par sub (circ (deltaTy s))))
                                                                           (Wire ps'))
			 where  TCirc a _ h _ sub = deltaCon' (xsl<**>xsr) ys 
				iTy       = (a:<s)<**>mkHeap (h+1)
				oTy       = tcon2ty (dCout xsl xsr ys s)
				(ps,ps')  = dCPerms iTy xsl xsr ys s

cXZ  = (SNil:<("x",Q2):<("z",Q2))
cZY  = (SNil:<("z",Q2):<("y",Q2))
cYZ  = (SNil:<("y",Q2):<("z",Q2))
cXYZ = (SNil:<("x",Q2):<("y",Q2):<("z",Q2))
cXZY = (SNil:<("x",Q2):<("z",Q2):<("y",Q2))
cY   = (SNil:<("y",Q2))
cX   = (SNil:<("x",Q2))

\end{code}

\[
\Qcircuit@@C=1.5em @@R=1em @@!R{
\lstick{|xs|'_l}& \qw     & \qw     & \multigate{3}{\delta_C}&     &       &    &                    \\
\lstick{|xs|'_r}& \qw     & \qw     & \ghost{\delta_C}       & \qw & \qw   & \qw& \rstick{|xs|_l}\qw \\
\lstick{|ys|}   & \qw     & \qw     & \ghost{\delta_C}       & \qw & \qxT  &    & \rstick{|sig|}\qw  \\
\lstick{|sig|}  & \qxT    &         & \ghost{\delta_C}       & \qxT& \qxBnw&    & \rstick{|xs|_r}\qw \\
                & \qxB\eqw&         & \multigate{1}{|dcs|}   & \qxB&       & \qw& \rstick{|ys|}\qw   \\
                & \eqw    & \qw     & \ghost{|dcs|}          & \qw & \qw   & \qw& \rstick{|sig|}\qw  }
\]

\subsubsection*{Auxillary Functions for |deltaCon|}
\begin{code}
dCout :: Con -> Con -> Con -> Ty -> TCon
dCout xsl xsr ys s = (xsl':<s)<**>xsr'<**>ys':<s
     where  xsl'  = con2tcon xsl
	    xsr'  = con2tcon xsr
	    ys'   = con2tcon ys

-- Can be simplified by using permN
dCPerms :: TCon -> Con -> Con -> Con -> Ty -> ([Int],[Int])
dCPerms iTy xsl xsr ys s = (permFromTy iTy ps,permFromTy mTy ps')
     where  mTy   = xsl'<**>xsr'<**>ys':<s:<s
            ps    = [0..sall-1]++[sall+1..sall+sh]++[sall,sall+sh+1]
            ps'   = [0..sxl-1]++((sxl+sxr+sys):[sxl..sxl+sxr+sys-1])++[sxl+sxr+sys+1]
	    ys'   = con2tcon ys
	    sh    = numDups (xsl<**>xsr) ys
	    sys   = slength ys  
	    sall  = sxr + sys + sxl - sh	
	    (sxl,sxr)    = (slength xsl,slength xsr)
            (xsl',xsr')  = (con2tcon xsl,con2tcon xsr)

splitAtN       :: Eq a => a -> Snoc a -> Maybe (Snoc a,Snoc a)
splitAtN x ys  = do  pivot <- selemIndex x ys
		     return (sdrop (pivot+1) ys, stake pivot ys)

mkHeap :: Int -> TCon
mkHeap 0  = eC
mkHeap n  = (mkHeap (n-1)):<Q2  
\end{code}

\subsection{Evaluating a typed circuit}
\begin{code}
compTC     :: TCirc -> Error Mat 
compTC tc  = do  validTCirc tc
                 m <- (comp.circ) tc
                 return m

evalTC       :: TCirc -> Vec -> Error Vec
evalTC tc v  = do  m <- compTC tc
                   return (v @>>= m)
\end{code}

\subsubsection{Auxillary Functions}
These functions are private, for use only in the compiler.
\begin{code}
permFromTy       :: TCon -> [Int] -> [Int]
permFromTy g ps  | length ps == slength g  = concat (permList (fixp (tcon2sizes g) 0) ps)
                 | otherwise               = error ("permFromTy: " ++ show (g,ps))

permList             :: [a] -> [Int] -> [a] 
permList _   []      = []
permList gs  (p:ps)  = (gs!!p) : permList gs ps

fixp           :: [Int] -> Int -> [[Int]]
fixp [] _      = []
fixp (g:gs) x  = [x..x+g-1] : fixp gs (x+g)

tcon2sizes     :: TCon -> [Int]
tcon2sizes gs  = [ (size (gs!!<(lgs-x-1))) | x <- [0..(lgs-1)] ] 
    where lgs = slength gs
\end{code}

\section{Examples and Tests}
\begin{code}
hadTC   ::  TCirc
hadTC   =   TCirc (eC:<Q2) Q2 0 0 (Rot (h,h) (h,-h)) where h = 1 / sqrt 2

notTC   ::  TCirc
notTC   =   TCirc (eC:<Q2) Q2 0 0 (Rot (0,1) (1,0))

cnotTC  ::  TCirc
cnotTC  =   TCirc (eC:<Q2) Q2 0 0 (Cond notC (idTC (eC:<Q2)))

ccnotTC, toffoliTC :: TCirc
ccnotTC    = TCirc (eC:<Q2) Q2 0 0 (Cond cnotC (Wire [0,1]))
toffoliTC  = ccnotTC

cswapCT, fredkinCT :: TCirc
cswapCT    = TCirc (eC:<Q2) Q2 0 0 (Cond (Wire [1,0]) (Wire [0,1]))
fredkinCT  = cswapCT

hadsConTC, permConTC :: TCirc
hadsConTC  =  TCirc (eC:<Q2) Q2 0 0 (Seq  (Seq  (Par hadC hadC) cnotC)
	                                        (Par hadC hadC))

permConTC  =  TCirc (eC:<Q2) Q2 0 0 (Seq  (Seq  (Wire [1,0]) cnotC) 
		                                (Wire [1,0]))

tConXY = SNil :< ("x",Q2) :< ("y",Q2)
tConXYZ = SNil :< ("x",Q2) :< ("y",Q2) :< ("z",Q2)
\end{code}

\subsubsection{Deutsch's Algorithm}
\[
\Qcircuit@@C=1em @@R=1em @@!R{
 & \qw         & \gate{H}\qw & \multigate{1}{oracle}\qw & \gate{H}\qw & \qw \\
 & \gate{X}\qw & \gate{H}\qw & \ghost{oracle}\qw        & \qw         & \qw    }
\]
\begin{code}
deutschTC         :: Circ -> TCirc
deutschTC oracle  = TCirc (eC:<Q2:<Q2) (Q2:<*>Q2) 0 0
                          (Seq  (Seq  (Seq  (Par  (Wire [0]) notC) 
                                            (Par  hadC  hadC)) 
                                      oracle)
 	                        (Par hadC (Wire [0])))

\end{code}
|o1u| Circuit
\[
\Qcircuit@@C=1em @@R=1em @@!R{
 & \ctrl{1}\qw & \qw \\
 & \gate{X}    & \qw }
\]

|o2u| circuit
\[
\Qcircuit@@C=1em @@R=1em @@!R{
 & \gate{X} & \ctrl{1}\qw & \gate{X} & \qw \\
 & \qw      & \gate{X}    & \qw      & \qw }
\]

|o3u| circuit
\[
\Qcircuit@@C=1em @@R=1em @@!R{
 & \qw & \qw \\
 & \qw & \qw }
\]

|o4u| circuit
\[
\Qcircuit@@C=1em @@R=1em @@!R{
 & \qw      & \qw \\
 & \gate{X} & \qw }
\]

\subsection{|FQC| functions}

A function to convert a Typed Circuit into an |FQC| morphism,
and |FQC| functions from the |FQC| chapter of the thesis.

\begin{code}
data FQC = FQC {a,b,h,g :: Int, phi :: Circ}
       deriving Show

tyc2fqc :: TCirc -> FQC
tyc2fqc (TCirc a' b' h' g' phi') = FQC (size a') (size b') h' g' phi'

validFQC :: FQC -> Error FQC
validFQC f = do  let  ah = OK (a f + h f)
		      bg = OK (b f + g f)
		 eguard (ah == bg) "Input and output mismatch"
                 eguard (arity (phi f) == ah) "Circuit arity mismatch"
		 return f

validTCirc :: TCirc -> Error TCirc
validTCirc tc = do (validFQC.tyc2fqc) tc
                   return tc
                  
\end{code}

\end{document}
