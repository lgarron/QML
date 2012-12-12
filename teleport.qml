-- The Quantum Teleport Algorithm
-- From:
-- "A lambda calculus for quantum computation
-- with classical control" (Selinger & Valiron,2005)

-- View in Haskell-mode for syntax highlighting

-- The Hadamard operation
Had (b,qb) |- ifo b then hF * qfalse + (-hF) * qtrue
                    else hF * qfalse + hF * qtrue :: qb;

-- The quantum Not operation (Pauli X)
Qnot (b,qb) |- ifo b then qfalse else qtrue :: qb;

-- A quantum CNOT operation
CNot (s,qb) (t,qb) |- ifo s then (qtrue,Qnot (t)) 
                            else (qfalse,t) :: qb*qb;

-- The measurement operator, using "if"
Meas (x,qb) |- if x then qtrue else qfalse :: qb;

-- The constant EPR pair
Epr |- hF * (qtrue,qtrue) + hF * (qfalse,qfalse) :: qb*qb;

-- The Bell-measurement operation
Bmeas (x,qb) (y,qb) |- let (xa,ya) = CNot (x,y)
                       in  (Meas (Had (xa)),Meas (ya)) :: qb*qb;

Bnmeas (x,qb) (y,qb) |- let (xa,ya) = CNot (x,y)
                        in  (Had (xa),ya) :: qb*qb;

-- The correction operations
Uol (x,qb) |- ifo x then  qfalse else qtrue  :: qb; 
Ulo (x,qb) |- ifo x then -qtrue  else qfalse :: qb;
Ull (x,qb) |- ifo x then -qfalse else qtrue  :: qb;  

-- The "unitary correction"
U (q,qb) (xy,qb*qb) |- let (x,y) = xy 
                       in if x then (if y then Ull (q) else Ulo (q))
                               else (if y then Uol (q) else q) :: qb;

-- The Teleport algorithm
--  To run type 'runX "teleport.qml" "Tele"', where X is
--  TC for the typed circuit, or I for the Isometry
Tele (a,qb) |- let (b,c) = Epr () 
               in  let f = Bnmeas (a,b)
                   in U (c,f) :: qb;

-- Some test cases
TeleT  |- Tele (qtrue) :: qb;
TeleF  |- Tele (qfalse) :: qb;
TeleHT |- Tele (Had (qtrue)) ::qb;
TeleHF |- Tele (Had (qfalse)) ::qb
