import Data.Char
import Text.Read
import Data.Complex
import QTyCirc
import QAux
import QVec
import QOrth
import QSyn
import QComp

import QSuper
import QCirc

-- parser produced by Happy Version 1.17

data HappyAbsSyn t9 t10 t11 t12
	= HappyTerminal Token
	| HappyErrorToken Int
	| HappyAbsSyn4 (Snoc (Name,Con,PTerm,Ty))
	| HappyAbsSyn5 ((Name,Con,PTerm,Ty))
	| HappyAbsSyn6 (PTerm)
	| HappyAbsSyn8 (Compl)
	| HappyAbsSyn9 t9
	| HappyAbsSyn10 t10
	| HappyAbsSyn11 t11
	| HappyAbsSyn12 t12
	| HappyAbsSyn13 (Ty)

action_0 (24) = happyShift action_3
action_0 (4) = happyGoto action_4
action_0 (5) = happyGoto action_2
action_0 _ = happyFail

action_1 (24) = happyShift action_3
action_1 (5) = happyGoto action_2
action_1 _ = happyFail

action_2 _ = happyReduce_1

action_3 (12) = happyGoto action_6
action_3 _ = happyReduce_46

action_4 (40) = happyShift action_5
action_4 (43) = happyAccept
action_4 _ = happyFail

action_5 (24) = happyShift action_3
action_5 (5) = happyGoto action_9
action_5 _ = happyFail

action_6 (28) = happyShift action_7
action_6 (41) = happyShift action_8
action_6 _ = happyFail

action_7 (23) = happyShift action_11
action_7 _ = happyFail

action_8 (38) = happyShift action_10
action_8 _ = happyFail

action_9 _ = happyReduce_2

action_10 (14) = happyShift action_16
action_10 (16) = happyShift action_17
action_10 (17) = happyShift action_18
action_10 (20) = happyShift action_19
action_10 (21) = happyShift action_20
action_10 (22) = happyShift action_21
action_10 (23) = happyShift action_22
action_10 (24) = happyShift action_23
action_10 (28) = happyShift action_24
action_10 (33) = happyShift action_25
action_10 (34) = happyShift action_26
action_10 (35) = happyShift action_27
action_10 (36) = happyShift action_28
action_10 (38) = happyShift action_29
action_10 (6) = happyGoto action_13
action_10 (7) = happyGoto action_14
action_10 (8) = happyGoto action_15
action_10 _ = happyFail

action_11 (30) = happyShift action_12
action_11 _ = happyFail

action_12 (28) = happyShift action_56
action_12 (42) = happyShift action_57
action_12 (13) = happyGoto action_55
action_12 _ = happyFail

action_13 (39) = happyShift action_54
action_13 _ = happyFail

action_14 _ = happyReduce_13

action_15 (26) = happyShift action_50
action_15 (27) = happyShift action_51
action_15 (37) = happyShift action_52
action_15 (38) = happyShift action_53
action_15 _ = happyFail

action_16 (23) = happyShift action_48
action_16 (28) = happyShift action_49
action_16 _ = happyFail

action_17 (14) = happyShift action_16
action_17 (16) = happyShift action_17
action_17 (17) = happyShift action_18
action_17 (20) = happyShift action_19
action_17 (21) = happyShift action_20
action_17 (22) = happyShift action_21
action_17 (23) = happyShift action_22
action_17 (24) = happyShift action_23
action_17 (28) = happyShift action_24
action_17 (33) = happyShift action_25
action_17 (34) = happyShift action_26
action_17 (35) = happyShift action_27
action_17 (36) = happyShift action_28
action_17 (38) = happyShift action_29
action_17 (6) = happyGoto action_47
action_17 (7) = happyGoto action_14
action_17 (8) = happyGoto action_15
action_17 _ = happyFail

action_18 (14) = happyShift action_16
action_18 (16) = happyShift action_17
action_18 (17) = happyShift action_18
action_18 (20) = happyShift action_19
action_18 (21) = happyShift action_20
action_18 (22) = happyShift action_21
action_18 (23) = happyShift action_22
action_18 (24) = happyShift action_23
action_18 (28) = happyShift action_24
action_18 (33) = happyShift action_25
action_18 (34) = happyShift action_26
action_18 (35) = happyShift action_27
action_18 (36) = happyShift action_28
action_18 (38) = happyShift action_29
action_18 (6) = happyGoto action_46
action_18 (7) = happyGoto action_14
action_18 (8) = happyGoto action_15
action_18 _ = happyFail

action_19 (31) = happyShift action_42
action_19 (10) = happyGoto action_45
action_19 _ = happyReduce_7

action_20 (31) = happyShift action_42
action_20 (10) = happyGoto action_44
action_20 _ = happyReduce_6

action_21 (39) = happyShift action_43
action_21 _ = happyReduce_33

action_22 (31) = happyShift action_42
action_22 (10) = happyGoto action_41
action_22 _ = happyReduce_20

action_23 (28) = happyShift action_40
action_23 _ = happyFail

action_24 (14) = happyShift action_16
action_24 (16) = happyShift action_17
action_24 (17) = happyShift action_18
action_24 (20) = happyShift action_19
action_24 (21) = happyShift action_20
action_24 (22) = happyShift action_21
action_24 (23) = happyShift action_22
action_24 (24) = happyShift action_23
action_24 (28) = happyShift action_24
action_24 (29) = happyShift action_39
action_24 (33) = happyShift action_25
action_24 (34) = happyShift action_26
action_24 (35) = happyShift action_27
action_24 (36) = happyShift action_28
action_24 (38) = happyShift action_29
action_24 (6) = happyGoto action_37
action_24 (7) = happyGoto action_14
action_24 (8) = happyGoto action_38
action_24 _ = happyFail

action_25 (28) = happyShift action_36
action_25 _ = happyFail

action_26 (28) = happyShift action_35
action_26 _ = happyFail

action_27 _ = happyReduce_32

action_28 _ = happyReduce_37

action_29 (20) = happyShift action_31
action_29 (21) = happyShift action_32
action_29 (22) = happyShift action_21
action_29 (28) = happyShift action_33
action_29 (33) = happyShift action_25
action_29 (34) = happyShift action_26
action_29 (35) = happyShift action_27
action_29 (36) = happyShift action_28
action_29 (38) = happyShift action_34
action_29 (8) = happyGoto action_30
action_29 _ = happyFail

action_30 _ = happyReduce_38

action_31 (31) = happyShift action_42
action_31 (10) = happyGoto action_85
action_31 _ = happyReduce_11

action_32 (31) = happyShift action_42
action_32 (10) = happyGoto action_84
action_32 _ = happyReduce_10

action_33 (22) = happyShift action_21
action_33 (28) = happyShift action_33
action_33 (33) = happyShift action_25
action_33 (34) = happyShift action_26
action_33 (35) = happyShift action_27
action_33 (36) = happyShift action_28
action_33 (38) = happyShift action_34
action_33 (8) = happyGoto action_83
action_33 _ = happyFail

action_34 (22) = happyShift action_21
action_34 (28) = happyShift action_33
action_34 (33) = happyShift action_25
action_34 (34) = happyShift action_26
action_34 (35) = happyShift action_27
action_34 (36) = happyShift action_28
action_34 (38) = happyShift action_34
action_34 (8) = happyGoto action_30
action_34 _ = happyFail

action_35 (22) = happyShift action_21
action_35 (28) = happyShift action_33
action_35 (33) = happyShift action_25
action_35 (34) = happyShift action_26
action_35 (35) = happyShift action_27
action_35 (36) = happyShift action_28
action_35 (38) = happyShift action_34
action_35 (8) = happyGoto action_82
action_35 _ = happyFail

action_36 (22) = happyShift action_21
action_36 (28) = happyShift action_33
action_36 (33) = happyShift action_25
action_36 (34) = happyShift action_26
action_36 (35) = happyShift action_27
action_36 (36) = happyShift action_28
action_36 (38) = happyShift action_34
action_36 (8) = happyGoto action_81
action_36 _ = happyFail

action_37 (29) = happyShift action_79
action_37 (30) = happyShift action_80
action_37 _ = happyFail

action_38 (26) = happyShift action_50
action_38 (27) = happyShift action_51
action_38 (29) = happyShift action_78
action_38 (37) = happyShift action_52
action_38 (38) = happyShift action_53
action_38 _ = happyFail

action_39 _ = happyReduce_17

action_40 (14) = happyShift action_16
action_40 (16) = happyShift action_17
action_40 (17) = happyShift action_18
action_40 (20) = happyShift action_19
action_40 (21) = happyShift action_20
action_40 (22) = happyShift action_21
action_40 (23) = happyShift action_22
action_40 (24) = happyShift action_23
action_40 (28) = happyShift action_24
action_40 (33) = happyShift action_25
action_40 (34) = happyShift action_26
action_40 (35) = happyShift action_27
action_40 (36) = happyShift action_28
action_40 (38) = happyShift action_29
action_40 (6) = happyGoto action_76
action_40 (7) = happyGoto action_14
action_40 (8) = happyGoto action_15
action_40 (9) = happyGoto action_77
action_40 _ = happyReduce_40

action_41 _ = happyReduce_19

action_42 (11) = happyGoto action_75
action_42 _ = happyReduce_44

action_43 (26) = happyShift action_74
action_43 _ = happyFail

action_44 _ = happyReduce_4

action_45 _ = happyReduce_5

action_46 (18) = happyShift action_73
action_46 _ = happyFail

action_47 (18) = happyShift action_72
action_47 _ = happyFail

action_48 (25) = happyShift action_71
action_48 _ = happyFail

action_49 (23) = happyShift action_70
action_49 _ = happyFail

action_50 (22) = happyShift action_21
action_50 (28) = happyShift action_33
action_50 (33) = happyShift action_25
action_50 (34) = happyShift action_26
action_50 (35) = happyShift action_27
action_50 (36) = happyShift action_28
action_50 (38) = happyShift action_34
action_50 (8) = happyGoto action_69
action_50 _ = happyFail

action_51 (14) = happyShift action_16
action_51 (16) = happyShift action_17
action_51 (17) = happyShift action_18
action_51 (20) = happyShift action_66
action_51 (21) = happyShift action_67
action_51 (22) = happyShift action_21
action_51 (23) = happyShift action_22
action_51 (24) = happyShift action_23
action_51 (28) = happyShift action_68
action_51 (33) = happyShift action_25
action_51 (34) = happyShift action_26
action_51 (35) = happyShift action_27
action_51 (36) = happyShift action_28
action_51 (38) = happyShift action_34
action_51 (7) = happyGoto action_64
action_51 (8) = happyGoto action_65
action_51 _ = happyFail

action_52 (22) = happyShift action_21
action_52 (28) = happyShift action_33
action_52 (33) = happyShift action_25
action_52 (34) = happyShift action_26
action_52 (35) = happyShift action_27
action_52 (36) = happyShift action_28
action_52 (38) = happyShift action_34
action_52 (8) = happyGoto action_63
action_52 _ = happyFail

action_53 (22) = happyShift action_21
action_53 (28) = happyShift action_33
action_53 (33) = happyShift action_25
action_53 (34) = happyShift action_26
action_53 (35) = happyShift action_27
action_53 (36) = happyShift action_28
action_53 (38) = happyShift action_34
action_53 (8) = happyGoto action_62
action_53 _ = happyFail

action_54 (39) = happyShift action_61
action_54 _ = happyFail

action_55 (27) = happyShift action_59
action_55 (29) = happyShift action_60
action_55 _ = happyFail

action_56 (28) = happyShift action_56
action_56 (42) = happyShift action_57
action_56 (13) = happyGoto action_58
action_56 _ = happyFail

action_57 _ = happyReduce_50

action_58 (27) = happyShift action_59
action_58 (29) = happyShift action_108
action_58 _ = happyFail

action_59 (28) = happyShift action_56
action_59 (42) = happyShift action_57
action_59 (13) = happyGoto action_107
action_59 _ = happyFail

action_60 _ = happyReduce_47

action_61 (28) = happyShift action_56
action_61 (42) = happyShift action_57
action_61 (13) = happyGoto action_106
action_61 _ = happyFail

action_62 (27) = happyShift action_86
action_62 (37) = happyShift action_52
action_62 _ = happyReduce_29

action_63 _ = happyReduce_31

action_64 (26) = happyShift action_105
action_64 _ = happyFail

action_65 _ = happyReduce_30

action_66 (26) = happyShift action_104
action_66 (31) = happyShift action_42
action_66 (10) = happyGoto action_103
action_66 _ = happyFail

action_67 (26) = happyShift action_102
action_67 (31) = happyShift action_42
action_67 (10) = happyGoto action_101
action_67 _ = happyFail

action_68 (14) = happyShift action_16
action_68 (16) = happyShift action_17
action_68 (17) = happyShift action_18
action_68 (20) = happyShift action_19
action_68 (21) = happyShift action_20
action_68 (22) = happyShift action_21
action_68 (23) = happyShift action_22
action_68 (24) = happyShift action_23
action_68 (28) = happyShift action_24
action_68 (29) = happyShift action_39
action_68 (33) = happyShift action_25
action_68 (34) = happyShift action_26
action_68 (35) = happyShift action_27
action_68 (36) = happyShift action_28
action_68 (38) = happyShift action_29
action_68 (6) = happyGoto action_100
action_68 (7) = happyGoto action_14
action_68 (8) = happyGoto action_38
action_68 _ = happyFail

action_69 (27) = happyShift action_86
action_69 (37) = happyShift action_52
action_69 _ = happyReduce_28

action_70 (30) = happyShift action_99
action_70 _ = happyFail

action_71 (14) = happyShift action_16
action_71 (16) = happyShift action_17
action_71 (17) = happyShift action_18
action_71 (20) = happyShift action_19
action_71 (21) = happyShift action_20
action_71 (22) = happyShift action_21
action_71 (23) = happyShift action_22
action_71 (24) = happyShift action_23
action_71 (28) = happyShift action_24
action_71 (33) = happyShift action_25
action_71 (34) = happyShift action_26
action_71 (35) = happyShift action_27
action_71 (36) = happyShift action_28
action_71 (38) = happyShift action_29
action_71 (6) = happyGoto action_98
action_71 (7) = happyGoto action_14
action_71 (8) = happyGoto action_15
action_71 _ = happyFail

action_72 (14) = happyShift action_16
action_72 (16) = happyShift action_17
action_72 (17) = happyShift action_18
action_72 (20) = happyShift action_19
action_72 (21) = happyShift action_20
action_72 (22) = happyShift action_21
action_72 (23) = happyShift action_22
action_72 (24) = happyShift action_23
action_72 (28) = happyShift action_24
action_72 (33) = happyShift action_25
action_72 (34) = happyShift action_26
action_72 (35) = happyShift action_27
action_72 (36) = happyShift action_28
action_72 (38) = happyShift action_29
action_72 (6) = happyGoto action_97
action_72 (7) = happyGoto action_14
action_72 (8) = happyGoto action_15
action_72 _ = happyFail

action_73 (14) = happyShift action_16
action_73 (16) = happyShift action_17
action_73 (17) = happyShift action_18
action_73 (20) = happyShift action_19
action_73 (21) = happyShift action_20
action_73 (22) = happyShift action_21
action_73 (23) = happyShift action_22
action_73 (24) = happyShift action_23
action_73 (28) = happyShift action_24
action_73 (33) = happyShift action_25
action_73 (34) = happyShift action_26
action_73 (35) = happyShift action_27
action_73 (36) = happyShift action_28
action_73 (38) = happyShift action_29
action_73 (6) = happyGoto action_96
action_73 (7) = happyGoto action_14
action_73 (8) = happyGoto action_15
action_73 _ = happyFail

action_74 (22) = happyShift action_95
action_74 _ = happyFail

action_75 (23) = happyShift action_93
action_75 (32) = happyShift action_94
action_75 _ = happyFail

action_76 _ = happyReduce_41

action_77 (29) = happyShift action_91
action_77 (30) = happyShift action_92
action_77 _ = happyFail

action_78 _ = happyReduce_39

action_79 _ = happyReduce_12

action_80 (14) = happyShift action_16
action_80 (16) = happyShift action_17
action_80 (17) = happyShift action_18
action_80 (20) = happyShift action_19
action_80 (21) = happyShift action_20
action_80 (22) = happyShift action_21
action_80 (23) = happyShift action_22
action_80 (24) = happyShift action_23
action_80 (28) = happyShift action_24
action_80 (33) = happyShift action_25
action_80 (34) = happyShift action_26
action_80 (35) = happyShift action_27
action_80 (36) = happyShift action_28
action_80 (38) = happyShift action_29
action_80 (6) = happyGoto action_90
action_80 (7) = happyGoto action_14
action_80 (8) = happyGoto action_15
action_80 _ = happyFail

action_81 (26) = happyShift action_50
action_81 (27) = happyShift action_86
action_81 (29) = happyShift action_89
action_81 (37) = happyShift action_52
action_81 (38) = happyShift action_53
action_81 _ = happyFail

action_82 (26) = happyShift action_50
action_82 (27) = happyShift action_86
action_82 (29) = happyShift action_88
action_82 (37) = happyShift action_52
action_82 (38) = happyShift action_53
action_82 _ = happyFail

action_83 (26) = happyShift action_50
action_83 (27) = happyShift action_86
action_83 (29) = happyShift action_78
action_83 (37) = happyShift action_52
action_83 (38) = happyShift action_53
action_83 _ = happyFail

action_84 _ = happyReduce_8

action_85 _ = happyReduce_9

action_86 (22) = happyShift action_21
action_86 (28) = happyShift action_33
action_86 (33) = happyShift action_25
action_86 (34) = happyShift action_26
action_86 (35) = happyShift action_27
action_86 (36) = happyShift action_28
action_86 (38) = happyShift action_34
action_86 (8) = happyGoto action_87
action_86 _ = happyFail

action_87 _ = happyReduce_30

action_88 _ = happyReduce_36

action_89 _ = happyReduce_35

action_90 (29) = happyShift action_119
action_90 _ = happyFail

action_91 _ = happyReduce_27

action_92 (14) = happyShift action_16
action_92 (16) = happyShift action_17
action_92 (17) = happyShift action_18
action_92 (20) = happyShift action_19
action_92 (21) = happyShift action_20
action_92 (22) = happyShift action_21
action_92 (23) = happyShift action_22
action_92 (24) = happyShift action_23
action_92 (28) = happyShift action_24
action_92 (33) = happyShift action_25
action_92 (34) = happyShift action_26
action_92 (35) = happyShift action_27
action_92 (36) = happyShift action_28
action_92 (38) = happyShift action_29
action_92 (6) = happyGoto action_118
action_92 (7) = happyGoto action_14
action_92 (8) = happyGoto action_15
action_92 _ = happyFail

action_93 _ = happyReduce_45

action_94 _ = happyReduce_43

action_95 _ = happyReduce_34

action_96 (19) = happyShift action_117
action_96 _ = happyFail

action_97 (19) = happyShift action_116
action_97 _ = happyFail

action_98 (15) = happyShift action_115
action_98 _ = happyFail

action_99 (23) = happyShift action_114
action_99 _ = happyFail

action_100 (30) = happyShift action_80
action_100 _ = happyFail

action_101 (26) = happyShift action_113
action_101 _ = happyFail

action_102 (22) = happyShift action_21
action_102 (28) = happyShift action_33
action_102 (33) = happyShift action_25
action_102 (34) = happyShift action_26
action_102 (35) = happyShift action_27
action_102 (36) = happyShift action_28
action_102 (38) = happyShift action_34
action_102 (8) = happyGoto action_112
action_102 _ = happyFail

action_103 (26) = happyShift action_111
action_103 _ = happyFail

action_104 (22) = happyShift action_21
action_104 (28) = happyShift action_33
action_104 (33) = happyShift action_25
action_104 (34) = happyShift action_26
action_104 (35) = happyShift action_27
action_104 (36) = happyShift action_28
action_104 (38) = happyShift action_34
action_104 (8) = happyGoto action_110
action_104 _ = happyFail

action_105 (22) = happyShift action_21
action_105 (28) = happyShift action_33
action_105 (33) = happyShift action_25
action_105 (34) = happyShift action_26
action_105 (35) = happyShift action_27
action_105 (36) = happyShift action_28
action_105 (38) = happyShift action_34
action_105 (8) = happyGoto action_109
action_105 _ = happyFail

action_106 (27) = happyShift action_59
action_106 _ = happyReduce_3

action_107 _ = happyReduce_48

action_108 _ = happyReduce_49

action_109 (26) = happyShift action_50
action_109 (27) = happyShift action_128
action_109 (37) = happyShift action_52
action_109 (38) = happyShift action_53
action_109 _ = happyFail

action_110 (26) = happyShift action_50
action_110 (27) = happyShift action_127
action_110 (37) = happyShift action_52
action_110 (38) = happyShift action_53
action_110 _ = happyFail

action_111 (22) = happyShift action_21
action_111 (28) = happyShift action_33
action_111 (33) = happyShift action_25
action_111 (34) = happyShift action_26
action_111 (35) = happyShift action_27
action_111 (36) = happyShift action_28
action_111 (38) = happyShift action_34
action_111 (8) = happyGoto action_126
action_111 _ = happyFail

action_112 (26) = happyShift action_50
action_112 (27) = happyShift action_125
action_112 (37) = happyShift action_52
action_112 (38) = happyShift action_53
action_112 _ = happyFail

action_113 (22) = happyShift action_21
action_113 (28) = happyShift action_33
action_113 (33) = happyShift action_25
action_113 (34) = happyShift action_26
action_113 (35) = happyShift action_27
action_113 (36) = happyShift action_28
action_113 (38) = happyShift action_34
action_113 (8) = happyGoto action_124
action_113 _ = happyFail

action_114 (29) = happyShift action_123
action_114 _ = happyFail

action_115 (14) = happyShift action_16
action_115 (16) = happyShift action_17
action_115 (17) = happyShift action_18
action_115 (20) = happyShift action_19
action_115 (21) = happyShift action_20
action_115 (22) = happyShift action_21
action_115 (23) = happyShift action_22
action_115 (24) = happyShift action_23
action_115 (28) = happyShift action_24
action_115 (33) = happyShift action_25
action_115 (34) = happyShift action_26
action_115 (35) = happyShift action_27
action_115 (36) = happyShift action_28
action_115 (38) = happyShift action_29
action_115 (6) = happyGoto action_122
action_115 (7) = happyGoto action_14
action_115 (8) = happyGoto action_15
action_115 _ = happyFail

action_116 (14) = happyShift action_16
action_116 (16) = happyShift action_17
action_116 (17) = happyShift action_18
action_116 (20) = happyShift action_19
action_116 (21) = happyShift action_20
action_116 (22) = happyShift action_21
action_116 (23) = happyShift action_22
action_116 (24) = happyShift action_23
action_116 (28) = happyShift action_24
action_116 (33) = happyShift action_25
action_116 (34) = happyShift action_26
action_116 (35) = happyShift action_27
action_116 (36) = happyShift action_28
action_116 (38) = happyShift action_29
action_116 (6) = happyGoto action_121
action_116 (7) = happyGoto action_14
action_116 (8) = happyGoto action_15
action_116 _ = happyFail

action_117 (14) = happyShift action_16
action_117 (16) = happyShift action_17
action_117 (17) = happyShift action_18
action_117 (20) = happyShift action_19
action_117 (21) = happyShift action_20
action_117 (22) = happyShift action_21
action_117 (23) = happyShift action_22
action_117 (24) = happyShift action_23
action_117 (28) = happyShift action_24
action_117 (33) = happyShift action_25
action_117 (34) = happyShift action_26
action_117 (35) = happyShift action_27
action_117 (36) = happyShift action_28
action_117 (38) = happyShift action_29
action_117 (6) = happyGoto action_120
action_117 (7) = happyGoto action_14
action_117 (8) = happyGoto action_15
action_117 _ = happyFail

action_118 _ = happyReduce_42

action_119 _ = happyReduce_18

action_120 _ = happyReduce_26

action_121 _ = happyReduce_16

action_122 _ = happyReduce_15

action_123 (25) = happyShift action_134
action_123 _ = happyFail

action_124 (26) = happyShift action_50
action_124 (27) = happyShift action_133
action_124 (37) = happyShift action_52
action_124 (38) = happyShift action_53
action_124 _ = happyFail

action_125 (20) = happyShift action_132
action_125 (22) = happyShift action_21
action_125 (28) = happyShift action_33
action_125 (33) = happyShift action_25
action_125 (34) = happyShift action_26
action_125 (35) = happyShift action_27
action_125 (36) = happyShift action_28
action_125 (38) = happyShift action_34
action_125 (8) = happyGoto action_87
action_125 _ = happyFail

action_126 (26) = happyShift action_50
action_126 (27) = happyShift action_131
action_126 (37) = happyShift action_52
action_126 (38) = happyShift action_53
action_126 _ = happyFail

action_127 (21) = happyShift action_130
action_127 (22) = happyShift action_21
action_127 (28) = happyShift action_33
action_127 (33) = happyShift action_25
action_127 (34) = happyShift action_26
action_127 (35) = happyShift action_27
action_127 (36) = happyShift action_28
action_127 (38) = happyShift action_34
action_127 (8) = happyGoto action_87
action_127 _ = happyFail

action_128 (14) = happyShift action_16
action_128 (16) = happyShift action_17
action_128 (17) = happyShift action_18
action_128 (22) = happyShift action_21
action_128 (23) = happyShift action_22
action_128 (24) = happyShift action_23
action_128 (28) = happyShift action_68
action_128 (33) = happyShift action_25
action_128 (34) = happyShift action_26
action_128 (35) = happyShift action_27
action_128 (36) = happyShift action_28
action_128 (38) = happyShift action_34
action_128 (7) = happyGoto action_129
action_128 (8) = happyGoto action_65
action_128 _ = happyFail

action_129 _ = happyReduce_25

action_130 _ = happyReduce_23

action_131 (21) = happyShift action_137
action_131 (22) = happyShift action_21
action_131 (28) = happyShift action_33
action_131 (33) = happyShift action_25
action_131 (34) = happyShift action_26
action_131 (35) = happyShift action_27
action_131 (36) = happyShift action_28
action_131 (38) = happyShift action_34
action_131 (8) = happyGoto action_87
action_131 _ = happyFail

action_132 _ = happyReduce_24

action_133 (20) = happyShift action_136
action_133 (22) = happyShift action_21
action_133 (28) = happyShift action_33
action_133 (33) = happyShift action_25
action_133 (34) = happyShift action_26
action_133 (35) = happyShift action_27
action_133 (36) = happyShift action_28
action_133 (38) = happyShift action_34
action_133 (8) = happyGoto action_87
action_133 _ = happyFail

action_134 (14) = happyShift action_16
action_134 (16) = happyShift action_17
action_134 (17) = happyShift action_18
action_134 (20) = happyShift action_19
action_134 (21) = happyShift action_20
action_134 (22) = happyShift action_21
action_134 (23) = happyShift action_22
action_134 (24) = happyShift action_23
action_134 (28) = happyShift action_24
action_134 (33) = happyShift action_25
action_134 (34) = happyShift action_26
action_134 (35) = happyShift action_27
action_134 (36) = happyShift action_28
action_134 (38) = happyShift action_29
action_134 (6) = happyGoto action_135
action_134 (7) = happyGoto action_14
action_134 (8) = happyGoto action_15
action_134 _ = happyFail

action_135 (15) = happyShift action_140
action_135 _ = happyFail

action_136 (31) = happyShift action_42
action_136 (10) = happyGoto action_139
action_136 _ = happyFail

action_137 (31) = happyShift action_42
action_137 (10) = happyGoto action_138
action_137 _ = happyFail

action_138 _ = happyReduce_21

action_139 _ = happyReduce_22

action_140 (14) = happyShift action_16
action_140 (16) = happyShift action_17
action_140 (17) = happyShift action_18
action_140 (20) = happyShift action_19
action_140 (21) = happyShift action_20
action_140 (22) = happyShift action_21
action_140 (23) = happyShift action_22
action_140 (24) = happyShift action_23
action_140 (28) = happyShift action_24
action_140 (33) = happyShift action_25
action_140 (34) = happyShift action_26
action_140 (35) = happyShift action_27
action_140 (36) = happyShift action_28
action_140 (38) = happyShift action_29
action_140 (6) = happyGoto action_141
action_140 (7) = happyGoto action_14
action_140 (8) = happyGoto action_15
action_140 _ = happyFail

action_141 _ = happyReduce_14

happyReduce_1 = happySpecReduce_1  4 happyReduction_1
happyReduction_1 (HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn4
		 (SNil :< happy_var_1
	)
happyReduction_1 _  = notHappyAtAll 

happyReduce_2 = happySpecReduce_3  4 happyReduction_2
happyReduction_2 (HappyAbsSyn5  happy_var_3)
	_
	(HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn4
		 (happy_var_1 :< happy_var_3
	)
happyReduction_2 _ _ _  = notHappyAtAll 

happyReduce_3 = happyReduce 8 5 happyReduction_3
happyReduction_3 ((HappyAbsSyn13  happy_var_8) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn6  happy_var_5) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn12  happy_var_2) `HappyStk`
	(HappyTerminal (TokenFunc happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn5
		 ((happy_var_1,happy_var_2,happy_var_5,happy_var_8)
	) `HappyStk` happyRest

happyReduce_4 = happySpecReduce_2  6 happyReduction_4
happyReduction_4 (HappyAbsSyn10  happy_var_2)
	_
	 =  HappyAbsSyn6
		 (PAtom (PSup 1 0) happy_var_2
	)
happyReduction_4 _ _  = notHappyAtAll 

happyReduce_5 = happySpecReduce_2  6 happyReduction_5
happyReduction_5 (HappyAbsSyn10  happy_var_2)
	_
	 =  HappyAbsSyn6
		 (PAtom (PSup 0 1) happy_var_2
	)
happyReduction_5 _ _  = notHappyAtAll 

happyReduce_6 = happySpecReduce_1  6 happyReduction_6
happyReduction_6 _
	 =  HappyAbsSyn6
		 (PAtom (PSup 1 0) SNil
	)

happyReduce_7 = happySpecReduce_1  6 happyReduction_7
happyReduction_7 _
	 =  HappyAbsSyn6
		 (PAtom (PSup 0 1) SNil
	)

happyReduce_8 = happySpecReduce_3  6 happyReduction_8
happyReduction_8 (HappyAbsSyn10  happy_var_3)
	_
	_
	 =  HappyAbsSyn6
		 (PAtom (PSup (-1) 0) happy_var_3
	)
happyReduction_8 _ _ _  = notHappyAtAll 

happyReduce_9 = happySpecReduce_3  6 happyReduction_9
happyReduction_9 (HappyAbsSyn10  happy_var_3)
	_
	_
	 =  HappyAbsSyn6
		 (PAtom (PSup 0 (-1)) happy_var_3
	)
happyReduction_9 _ _ _  = notHappyAtAll 

happyReduce_10 = happySpecReduce_2  6 happyReduction_10
happyReduction_10 _
	_
	 =  HappyAbsSyn6
		 (PAtom (PSup (-1) 0) SNil
	)

happyReduce_11 = happySpecReduce_2  6 happyReduction_11
happyReduction_11 _
	_
	 =  HappyAbsSyn6
		 (PAtom (PSup 0 (-1)) SNil
	)

happyReduce_12 = happySpecReduce_3  6 happyReduction_12
happyReduction_12 _
	(HappyAbsSyn6  happy_var_2)
	_
	 =  HappyAbsSyn6
		 (( happy_var_2 )
	)
happyReduction_12 _ _ _  = notHappyAtAll 

happyReduce_13 = happySpecReduce_1  6 happyReduction_13
happyReduction_13 (HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn6
		 (happy_var_1
	)
happyReduction_13 _  = notHappyAtAll 

happyReduce_14 = happyReduce 10 7 happyReduction_14
happyReduction_14 ((HappyAbsSyn6  happy_var_10) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn6  happy_var_8) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TokenVar happy_var_5)) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TokenVar happy_var_3)) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (PLetP happy_var_3 happy_var_5 happy_var_8 happy_var_10
	) `HappyStk` happyRest

happyReduce_15 = happyReduce 6 7 happyReduction_15
happyReduction_15 ((HappyAbsSyn6  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn6  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TokenVar happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (PLet happy_var_2 happy_var_4 happy_var_6
	) `HappyStk` happyRest

happyReduce_16 = happyReduce 6 7 happyReduction_16
happyReduction_16 ((HappyAbsSyn6  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn6  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn6  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (PIf happy_var_2 happy_var_4 happy_var_6
	) `HappyStk` happyRest

happyReduce_17 = happySpecReduce_2  7 happyReduction_17
happyReduction_17 _
	_
	 =  HappyAbsSyn6
		 (PUnit
	)

happyReduce_18 = happyReduce 5 7 happyReduction_18
happyReduction_18 (_ `HappyStk`
	(HappyAbsSyn6  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn6  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (PPair happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_19 = happySpecReduce_2  7 happyReduction_19
happyReduction_19 (HappyAbsSyn10  happy_var_2)
	(HappyTerminal (TokenVar happy_var_1))
	 =  HappyAbsSyn6
		 (PAtom (PVar happy_var_1) happy_var_2
	)
happyReduction_19 _ _  = notHappyAtAll 

happyReduce_20 = happySpecReduce_1  7 happyReduction_20
happyReduction_20 (HappyTerminal (TokenVar happy_var_1))
	 =  HappyAbsSyn6
		 (PAtom (PVar happy_var_1) SNil
	)
happyReduction_20 _  = notHappyAtAll 

happyReduce_21 = happyReduce 9 7 happyReduction_21
happyReduction_21 ((HappyAbsSyn10  happy_var_9) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn8  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn10  happy_var_4) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn8  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (PAtom (PSup happy_var_6 happy_var_1) (noDups (happy_var_4++<happy_var_9))
	) `HappyStk` happyRest

happyReduce_22 = happyReduce 9 7 happyReduction_22
happyReduction_22 ((HappyAbsSyn10  happy_var_9) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn8  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn10  happy_var_4) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn8  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (PAtom (PSup happy_var_1 happy_var_6) (noDups (happy_var_4++<happy_var_9))
	) `HappyStk` happyRest

happyReduce_23 = happyReduce 7 7 happyReduction_23
happyReduction_23 (_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn8  happy_var_5) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn8  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (PAtom (PSup happy_var_5 happy_var_1) SNil
	) `HappyStk` happyRest

happyReduce_24 = happyReduce 7 7 happyReduction_24
happyReduction_24 (_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn8  happy_var_5) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn8  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (PAtom (PSup happy_var_1 happy_var_5) SNil
	) `HappyStk` happyRest

happyReduce_25 = happyReduce 7 7 happyReduction_25
happyReduction_25 ((HappyAbsSyn6  happy_var_7) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn8  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn6  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn8  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (PTSup happy_var_1 happy_var_3 happy_var_5 happy_var_7
	) `HappyStk` happyRest

happyReduce_26 = happyReduce 6 7 happyReduction_26
happyReduction_26 ((HappyAbsSyn6  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn6  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn6  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (PIfo happy_var_2 happy_var_4 happy_var_6
	) `HappyStk` happyRest

happyReduce_27 = happyReduce 4 7 happyReduction_27
happyReduction_27 (_ `HappyStk`
	(HappyAbsSyn9  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TokenFunc happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (PFApp happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_28 = happySpecReduce_3  8 happyReduction_28
happyReduction_28 (HappyAbsSyn8  happy_var_3)
	_
	(HappyAbsSyn8  happy_var_1)
	 =  HappyAbsSyn8
		 (happy_var_1 + happy_var_3
	)
happyReduction_28 _ _ _  = notHappyAtAll 

happyReduce_29 = happySpecReduce_3  8 happyReduction_29
happyReduction_29 (HappyAbsSyn8  happy_var_3)
	_
	(HappyAbsSyn8  happy_var_1)
	 =  HappyAbsSyn8
		 (happy_var_1 - happy_var_3
	)
happyReduction_29 _ _ _  = notHappyAtAll 

happyReduce_30 = happySpecReduce_3  8 happyReduction_30
happyReduction_30 (HappyAbsSyn8  happy_var_3)
	_
	(HappyAbsSyn8  happy_var_1)
	 =  HappyAbsSyn8
		 (happy_var_1 * happy_var_3
	)
happyReduction_30 _ _ _  = notHappyAtAll 

happyReduce_31 = happySpecReduce_3  8 happyReduction_31
happyReduction_31 (HappyAbsSyn8  happy_var_3)
	_
	(HappyAbsSyn8  happy_var_1)
	 =  HappyAbsSyn8
		 (happy_var_1 / happy_var_3
	)
happyReduction_31 _ _ _  = notHappyAtAll 

happyReduce_32 = happySpecReduce_1  8 happyReduction_32
happyReduction_32 _
	 =  HappyAbsSyn8
		 (pi
	)

happyReduce_33 = happySpecReduce_1  8 happyReduction_33
happyReduction_33 (HappyTerminal (TokenDouble happy_var_1))
	 =  HappyAbsSyn8
		 (happy_var_1 :+ 0
	)
happyReduction_33 _  = notHappyAtAll 

happyReduce_34 = happyReduce 4 8 happyReduction_34
happyReduction_34 ((HappyTerminal (TokenDouble happy_var_4)) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TokenDouble happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn8
		 (happy_var_1 :+ happy_var_4
	) `HappyStk` happyRest

happyReduce_35 = happyReduce 4 8 happyReduction_35
happyReduction_35 (_ `HappyStk`
	(HappyAbsSyn8  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn8
		 (exp  happy_var_3
	) `HappyStk` happyRest

happyReduce_36 = happyReduce 4 8 happyReduction_36
happyReduction_36 (_ `HappyStk`
	(HappyAbsSyn8  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn8
		 (sqrt happy_var_3
	) `HappyStk` happyRest

happyReduce_37 = happySpecReduce_1  8 happyReduction_37
happyReduction_37 _
	 =  HappyAbsSyn8
		 (1 / sqrt 2
	)

happyReduce_38 = happySpecReduce_2  8 happyReduction_38
happyReduction_38 (HappyAbsSyn8  happy_var_2)
	_
	 =  HappyAbsSyn8
		 (- ( happy_var_2 )
	)
happyReduction_38 _ _  = notHappyAtAll 

happyReduce_39 = happySpecReduce_3  8 happyReduction_39
happyReduction_39 _
	(HappyAbsSyn8  happy_var_2)
	_
	 =  HappyAbsSyn8
		 (( happy_var_2 )
	)
happyReduction_39 _ _ _  = notHappyAtAll 

happyReduce_40 = happySpecReduce_0  9 happyReduction_40
happyReduction_40  =  HappyAbsSyn9
		 (SNil
	)

happyReduce_41 = happySpecReduce_1  9 happyReduction_41
happyReduction_41 (HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn9
		 (SNil :< happy_var_1
	)
happyReduction_41 _  = notHappyAtAll 

happyReduce_42 = happySpecReduce_3  9 happyReduction_42
happyReduction_42 (HappyAbsSyn6  happy_var_3)
	_
	(HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn9
		 (happy_var_1 :< happy_var_3
	)
happyReduction_42 _ _ _  = notHappyAtAll 

happyReduce_43 = happySpecReduce_3  10 happyReduction_43
happyReduction_43 _
	(HappyAbsSyn11  happy_var_2)
	_
	 =  HappyAbsSyn10
		 (happy_var_2
	)
happyReduction_43 _ _ _  = notHappyAtAll 

happyReduce_44 = happySpecReduce_0  11 happyReduction_44
happyReduction_44  =  HappyAbsSyn11
		 (SNil
	)

happyReduce_45 = happySpecReduce_2  11 happyReduction_45
happyReduction_45 (HappyTerminal (TokenVar happy_var_2))
	(HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn11
		 (happy_var_1 :< happy_var_2
	)
happyReduction_45 _ _  = notHappyAtAll 

happyReduce_46 = happySpecReduce_0  12 happyReduction_46
happyReduction_46  =  HappyAbsSyn12
		 (SNil
	)

happyReduce_47 = happyReduce 6 12 happyReduction_47
happyReduction_47 (_ `HappyStk`
	(HappyAbsSyn13  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TokenVar happy_var_3)) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn12  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn12
		 (happy_var_1 :< (happy_var_3,happy_var_5)
	) `HappyStk` happyRest

happyReduce_48 = happySpecReduce_3  13 happyReduction_48
happyReduction_48 (HappyAbsSyn13  happy_var_3)
	_
	(HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn13
		 (happy_var_1 :<*> happy_var_3
	)
happyReduction_48 _ _ _  = notHappyAtAll 

happyReduce_49 = happySpecReduce_3  13 happyReduction_49
happyReduction_49 _
	(HappyAbsSyn13  happy_var_2)
	_
	 =  HappyAbsSyn13
		 (happy_var_2
	)
happyReduction_49 _ _ _  = notHappyAtAll 

happyReduce_50 = happySpecReduce_1  13 happyReduction_50
happyReduction_50 _
	 =  HappyAbsSyn13
		 (Q2
	)

happyNewToken action sts stk
	= lexer(\tk -> 
	let cont i = action i i tk (HappyState action) sts stk in
	case tk of {
	TokenEOF -> action 43 43 tk (HappyState action) sts stk;
	TokenLet -> cont 14;
	TokenIn -> cont 15;
	TokenIf -> cont 16;
	TokenIfo -> cont 17;
	TokenThen -> cont 18;
	TokenElse -> cont 19;
	TokenTrue -> cont 20;
	TokenFalse -> cont 21;
	TokenDouble happy_dollar_dollar -> cont 22;
	TokenVar happy_dollar_dollar -> cont 23;
	TokenFunc happy_dollar_dollar -> cont 24;
	TokenEq -> cont 25;
	TokenPlus -> cont 26;
	TokenTimes -> cont 27;
	TokenOB -> cont 28;
	TokenCB -> cont 29;
	TokenCom -> cont 30;
	TokenOSB -> cont 31;
	TokenCSB -> cont 32;
	TokenExpo -> cont 33;
	TokenSqrt -> cont 34;
	TokenPi -> cont 35;
	TokenHFaq -> cont 36;
	TokenDiv -> cont 37;
	TokenMinus -> cont 38;
	TokenColon -> cont 39;
	TokenSColon -> cont 40;
	TokenBar -> cont 41;
	TokenQB -> cont 42;
	_ -> happyError' tk
	})

happyError_ tk = happyError' tk

happyThen :: () => P a -> (a -> P b) -> P b
happyThen = (thenP)
happyReturn :: () => a -> P a
happyReturn = (returnP)
happyThen1 = happyThen
happyReturn1 :: () => a -> P a
happyReturn1 = happyReturn
happyError' :: () => Token -> P a
happyError' tk = (\token -> happyError) tk

calc = happySomeParser where
  happySomeParser = happyThen (happyParse action_0) (\x -> case x of {HappyAbsSyn4 z -> happyReturn z; _other -> notHappyAtAll })

happySeq = happyDontSeq


type P a = String -> Int -> Error a

thenP :: P a -> (a -> P b) -> P b
m `thenP` k = \s l -> 
	case m s l of
		Error s -> Error s
		OK a -> k a s l

returnP :: a -> P a
returnP a = \s l -> OK a





data PTerm =  PAtom  Atm (Snoc Name)
           |  PPair  PTerm PTerm
           |  PLet   Name PTerm PTerm
           |  PLetP  Name Name PTerm PTerm
           |  PIf    PTerm  PTerm  PTerm
           |  PIfo   PTerm  PTerm  PTerm
           |  PTSup  Compl  PTerm  Compl  PTerm
           |  PFApp  Name (Snoc PTerm)
           |  PUnit
            deriving (Eq,Show)

data Atm  =  PVar  Name  
          |  PSup  Compl Compl
           deriving (Eq,Show)





data Token
	= TokenLet
	| TokenIn
      | TokenIf
      | TokenIfo
      | TokenThen
      | TokenElse
      | TokenTrue
      | TokenFalse
      | TokenDouble Double
	| TokenVar Name
      | TokenFunc Name
	| TokenEq
	| TokenPlus
	| TokenTimes
	| TokenCom
	| TokenOSB
	| TokenCSB
	| TokenOB
	| TokenCB
	| TokenEOF
      | TokenMinus
      | TokenDiv
      | TokenColon
      | TokenSColon
      | TokenPi
      | TokenHFaq
      | TokenSqrt
      | TokenExpo
      | TokenBar
      | TokenQB



lexer :: (Token -> P a) -> P a
lexer cont s = case s of
	[] -> cont TokenEOF []
 	('\n':cs) -> \line -> lexer cont cs (line+1)
	(c:cs) 
              | isSpace c -> lexer cont cs
              | isAlpha c -> lexVar (c:cs)
              | isNum c -> lexNum (c:cs)
	('-':'-':cs) -> \line -> lexer cont (dropWhile (/='\n') cs) (line+1)
	('=':cs) -> cont TokenEq cs
	('+':cs) -> cont TokenPlus cs
	('-':cs) -> cont TokenMinus cs
	('*':cs) -> cont TokenTimes cs
	('/':cs) -> cont TokenDiv cs
	(',':cs) -> cont TokenCom cs
	(':':cs) -> cont TokenColon cs
	(';':cs) -> cont TokenSColon cs
	('(':cs) -> cont TokenOB cs
	(')':cs) -> cont TokenCB cs
	('[':cs) -> cont TokenOSB cs
	(']':cs) -> cont TokenCSB cs
	('|':cs) -> cont TokenBar cs
 where
    lexNum cs = cont (TokenDouble (read num :: Double)) rest
        where (num,rest) = span isNum cs
    lexVar cs =
        case span isAlpha cs of
             ("let",rest)    -> cont TokenLet rest
             ("in",rest)     -> cont TokenIn rest
             ("if",rest)     -> cont TokenIf rest
             ("ifo",rest)    -> cont TokenIfo rest
             ("then",rest)   -> cont TokenThen rest
             ("else",rest)   -> cont TokenElse rest
             ("qtrue",rest)  -> cont TokenTrue rest
             ("qfalse",rest) -> cont TokenFalse rest
             ("exp",rest)    -> cont TokenExpo rest
             ("pi",rest)     -> cont TokenPi rest
             ("hF",rest)     -> cont TokenHFaq rest
             ("sqrt",rest)   -> cont TokenSqrt rest
             ("qb",rest)     -> cont TokenQB rest
             (var,rest)      -> cont (lexAux var) rest
    isNum  :: Char -> Bool
    isNum  c = isDigit c || (c == '.') -- Needs improvement

lexAux (c:cs) | isUpper c  = TokenFunc (c:cs)
              | otherwise  = TokenVar (c:cs)

runCalc :: String -> Snoc (Name,Con,PTerm,Ty)
runCalc s = case calc s 1 of
		OK e     -> e
		Error s  -> error s

runParser :: FilePath -> IO ()
runParser x = (readFile x) >>= print.runCalc

runPQTerm :: FilePath -> IO ()
runPQTerm x = (readFile x) >>= print.pQTerm

pQTerm    :: String -> Error Prog
pQTerm s  =  do  funcs <- calc s 1
                 return (Env ((unError.parseF (Env SNil)) (sreverse funcs)))

parseF  :: Env (TCon,Ty) -> Snoc (Name,Con,PTerm,Ty) -> Error (Snoc (Name,FDef))
parseF fs SNil                  =  OK SNil
parseF fs (xs:< (f,gam,t,sig))  =  
      do  pt           <- pTerm fs gam t
          (gam',sig')  <- typeTm fs gam pt
          eguard (size gam == size gam') (show f ++ ": context mismatch "++ show (gam,gam'))
          eguard (size sig == size sig') (show f ++ ": Inferred type mismatch " ++ show (sig,sig'))
          let fs' = Env ((unEnv fs) :< (f,(con2tcon gam,sig)))
          pts          <- parseF fs' xs  
          return (pts :< (f,FDef (FSig gam sig) pt))

runTC :: FilePath -> Name -> IO()
runTC fp n =  (readFile fp) >>= print.(pTCirc n)

pTCirc :: Name -> String -> Error TCirc
pTCirc n s = do  p <- pQTerm s
                 c <- getTCirc n p 
                 return c

runC :: FilePath -> Name -> IO()
runC fp n =  (readFile fp) >>= print.(pCirc n)

pCirc :: Name -> String -> Error Circ
pCirc n s = do  p <- pQTerm s
                c <- getCirc n p 
                return c

runM :: FilePath -> Name -> IO()
runM fp n =  (readFile fp) >>= print.(pComp n)

pComp :: Name -> String -> Error Mat
pComp n s = do  p <- pQTerm s
                c <- compP n p 
                return c

runI :: FilePath -> Name -> IO()
runI fp n =  (readFile fp) >>= print.(pIsom n)

pIsom :: Name -> String -> Error (Int,Isom)
pIsom n s = do  p     <- pQTerm s
                (g,c) <- isomP n p
                return (g,c)

runCon :: FilePath -> Name -> IO()
runCon fp n =  (readFile fp) >>= print.(pCon n)

pCon :: Name -> String -> Error (Snoc Name)
pCon n s = do  p   <- pQTerm s
               uc  <- getuCon n p
               return uc

runS :: FilePath -> Name -> IO()
runS fp n =  (readFile fp) >>= print.(pSuper n)

pSuper      :: Name -> String -> Error Super
pSuper n s  = do  p <- pQTerm s
                  s <- superP n p         
                  return s

runStrict     :: FilePath -> IO()
runStrict fp  =  (readFile fp) >>= print.(pStrict)


pStrict    :: String -> Error (Env Bool)
pStrict s  = do p <- pQTerm s
                return (strictTms (getTms p))






type Parse = P (Snoc (Name,Con,PTerm,Ty))
calc :: Parse




happyError :: P a
happyError = \s i -> error (
	"Parse error in line " ++ show (i::Int) ++ "\n")









pTerm :: Env (TCon,Ty) -> Con -> PTerm -> Error Tm
pTerm fs g (PPair t u)      = do  pt <- pTerm fs g t
                                  pu <- pTerm fs g u
                                  return (Pair pt pu)
pTerm fs g (PLet x t u)     = do  pt <- pTerm fs g t
                                  pu <- pTerm fs g u
                                  return (Let x pt pu)
pTerm fs g (PLetP x y t u)  = do  pt <- pTerm fs g t
                                  pu <- pTerm fs g u
                                  return (LetP x y pt pu)
pTerm fs g (PIf c t u)      = do  pt <- pTerm fs g t
                                  pu <- pTerm fs g u
                                  pc <- pTerm fs g c
                                  return (If pc pt pu)
pTerm fs g (PTSup l t k u)  = do  pt  <- pTerm fs g t
                                  pu  <- pTerm fs g u
                                  otu <- isOrth fs g pt pu
                                  return (Ifo (Atom (Sup l k) SNil) pt pu otu)
pTerm fs g (PIfo c t u)     = do  pt  <- pTerm fs g t
                                  pu  <- pTerm fs g u
                                  pc  <- pTerm fs g c
                                  otu <- isOrth fs g pt pu
                                  return (Ifo pc pt pu otu)
pTerm fs g (PFApp fn pts)        = OK (FApp fn (smap (unError.pTerm fs g) pts))
pTerm _  _ (PAtom (PSup a b) xs) = OK (Atom (Sup a b) xs)
pTerm _  _ (PAtom (PVar x) xs)   = OK (Atom (Var x) xs)
pTerm _  _ (PUnit)               = OK Unit
{-# LINE 1 "templates/GenericTemplate.hs" #-}
{-# LINE 1 "templates/GenericTemplate.hs" #-}
{-# LINE 1 "<built-in>" #-}
{-# LINE 1 "<command line>" #-}
{-# LINE 1 "templates/GenericTemplate.hs" #-}
-- Id: GenericTemplate.hs,v 1.26 2005/01/14 14:47:22 simonmar Exp 

{-# LINE 28 "templates/GenericTemplate.hs" #-}








{-# LINE 49 "templates/GenericTemplate.hs" #-}

{-# LINE 59 "templates/GenericTemplate.hs" #-}

{-# LINE 68 "templates/GenericTemplate.hs" #-}

infixr 9 `HappyStk`
data HappyStk a = HappyStk a (HappyStk a)

-----------------------------------------------------------------------------
-- starting the parse

happyParse start_state = happyNewToken start_state notHappyAtAll notHappyAtAll

-----------------------------------------------------------------------------
-- Accepting the parse

-- If the current token is (1), it means we've just accepted a partial
-- parse (a %partial parser).  We must ignore the saved token on the top of
-- the stack in this case.
happyAccept (1) tk st sts (_ `HappyStk` ans `HappyStk` _) =
	happyReturn1 ans
happyAccept j tk st sts (HappyStk ans _) = 
	 (happyReturn1 ans)

-----------------------------------------------------------------------------
-- Arrays only: do the next action

{-# LINE 155 "templates/GenericTemplate.hs" #-}

-----------------------------------------------------------------------------
-- HappyState data type (not arrays)



newtype HappyState b c = HappyState
        (Int ->                    -- token number
         Int ->                    -- token number (yes, again)
         b ->                           -- token semantic value
         HappyState b c ->              -- current state
         [HappyState b c] ->            -- state stack
         c)



-----------------------------------------------------------------------------
-- Shifting a token

happyShift new_state (1) tk st sts stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--     trace "shifting the error token" $
     new_state i i tk (HappyState (new_state)) ((st):(sts)) (stk)

happyShift new_state i tk st sts stk =
     happyNewToken new_state ((st):(sts)) ((HappyTerminal (tk))`HappyStk`stk)

-- happyReduce is specialised for the common cases.

happySpecReduce_0 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_0 nt fn j tk st@((HappyState (action))) sts stk
     = action nt j tk st ((st):(sts)) (fn `HappyStk` stk)

happySpecReduce_1 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_1 nt fn j tk _ sts@(((st@(HappyState (action))):(_))) (v1`HappyStk`stk')
     = let r = fn v1 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_2 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_2 nt fn j tk _ ((_):(sts@(((st@(HappyState (action))):(_))))) (v1`HappyStk`v2`HappyStk`stk')
     = let r = fn v1 v2 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_3 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_3 nt fn j tk _ ((_):(((_):(sts@(((st@(HappyState (action))):(_))))))) (v1`HappyStk`v2`HappyStk`v3`HappyStk`stk')
     = let r = fn v1 v2 v3 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happyReduce k i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happyReduce k nt fn j tk st sts stk
     = case happyDrop (k - ((1) :: Int)) sts of
	 sts1@(((st1@(HappyState (action))):(_))) ->
        	let r = fn stk in  -- it doesn't hurt to always seq here...
       		happyDoSeq r (action nt j tk st1 sts1 r)

happyMonadReduce k nt fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happyMonadReduce k nt fn j tk st sts stk =
        happyThen1 (fn stk tk) (\r -> action nt j tk st1 sts1 (r `HappyStk` drop_stk))
       where sts1@(((st1@(HappyState (action))):(_))) = happyDrop k ((st):(sts))
             drop_stk = happyDropStk k stk

happyMonad2Reduce k nt fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happyMonad2Reduce k nt fn j tk st sts stk =
       happyThen1 (fn stk tk) (\r -> happyNewToken new_state sts1 (r `HappyStk` drop_stk))
       where sts1@(((st1@(HappyState (action))):(_))) = happyDrop k ((st):(sts))
             drop_stk = happyDropStk k stk





             new_state = action


happyDrop (0) l = l
happyDrop n ((_):(t)) = happyDrop (n - ((1) :: Int)) t

happyDropStk (0) l = l
happyDropStk n (x `HappyStk` xs) = happyDropStk (n - ((1)::Int)) xs

-----------------------------------------------------------------------------
-- Moving to a new state after a reduction

{-# LINE 253 "templates/GenericTemplate.hs" #-}
happyGoto action j tk st = action j j tk (HappyState action)


-----------------------------------------------------------------------------
-- Error recovery ((1) is the error token)

-- parse error if we are in recovery and we fail again
happyFail  (1) tk old_st _ stk =
--	trace "failing" $ 
    	happyError_ tk

{-  We don't need state discarding for our restricted implementation of
    "error".  In fact, it can cause some bogus parses, so I've disabled it
    for now --SDM

-- discard a state
happyFail  (1) tk old_st (((HappyState (action))):(sts)) 
						(saved_tok `HappyStk` _ `HappyStk` stk) =
--	trace ("discarding state, depth " ++ show (length stk))  $
	action (1) (1) tk (HappyState (action)) sts ((saved_tok`HappyStk`stk))
-}

-- Enter error recovery: generate an error token,
--                       save the old token and carry on.
happyFail  i tk (HappyState (action)) sts stk =
--      trace "entering error recovery" $
	action (1) (1) tk (HappyState (action)) sts ( (HappyErrorToken (i)) `HappyStk` stk)

-- Internal happy errors:

notHappyAtAll = error "Internal Happy error\n"

-----------------------------------------------------------------------------
-- Hack to get the typechecker to accept our action functions







-----------------------------------------------------------------------------
-- Seq-ing.  If the --strict flag is given, then Happy emits 
--	happySeq = happyDoSeq
-- otherwise it emits
-- 	happySeq = happyDontSeq

happyDoSeq, happyDontSeq :: a -> b -> b
happyDoSeq   a b = a `seq` b
happyDontSeq a b = b

-----------------------------------------------------------------------------
-- Don't inline any functions from the template.  GHC has a nasty habit
-- of deciding to inline happyGoto everywhere, which increases the size of
-- the generated parser quite a bit.

{-# LINE 317 "templates/GenericTemplate.hs" #-}
{-# NOINLINE happyShift #-}
{-# NOINLINE happySpecReduce_0 #-}
{-# NOINLINE happySpecReduce_1 #-}
{-# NOINLINE happySpecReduce_2 #-}
{-# NOINLINE happySpecReduce_3 #-}
{-# NOINLINE happyReduce #-}
{-# NOINLINE happyMonadReduce #-}
{-# NOINLINE happyGoto #-}
{-# NOINLINE happyFail #-}

-- end of Happy Template.
