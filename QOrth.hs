module QOrth where

import Monad
import Complex
import QSyn
import QAux
import QCirc
import QTyCirc 

-- Given the two branches of an ifo statement
-- isOrth will return either OK <orth-proof>
-- or an Error

isOrth :: Env (TCon,Ty) -> Con -> Tm -> Tm -> Error Orth
isOrth _ _ t u 
    | t == qfalse  && u == qtrue   = OK OQBit0
    | t == qtrue   && u == qfalse  = OK OQBit1
isOrth fs gam (Pair t1 t2) (Pair u1 u2) 
    = do let x = isOrth fs gam t1 u1
             y = isOrth fs gam t2 u2
         (_,tau1) <- typeTm fs gam t1
         (_,tau2) <- typeTm fs gam t2
         z <- (x `mplus` y)
         if (efail x) 
           then return (OPair1 (sizet tau1) z)
           else return (OPair0 (sizet tau2) z)
isOrth _   _  (Ifo (Atom (Sup l0 l1) SNil) t u o)
              (Ifo (Atom (Sup k0 k1) SNil) t' u' o')
    | tOrthu && osup = OK (OSup (l0,l1,k0,k1) o)
  where osup = (conjugate l0) * k0 == -(conjugate l1) * k1  
        tOrthu = t == t' && u == u' && o == o'
isOrth _   _  (Atom (Sup l0 l1) SNil) (Atom (Sup k0 k1) SNil) 
     | osup = OK (OSup (l0,l1,k0,k1) OQBit0)
   where osup = (conjugate l0) * k0 == -(conjugate l1) * k1
isOrth _ _ _ _ = Error "Not orthogonal"

--Problem here
sizet :: Ty -> Int
sizet Q1 = 0
sizet Q2 = 1
sizet (t1:<*>t2) = sizet t1 + sizet t2

-- ORTHOGONALITY CIRCUIT
-- returns c and phi from tuple (c,l,r,phi)

orthCirc :: Orth -> (Int,Circ)
orthCirc OQBit0  = (0,notC)
orthCirc OQBit1  = (0,idC 1)
orthCirc (OPair0 t x)
             -- = (c+t, Par phi (idC t)) 
             = (c+t,Seq (Wire ps) (Par phi (idC t)))
               where  (c,phi) = orthCirc x
                      ps = [0..c-1] ++ [c+t] ++ map (+c) [0..t-1]
orthCirc (OPair1 t x)
             -- = (c+t, Par phi (idC t)) -- old  
             -- = (c+t,Seq (Seq (Wire ps) (Par phi (idC t))) (Wire ps)) -- works
                = (c+t, Par (idC t) phi)
               where  (c,phi) = orthCirc x
                      -- ps = [0..c-1] ++ [c+t] ++ map (+c) [0..t-1]
orthCirc (OSup (l0,l1,k0,k1) x)  
             = (c,Seq (Par (idC c) (Rot (l0,k0) (l1,k1))) phi)
               where  (c,phi) = orthCirc x

-- returns c in the tuple (c,l,r,phi)
orthC :: Orth -> Int
orthC OQBit0          = 0
orthC OQBit1          = 0
orthC (OPair0 tau o)  = orthC o + tau
orthC (OPair1 tau o)  = orthC o + tau
orthC (OSup _ o)      = orthC o 
  
-- OrthJudgement -> term -> l'
orthTL :: Orth -> Tm -> Error Tm
orthTL OQBit0 _                         = OK Unit
orthTL OQBit1 _                         = OK Unit
orthTL (OPair0 _ o) (Pair t v)          = do l <- orthTL o t
                                             return (Pair l v)
orthTL (OPair1 _ o) (Pair v t)          = do l <- orthTL o t
                                             return (Pair v l) 
orthTL (OSup _ o) (Ifo _ t _ _)         = orthTL o t
orthTL (OSup _ _) (Atom (Sup _ _) SNil) = OK Unit
orthTL _          _                     = Error "Not orthogonal, orthTL"

orthTR :: Orth -> Tm -> Error Tm
orthTR OQBit0 _                         = OK Unit
orthTR OQBit1 _                         = OK Unit
orthTR (OPair0 _ o) (Pair u w)          = do r <- orthTR o u
                                             return (Pair r w)
orthTR (OPair1 _ o) (Pair w u)          = do r <- orthTR o u
                                             return (Pair w r) 
orthTR (OSup _ o) (Ifo _ _ u _)         = orthTL o u
orthTR (OSup _ _) (Atom (Sup _ _) SNil) = OK Unit
orthTR _          _                     = Error "Not orthogonal, orthTR"

orthComp :: Orth -> Tm -> Tm -> Error (Int,Tm,Tm,Circ) 
orthComp o t u = do l <- orthTL o t
                    r <- orthTR o u
                    let (c,phi) = orthCirc o
                    return (c,l,r,phi)