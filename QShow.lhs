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

\title{QShow.lhs: |show| functions for |QVec|, |QCirc| and |QSuper|}
\author{Jonathan Grattage}
\date{}

\begin{document}

\maketitle

This file contains the show functions for vectors and 
matricies (|QVec.lhs|), circuits (|QCirc.lhs|),
and isometries and superoperators (|QSuper.lhs|).

\begin{code}
module QShow where

import QVec
import QCirc
import QSuper
\end{code}

\section{QVec Show functions}
\begin{code}
instance Show Vec where
  show (Vec a v)    =   "Arity = " ++ show a ++ "\n"
	            ++  lshow [(b, v b) | b <- base a, v b /= 0]

instance Show Mat where
  show (Mat a b m)  =   "\nRow/Input Arity = "  ++ show a ++  ",\n" 
	            ++  "Column/Output Arity = "  ++ show b ++  ",\n" 
	            ++  lshow [(x, y, m x y) |  x <- base a, 
			                        y <- base b, m x y /= 0]
			  
lshow :: Show a => [a] -> String
lshow []      =  "()"
lshow [x]     =  show x
lshow (x:xs)  =  (show x)++"\n"++(lshow xs)
\end{code}

\section{QCirc Show Functions}
\begin{code}
instance Show Circ where
  show  (Par   x  y)    = "Par "   ++ showp x y
  show  (Seq   x  y)    = "Seq "   ++ showp x y
  show  (Wire  xs)      = "Wire "  ++ show xs
  show  (Cond  x  y)    | x==notC && 
                          (y == (idC 1) || (y == Rot (1,0) (0,1))) 
                                      = "Controlled-Not"
                        | otherwise   = "Cond "  ++ showp x y
  show  r@(Rot   x  y)  | r == notC   = "Not"
                        | r == hadC   = "Hadamard"
                        | otherwise   = "Rot "   ++ show x ++ " " ++ show y

showp :: (Show a) => a -> a -> String
showp x y = "(" ++ show x ++ ") (" ++ show y ++ ")"
\end{code}

\section{QSuper Show Functions}
\begin{code}
instance Show Super where
  show (Super a b m)  =  "\nSuper-op input = "  ++ show a ++  ",\n" 
	                 ++ "Super-op output = "  ++ show b ++  ",\n" 
	                 ++  lshow [(x, y, m x y) |  x <- base (2*a), 
			                             y <- base (2*b), m x y /= 0]

instance Show Isom where
  show (Isom a b m)  =   "\nIsom input = "  ++ show a ++  ",\n" 
	                 ++  "Isom output = "  ++ show b ++  ",\n" 
	                 ++  lshow [(x, y, m x y) |  x <- base (a), 
			                             y <- base (b), m x y /= 0]
\end{code}

\end{document}
