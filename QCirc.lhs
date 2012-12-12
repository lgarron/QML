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

\title{QCirc.lhs: Haskell code for quantum circuits}
\author{Jonathan Grattage}
\date{}

\begin{document}

\maketitle

This file includes the Haskell code for quantum circuits, introduced in chapter 3, reversible
quantum computations. The {\tt -fglasgow-exts} flag must be used.

\section{Module and import statements}
\begin{code}
module QCirc where

import Control.Monad
import Data.Complex

import QVec
import QAux
\end{code}

\section{A datatype of quantum circuits}
\begin{code}
data  Circ  =  Rot (Compl,Compl) (Compl,Compl)
	    |  Wire  [Int]
            |  Par   Circ  Circ
            |  Seq   Circ  Circ
	    |  Cond  Circ  Circ
	       deriving Eq
\end{code}

\subsection{Arity Functions}
\begin{code}
arity              :: Circ -> Error Int
arity (Rot x y)    = do  eguard  (orthTest x y)  
                                 ("Orthogonality" ++ show (x,y))
			 return 1
arity (Wire xs)    = do  eguard  (chkPerm xs)  
                                 ("Wire: " ++ show xs)
		         return (length xs)
arity (Cond x y)   = do  m <- arity x
		  	 n <- arity y
			 eguard  (m == n) 
                                 ("Cond: arity =" ++ show (m,n))
			 return (1 + m)
arity (Par x y)    = do  m <- arity x
			 n <- arity y
			 return (m+n)
arity (Seq x y)    = do  m <- arity x
			 n <- arity y
			 eguard  (m == n) 
                                 ("Seq: arity =" ++ show (m,n))
			 return m

orthTest                  ::(Compl,Compl) -> (Compl,Compl) -> Bool
orthTest (l0,l1) (k0,k1)  = (conjugate l0) * k0 == -(conjugate l1) * k1

chkPerm     :: [Int] -> Bool
chkPerm xs  =  (and [elem x xs | x <- [0..length xs-1]])
\end{code}

\begin{code}
eval ::  Circ ->  Vec  -> Error  Vec
eval     c        v    = do  a <- arity c
                             eguard  (a == size v)
				     ("Input arity: " ++ show a)
                             m <- comp c
                             return (v @>>= m)
\end{code}

\subsection{Compiling a circuit into a matrix}
\begin{code}
comp                :: Circ -> Error Mat
comp  (Wire ps)     = return (Mat rcdim rcdim permuteF)
	           where  rcdim = length ps
		          permuteF xs ys  | ys == [xs!!p | p<-ps] = 1
			                  | otherwise = 0
comp  (Seq c1 c2)   = do  m1 <- comp c1
			  m2 <- comp c2
			  return (m1 @>>= m2)
comp  (Par c1 c2)   = do  m1 <- comp c1
			  m2 <- comp c2
			  return (m1 <*> m2)
comp  (Cond c1 c2)  = do  a  <- arity c1
			  b  <- arity c2
			  eguard  (a == b) 
                                  ("Cond arity: " ++ show (a,b))
			  m1 <- comp c1
			  m2 <- comp c2
			  let  cond (True:xs)   (True:ys)   = (funM m1) xs ys
			       cond (False:xs)  (False:ys)  = (funM m2) xs ys
			       cond _           _           = 0
			  return (Mat (1+a) (1+b) cond)
comp  (Rot (l0,l1) (k0,k1))  = do  let  rotF [True]   [True]   = k1
					rotF [True]   [False]  = k0
					rotF [False]  [True]   = l1
					rotF [False]  [False]  = l0
					rotF _        _        = undefined
				   return (Mat 1 1 rotF)
\end{code}

\section{Auxiliary Code}

|permN a b c d| generates
a permutation which swaps two groups of wires, and is best explained with
a diagram, where |a::Nat| represents the first |a| wires as a group,
|b::Nat| is the next |b| wires, |c::Nat| is the next |c| wires,
and |d::Nat| is the final group of |d| wires. The action is given as:
\[
\Qcircuit@@C=1em @@R=1em @@!R{
  \lstick{a}&\qw &\qw&\rstick{a}\qw\\
  \lstick{b}&\qxT&   &\rstick{c}\qw\\
  \lstick{c}&\qxB&   &\rstick{b}\qw\\
  \lstick{d}&\qw &\qw&\rstick{d}\qw}
\]
For example, |permN 1 2 3 1 = Wire [0,3,4,5,1,2,6]|; the action
essentially swaps the |b| and |c| wire groups.
\begin{code}
permN           :: Int -> Int ->  Int -> Int -> Circ
permN  0 0 0 0  = Wire []
permN  a b c d  = Wire (as++cs++bs++ds)
      where  as = [0..a-1] 
             bs = map (+a) [0..b-1]
             cs = map (+(a+b)) [0..c-1]
             ds = map (+(a+b+c)) [0..d-1]
\end{code}


\section{Example Circuits}
\begin{code}
idC     ::  Int  ->  Circ
idC         x    =   Wire [0..x-1]

notC    ::  Circ
notC    =   Rot  (0,1)  (1,0)

cnotC   ::  Circ
cnotC   =   Cond notC (idC 1)

phaseC  ::  Circ
phaseC  =   Rot  (1,0)  (0,0:+1)

pZedC   ::  Circ
pZedC   =   Rot  (1,0)  (0,-1)

--The Hadamard Gate
hadC    ::  Circ
hadC    =   Rot  (h,h)  (h,-h) where h = 1/(sqrt 2)

--The Toffoli Gate
toffoliC  ::  Circ
toffoliC  =   Cond cnotC (idC 2)

--The Fredkin Gate
fredkinC  ::  Circ
fredkinC  =   Cond (Wire [1,0]) (idC 2)
\end{code}

\section{Deutsch's Algorithm}
\begin{code}
deutschC ::  Circ    ->  Circ
deutschC     oracle  =  (Seq  (Seq  (Seq  (Par  (idC 1) notC) 
                                          (Par  hadC  hadC)) 
                                    oracle)
 	                      (Par hadC (idC 1)))


deutschJozsaC  ::  Int ->  Circ    ->  Circ
deutschJozsaC      n       oracle  =   Seq  (Seq  (Seq  (Par (idC n) notC)
                                                        (hadN (n+1)))
                                                  oracle) 
                                            (Par (hadN n) (idC 1))

hadN ::  Int  ->  Circ
hadN     0    =   error "Invalid arity"
hadN     1    =   hadC
hadN     n    =   Par (hadN (n-1)) hadC


o1,o2,o3,o4 :: Circ
o1 =  cnotC                                -- |f x  = x|,  balanced
o2 =  Seq  (Seq (Par notC (idC 1)) cnotC) 
	   (Par notC (idC 1))              -- |f x  = not x|,  balanced
o3 =  idC 2                                -- |f x  = 0|, constant
o4 =  Par (idC 1) notC                     -- |f x  = 1|, constant
\end{code}


\section{Quantum Teleportation}
\begin{code}
cpZedC  ::  Circ
cpZedC  =   Cond pZedC (idC 1)

teleportC :: Circ
teleportC = Seq  (Seq  (Seq  (Seq  (Seq  (Par  cnotC  (idC 1))
                                         (Par  hadC   (idC 2)))
                                   (Par (idC 1) cnotC))
	                     (Wire [1,0,2]))
	               (Par (idC 1) cpZedC))
	         (Wire [1,0,2])
\end{code}

\section{Circuit optimiser}

This code optimises a circuit by applying several simple
structural simplifications to a circuit datatype.

\begin{code}
rCircuit     :: Circ -> Circ
rCircuit x   | rCirc x == x = x
             | otherwise = rCircuit (rCirc x)
\end{code}

\begin{code}
rCirc :: Circ -> Circ
rCirc  (Seq  (Wire xs)  (Wire ys))      = (Wire (seqPerm xs ys))
rCirc  (Par  x          (Wire []))      = x
rCirc  (Par  (Wire [])  y)              = y
rCirc  (Par  (Wire xs)  (Wire ys))      = Wire (xs ++ [y+length xs | y <- ys])
rCirc  (Seq  x          (Wire xs))      | xs == [0..length xs-1]  = x
                                        | otherwise               = (Seq   (rCirc x)   (Wire xs))
rCirc  (Seq  (Wire xs)  x)              | xs == [0..length xs-1]  = x
                                        | otherwise               = (Seq   (Wire xs)   (rCirc x))
rCirc  (Cond x          y)              | x == y     = (Par   (Wire [0])  (rCirc x))
                                        | otherwise  = (Cond  (rCirc x)   (rCirc y))
rCirc  (Seq (Par x y)   (Par a b))      | arity x == arity a  = (Par (rCirc (Seq x a)) (rCirc (Seq y b)))
rCirc  (Par (Seq a b) (Seq c d))        = rCirc (Seq (Par a c) (Par b d))
rCirc  (Par x y)                        = Par (rCirc x) (rCirc y)
rCirc  (Seq x (Seq y z))                = Seq (Seq x y) z
rCirc  (Seq x y)                        = Seq (rCirc x) (rCirc y)
rCirc  x                                = x
\end{code}

\begin{code}
seqPerm        :: [Int] -> [Int] -> [Int]
seqPerm xs ys  | lx /= ly       = error "Arity"
               | xs == [0..lx]  = ys
               | ys == [0..ly]  = xs
               | otherwise      = sortp xs ys
    where  lx = (length xs)-1
           ly = (length ys)-1
	   sortp _    []       = undefined
           sortp xs'  [y]      = [xs'!!y]
           sortp xs'  (y:ys')  = (xs'!!y) : sortp xs' ys' 
\end{code}




\end{document}
