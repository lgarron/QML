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

\title{QAux.lhs: Auxiliary Haskell code used by the QML compiler}
\author{Jonathan Grattage}
\date{}

\begin{document}

\maketitle

This file includes the Haskell code for auxiliary functions,
such as a Snoc list library, the Error monad, Environment
definitions and functions, and some sorting functions.

\section{Module and import statements}

\begin{code}
module QAux where

import Control.Monad
\end{code}




\section{Snoc Lists}

This library is based on the Haskell list library, adapted
for Snoc lists.

\begin{code}
data Snoc a  =  SNil
	     |  Snoc a :< a
                deriving Eq

instance Monad Snoc where
   m >>= k   = sconcat (smap k m)
   return x  = SNil :< x
   fail _    = SNil

instance MonadPlus Snoc where
    mzero           = SNil
    SNil `mplus` b  = b
    a `mplus` _     = a

instance (Show a) => Show (Snoc a) where
    show xs = "{" ++ sshow xs ++ "}"
      where  sshow SNil       = ""
	     sshow (SNil:<x)  = show x
             sshow (ys:<y)    = sshow ys ++ "," ++ show y


unSnoc  :: Snoc a -> [a]
unSnoc  SNil     = []
unSnoc  (xs:<x)  = x: unSnoc xs

snocify  :: [a] -> Snoc a
snocify  []      = SNil
snocify  (x:xs)  = (snocify xs) :< x

(++<)           :: Snoc a -> Snoc a -> Snoc a
xs ++< SNil     =  xs
xs ++< (ys:<y)  =  (xs ++< ys):<y

(!!<)           :: Snoc a -> Int -> a
SNil   !!<_     = error "Empty !!< _"
(_ :<x)!!<0     = x
(xs:<_)!!<(n+1) = xs!!<n

sconcat      :: Snoc (Snoc a) -> Snoc a
sconcat xss  = sfoldr (++<) SNil xss

snull       :: Snoc a -> Bool
snull SNil  = True
snull _     = False

smap              :: (a -> b) -> Snoc a -> Snoc b
smap _ SNil       =  SNil
smap f (SNil:<x)  =  SNil :< (f x)
smap f (xs:<x)    =  (smap f xs) :< (f x)

slookup :: (Eq a, Show a) => a -> Snoc (a,b) -> Error b
slookup x SNil = Error ((show x) ++" Not found in context")
slookup k (xys:<(x,y)) | k==x      = OK y
		       | otherwise = slookup k xys

slength :: Snoc a -> Int
slength SNil    = 0
slength (xs:<_) = 1 + slength xs 

sreverse :: Snoc a -> Snoc a
sreverse SNil = SNil
sreverse (xs:<x) = (SNil:<x) ++< (sreverse xs)

stake :: Int -> Snoc a -> Snoc a
stake  0      _        = SNil
stake  _      SNil     = SNil
stake  (n+1)  (xs:<x)  = (stake n xs) :< x

sdrop :: Int -> Snoc a -> Snoc a
sdrop  0      xs       = xs
sdrop  _      SNil     = SNil
sdrop  (n+1)  (xs:<_)  = sdrop n xs

maybeToSnoc           :: Maybe a -> Snoc a
maybeToSnoc Nothing    = SNil
maybeToSnoc (Just a)   = SNil :< a

snocToMaybe           :: Snoc a -> Maybe a
snocToMaybe SNil       = Nothing
snocToMaybe (_:<a)    = Just a

sfilter           :: (a -> Bool) -> Snoc a -> Snoc a
sfilter _  SNil       = SNil
sfilter p  (SNil:<x)  = if p x then (SNil:<x) else SNil
sfilter p  (xs:<x)    = if p x then ((sfilter p xs):<x) else (sfilter p xs)

selemIndex               :: Eq a => a ->Snoc a -> Maybe Int
selemIndex x              = sfindIndex (x ==)
        
selemIndices             :: Eq a => a -> Snoc a ->Snoc Int
selemIndices x            = sfindIndices (x ==)
		        
sfind                    :: (a -> Bool) -> Snoc a -> Maybe a
sfind p xs                = snocToMaybe (sfilter p xs)

sfindIndex               :: (a -> Bool) -> Snoc a -> Maybe Int
sfindIndex p xs           = snocToMaybe (sfindIndices p xs)

sfindIndices             :: (a -> Bool) -> Snoc a -> Snoc Int
sfindIndices p xs         = snocify [ i | (x,i) <- szip' xs [0..], p x ]

szip'             :: Snoc a -> [b] -> [(a,b)]
szip'              = szipWith'  (\a b -> (a,b))

szip              :: Snoc a -> Snoc b -> Snoc (a,b)
szip               = szipWith  (\a b -> (a,b))


szipWith'                  :: (a->b->c) -> Snoc a -> [b] -> [c]
szipWith' z (as:<a) (b:bs)   = z a b : (szipWith' z as bs)
szipWith' _ _      _         = []

szipWith                  :: (a->b->c) -> Snoc a -> Snoc b -> Snoc c
szipWith z (as:<a) (bs:<b)   = (szipWith z as bs) :< z a b
szipWith _ _      _         = SNil

selem :: Eq a => a -> Snoc a -> Bool
selem x xs = sany (==x) xs

sany :: (a -> Bool) -> Snoc a -> Bool
sany p = sor . smap p

sor :: Snoc Bool -> Bool
sor = sfoldr (||) False

sand :: Snoc Bool -> Bool
sand = sfoldr (&&) True

sfoldr :: (a -> b -> b) -> b -> Snoc a -> b
sfoldr _ v SNil = v
sfoldr f v (xs:<x) = f x (sfoldr f v xs)

sfoldl :: (a -> b -> a) -> a -> Snoc b -> a
sfoldl _ v SNil = v
sfoldl f v (xs:<x) = sfoldl f (f v x) xs

sfst :: Snoc a -> a
sfst xs = xs!!<(slength xs -1)

ssum :: Snoc Int -> Int
ssum = sfoldr (+) 0
\end{code}

\section{The Error Monad}
\begin{code}
data Error a  =  OK a
	      |  Error String 
                 deriving (Eq,Show)

instance Functor Error where
    fmap _ (Error s)  = Error s
    fmap f (OK x)     = OK (f x)

instance Monad Error where
    OK x  >>= k      = k x
    (Error s) >>= _  = (Error s)
    return           = OK
    fail s           = Error s

instance MonadPlus Error where
    mzero                = Error ""
    (Error _) `mplus` b  = b
    a `mplus` _          = a

efail :: Error a -> Bool
efail (OK _)      = False
efail (Error _ )  = True

unError :: Error a -> a
unError (OK x)    = x
unError (Error e) = error e

eguard :: Bool -> String -> Error ()
eguard True _  = OK ()
eguard _    s  = Error s
\end{code}


\section{Environment Functions}

\begin{code}
type Name = String

data Env a  = Env { unEnv :: Snoc (Name,a) }
              deriving Show

elookup :: Eq a => Name -> (Env a) -> Error a
elookup n (Env xs) = slookup n xs
\end{code}

\section{Other Auxilary Functions}
\begin{code}
remove :: (Eq a) => [a] -> [a] -> [a]
remove [] ys = ys
remove _  [] = []
remove xs ys = [ y |y <- ys,  not (elem y xs)]

sremove :: (Eq a) => Snoc a -> Snoc a -> Snoc a
sremove SNil ys  = ys
sremove _  SNil  = SNil
sremove xs ys    = do y <- ys
		      guard (not (selem y xs))
		      return y

numDups :: (Eq a) => Snoc a -> Snoc a -> Int
numDups _   SNil     = 0
numDups xs  (ys:<y)  | selem y xs  = 1 + numDups xs ys
		     | otherwise   = numDups xs ys

noDups :: (Eq a) => Snoc a -> Snoc a
noDups SNil     = SNil
noDups (xs:<x)  | selem x xs == False   = (noDups xs):<x
	        | otherwise             = noDups xs

getDups :: (Eq a) => Snoc a -> Snoc a
getDups SNil     = SNil
getDups (xs:<x)  | selem x xs == True   = (getDups xs):<x
	         | otherwise            = getDups xs

qsort' :: (Ord a) => [a] -> [a]
qsort' []       = []
qsort' l@(x:xs) = qsort' small ++ mid ++ qsort' large
    where
      small = [y | y<-xs, y<x]
      mid   = [y | y<-l, y==x]
      large = [y | y<-xs, y>x]

qsort :: (Ord a) => Snoc a -> Snoc a
qsort SNil       = SNil
qsort l@(xs:<x)  = qsort small ++< mid ++< qsort large
    where
      small = do y <- xs
                 guard (y<x)
		 return y
      mid   = do y <- l
                 guard (y==x)
		 return y
      large = do y <- xs
                 guard (y>x)
		 return y
\end{code}

\end{document}
