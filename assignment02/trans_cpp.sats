
(*
** CAS CS525, Spring 2011
** Instructor: Hongwei Xi
*)

(* ****** ****** *)

staload Trans2 = "trans2.sats"
// staload
// Posloc = "contrib/parcomb/SATS/posloc.sats"
// 
// (* ****** ****** *)
// 
// staload Absyn = "absyn.sats"
// 
// (* ****** ****** *)
// 
// staload
// Trans1 = "trans1.sats"
// typedef e1xp = $Trans1.e1xp
// 
// (* ****** ****** *)
// 
// (* desc: type for temporary variable *)
// abstype tmpvar_t
// typedef tmpvar = tmpvar_t
// 
// fun fprint_tmpvar (out: FILEref, x: tmpvar): void
// overload fprint with fprint_tmpvar
// fun print_tmpvar (x: tmpvar): void
// overload print with print_tmpvar

(*
abstype cppvar_t
typedef cppvar cppvar_t

datatype stat_cpp =
  | CPPopr (cppvar, j
*)

abstype ostream_t
typedef ostream = ostream_t

fun ostream_new (): ostream

fun ostream_in (os: &ostream, s: string): void

fun print_ostream (os: ostream): void

fun trans_cpp (instrs: $Trans2.instrlst, fns: list0 $Trans2.funent_t): ostream



