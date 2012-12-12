\section{QComp.lhs}

\begin{code}
module QComp where

--QML imports
import QAux
import QVec
import QSyn
import QTyCirc
import QCirc
import QOrth
import QSuper
\end{code}

\subsection{Compiler Output Types}

\begin{code}
data Comp  = Comp {uCon::Snoc Name, fqc::TCirc}
             deriving (Show,Eq)
\end{code}


\subsection{Compiler Input Types}
\begin{code}
data FDef    = FDef  FSig  Tm  deriving Show
data FSig    = FSig  Con   Ty  deriving Show

type Prog    = Env   FDef

type Code    = Env   Comp

eCode  ::  Code
eCode  =   Env SNil

eComp  ::  Comp
eComp  =   Comp SNil eTC

getTms :: Prog -> Env Tm
getTms p = Env (getTms' (unEnv p))
  where  getTms' SNil = SNil
         getTms' (xs :< (n,FDef _ tm)) = getTms' xs :< (n,tm) 
\end{code}


\subsection{Compiler Error Checking}
\begin{code}
eTypeInf :: Ty -> Comp -> Error Bool
eTypeInf ety cmp  | (size inf) == (size ety)  = return True
		  | otherwise   = Error ("Type Mismatch! Expected " ++ show ety 
                                         ++ "; Inferred " ++ show inf)
	    where inf = (outT.fqc) cmp

eUsedCon :: Con -> Snoc Name -> Error Bool
eUsedCon gam used | checkCon gam used  = return True
		  | otherwise          = Error "Some context unused"


--Main error functions
checkCompProg :: Comp -> Con -> Ty -> Error Bool
checkCompProg cmp gam sig = do t1 <- eTypeInf sig cmp
			       t2 <- eUsedCon gam (uCon cmp)
			       return (t1 && t2)

treturn :: Maybe Ty -> Comp -> Error Comp
treturn mT cmp  |  mT == Nothing  = return cmp
	        |  smT == sout    = return cmp
	        |  otherwise      = Error ("Type error: " ++ show cmp)
		     where  smT       = size mT
			    sout      = (size.outT) fc
			    fc        = fqc cmp

\end{code}


\subsection{Program Compiler Function}

Compiler reverses input so that functions are compiled
before they are used (otherwise, as it is a snoc list,
the last function would be compiled first)

\begin{code}
compileProg  :: Prog -> Error Code
compileProg  (Env SNil) = OK (Env SNil)
compileProg  xs = do  code <- compileProg' (sreverse (unEnv xs))
                      return (Env code) 

compileProg' SNil = OK SNil
compileProg'  (p:< (f,(FDef (FSig gam sig) cmp))) =
    do c     <- compileProg' p
       cmp'  <- compileTm (Env c) gam cmp (Just sig)
       checkCompProg cmp' gam sig
       return (c:<(f,optimise cmp'))

optimise ::  Comp ->  Comp
optimise     (Comp uc (TCirc a b h g phi))  
                = Comp uc (TCirc a b h g (rCircuit phi))
\end{code}

\subsection{Term Compiler Functions}
\begin{code}
compileTm :: Code -> Con -> Tm -> Maybe Ty -> Error Comp

compileTm _ gam (Atom (Var x) SNil) mTy = 
    do  sig <- slookup x gam
	let con = eC:<sig
        treturn mTy (Comp (SNil:<x) 
                       (TCirc con sig 0 0 (Wire [0..size sig-1])))

compileTm _ gam (Atom (Var x) dom) mTy = 
    do  sig   <- slookup x gam
	tdom  <- popCon gam dom
	let  sd   = size tdom
	     iTy  = (smap snd tdom):<sig
             g    = SNil :< (x,sig)
        dC   <- deltaCon gam g tdom
        treturn mTy (Comp (dom:<x) (TCirc iTy sig 0 sd  (circ dC)))
	
compileTm _ _ (Atom (Sup x y) SNil) mTy = 
    treturn mTy (Comp SNil (TCirc eC Q2 1 0 (Rot (x,y) (y,-x))))

compileTm _ gam (Atom (Sup x y) dom) mTy =
    do  tdom <- populate gam dom
	let  ld    = slength dom
	     sd    = size tdom
	     ps    = permFromTy (tdom:<Q2) ([ld]++[0..ld-1])
             phi   = Seq (Par (idC sd) (Rot (x,y) (y,-x))) (Wire ps)
	treturn mTy (Comp dom (TCirc tdom Q2 1 sd phi))


compileTm c gam (Pair t u) mTy =
  do  let  fs       = fcons c 
      (tC,sig)  <- typeTm fs gam t
      (uC,tau)  <- typeTm fs gam u
      ct        <- compileTm c tC t (Just sig)            --Compile term |t::sig|
      cu        <- compileTm c uC u (Just tau)            --Compile term |u::tau|
      fdC      <- deltaCon gam tC uC                      --Calculate |deltaCon|
      let  (ft,fu)  = (fqc ct, fqc cu)                    --Ind Typed Circs
	   (ht,hu)  = (hpS ft, hpS fu)                    --Ind Heap sizes
           (gt,gu)  = (gbS ft,gbS fu)                     --Ind Garbage sizes
	   (sg,sd)  = (size tC,size uC)                   --Ind Context sizes
	   (bt,bu)  = ((size.outT) ft,(size.outT) fu)     --Ind output-type sizes (b := output type)
           (hS,gS)  = (ht + hu + hpS fdC,gbS ft + gbS fu) --Full heap & garbage sizes
	   phi  = Seq  (Seq  (Seq  (Par (circ fdC) (Wire [0..ht+hu-1]))
                                   (permN sg sd ht hu))
                             (Par (circ ft) (circ fu)))
                       (permN bt gt bu gu)
	   oTy  = outT ft :<*> outT fu
      treturn mTy (Comp  (uniqueCon (uCon ct) (uCon cu))
                         (TCirc (inT fdC) oTy hS gS phi))

compileTm c gam (Let x t u) mTy =
  do  eguard  (not (checkCon gam (SNil:<x))) 
              ("Variable "++x++" already defined in context")
      let  fs    = fcons c 
      (tC,tTy)  <- typeTm fs gam t                         --Infer type of term |t|
      ct        <- compileTm c tC t (Just tTy)             --Compile term |t|
      (uC,uTy)  <- typeTm fs (gam:<(x,tTy)) u
      cu        <- compileTm c uC u (Just uTy)             --Compile term |u::mTy|
      let  uuC = rmFromCon uC x
      fdC       <- deltaCon gam tC uuC                     --Calculate |deltaCon| (copy circuit)
      let  (ft,fu)  = (fqc ct,fqc cu)                      --Ind Typed Circs
	   (ht,hu)  = (hpS ft, hpS fu)                     --Ind Heap sizes
           (gt,gu)  = (gbS ft,gbS fu)                      --Ind Garbage sizes
	   (sg,sd)  = (size tC,size uuC)                   --Ind Context sizes
	   (bt,bu)  = ((size.outT) ft,(size.outT) fu)      --Ind output-type sizes
           (hS,gS)  = (ht + hu + hpS fdC,gbS ft + gbS fu)  --Full heap & garbage sizes
	   phi   = Seq  (Seq  (Seq  (Seq  (Seq  (Par (circ fdC) (Wire [0..ht+hu-1]))
		                                (permN 0 sg sd (ht+hu)))
		                          (Par (Par (idC sd) (circ ft)) (idC hu)))
		                     (permN (sd+bt) gt hu 0))
			      (permN bu gu gt 0))
		        (Par (circ fu) (idC gt))
      treturn mTy (Comp  (uniqueCon (uCon ct) (sfilter (/=x) (uCon cu)))
                         (TCirc (inT fdC) (outT fu) hS gS phi))

compileTm c gam (LetP x y t u) mTy = 
  do  eguard  (not (checkCon gam (SNil:<x:<y))) 
              ("Variables "++x++" or "++y++" already defined in context")
      let  fs     = fcons c 
      (tC,tTy)   <- typeTm fs gam t                          --Infer type of term |t|
      ct         <- compileTm c tC t (Just tTy)              --Compile |t|
      (sig,tau)  <- splitTy tTy                              --Extract type of |x::sig| and |y::tau|
      let  gam'   = gam:<(x,sig):<(y,tau)                    --Add |(x::sig,y::tau)| to context
      (uC,uTy)   <- typeTm fs gam' u
      cu         <- compileTm c gam' u (Just uTy)            --Compile |u:mTy| with extended context
      let uuCon   = sfilter (/=x) (sfilter (/=y) (uCon cu))  --Remove x and y from used context
          uuC     = stripfromCon uC (SNil:<x:<y)
      fdC        <- deltaCon gam tC uuC                      --Calculate |deltaCon| (copy circuit)
      let  (ft,fu)  = (fqc ct,fqc cu)                        --Ind Typed Circs
	   (ht,hu)  = (hpS ft, hpS fu)                       --Ind Heap sizes
           (gt,gu)  = (gbS ft,gbS fu)                        --Ind Garbage sizes
	   (sg,sd)  = (size tC,size uuC)                     --Ind Context sizes
	   (bt,bu)  = ((size.outT) ft,(size.outT) fu)        --Ind output-type sizes
           (hS,gS)  = (ht + hu + hpS fdC,gbS ft + gbS fu)    --Full heap & garbage sizes      
	   phi   = Seq  (Seq  (Seq  (Seq  (Seq  (Par (circ fdC) (Wire [0..ht+hu-1]))
		                                (permN 0 sg sd (ht+hu)))
		                          (Par (Par (idC sd) (circ ft)) (idC hu)))
		                     (permN (sd+bt) gt hu 0))
			      (permN bu gu gt 0))
		        (Par (circ fu) (idC gt))
      treturn mTy (Comp  (uniqueCon (uCon ct) uuCon)
                         (TCirc (inT fdC) (outT fu) hS gS phi))

compileTm c gam (If b t u) mTy = 
  do  let  fs     = fcons c 
      (bC,_)    <- typeTm fs gam b
      cb        <- compileTm c bC b (Just Q2)       --Compile |b::Qbit|
      (tC,tTy)  <- typeTm fs gam t
      ct        <- compileTm c tC t (Just tTy)      --Compile |t::sig|
      (uC,uTy)  <- typeTm fs gam u 
      cu        <- compileTm c tC u (Just uTy)      --Compile |u::sig|, with t's context
      eguard (conEq uC tC) "If branch context mismatch" --ensure tC and uC are equiv
      ftu       <- condOp (fqc ct) (fqc cu)         --Compile circuit |t|\vert|u :: sig:<*>Qbit|
      fdC       <- deltaCon gam bC tC               --Calculate |deltaCon| (Copy circuit)
      let  fb    = fqc cb                           --Typed circuit for |b|
	   gb    = gbS fb                           --Size of garbage for |b|
           gtu   = gbS ftu                          --Size of garbage for cond (inc qubit)
	   uCb   = uCon cb                          --Context used in conditional
	   (uCt,uCu)  = (uCon ct,uCon cu)           --Context used in branches
	   (hb,htu)   = (hpS fb,hpS ftu)            --Ind Heap sizes
	   (sg,sd)    = (size bC,size tC)           --Ind Context sizes
	   hS    = hb + htu + hpS fdC               --Full heap required
           gS    = gb + gtu                         --Total garbage (control \in gtu)
           sS    = size (outT ftu)                  --Size of output |sigma| 
	   phi   = Seq (Seq (Seq  (Seq  (Seq  (Par (circ fdC) (Wire [0..hb+htu-1]))
		                              (permN 0 sg sd (hb+htu)))
                                        (Par (Par (idC sd) (circ fb)) (idC htu)))
                                  (permN (sd+1) gb htu 0))
                            (Par (circ ftu) (idC gb)))
                       (permN (sS+1) gtu gb 0)
      treturn mTy (Comp  (uniqueCon uCb (uniqueCon uCt uCu))
                         (TCirc (inT fdC) (outT ftu) hS gS phi))

compileTm c gam (Ifo b t u o) mTy = 
  do  let fs     = fcons c
      (bC,_)     <- typeTm fs gam b
      cb         <- compileTm c bC b (Just Q2)      --Compile |b::Qbit|
      (_,ol,or,op)  <- orthComp o t u               --Calc orthogonality
      (lC,sig)   <- typeTm fs gam ol
      cl         <- compileTm c lC ol (Just sig)    --Compile |l::1+d|
      (rC,_)     <- typeTm fs gam or
      cr         <- compileTm c lC or (Just sig)    --Compile |r::1+d|, with lC
      eguard (conEq lC rC) "Ifo branch context mismatch"
      flr        <- condOpo (fqc cl) (fqc cr)       --Compile circuit |t|\vert|u :: sig:<*>Qbit|
      fdC        <- deltaCon gam bC lC              --Calculate |deltaCon| (Copy circuit)
      eguard ((gbS.fqc) cb == 0) "Ifo conditional produces garbage"
      let  fb    = fqc cb                           --Typed circuit for |b|
	   uCb   = uCon cb                          --Context used in conditional
	   (uCl,uCr)  = (uCon cl,uCon cr)           --Context used in branches
	   (hb,hlr)   = (hpS fb,hpS flr)            --Ind Heap sizes
	   (sg,sd)    = (size bC,size lC)           --Ind Context sizes
	   hS    = hb + hlr + hpS fdC               --Full heap required
	   phi   = Seq  (Seq  (Seq  (Seq  (Par (circ fdC) (Wire [0..hb+hlr-1]))
		                               (permN 0 sg sd (hb+hlr)))
                                    (Par (Par (idC sd) (circ fb)) (idC hlr)))
                              (circ flr))
                        op
           outTy = (outT flr) :<*> Q2
      treturn mTy (Comp  (uniqueCon uCb (uniqueCon uCl uCr))
                         (TCirc (inT fdC) outTy hS 0 phi))

compileTm _ _ (Unit) mTy = 
      treturn mTy (Comp SNil (TCirc eC Q1 0 0 (Wire [])))

compileTm c gam (FApp n ts) mTy =
  do  fComp     <- elookup n c        -- Lookup function n in code
      let  fTC  = fqc fComp           -- Get typed circuit of function n    
           args = (smap (unError.compileTm' c gam Nothing) ts) --compile arguments
           uC   = (sreverse.sconcat) (smap uCon args) -- get context used by arguments
           fAgs = smap fqc args -- list of typed circuits for arguments
           fIn  = szip (smap (size.inT) fAgs)  (smap hpS fAgs) -- input size and heap size for args
           fOut = szip (smap (size.outT) fAgs) (smap gbS fAgs) -- output and garbage size for args
           (fI,fH) = ((size.inT) fTC, hpS fTC) -- function input and heap sizes
           (fO,fG) = ((size.outT) fTC, gbS fTC) -- function output and garbage sizes
           gAgs = ssum (smap snd fOut) -- calculate garbage needed for args
           hAgs = ssum (smap snd fIn) -- calculate heap needed for args
           p1   = Wire (fPerm fIn fH)
           p2   = Seq (Wire (fPerm fOut fH)) (permN fI gAgs fH 0)
           p3   = permN fO fG gAgs 0
           phi  = Seq  (Seq  (Seq  (Seq p1  (Par  (fAgsCirc fAgs) 
                                                  (idC fH)))
                                   p2)
                             (Par (circ fTC) (idC gAgs)))
                       p3
      con  <- populate gam uC
      treturn mTy (Comp uC (TCirc con (outT fTC) (fH+hAgs) (fG+gAgs) phi))
    where compileTm' c gam mTy tm = compileTm c gam tm mTy

--Helper Functions

-- If and Ifo Helper functions

--Strict Choice circuit generator (Used by Ifo)
--Does swapping before and after
condOpo :: TCirc -> TCirc -> Error TCirc
condOpo tTC uTC = do  let  (sit,siu)  = ((size.inT) tTC,(size.inT) uTC)
 			   (sot,sou)  = ((size.outT) tTC,(size.outT) uTC)
			   (ht,hu)    = (hpS tTC,hpS uTC)
			   gt         = gbS tTC
                           condPhi    = Seq (Seq  (permN 0 sit 1 ht)
                                                  (Cond (circ tTC) (circ uTC)))
			 	            (permN 0 1 sot 0)
		      eguard (sot == sou)  "Ifo: Branch output mismatch"
                      eguard (sit == siu)  "Ifo: Branch input mismatch"
                      eguard (ht == hu)    "Ifo: Branch heap mismatch"
		      eguard (gt == 0)     "Ifo: Branching produces garbage"
		      return (TCirc ((inT tTC):<Q2) (outT tTC) ht 1 condPhi)

--Choice circuit generator (Used by If)
--Does swapping before and after
condOp  :: TCirc -> TCirc -> Error TCirc
condOp  tTC uTC = do  let  (sit,siu)  = ((size.inT) tTC,(size.inT) uTC)
 			   (sot,sou)  = ((size.outT) tTC,(size.outT) uTC)
			   (ht,hu)    = (hpS tTC,hpS uTC)
			   (gt,gu)    = (gbS tTC,gbS uTC)
                           htu        = max ht hu
                           gtu        = max gt gu
                           circT      = pad htu ht (circ tTC)
                           circU      = pad htu hu (circ uTC) 
			   condPhi    = Seq  (Seq  (permN 0 sit 1 htu)
                                                   (Cond circT circU))
			 	             (permN 0 1 sot gtu)
		      eguard (sot == sou)  "If: Branch output mismatch"
                      eguard (sit == siu)  "If: Branch input mismatch"
		      return (TCirc ((inT tTC):<Q2) (outT tTC) htu (1+gtu) condPhi)

--Padding circuit function
-- First is padded size, second is current size, 
pad  :: Int -> Int -> Circ -> Circ
pad  m h c | m == h     = c
           | otherwise  = Par c (idC (m - h))

-- General helper functions

fcons :: Code -> Env (TCon,Ty)
fcons c = Env ((fcons'.unEnv) c)
      where  fcons' SNil          = SNil
             fcons' (xs:<(f,cmp)) = fcons' xs :< (f,comp2con)
              where  comp2con = (inT tc, outT tc)
                     tc       = fqc cmp

-- FApp helper functions

fPerm :: Snoc (Int,Int) -> Int -> [Int]
fPerm xs = fPerm' ((reverse.unSnoc) xs)

fPerm' :: [(Int,Int)] -> Int -> [Int]
fPerm' xs h = concat (pT' is hs) ++ map (+tih) [0..h-1]
     where  (is,hs') = pT'' xs 0 0
            hs       = map (map (+ti)) hs'
            ti       = sum (map fst xs)
            tih      = ti + sum (map snd xs)
            pT' []      []      = []
            pT' (i:is') (h:hs') = i:h:(pT' is' hs')
            pT'' [] _ _           =  ([],[])
            pT'' ((a,h):xs) io ho =  ([io..io+a-1]:bs, [ho..ho+h-1]:hs)
                where (bs,hs) = pT'' xs (io+a) (ho+h)

fAgsCirc :: Snoc TCirc -> Circ
fAgsCirc SNil       = Wire []
fAgsCirc (SNil:<x)  = circ x
fAgsCirc (xs:<x)    = Par (fAgsCirc xs) (circ x)
\end{code}


Testing functions:

\begin{code}
getuCon      :: Name -> Prog -> Error (Snoc Name)
getuCon n p  =  do  cp  <- compileProg p
                    cp' <- elookup n cp 
                    let uc = uCon cp'
                    return uc

getCirc      :: Name -> Prog -> Error Circ
getCirc n p  =  do  cp  <- compileProg p
		    cp' <- elookup n cp
                    return ((circ.fqc) cp')

getTCirc      :: Name -> Prog -> Error TCirc
getTCirc n p  =  do  cp   <- compileProg p
	  	     cp'  <-  elookup n cp
                     return (fqc cp')

arityP      :: Name -> Prog -> Error Int
arityP n p  = do  c <- getCirc n p
	  	  a <- arity c
		  return a

compP     :: Name -> Prog -> Error Mat
compP n p = do  c <- getCirc n p
                arity c
                e <- comp c
	        return e

-- Returns (Garbage size, Isom)
isomP     :: Name -> Prog -> Error (Int,Isom)
isomP n p = do  tc  <- getTCirc n p
                m   <- comp (circ tc)
                let i = mat2isom m
                    z = heapI ((size.inT) tc) (hpS tc)
                return (gbS tc,z @>>= i)

superP     :: Name -> Prog -> Error Super
superP n p = do  tc <- getTCirc n p
                 m   <- comp (circ tc)
                 let i     = mat2isom m
                     z     = heapI ((size.inT) tc) (hpS tc)
                     out   = (size.outT) tc
                     trace = tr (gbS tc + out) out
                     ism   = isom2super (z @>>= i)
                 return (ism @>>= trace)  


cnot = Super 1 1 f
    where f [True,True]    [False,False]  = 1
          f [False,False]  [True,True]    = 1
          f _              _              = 0
\end{code}

\end{document}
