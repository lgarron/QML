%\documentclass[times, 10pt,twocolumn]{article} 
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

\title{QSuper.lhs: Haskell code for isometries and superoperators}
\author{Jonathan Grattage}
\date{}

\begin{document}

\maketitle

Haskell code for superoperators and isometries, discussed in chapter 5,
|FQC|: reversible and irreversible quantum computation. This code
requires the use of the Glasgow extensions.

\section{Module and import statements}
\begin{code}
{-# OPTIONS_GHC -XMultiParamTypeClasses -XTypeSynonymInstances #-}
\end{code}

\begin{code}
module QSuper where

import Data.Complex

import QVec
import QAux
\end{code}

\begin{code}
data Isom   = Isom   {conI :: Int, tyI :: Int, funI :: [Bool] -> [Bool] -> Compl}

data Super  = Super  {conS :: Int, tyS :: Int, funS :: [Bool] -> [Bool] -> Compl}

type Dens     = Mat 
\end{code}

\begin{code}

instance VEC Super Super where
   adjoint (Super a b s) = Super a b (adj s)
                            where adj f x y = conjugate (f y x)
   Super at bt s1  <*> Super ct dt s2   
            = Super  (at+ct) (bt+dt) 
                     (\bac -> \bbd -> 
                       let  (a,c,a',c')  = sTyPerm (2*at) (2*ct) bac
                            (b,d,b',d')  = sTyPerm (2*bt) (2*dt) bbd
  		       in (s1 (a++a') (b++b')) * (s2 (c++c') (d++d')))
   Super a1 b1 s1  <.>   Super a2 b2 s2   = Mat (a1+a1) (b1+b1) s1 <.> Mat (a2+a2) (b2+b2) s2
   Super a1 b1 s1  >.<   Super a2 b2 s2   = Super (a3 `div` 2) (b3 `div` 2) s3
                           where Mat a3 b3 s3 = Mat a1 b1 s1 >.< Mat a2 b2 s2
   x               $*   Super a b s      = Super a b (\ba -> \bb -> x * (s ba bb))
 
-- sTyPerm corrects order input for superoperator tensor. See chapter 5.
sTyPerm :: Show a => Int -> Int -> [a] -> ([a],[a],[a],[a])
sTyPerm la lb xs  | la + lb == length xs = (a,b,a',b')
                  | otherwise = error ("sTyPerm size failure "++ show (la,lb,xs))
             where  (abs,abs')  = splitAt (hla+hlb) xs
                    (a,b)       = splitAt hla abs
                    (a',b')     = splitAt hla abs'
                    (hla,hlb)   = (la `div` 2, lb `div` 2)


instance VEC Isom Isom where
   adjoint (Isom a b i) = Isom a b (adj i)
                            where adj f x y = conjugate (f y x)
   Isom a1 b1 i1  <*>  Isom a2 b2 i2   = Isom a3 b3 i3
                            where Mat a3 b3 i3 = Mat a1 b1 i1 <*> Mat a2 b2 i2
   Isom a1 b1 i1  <.>  Isom a2 b2 i2   = Mat a1 b1 i1 <.> Mat a2 b2 i2
   Isom a1 b1 i1  >.<  Isom a2 b2 i2   = Isom a3 b3 i3
                            where Mat a3 b3 i3 = Mat a1 b1 i1 >.< Mat a2 b2 i2
   x              $*  Isom a b i      = Isom a b (\ba -> \bb -> x * (i ba bb))
\end{code}

\begin{code}
instance Bind Vec Isom where
   v @>>= (Isom a b f)   =  v @>>= (Mat a b f)

instance Bind Dens Super where
   d @>>= Super a b f    =  d @>>= (Mat (2*a) (2*b) f) 

instance Bind Super Super where
   Super a1 b1 f1 @>>= Super a2 b2 f2 = Super (a`div`2) (b`div`2) f 
               where Mat a b f = Mat (a1*2) (b1*2) f1 @>>= Mat (a2*2) (b2*2) f2

instance Bind Isom Isom where
   Isom a1 b1 f1 @>>= Isom a2 b2 f2 = Isom a b f 
               where Mat a b f = Mat a1 b1 f1 @>>= Mat a2 b2 f2
\end{code}

\begin{code}
instance Eq Isom where
 Isom a b m == Isom a' b' m'  =  a == a' &&  b == b' &&
			        (  [(x, y, m  x y) | x <- ba, y <- bb] ==
			           [(x, y, m' x y) | x <- ba, y <- bb])
			        where ba = base a
				      bb = base b

instance Eq Super where
 Super a b m == Super a' b' m'  =  a == a' &&  b == b' &&
			         (  [(x, y, m  x y) | x <- ba, y <- bb] ==
			            [(x, y, m' x y) | x <- ba, y <- bb])
			         where ba = base a
				       bb = base b
\end{code}

\begin{code}
mat2vec  :: Mat -> Vec
mat2vec  (Mat m n f) = Vec (m+n) (\bs -> let (b1,b2) = splitAt m bs
                                         in f b1 b2)

mat2super  :: Mat -> Super
mat2super  (Mat m n f)  
            = Super  m n 
                     (\ba -> \bb -> 
                               let  (a1,b1) = splitAt m ba
                                    (a2,b2) = splitAt n bb
                               in  (f a1 a2) * conjugate (f b1 b2))

mat2super' :: Mat -> Super
mat2super' m = Super (r `div` 2) (c `div` 2) f 
               where Mat r c f = m <*> (adjoint m)

copyM    :: Int -> Mat
copyM n  = Mat  n (n+n) 
                (\ba -> \bb -> let (b1,b2) = splitAt n bb
                               in if (ba == b1 && b1==b2) then 1 else 0)

mat2isom :: Mat -> Isom
mat2isom (Mat a b f) = Isom a b f 

copyS  :: Int -> Super
copyS  = mat2super . copyM
\end{code}

\begin{code}
isom2super  :: Isom -> Super
isom2super  (Isom m n f) 
            = Super  m n 
                     (\ba -> \bb -> 
                               let  (a1,a2) = splitAt m ba
                                    (b1,b2) = splitAt n bb
                               in  (f a1 b1) * conjugate (f a2 b2))

tr  :: Int -> Int -> Super
tr  m n = Super  m n 
                 (\ba -> let  (ab1,ab2) = splitAt m ba
                              (a1,b1) = splitAt n ab1
                              (a2,b2) = splitAt n ab2
                         in if b1 == b2  then funV (vreturn (a1 ++ a2))
                                         else funV (vzero))

permIsom     :: [Int] -> Isom
permIsom ps  = (Isom rcdim rcdim permuteF)
                where  rcdim = length ps
		       permuteF xs ys  | ys == [xs!!p | p<-ps] = 1
			               | otherwise = 0

permSuper     :: [Int] -> Super
permSuper ps  = isom2super (permIsom ps)

permSuper' ps  = (Super (rcdim `div` 2) (rcdim `div` 2) permuteF)
                 where  rcdim = length ps
		        permuteF xs ys  | ys == [xs!!p | p<-ps] = 1
			                | otherwise = 0

-- See permN in QCirc.lhs
permNI           :: Int -> Int ->  Int -> Int -> Isom
permNI  0 0 0 0  = idI 0
permNI  i o l n  | i+n   < 0  = error "permNI index: Arity too small"
	         | otherwise  = permIsom ([0..i-1] ++ block ++ rest)
    where  block  = [o+i..o+i+l-1]
	   rest   =  remove block [i..i+o+l+n-1]

permNS :: Int -> Int ->  Int -> Int -> Super
permNS  i o l n  = isom2super (permNI i o l n)
\end{code}

\begin{code}
idI  :: Int -> Isom
idI  n = Isom n n (\ba -> \bb -> if ba == bb then 1 else 0)

idS  :: Int -> Super
idS  n = Super n n (\ba -> \bb -> if ba == bb then 1 else 0)

pureDen  :: Vec -> Dens
pureDen  v =  v >.< v

den2super :: Dens -> Super
den2super d =  mat2super d

vec2super :: Vec -> Super
vec2super = mat2super.pureDen

\end{code}

\begin{code}
notI  :: Isom
notI  = Isom 1 1 notF
             where  notF [x] [y] | x /= y     = 1
                                 | otherwise  = 0
                    notF _   _   = 0

notS  :: Super
notS  = isom2super notI


cnotI = Isom 2 2 cnotf
        where cnotf [True,True] [True,False] = 1
              cnotf [True,False] [True,True] = 1
              cnotf [False,True] [False,True] = 1
              cnotf [False,False] [False,False] = 1
              cnotf _ _ = 0

-- Given a and h returns Isom a (a+h)
heapI      :: Int -> Int -> Isom 
heapI a h  = Isom a (a+h) heapf
      where heapf x xs = if (xs == x++fs) then 1 else 0
            fs = take h (repeat False)


dT = pureDen vT
dF = pureDen vF

sT = vec2super vT
sF = vec2super vF

\end{code}

\end{document}
