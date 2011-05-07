

(*
** CAS CS525, Spring 2011
** Instructor: Hongwei Xi
** Author: Zhiqiang Ren
*)

staload Trans2 = "trans2.sats"
staload Ostream = "ostream.sats"


fun trans_llvm (instrs: $Trans2.instrlst, fns: list0 $Trans2.funent_t): $Ostream.ostream

