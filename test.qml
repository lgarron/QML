Cnot (b,qb) |- if b then qfalse else qtrue :: qb;

Qnot (b,qb) |- ifo b then qfalse else qtrue :: qb;

Cid (b,qb) |- if b then qtrue else qfalse :: qb;

Ifa (b,qb) |- ifo b then (qtrue,qfalse) else (qfalse,qtrue) :: qb*qb;


Ifb (b,qb) (x,qb) |- ifo b  then (x,qtrue) 
                            else (x,qfalse) :: qb*qb;

Ifc (b,qb) (x,qb) |- ifo b  then (qtrue,x) 
                            else (qfalse,x) :: qb*qb;

Ifbb (b,qb) (x,qb) |- ifo b  then (x,qfalse) 
                             else (x,qtrue) :: qb*qb;

Ifcc (b,qb) (x,qb) |- ifo b  then (qfalse,x) 
                             else (qtrue,x) :: qb*qb;

Had (b,qb) |- ifo b then hF * qfalse + (-hF) * qtrue
                    else hF * qfalse + hF * qtrue :: qb;

T |- qtrue :: qb;

F |- qfalse :: qb;

HT |- Had (qtrue) :: qb;

HHT |- Had (Had (qtrue)) :: qb;

NT |- Qnot (qtrue) :: qb;

NF |- Qnot (qfalse) :: qb;

CnotT |- Cnot (qtrue) :: qb;

CNot (s,qb) (b,qb) |- if s then Cnot (b) else b :: qb;

CQnot (s,qb) (t,qb) |- if s then Qnot (t) else t :: qb;

QCNot (s,qb) (t,qb) |- ifo s then (qtrue,Qnot (t)) 
                             else (qfalse,t) :: qb * qb;

Wone (x,qb) (y,qb) |- x [y] :: qb;

Wonep (x,qb) (y,qb) |- y [x] :: qb;

Wtwo (x,qb)  (y,qb) (z,qb) |- x [y z] :: qb;

Wtwop (x,qb)  (y,qb) (z,qb) |- (x,z [y]) :: qb*qb;

Wtwopp (x,qb)  (y,qb) (z,qb) |- (x [y],z) :: qb*qb;

Pc (x,qb) (y,qb) (z,qb) |- (x,(z,y)) :: qb*qb*qb;

WoneTF |- Wone (qtrue,qfalse) :: qb;

WonepTF |- Wonep (qtrue,qfalse) :: qb;

WCNot (s,qb) (t,qb) |- let (x,y) = ifo s then (Qnot (t),qtrue) 
                                         else (t,qfalse) 
                       in x [y] :: qb;

Pone (x,qb) (y,qb) |- (x,y) :: qb*qb;

Ptwo (x,qb) (y,qb) |- (y,x) :: qb*qb;

PoneTF |- Pone (qtrue,qfalse) :: qb*qb;

PtwoTF |- Ptwo (qtrue,qfalse) :: qb*qb;

Ifd (x,qb) (y,qb) (z,qb) |- if x then y [z] 
                                 else z [y] :: qb;

Ife (x,qb) (y,qb) (z,qb) |- if x then (y,z) 
                                 else (z,y) :: qb*qb;

Iff (x,qb) (y,qb) (z,qb) |- ifo x then ((y,z),qtrue) 
                                  else ((z,y),qfalse) :: qb*qb*qb;

Ifg (x,qb) (y,qb) (z,qb) |- ifo x then (qtrue,(y,z))
                                  else (qfalse,(z,y)) :: qb*qb*qb;

Ptt |- (qtrue,qtrue)   :: qb*qb;
Pff |- (qfalse,qfalse) :: qb*qb;

Ht  |- hF * qtrue + (-hF) * qfalse :: qb;

Hf  |- hF * qtrue + hF * qfalse :: qb