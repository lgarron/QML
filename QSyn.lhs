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

\title{QSyn.lhs: The syntax of QML as a Haskell datatype}
\author{Jonathan Grattage}
\date{}

\begin{document}

\maketitle

This file includes the Haskell code which encapsulates the syntax
of QML terms, introduced in chapter 6, QML: A functional quantum programming
language.

\begin{code}
{-# OPTIONS_GHC -fglasgow-exts #-}
\end{code}

\section{Module and import statements}
\begin{code}
module QSyn where

import QAux
import QVec
\end{code}

\section{QML Grammar}
\begin{code}
data At  =  Var  Name  
         |  Sup  Compl Compl
            deriving (Eq,Show)

data Tm  =  Atom  At (Snoc Name)
         |  Pair  Tm Tm
         |  Let   Name Tm Tm
         |  LetP  Name Name Tm Tm
         |  If    Tm  Tm  Tm
         |  Ifo   Tm  Tm  Tm Orth
	 |  FApp  Name (Snoc Tm)
         |  Unit
            deriving (Eq,Show)

qfalse,qtrue :: Tm
qfalse = Atom (Sup 1 0) SNil
qtrue  = Atom (Sup 0 1) SNil
\end{code}

\section{Orthogonality judgements}
\begin{code}
data Orth  =  OQBit0             -- qfalse $\perp$ qtrue       
           |  OQBit1             -- qtrue $\perp$ qfalse
	   |  OPair0  Int  Orth  -- left component + size of right term
           |  OPair1  Int  Orth  -- right component + size of left term   
	   |  OSup (Compl,Compl,Compl,Compl) Orth -- superposition + unitary
--	   |  OIfl  Orth  Orth
--	   |  OIfr  Orth  Orth
              deriving (Eq,Show)
\end{code}


\section{Strictness function}
\begin{code}
isStrict  :: Env Bool -> Tm -> Error Bool
isStrict  _  (Atom _ xs)     =  OK (snull xs)
isStrict  sf (Pair t u)      =  do  sT <- isStrict sf t
                                    sU <- isStrict sf u
                                    return (sT && sU)
isStrict  sf (Let _ t u)     =  do  sT <- isStrict sf t
                                    sU <- isStrict sf u
                                    return (sT && sU)
isStrict  sf (LetP _ _ t u)  =  do  sT <- isStrict sf t
                                    sU <- isStrict sf u
                                    return (sT && sU)
isStrict  sf (If  _ _ _)     =  OK False
isStrict  sf (Ifo t _ _ _)   =  isStrict sf t
isStrict  sf (FApp n ts)     =  
   do  nS <- elookup n sf
       if nS  then return (sand (smap (unError.isStrict sf) ts))
              else return False
isStrict  _  (Unit)          =  OK True

strictTms :: Env Tm -> Env Bool
strictTms tms = Env (sTms SNil ((sreverse.unEnv) tms))
    where  sTms :: Snoc (Name,Bool) -> Snoc (Name,Tm) -> Snoc (Name,Bool)
           sTms sf SNil          = sf
           sTms sf (xs:<(n,tm))  
               = sf' :< (n,unError (isStrict (Env sf') tm))
                where sf' = sTms sf xs 
\end{code}
\end{document}
