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

\title{QVec.lhs: Haskell code for linear algebra}
\author{Jonathan Grattage}
\date{}

\begin{document}

\maketitle

Code for vectors, matrices, and assosiated operations.
Used in chapter 3, reversible
quantum computations. The module |QVec| defined
here is imported by the |QCirc| module.
This module requres the Glasgow extensions, |-fglasgow-exts|.

\section{Module and import statements}
%if False
\begin{code}
{-# OPTIONS_GHC -fglasgow-exts #-}
\end{code}
%endif
\begin{code}
module QVec where

import Data.Complex
\end{code}

\section{Real and Complex number types}
\begin{code}
type Rea    = Double
type Compl  = Complex Rea
\end{code}

\section{Vector and Matrix definitions}
\begin{code}
--Vector (column) function
data Vec = Vec {dim::Int, funV:: [Bool]->Compl}

--Matrix (linear) function
data Mat = Mat {row :: Int, col :: Int, funM :: [Bool] ->[Bool]->Compl}
\end{code}

\section{The Size Class}
\begin{code}
class Size m where
    size :: m -> Int

instance Size Vec where
    size = dim
\end{code}

\section{Base enumerator}
\begin{code}
base :: Int -> [[Bool]]
base 0  = [[]] 
base n  = [True:bs | bs <- bss]++[False:bs | bs <- bss]
          where bss = base (n-1)
\end{code}

\section{Monad Bind: Matrix multiplication}
\begin{code}
class Bind a b where 
    (@>>=) :: a -> b -> a

instance Bind Vec Mat where 
    Vec d vf @>>= Mat m n mf  
              | d == m = Vec n (\bs -> if length bs == n 
                                        then  sum [vf as * (mf as bs) | as <- base d]
                                        else  error ("This vector has a different size "++show(bs,n)))
              | otherwise = error ("Type error: Vec ("++ show d ++") @>>= Mat "++ show (m,n))

instance Bind Mat Mat where 
   Mat a b f @>>= Mat a' b' f'  | b == a' =  Mat a b' (\ba -> funV ((Vec b (f ba)) @>>= Mat a' b' f'))
			        | otherwise = error ("Type error: Mat "++ show (a,b) ++" @>>= Mat " ++ show (a',b'))
\end{code}

\section{The Vector Class}
\begin{code}
class VEC a m | a -> m where
   adjoint  :: a -> a
   (<*>)    :: a -> a -> a      -- Tensor Product
   (<.>)    :: a -> a -> Compl  -- Inner Product
   (>.<)    :: a -> a -> m      -- Outer Product
   ($*)     :: Compl -> a -> a  -- Scalar Product
\end{code}

\begin{code}
instance VEC Vec Mat where
   adjoint (Vec a v)         = Vec a (adj v)
                                   where adj f x = conjugate (f x)

   Vec a v  <*>   Vec a' v'  = Vec (a + a') (\bs ->  let (b1,b2) = splitAt a bs
					             in v b1 * v' b2)

   Vec a v  <.>   Vec a' v'  | a == a'    = sum [conjugate (v as) * v' as | as <- base a]
                             | otherwise  = error "Vec: <.> Dot Product"

   Vec a v  >.<   Vec a' v'  = Mat a a' (\ba -> \bb -> v ba * conjugate (v' bb))
   x        $*   Vec a  v   = Vec a (\b -> x * (v b))
\end{code}

\begin{code}
instance VEC Mat Mat where
   adjoint (Mat a b m) = Mat a b (adj m)
                      where adj f x y = conjugate (f y x)

   Mat a b m  <*>   Mat a' b' m'  = Mat  (a+a') (b+b')
			   	         (\ba -> \bb -> 
                                         let  (a1,a2) = splitAt a ba
                                              (b1,b2) = splitAt b bb
				         in (m a1 b1) * (m' a2 b2))

   Mat a b m  <.>   Mat _ _ m'  = sum [conjugate (m bs as) * (m' as bs) | as <- base a, bs <- base b]

   m          >.<   m'          = m @>>= adjoint m'
   x          $*   Mat a b m   = Mat a b (\ba -> \bb -> x * (m ba bb))
\end{code}

\section{Equality functions}
\begin{code}
instance Eq Vec where
 Vec a v1 == Vec b v2 = a == b && ([(x, v1 x) | x <- bs] == [(y, v2 y) | y <- bs])
			where bs = base a

instance Eq Mat where
 Mat a b m == Mat a' b' m'  =  a == a' &&  b == b' &&
			       (  [(x, y, m  x y) | x <- ba, y <- bb] ==
			          [(x, y, m' x y) | x <- ba, y <- bb])
			       where ba = base a
				     bb = base b
\end{code}

\section{Vector return, apply, zero, and examples}
\begin{code}
vreturn  :: [Bool] -> Vec
vreturn  ba = Vec (length ba) (\b -> if b == ba then 1 else 0)

vapply  :: Vec -> [Bool] -> Compl
vapply  (Vec _ v) bs = v bs

vzero  :: Vec
vzero  = Vec 0 (\_ -> 0)

vT,vF,vFT :: Vec
vT   = vreturn  [True]
vF   = vreturn  [False]
vFT  = Vec 1 (\_ -> 1/sqrt 2)

pFF,pTT,pFT,pTF,pEPR :: Vec
pFF   = vreturn [False,False]
pTT   = vreturn [True,True]
pFT   = vreturn [False,True]
pTF   = vreturn [True,False]
pEPR  = Vec  2 eprF  
           where  eprF  [False,False]  = 1/sqrt 2
                  eprF  [True,True]    = 1/sqrt 2
                  eprF  _              = 0

mHad :: Mat
mHad = Mat 1 1 hadF 
            where  hadF [True]   [True]   = -  h 
                   hadF [True]   [False]  =    h
                   hadF [False]  [False]  =    h
                   hadF [False]  [True]   =    h
		   hadF _        _        =    0 --error "mHad Arity"
		   h = 1/sqrt 2

mNot :: Mat
mNot = Mat 1 1 notF
            where  notF [x] [y] | x /= y     = 1
                                | otherwise  = 0
                   notF _   _   = 0 --error "mNot Arity"
\end{code}

\end{document}
